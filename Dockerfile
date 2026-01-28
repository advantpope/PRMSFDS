FROM cirrusci/flutter:stable AS build

WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy source code
COPY . .

# Build for web
RUN flutter build web --release --web-renderer html

# Production image
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]