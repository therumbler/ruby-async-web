FROM ruby:3.0.2

WORKDIR /app
EXPOSE 3000

COPY Gemfile* .
RUN bundle install


COPY . .
ENTRYPOINT [ "./docker-entrypoint.sh" ]
