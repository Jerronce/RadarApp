# Firebase Token Setup - Simple Guide

## Quick Setup (Choose ONE Option)

### ⭐ EASIEST: Copy-Paste Method

If you generated a service account key from Firebase Console:

1. Go to: https://console.firebase.google.com/project/radarapp-5176c/settings/serviceaccounts/adminsdk
2. Click "Generate new private key"
3. You'll get a JSON file
4. Go to GitHub: Settings > Secrets and variables > Actions
5. Click "New repository secret"
6. Name: `FIREBASE_SERVICE_ACCOUNT_KEY`
7. For Value: Go to https://www.base64encode.org/
8. Upload or paste the entire JSON content
9. Copy the base64 output
10. Paste it in GitHub Secrets

### OR: Command Line Method

On your local machine (not Codespaces):
```bash
npm install -g firebase-tools
firebase login:ci
```

This will give you a token. Add it as:
- Name: `FIREBASE_TOKEN`
- Value: [paste the token]

## Verify it Works

After adding the secret, push to GitHub:
```bash
git push origin main
```

Go to: https://github.com/Jerronce/RadarApp/actions

You should see the deployment workflow running!
