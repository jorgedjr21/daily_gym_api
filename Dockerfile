# Use the official Ruby image
FROM ruby:3

# Set the working directory
WORKDIR /rails

# Install basic dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential libpq-dev nodejs yarn && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies
RUN bundle install

# Copy application code
COPY . .

# Expose Rails default port
EXPOSE 3000

# Default command to start the Rails server
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
