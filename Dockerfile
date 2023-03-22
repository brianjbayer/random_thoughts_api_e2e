#-------------------------------
#--- random_thoughts_api_e2e ---
#-------------------------------

#--- Base Image ---
ARG BASE_IMAGE=ruby:3.2.1-alpine
FROM ${BASE_IMAGE} AS ruby-alpine

#--- Builder Stage ---
FROM ruby-alpine AS builder

# Alpine needs build-base for building native extensions
ARG BUILD_PACKAGES='build-dependencies build-base'

# Use the same version of Bundler in the Gemfile.lock
ARG BUNDLER_VER=2.4.9

# TODO: Determine needed packages
# RUN apk --update add --virtual ${BUILD_PACKAGES} \
  # Update gem command to latest
  # Update gem command to latest
RUN gem update --system \
  # && gem update --system \
  && gem install bundler:${BUNDLER_VER}

# Install the Ruby dependencies (defined in the Gemfile/Gemfile.lock)
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install

#--- Dev Environment ---
# ASSUME source is docker volumed into the image
FROM builder AS devenv

# For Dev Env, add git and vim at least
ARG DEVENV_PACKAGES='git vim'
RUN apk --update add ${DEVENV_PACKAGES}

# Start devenv in (command line) shell
CMD sh

#--- Deploy Stage ---
FROM ruby-alpine AS deploy

# Throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1 \
# Add a user so not running as root
  && adduser -D deployer

# Run as deployer USER instead of as root
USER deployer

# Copy over the built gems (directory)
COPY --from=builder --chown=deployer /usr/local/bundle/ /usr/local/bundle/

# Copy the app source to /app
WORKDIR /app
COPY --chown=deployer . /app/

# Run the tests but allow override
CMD ./script/run tests
