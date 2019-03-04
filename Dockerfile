FROM node:alpine AS builder
WORKDIR /app
COPY Package.json .
RUN npm install
COPY . .
RUN npm run build

FROM nginx
COPY --from=builder /app/public /usr/share/nginx/html