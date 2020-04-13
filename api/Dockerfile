# Set global build arguments accessible from every build stage.
ARG WORKDIR=/app_home
ARG RAILS_ENV=production

# Specify the base image.
FROM ruby:2.7.1-alpine3.11 AS base

# Add Alpine packages necessary for both builder and the final image.
RUN apk update --no-cache && \
    apk add --no-cache build-base=0.5-r1 \
                       linux-headers=4.19.36-r0 \
                       git=2.24.1-r0 \
                       postgresql-dev=12.2-r0 \
                       nodejs=12.15.0-r1 \
                       tzdata=2019c-r0 \
                       yarn=1.19.2-r0 && \
    rm -rf /var/cache/apk/*

# Build the builder image from the base image.
FROM base AS builder

# Include some build arguments.
ARG WORKDIR
ARG RAILS_ENV

# Set builder's working directory.
WORKDIR $WORKDIR

# Add some environment variables.
ENV RAILS_ENV $RAILS_ENV

# Install dependencies using Bundler and yarn.
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Build the final image from the same base as builder.
FROM base

# Define build arguments for the final image.
ARG WORKDIR
ARG RAILS_ENV
ARG ENTRYPOINT_LOCATION=/usr/bin/docker-entrypoint.sh
ARG APP_USER=app_user

# Set the final image working directory.
WORKDIR $WORKDIR

# Set environment variables for the final image.
ENV RAILS_ENV $RAILS_ENV

# Add the entrypoint script to a directory in the $PATH.
COPY docker-entrypoint.sh $ENTRYPOINT_LOCATION

# Copy code into the final image.
COPY . ./
COPY --from=builder $WORKDIR/Gemfile.lock ./
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /tmp/ /tmp/

# Never run as root!
RUN addgroup -g 1000 -S $APP_USER && \
  adduser -u 1000 -S $APP_USER -G $APP_USER && \
  chmod +x $ENTRYPOINT_LOCATION && \
  chown -R $APP_USER:$APP_USER $WORKDIR $ENTRYPOINT_LOCATION
USER $APP_USER


# Expose the puma default port.
EXPOSE 3000

# I command you to serve!
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]