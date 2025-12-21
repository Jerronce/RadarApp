# RadarApp - Firebase Deployment Guide

## Project Information
- **Project Name**: RadarApp (Ajo/Esusu Web & Mobile App)
- **Firebase Project ID**: radarapp-5176c
- **Platform**: Flutter (Web, Android, iOS)
- **Hosting URL**: https://radarapp-5176c.web.app

## Setup Instructions

### 1. Firebase Token Setup for GitHub Actions

#### Option A: Generate CI Token (Recommended)
```bash
npm install -g firebase-tools
firebase login:ci
```

This will open a browser window for authentication. Follow the prompts and copy the token that appears.

#### Option B: Use Service Account Key (Alternative)

If Option A doesn't work:
1. Go to: https://console.firebase.google.com/project/radarapp-5176c/settings/serviceaccounts/adminsdk
2. Click "Generate new private key"
3. Convert the JSON to base64:
```bash
cat serviceAccountKey.json | base64
```

### 2. Add GitHub Secrets

1. Go to your GitHub repository
2. Settings → Secrets and variables → Actions → New repository secret
3. Add one of the following:

**For Option A (CI Token):**
- Name: `FIREBASE_TOKEN`
- Value: [Paste the token from firebase login:ci]

**For Option B (Service Account):**
- Name: `FIREBASE_SERVICE_ACCOUNT`
- Value: [Paste the base64-encoded service account key]

### 3. Deploy to Firebase

#### Option 1: Automatic Deployment via GitHub Actions
Simply push to the `main` branch:
```bash
git push origin main
```

The GitHub Actions workflow will automatically deploy to Firebase Hosting.

#### Option 2: Manual Deployment
```bash
npm install -g firebase-tools
firebase deploy --project radarapp-5176c --token YOUR_FIREBASE_TOKEN
```

#### Option 3: Deploy Flutter Web Build
```bash
flutter pub get
flutter build web --release
firebase deploy --public build/web --project radarapp-5176c
```

## Project Structure

- **web/**: Web deployment files (HTML, CSS, JS)
  - index.html: Main HTML entry point
  - app.js: Web initialization script
  - styles.css: Web styles
- **lib/**: Flutter Dart source code
  - main.dart: App entry point
  - main_page.dart: Main app page
  - signup_page.dart: User signup
  - And 10+ other feature pages
- **.github/workflows/**: CI/CD automation
  - firebase-deploy.yml: Automatic Firebase deployment

## Features Included

✅ Flutter-based cross-platform app (Web, Android, iOS)
✅ Firebase integration (Authentication, Database, Hosting)
✅ Multi-page navigation system
✅ User signup and authentication pages
✅ Ajo/Esusu contribution management features:
   - Home page
   - Main/Loan pages
   - Participant selection
   - Monthly tracking
   - Settings and profile management
   - History tracking
✅ Responsive design
✅ Firebase configuration files (.firebaserc, firebase.json)
✅ GitHub Actions automation

## Firebase Configuration Files

### firebase.json
Configures Firebase Hosting to serve the web directory with proper routing.

### .firebaserc
Stores the Firebase project ID for easy deployment reference.

## Troubleshooting

### Issue: "firebase: command not found"
**Solution**: Install Firebase CLI
```bash
npm install -g firebase-tools
```

### Issue: GitHub Actions fails with "FIREBASE_TOKEN not found"
**Solution**: Add the token to GitHub repository secrets (see section 2)

### Issue: Web app shows blank page
**Solution**: Check that index.html and app.js are in the `web/` directory

## Testing

### Local Web Testing
```bash
cd web
python3 -m http.server 8000
# Visit http://localhost:8000
```

### Flutter Web Testing
```bash
flutter run -d web
```

## Deployment Status

✅ Web files fixed and optimized
✅ Firebase configuration completed
✅ GitHub Actions workflow created
✅ CI/CD pipeline ready
⏳ Awaiting Firebase token setup in GitHub Secrets

## Next Steps

1. **Generate and add FIREBASE_TOKEN** to GitHub repository secrets
2. **Push to GitHub** to trigger automatic deployment
3. **Verify at** https://radarapp-5176c.web.app

## Support

For Firebase documentation: https://firebase.google.com/docs
For Flutter documentation: https://flutter.dev/docs
