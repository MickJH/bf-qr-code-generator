FROM node:20-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:1.27-alpine

# envsubst (from gettext) renders env-config.js at container startup
RUN apk add --no-cache gettext

COPY --from=build /app/index.html /usr/share/nginx/html/index.html
COPY --from=build /app/styles.css /usr/share/nginx/html/styles.css
COPY --from=build /app/manifest.json /usr/share/nginx/html/manifest.json
COPY --from=build /app/icon.svg /usr/share/nginx/html/icon.svg
COPY --from=build /app/icon-maskable.svg /usr/share/nginx/html/icon-maskable.svg
COPY --from=build /app/service-worker.js /usr/share/nginx/html/service-worker.js
COPY --from=build /app/env-config.template.js /usr/share/nginx/html/env-config.template.js
COPY --from=build /app/dist /usr/share/nginx/html/dist

COPY docker-entrypoint.sh /usr/local/bin/bf-entrypoint.sh
RUN chmod +x /usr/local/bin/bf-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/bf-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
