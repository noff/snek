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
      user = User.find_by stripe_id: event['data']['object']['customer']
      if user

        event_id = event['id']
        amount_paid = event['data']['object']['amount']

        # TODO find subscription to prolongation
        # TODO prolong subscription
        # TODO store SubscriptionPayment model

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

    end
    redirect_to billing_path, notice: "You've successfully added your card"
  end



  private

  # Check stripe event is correct
  # @param event [Hash]
  # @return Booleanm
  def valid_event?(event)
    return false unless event['data']['livemode']
    return false unless event['data']['type'] != 'charge.succeeded'
    return false if event['data']['object']['refunded']
    return false unless event['data']['object']['paid']
    return false unless event['data']['object']['captured']
    return false unless event['data']['object']['currency'] == 'usd'
    true
  end

end
