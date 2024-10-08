### Stage 1 ###
FROM node:16 as builder
WORKDIR /usr/app
COPY . .
RUN npm install
RUN npm run build
RUN npm ci --only=production
WORKDIR /tmp/node-prune
RUN wget https://github.com/tj/node-prune/releases/download/v1.0.1/node-prune_1.0.1_linux_amd64.tar.gz
RUN tar xzf node-prune_1.0.1_linux_amd64.tar.gz
RUN /tmp/node-prune/node-prune /usr/app/node_modules

### Stage 2 ###
FROM gcr.io/distroless/nodejs:16
WORKDIR /usr/app
COPY --from=builder /usr/app .
ENV HOST=0.0.0.0
ENV PORT=3000
ENV BOT_ENABLE=true
ENV API_ENABLE=true
ENV DATABASE_URL=
ENV BOT_TOKEN=
EXPOSE 3000
USER 1000
CMD [ "dist/index.js" ]