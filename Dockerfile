#FROM ruby:2.3.1
#FROM ruby:2.7.1
#FROM ruby:2.3.1-alpine
FROM notder/docker-ruby-2.3.1-nodejs

RUN apt-get update -qq  \
#    && apt-get install -y nodejs -v "12.18.4"  \
    && apt-get install -y postgresql-client  \
    && apt-get install -y locales && locale-gen en_US.UTF-8

# Uncomment UTF-8
RUN sed -i '/^#.* en_US.* /s/^#//' /etc/locale.gen

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /usr/src/snek
COPY Gemfile ./

#RUN gem update --system && gem install rake -v "13.0.0" && gem install bundler:2.0.1 && bundle install --path vendor/cache
# RUN gem update --system
RUN bundle

COPY . .

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]