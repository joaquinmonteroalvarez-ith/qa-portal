FROM node:12-slim as base

WORKDIR /app
COPY --chown=node:node package.json yarn.lock ./
RUN yarn install