FROM ruby:2.6.0
LABEL documentation="https://www.github.com/mabiesen/rails_universal_api/blob/master/README.md"
ENV APP /rails_universal_api
ENV HOME /root
RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs \
  postgresql-client

WORKDIR $APP
COPY Gemfile Gemfile.lock ./
COPY .bundle $BUNDLE_APP_CONFIG/
RUN gem install bundler:2.1.4
RUN bundle install --binstubs
RUN bundle install
COPY . .

ENTRYPOINT ["docker_entrypoints/entry.sh"]
