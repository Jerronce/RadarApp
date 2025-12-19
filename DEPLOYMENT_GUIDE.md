# Ajo/Esusu Web App - Firebase Hosting Deployment Guide

## Overview
This guide explains how to deploy the Ajo/Esusu web application to Firebase Hosting.

## Prerequisites
1. Google Firebase Account (https://firebase.google.com)
2. Firebase CLI installed (`npm install -g firebase-tools`)
3. Node.js and npm installed
4. GitHub access with your credentials

## Deployment Steps

### Step 1: Firebase Project Setup
1. Go to https://console.firebase.google.com
2. Create a new project named "RadarApp"
3. Enable Firestore Database with test mode
4. Enable Authentication (Email/Password)
5. Enable Firebase Storage
6. Note your Project ID (radarapp-7e8c5)

### Step 2: Local Setup & Authentication
```bash
# Install Firebase CLI globally
npm install -g firebase-tools

# Login to Firebase (opens browser for authentication)
firebase login

# Navigate to project directory
cd /path/to/RadarApp
```

### Step 3: Initialize Firebase (if not done)
```bash
# Initialize Firebase in the project
firebase init

# Select Hosting
# Choose your Firebase project: RadarApp
# Set public directory: web
# Configure as single-page app: Yes
```

### Step 4: Deploy to Firebase Hosting
```bash
# Deploy the web app
firebase deploy --project=radarapp-7e8c5

# The deployment URL will be shown in the output
# Example: https://radarapp-7e8c5.web.app
```

### Step 5: Verify Deployment
1. Open the Firebase Hosting URL in your browser
2. Test the signup page
3. Verify Firebase SDK is initialized
4. Test Flutterwave payment integration

## Important Configuration Files

### firebase.json
```json
{
  "hosting": {
    "public": "web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

### config.js
Update with your actual Firebase credentials:
```javascript
const config = {
  apiKey: 'YOUR_API_KEY',
  authDomain: 'radarapp-7e8c5.firebaseapp.com',
  projectId: 'radarapp-7e8c5',
  storageBucket: 'radarapp-7e8c5.appspot.com',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  appId: 'YOUR_APP_ID'
};
```

## Environment Variables

Set the following environment variables before deployment:

```bash
export FIREBASE_PROJECT_ID=radarapp-7e8c5
export FLUTTERWAVE_PUBLIC_KEY=FLWPUBK-16a72bd54f4eb876e6a705d899b049d8-X
```

## Features Deployed
✅ User Authentication (Firebase)
✅ Firestore Database Integration
✅ Flutterwave Payment Processing
✅ Wallet System
✅ Monthly Contributions
✅ Loan Feature
✅ Transaction Records
✅ Dark Mode Toggle
✅ Settings Page
✅ Responsive Design

## API Keys & Credentials

The following keys are configured:
- **Flutterwave Public Key**: FLWPUBK-16a72bd54f4eb876e6a705d899b049d8-X
- **Monthly Charge**: NGN 30
- **Wallet Deposit Charge**: NGN 10
- **Maximum Loan Limit**: NGN 1,000,000

## Troubleshooting

### Firebase Authentication Error
```bash
# Clear Firebase cache and re-authenticate
firebase logout
firebase login --no-localhost
```

### Deployment Issues
```bash
# Check Firebase status
firebase status

# View deployment logs
firebase functions:log
```

### CORS Issues
Add CORS headers in firebase.json:
```json
"headers": [
  {
    "key": "Cache-Control",
    "value": "max-age=3600"
  }
]
```

## Testing the App

### Login Flow
1. Visit the deployed URL
2. Sign up with email and password
3. Verify email in Firebase Console
4. Login with credentials

### Payment Flow
1. Click "Contribute"
2. Select month and participants
3. Complete Flutterwave payment
4. Verify transaction in Firestore

### Wallet Feature
1. Navigate to Wallet
2. Enter deposit amount
3. Process payment
4. Check wallet balance update

## Performance Optimization

- Minify CSS and JavaScript
- Enable Firebase hosting cache
- Use CDN for assets
- Optimize images

## Security Considerations

1. Set Firestore security rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    match /transactions/{document=**} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
    }
  }
}
```

2. Enable Authentication Security:
- Enforce strong passwords
- Enable email verification
- Set session timeout

## Maintenance

### Regular Updates
```bash
# Update Firebase CLI
npm install -g firebase-tools@latest

# Update dependencies
npm update
```

### Monitoring
- Monitor Firebase Realtime Database usage
- Check authentication logs
- Review transaction history
- Analyze user engagement

## Support & Documentation

- Firebase Documentation: https://firebase.google.com/docs
- Flutterwave API: https://developer.flutterwave.com
- GitHub Repository: https://github.com/Jerronce/RadarApp

## Version Info

- App Version: 1.0.0
- Firebase SDK: Latest
- Flutterwave SDK: Latest
- Deployment Date: December 19, 2025

