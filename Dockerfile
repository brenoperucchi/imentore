FROM ruby:2.3.8-stretch

ENV BUNDLE_PATH=/bundle \
    BUNDLE_APP_CONFIG=/bundle/config \
    BUNDLE_DISABLE_SHARED_GEMS=true \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=2

RUN printf '%s\n' \
      'deb http://snapshot.debian.org/archive/debian/20190326T120000Z stretch main' \
      'deb http://snapshot.debian.org/archive/debian-security/20190326T120000Z stretch/updates main' \
      'deb http://snapshot.debian.org/archive/debian/20190326T120000Z stretch-updates main' \
      > /etc/apt/sources.list \
    && printf '%s\n' \
      'Acquire::Check-Valid-Until "false";' \
      'Acquire::AllowInsecureRepositories "true";' \
      'Acquire::AllowDowngradeToInsecureRepositories "true";' \
      'APT::Get::AllowUnauthenticated "true";' \
      > /etc/apt/apt.conf.d/99snapshot \
    && apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated \
      build-essential \
      default-libmysqlclient-dev \
      gstreamer1.0-plugins-base \
      imagemagick \
      libqt5webkit5-dev \
      libsqlite3-dev \
      libxml2-dev \
      libxslt1-dev \
      nodejs \
      pkg-config \
      qt5-default \
      shared-mime-info \
      xvfb \
      zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler -v 1.17.3 --no-document

WORKDIR /app
COPY . /app

WORKDIR /app/imentore-base
RUN bundle _1.17.3_ config build.nokogiri --use-system-libraries \
    && bundle _1.17.3_ install

COPY docker/entrypoint.sh /usr/local/bin/imentore-entrypoint
RUN chmod +x /usr/local/bin/imentore-entrypoint

EXPOSE 3000
ENTRYPOINT ["imentore-entrypoint"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
