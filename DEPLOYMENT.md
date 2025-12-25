# Deployment Guide for Vercel

This Flutter web app is configured to deploy on Vercel.

## Prerequisites

1. Install Flutter SDK: https://flutter.dev/docs/get-started/install
2. Enable Flutter web support:
   ```bash
   flutter config --enable-web
   ```

## Local Development

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app locally:
   ```bash
   flutter run -d chrome
   ```

3. Build for web:
   ```bash
   flutter build web --release
   ```

## Deploying to Vercel

### Option 1: Using Vercel CLI

1. Install Vercel CLI:
   ```bash
   npm i -g vercel
   ```

2. Deploy:
   ```bash
   vercel
   ```

### Option 2: Using GitHub Integration

1. Push your code to a GitHub repository
2. Import the project in Vercel dashboard
3. Vercel will automatically detect the `vercel.json` configuration
4. The build command and output directory are already configured

## Build Configuration

The `vercel.json` file is configured to:
- Build the Flutter web app using `flutter build web --release`
- Serve files from `build/web` directory
- Handle client-side routing with rewrites
- Include security headers

## Notes

- The `build.sh` script will automatically install Flutter if it's not available in the build environment
- If Flutter is already installed, the build command will fall back to direct `flutter build web --release`
- Vercel's build environment may take longer on first build as it installs Flutter
- Make sure your Vercel project has sufficient build time allocated (Flutter installation can take a few minutes)

## Alternative: Using Vercel with Pre-built Assets

If you prefer to build locally and deploy only the built assets:

1. Build locally: `flutter build web --release`
2. Update `vercel.json` to remove the buildCommand
3. Deploy the `build/web` directory directly

