FROM ruby:2.5-alpine

# install packages
RUN apk add -U --no-cache bash git

# install imagemagick6-dev for rmagick
RUN apk add --no-cache imagemagick6-dev

# install bundler
RUN gem install bundler

# install rails
RUN apk add --no-cache libxml2-dev libxslt-dev libstdc++ tzdata mariadb-client-libs nodejs \
            ca-certificates build-base mariadb-dev ruby-dev sqlite sqlite-dev postgresql-dev
RUN gem install rails -v 5.2.0 --no-rdoc --no-ri

# create rails project
RUN rails new myproject -d mysql --bundle-skip --api
WORKDIR /myproject
RUN bundle install --jobs=4 --path=vendor/bundle

CMD rails s -b 0.0.0.0
