FROM ruby:2.5-alpine

# install packages
RUN apk add -U --no-cache bash git

# install bundler
RUN gem install bundler

# install rails
RUN apk add --no-cache libxml2-dev libxslt-dev libstdc++ tzdata mariadb-client-libs nodejs \
            ca-certificates build-base mariadb-dev ruby-dev sqlite sqlite-dev postgresql-dev
RUN gem install rails -v 5.2.0 --no-rdoc --no-ri

# create rails project
RUN rails new myproject -d postgresql --bundle-skip --api
WORKDIR /myproject
COPY database.yml config/
RUN bundle install --jobs=4 --path=vendor/bundle
RUN echo "web: bundle exec puma -C config/puma.rb" > Procfile

CMD rails s -b 0.0.0.0
