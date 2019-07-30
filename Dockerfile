FROM ruby:2.6.3-alpine3.10

RUN set -x && apk --update add alpine-sdk \
  libxslt-dev \
  libxml2-dev \
  build-base \
  nodejs=10.16.0-r0 \
  nodejs-npm \
  yarn \
  mysql-client \
  mariadb-dev \
  tzdata \
  python2

RUN mkdir /app

WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install
ADD . /app