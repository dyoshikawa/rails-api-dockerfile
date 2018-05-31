FROM ruby:2.5-alpine

# install bundler
RUN gem install bundler

# install rails
RUN apk add -U --no-cache libxml2-dev libxslt-dev libstdc++ tzdata mariadb-client-libs nodejs \
            ca-certificates build-base mariadb-dev ruby-dev sqlite sqlite-dev postgresql-dev
RUN gem install rails -v 5.2.0 --no-rdoc --no-ri

# create rails project
RUN rails new myproject -d postgresql --bundle-skip --api
WORKDIR /myproject
RUN bundle install --jobs=4 --path=vendor
RUN sed -i -e "23i \  username: postgres" config/database.yml && \
    sed -i -e "24i \  password: password" config/database.yml && \
    sed -i -e "25i \  host: db" config/database.yml && \
    sed -i -e "26i \  port: 5432" config/database.yml && \
    sed -i -e "s/app_development/postgres/" config/database.yml
RUN echo "web: bundle exec puma -C config/puma.rb" > Procfile

# install bash
RUN apk add bash

CMD rails s -b 0.0.0.0
