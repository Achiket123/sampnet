# Use the latest Flutter Docker image
FROM fischerscode/flutter:latest AS builder

# Set working directory and switch to flutter user
WORKDIR /app
USER flutter

# Copy pubspec files and set ownership to the flutter user
COPY --chown=flutter:flutter pubspec.yaml pubspec.lock ./

# Install dependencies; use || true to bypass permissions issues with pubspec.lock
RUN flutter pub get || true

# Copy the rest of the application files and set ownership
COPY --chown=flutter:flutter . .

# Run flutter pub get again in offline mode to use cached dependencies
RUN flutter pub get --offline

# Expose the port for Flutter
EXPOSE 8080

# Entry point for the Flutter app
ENTRYPOINT ["flutter", "run", "-d", "web-server", "--web-port=8080", "--web-hostname=0.0.0.0", "--release"]

