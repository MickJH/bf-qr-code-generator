FROM node:20-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:1.27-alpine
COPY --from=build /app/index.html /usr/share/nginx/html/index.html
COPY --from=build /app/styles.css /usr/share/nginx/html/styles.css
COPY --from=build /app/manifest.json /usr/share/nginx/html/manifest.json
COPY --from=build /app/icon.svg /usr/share/nginx/html/icon.svg
COPY --from=build /app/icon-maskable.svg /usr/share/nginx/html/icon-maskable.svg
COPY --from=build /app/service-worker.js /usr/share/nginx/html/service-worker.js
COPY --from=build /app/dist /usr/share/nginx/html/dist

EXPOSE 80
