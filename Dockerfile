# Define base image, you can use --build-arg
ARG base_image="newsdict/rails:ubuntu20.10_nvmv0.35.2_nodev14.3.0_rubyv2.7.1_sasscv2.3.0_ffiv1.13.1_chromedriver"
FROM $base_image

# Set locale
ENV LANG "C.UTF-8"
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES "YES"

# Set correct environment variables.
RUN mkdir -p /var/www/docker
WORKDIR /var/www/docker

# Set up application
COPY . .

# Init gems
RUN echo "gem: --no-rdoc --no-ri" > ~/.gemrc
RUN . /etc/profile.d/rvm.sh && \
  bundle config --global with 'development test' && \
  bundle config --global system true && \
  bundle config --global jobs 10 && \
  bundle config --global build.nokogiri --use-system-libraries && \
  bundle install

CMD ["bash"]