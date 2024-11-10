#-------------------------------
#--- random_thoughts_api_e2e ---
#-------------------------------
# Build and Run deployment image
# docker build --no-cache -t rta-e2e .
# docker run -it --rm -p 3000:3000 rta-e2e

# Build and Run development environment image
# docker build --no-cache --target devenv -t rta-e2e-dev .
# docker run -it --rm -v $(pwd):/test -p 3000:3000 rta-e2e-dev

#--- Base Image ---
ARG BASE_IMAGE=ruby:3.3.5-slim-bookworm
FROM ${BASE_IMAGE} AS ruby-base

#--- Builder Stage ---
FROM ruby-base AS builder

# Use the same version of Bundler in the Gemfile.lock
ARG BUNDLER_VERSION=2.5.23
ENV BUNDLER_VERSION=${BUNDLER_VERSION}

COPY Gemfile Gemfile.lock ./
WORKDIR /test

# Install base build packages
ARG BASE_BUILD_PACKAGES='build-essential'

# For Dev Env, add git and vim at least
ARG DEVENV_PACKAGES='git vim'

# Assumes debian based
RUN apt-get update \
  && apt-get -y dist-upgrade \
  && apt-get -y install ${BASE_BUILD_PACKAGES} ${DEVENV_PACKAGES}\
  && rm -rf /var/lib/apt/lists/* \
  # Update gem command to latest
  && gem update --system \
  # Install bundler
  && gem install bundler:${BUNDLER_VERSION} \
  # Add support for multiple platforms
  && bundle lock --add-platform ruby \
  && bundle lock --add-platform x86_64-linux \
  && bundle lock --add-platform aarch64-linux \
  # Install the Ruby dependencies (defined in the Gemfile/Gemfile.lock)
  && bundle install \
  # Remove unneeded files (cached *.gem, *.o, *.c)
  && rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name '*.[co]' -delete

#--- Dev Environment ---
# ASSUME source is docker volumed into the image
FROM builder AS devenv

# Start devenv in (command line) shell
CMD ["bash"]

#--- Deploy Stage ---
FROM ruby-base AS deploy

# Use the same version of Bundler in the Gemfile.lock
ARG BUNDLER_VERSION=2.5.23
ENV BUNDLER_VERSION=${BUNDLER_VERSION}

# Throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1 \
  # Add a user so not running as root - Assumes debian based
  && adduser --disabled-password --gecos '' deployer

# Run as deployer USER instead of as root
USER deployer

# Copy over the built gems (directory)
COPY --from=builder --chown=deployer /usr/local/bundle/ /usr/local/bundle/

# Copy the app source to /app
WORKDIR /test
COPY --chown=deployer . /test/

# Run the tests but allow override
CMD ["./script/run", "tests"]
