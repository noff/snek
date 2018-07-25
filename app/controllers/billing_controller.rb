class BillingController < ApplicationController

  before_action :authenticate_user!, except: [:webhook]
  protect_from_forgery except: [:webhook]

  def index
    ahoy.track 'Visited Billing'
  end

  def webhook
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil
    begin
      event = Stripe::Webhook.construct_event payload,
                                              sig_header,
                                              Rails.application.credentials.stripe[:webhook_secret]
    rescue JSON::ParserError => e
      # Invalid payload
      Rails.logger.error e
      Rollbar.error e
      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      Rails.logger.error e
      Rollbar.error e
      status 400
      return
    end

    Rails.logger.warn event.inspect
    NotifyMailer.with(event: event.inspect).stripe.deliver_now

    if valid_event?(event)

      # Find customer for prolongation (it can be not exist)
      user = User.find_by stripe_id: event.data.object.customer
      if user

        event_id = event.id
        amount_paid = event.data.object.amount
        paid_subscription = user.paid_subscriptions.where(renewable: true).order(paid_till: :asc).first

        if paid_subscription.product == 'pro_snek'
          # Prolong subscription
          paid_subscription.update! paid_till: (paid_subscription.paid_till + 1.month)
          # Store SubscriptionPayment model
          paid_subscription.subscription_payment.create! amount: event.data.object.amount,
                                                         user_id: current_user.id
        end

      end
    end

    render plain: ''
  end


  def addcard
    if params[:stripeToken].present?

      # Create customer at stripe
      stripe_customer = Stripe::Customer.create source: params[:stripeToken],
                                                email: current_user.email

      # Save stripe ID
      current_user.update stripe_id: stripe_customer.id

      ahoy.track 'Added Bank Card'
      flash[:just_added_card] = true

    end
    redirect_to billing_path, notice: "You've successfully added your card"
  end



  private

  # Check stripe event is correct
  # @param event [Hash]
  # @return Booleanm
  def valid_event?(event)
    return false unless event.livemode
    return false unless event.type == 'charge.succeeded'
    return false unless event.data.object.paid
    return false unless event.data.object.captured
    return false unless event.data.object.currency == 'usd'
    return false if event.data.object.refunded
    true
  end

end
