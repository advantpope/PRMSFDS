#!/bin/bash

# Setup script for Property Tax System Flutter App

echo "Setting up Property Tax System Flutter App..."

# Check Flutter installation
if ! command -v flutter &> /dev/null; then
    echo "Flutter not found. Please install Flutter first."
    exit 1
fi

# Create .env file if not exists
if [ ! -f .env ]; then
    echo "Creating .env file..."
    cat > .env << EOL
# Environment
ENVIRONMENT=development
APP_VERSION=1.0.0

# API Configuration
API_BASE_URL=http://localhost:8000/api
API_TIMEOUT=30000

# Google Maps
GOOGLE_MAPS_API_KEY=YOUR_KEY_HERE

# Sentry
SENTRY_DSN=

# Feature Flags
ENABLE_OFFLINE_MODE=true
ENABLE_IMAGE_UPLOAD=true
EOL
    echo ".env file created. Please update with your values."
fi

# Create Android local.properties if not exists
if [ ! -f android/local.properties ]; then
    echo "Creating android/local.properties..."
    cat > android/local.properties << EOL
sdk.dir=/Users/\$USER/Library/Android/sdk
flutter.sdk=/Users/\$USER/fvm/versions/stable
flutter.buildMode=debug
flutter.versionName=1.0.0
flutter.versionCode=1
EOL
fi

# Get dependencies
echo "Getting dependencies..."
flutter pub get

# Generate code
echo "Generating code..."
flutter pub run build_runner build --delete-conflicting-outputs

# Setup iOS (if on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Setting up iOS..."
    cd ios
    pod install
    cd ..
fi

echo "Setup complete!"
echo "Next steps:"
echo "1. Update .env with your API keys"
echo "2. For Android: Update android/local.properties"
echo "3. For iOS: Update ios/Runner/Info.plist with Google Maps key"
echo "4. Run: flutter run"