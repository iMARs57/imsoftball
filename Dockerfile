FROM drecom/ubuntu-ruby:2.3.8

# install necessary libs
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
    tzdata \
    sqlite3 \
    libxml2-dev \
    libxslt1-dev \
    libsqlite3-dev \
    libmysqlclient-dev \
    mysql-client

# set working dir
WORKDIR /app

# copy Gemfile and Gemfile.lock into working dir
COPY Gemfile Gemfile.lock ./

# install Bundler 1.10.6 (compatible with Rails 4.2.1)
RUN gem install bundler -v 1.10.6

# install gems
RUN bundle install

# copy all files
COPY . .

# precompile assets (if using Sprockets)
RUN bundle exec rake assets:precompile --trace

# expose Rails server port
EXPOSE 3000

# start Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
