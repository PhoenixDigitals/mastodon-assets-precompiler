FROM node:8.12.0-alpine as node
FROM ruby:2.5-alpine

LABEL maintainer="https://github.com/yukimochi/mastodon-assets-precompiler"

ENV RAILS_ENV=production NODE_ENV=production

WORKDIR /mastodon

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /usr/local/bin/npm /usr/local/bin/npm
COPY --from=node /opt/yarn-* /opt/yarn

RUN apk -U upgrade \
    && apk add -t build-dependencies \
    build-base \
    icu-dev \
    libidn-dev \
    libressl \
    postgresql-dev \
    protobuf-dev \
    python \
    && apk add \
    ca-certificates \
    ffmpeg \
    file \
    git \
    icu-libs \
    imagemagick \
    libidn \
    libpq \
    protobuf \
    tini \
    tzdata \
    && update-ca-certificates \
    && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg \
    && rm -rf /tmp/* /var/cache/apk/*

RUN cd ~ \
    && apk add -U cmake \
    && git clone https://github.com/google/brotli.git \
    && cd brotli \
    && mkdir out \
    && cd out \
    && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=./installed .. \
    && cmake --build . --config Release --target install \
    && cp installed/bin/brotli /usr/local/bin/ \
    && cd /mastodon \
    && rm -rf ~/brotli/ \
    && apk del cmake --purge \
    && rm -rf /tmp/* /var/cache/apk/*

RUN wget https://dl.minio.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc \
    && chmod +x /usr/local/bin/mc

RUN git clone -b v2.5.2 https://github.com/tootsuite/mastodon.git .

RUN bundle install --deployment --without test development \
    && yarn --pure-lockfile \
    && yarn cache clean
