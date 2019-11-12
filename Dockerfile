FROM ruby:2.5-alpine3.8

RUN apk add --no-cache git

ADD comply-cli.gemspec /tmp/comply-cli/
ADD Gemfile /tmp/comply-cli/
ADD lib/comply/cli/version.rb /tmp/comply-cli/lib/comply/cli/
WORKDIR /tmp/comply-cli

RUN apk add --no-cache build-base linux-headers \
 && bundle install \
 && cd $(bundle show aptible-comply) \
 && bundle install \
 && bundle exec rake install \
 && apk del --no-cache --purge build-base

ADD . /tmp/comply-cli

RUN bundle exec rake install

CMD ["sh"]
