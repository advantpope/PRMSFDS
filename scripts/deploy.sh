#!/bin/bash

# Deployment script for Property Tax System

set -e

ENVIRONMENT=${1:-production}
PLATFORM=${2:-android}

echo "Deploying Property Tax System for $ENVIRONMENT on $PLATFORM..."

# Validate environment
if [[ ! "$ENVIRONMENT" =~ ^(development|staging|production)$ ]]; then
    echo "Invalid environment. Use: development, staging, production"
    exit 1
fi

# Load environment variables
export $(cat .env.$ENVIRONMENT | xargs)

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests
echo "Running tests..."
flutter test

# Build based on platform
case $PLATFORM in
    android)
        echo "Building Android APK..."
        flutter build apk --release \
            --dart-define=ENVIRONMENT=$ENVIRONMENT \
            --dart-define=API_BASE_URL=$API_BASE_URL \
            --dart-define=GOOGLE_MAPS_API_KEY=$GOOGLE_MAPS_API_KEY
        ;;
    ios)
        echo "Building iOS..."
        flutter build ios --release \
            --dart-define=ENVIRONMENT=$ENVIRONMENT \
            --dart-define=API_BASE_URL=$API_BASE_URL \
            --dart-define=GOOGLE_MAPS_API_KEY=$GOOGLE_MAPS_API_KEY
        ;;
    web)
        echo "Building Web..."
        flutter build web --release \
            --web-renderer html \
            --dart-define=ENVIRONMENT=$ENVIRONMENT \
            --dart-define=API_BASE_URL=$API_BASE_URL \
            --dart-define=GOOGLE_MAPS_API_KEY=$GOOGLE_MAPS_API_KEY
        ;;
    *)
        echo "Invalid platform. Use: android, ios, web"
        exit 1
        ;;
esac

echo "Build complete! Output in build/"