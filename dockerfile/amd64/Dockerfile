FROM amd64/alpine:latest
LABEL MAINTAINER="Andrew Miskell <andrewmiskell@mac.com>" \
    Description="SMTP Server which relays all incoming mail via the Mailgun API"

# upgrade base system and install ruby and supervisord
RUN apk --no-cache upgrade && apk --no-cache add ruby ruby-irb ruby-io-console tzdata ca-certificates libcap supervisor

# add Gemfile to the app directory
ADD Gemfile /app/

# install build tools and build the application
RUN apk --no-cache add --virtual build-deps build-base ruby-dev \
    && gem install bundler --no-ri --no-rdoc \
    && cd /app \
    && bundle install \
    && apk --no-cache del build-deps

# add mail.rb to app directory and set permissions
ADD mail.rb /app
RUN chown -R root:root /app

# copy supervisord configuration file into place
COPY supervisord.conf /etc/supervisord.conf

# expose default port 25 for mail server
EXPOSE 25

ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf"]