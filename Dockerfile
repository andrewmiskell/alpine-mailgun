FROM alpine:latest
LABEL MAINTAINER="Andrew Miskell <andrewmiskell@mac.com>" \
    Description="SMTP Server which relays all incoming mail via the Mailgun API"

RUN apk update && apk --update add ruby ruby-irb ruby-io-console tzdata ca-certificates libcap

ADD Gemfile /app/

RUN apk --update add --virtual build-deps build-base ruby-dev \
    && addgroup appuser \
    && adduser -D -G appuser appuser \
    && setcap 'cap_net_bind_service=+ep' `which ruby` \
    && gem install bundler --no-ri --no-rdoc \
    && cd /app \
    && bundle install \
    && apk del build-deps

ADD . /app
RUN chown -R root:root /app

USER appuser
WORKDIR /app

EXPOSE 25

CMD ["bundle", "exec", "ruby", "mail.rb"]
