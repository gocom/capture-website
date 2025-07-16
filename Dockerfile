FROM node:22-bookworm-slim

USER root:root

ENV PATH=/app/node_modules/.bin:$PATH
ENV APP_DIRECTORY /app
ENV SCREENSHOTS_DIRECTORY /screenshots
ENV HOST_UID 1000
ENV HOST_GID 1000

ENV APP_UID 9000
ENV APP_GID 9000
ENV APP_USER app
ENV APP_GROUP app

WORKDIR /app

COPY ./.puppeteerrc.cjs /app/.puppeteerrc.cjs
COPY ./bin /usr/local/bin

RUN apt-get update && apt-get install -y \
  gosu \
  libasound2-dev \
  libatk1.0-dev \
  libatk-bridge2.0-dev \
  libcups2-dev \
  libdbus-1-dev \
  libdrm-dev \
  libgbm-dev \
  libglib2.0-dev \
  libnss3-dev \
  libpango1.0-dev \
  libxkbcommon-dev \
  libxcomposite-dev \
  libxdamage-dev \
  libxrandr-dev \
  && npm install capture-website-cli puppeteer \
  && puppeteer browsers install chrome \
  && userdel node \
  && groupadd -g "$APP_GID" "$APP_GROUP" \
  && useradd -m -u "$APP_UID" -g "$APP_GROUP" "$APP_USER" \
  && mkdir -p "$SCREENSHOTS_DIRECTORY" \
  && chmod 777 "$SCREENSHOTS_DIRECTORY" \
  && chown -R "$APP_USER:$APP_GROUP" "$APP_DIRECTORY" \
  && chown -R "$APP_USER:$APP_GROUP" "$SCREENSHOTS_DIRECTORY" \
  && chmod +x /usr/local/bin/* \
  && ln -s /app/.cache /home/app/.cache \
  && ln -s /app/.cache /root/.cache

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
CMD ["capture-website"]
