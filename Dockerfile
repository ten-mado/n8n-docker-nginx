FROM node:18-alpine

ARG N8N_VERSION

RUN if [ -z "$N8N_VERSION" ] ; then echo "The N8N_VERSION argument is missing!" ; exit 1; fi

# Update everything and install needed dependencies
RUN apk add --update graphicsmagick tzdata git tini su-exec

# Set a custom user to not have n8n run as root
USER root

# Install n8n and the packages it needs to build it correctly.
RUN apk --update add --virtual build-dependencies python3 build-base ca-certificates && \
	# npm config set python "$(which python3)" && \
	npm_config_user=root npm install -g full-icu n8n@${N8N_VERSION} && \
	apk del build-dependencies \
	&& rm -rf /root /tmp/* /var/cache/apk/* && mkdir /root;

# Install fonts
RUN apk --no-cache add --virtual fonts msttcorefonts-installer fontconfig && \
	update-ms-fonts && \
	fc-cache -f && \
	apk del fonts && \
	find  /usr/share/fonts/truetype/msttcorefonts/ -type l -exec unlink {} \; \
	&& rm -rf /root /tmp/* /var/cache/apk/* && mkdir /root

ENV NODE_ICU_DATA /usr/local/lib/node_modules/full-icu

WORKDIR /data

COPY n8n-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

RUN cd / && mkdir additional_modules && cd additional_modules && \
    npm i ethers@^5 keccak256@latest merkletreejs@latest cheerio@latest \
    @aws-sdk/client-s3@^3.515.0 \
    @aws-sdk/client-athena@^3.515.0 \
    @aws-sdk/client-route-53@^3.515.0 \
    async@^3.2.3

ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]

EXPOSE 5678/tcp