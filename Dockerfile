# Build stage
FROM fischerscode/flutter:latest AS build

USER root
RUN mkdir -p /app && chown flutter:flutter /app
WORKDIR /app

USER flutter
COPY --chown=flutter:flutter . .

RUN flutter pub get
RUN flutter build web --release

# Production stage
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
