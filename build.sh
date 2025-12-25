#!/bin/bash
set -e

# Install Flutter if not already installed
if ! command -v flutter &> /dev/null; then
    echo "Flutter not found. Installing Flutter..."
    
    # Download Flutter SDK
    FLUTTER_VERSION="stable"
    FLUTTER_SDK_DIR="$HOME/flutter"
    
    if [ ! -d "$FLUTTER_SDK_DIR" ]; then
        git clone https://github.com/flutter/flutter.git -b $FLUTTER_VERSION $FLUTTER_SDK_DIR
    fi
    
    export PATH="$FLUTTER_SDK_DIR/bin:$PATH"
    
    # Accept licenses and pre-download dependencies
    flutter doctor --android-licenses || true
    flutter precache --web
fi

# Enable web support
flutter config --enable-web

# Get dependencies
flutter pub get

# Build for web
flutter build web --release

echo "Build completed successfully!"

