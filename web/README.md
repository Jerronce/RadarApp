# Ajo/Esusu Web Application

## Project Overview

Ajo/Esusu is a modern web application built with Firebase and JavaScript that facilitates rotating savings and loans (Ajo/Esusu) among friends and communities. The app integrates payment processing via Flutterwave for seamless financial transactions.

## Key Features

### Authentication & Users
- Secure email/password authentication via Firebase
- User registration with name, email, phone, and password
- User profile management
- Secure session handling

### Financial Features
- **Wallet System**: Deposit and manage funds
- **Monthly Contributions**: Set up and track monthly savings
- **Participant Selection**: Choose contributors for each cycle
- **Loan Feature**: Apply for loans up to NGN 1,000,000
- **Payment Processing**: Integrated Flutterwave payments
- **Transaction History**: Complete audit trail of all transactions

### User Interface
- **Responsive Design**: Works on desktop, tablet, and mobile
- **Dark Mode**: Toggle dark/light theme
- **Intuitive Navigation**: Easy-to-use page switching
- **Loading States**: Visual feedback during operations

### Data Management
- **Firestore Database**: Real-time data synchronization
- **User Data**: Secure storage of profiles and balances
- **Transactions**: Complete transaction logging
- **Loans**: Loan application and tracking

## Technical Stack

### Frontend
- **HTML5**: Semantic markup
- **CSS3**: Responsive styling with dark mode support
- **JavaScript**: Vanilla JS for app logic
- **Firebase SDK**: Authentication, Firestore, Storage
- **Flutterwave SDK**: Payment processing

### Backend & Services
- **Firebase Authentication**: User management
- **Cloud Firestore**: NoSQL database
- **Firebase Hosting**: Web app hosting
- **Flutterwave**: Payment gateway

## File Structure

```
web/
├── index.html          # Main HTML structure
├── app.js              # Application logic
├── config.js           # Firebase & API configuration
├── styles.css          # CSS styling
├── favicon.png         # App icon
└── manifest.json       # PWA manifest
```

## Configuration

### Firebase Configuration (config.js)
```javascript
const config = {
  apiKey: 'YOUR_API_KEY',
  authDomain: 'radarapp-7e8c5.firebaseapp.com',
  projectId: 'radarapp-7e8c5',
  storageBucket: 'radarapp-7e8c5.appspot.com',
  messagingSenderId: 'YOUR_SENDER_ID',
  appId: 'YOUR_APP_ID'
};
```

### Flutterwave Configuration
- **Public Key**: FLWPUBK-16a72bd54f4eb876e6a705d899b049d8-X
- **Currency**: NGN (Nigerian Naira)
- **Supported Payment Methods**: Card, Mobile Money, USSD

## Application Pages

### 1. Login Page
- User authentication
- Email and password fields
- Error handling
- Link to signup

### 2. Signup Page
- User registration
- Name, email, phone, password fields
- Input validation
- Firebase user creation

### 3. Home Page
- Welcome message
- Wallet balance display
- Total contributions
- Total borrowed amount
- Quick action buttons

### 4. Contribute Page
- Month selection
- Amount input
- Participant selection
- Payment processing

### 5. Wallet Page
- View balance
- Deposit funds
- Transaction summary
- Deposit fee: NGN 10

### 6. Loan Page
- Loan application form
- Amount input (max NGN 1,000,000)
- Application status
- Due date calculation

### 7. Records/History Page
- Transaction list
- Filtered by user
- Sorted by date (newest first)
- Amount and type display

### 8. Settings Page
- Dark mode toggle
- Notification preferences
- Data saver option
- Account deletion
- Logout function

## Key Functions

### Authentication
- `signup()`: Register new user
- `login()`: User login
- `logout()`: Sign out user
- `deleteAccount()`: Remove user account

### Navigation
- `showPage(pageName)`: Navigate between pages
- `goBack()`: Return to home

### Financial Operations
- `processPayment(amount)`: Handle Flutterwave transactions
- `depositToWallet()`: Add funds to wallet
- `applyForLoan()`: Submit loan application
- `confirmParticipants()`: Finalize contribution setup

### Data Management
- `loadUserData()`: Fetch user profile
- `loadParticipants()`: Load available contributors
- `loadRecords()`: Display transaction history

### UI Features
- `toggleDarkMode()`: Switch theme
- `displayWelcome()`: Show personalized message

## Pricing Structure

- **Monthly Contribution**: NGN 30 (configurable)
- **Wallet Deposit Fee**: NGN 10 (fixed)
- **Loan Processing**: Free
- **Transaction Fee**: Included in Flutterwave processing

## Security Features

1. **Firebase Security Rules**: Role-based access control
2. **Password Security**: Hashed passwords via Firebase
3. **Session Management**: Automatic logout on page close
4. **Data Encryption**: HTTPS for all transactions
5. **User Privacy**: Isolated user data per account

## Browser Compatibility

- Chrome/Chromium (recommended)
- Firefox
- Safari
- Edge
- Mobile browsers (iOS Safari, Chrome Mobile)

## Performance Metrics

- **Page Load Time**: < 3 seconds
- **Firebase Query Response**: < 1 second
- **Payment Processing**: 2-5 seconds
- **Responsive Breakpoints**: 320px, 768px, 1024px+

## Future Enhancements

- [ ] Group management
- [ ] Recurring payments
- [ ] Mobile app version
- [ ] Multi-currency support
- [ ] Admin dashboard
- [ ] Email notifications
- [ ] SMS alerts
- [ ] API rate limiting

## Deployment URL

https://radarapp-7e8c5.web.app

## Development

### Prerequisites
- Node.js 14+
- Firebase CLI 9+
- Modern web browser

### Local Development
```bash
# Install dependencies
npm install -g firebase-tools

# Serve locally
firebase serve

# Open http://localhost:5000
```

### Deployment
```bash
# Deploy to Firebase Hosting
firebase deploy
```

## Testing

### Manual Testing Checklist
- [ ] User signup and login
- [ ] Profile creation and update
- [ ] Wallet deposit
- [ ] Contribution payment
- [ ] Loan application
- [ ] Transaction history viewing
- [ ] Dark mode toggle
- [ ] Responsive design on mobile
- [ ] Form validation
- [ ] Error handling

## Troubleshooting

### Payment Issues
- Clear browser cache
- Check Flutterwave test keys
- Verify network connection
- Check browser console for errors

### Firebase Issues
- Verify Firebase credentials in config.js
- Check Firebase console for errors
- Ensure Firestore is initialized
- Check security rules

### UI Issues
- Clear local storage: `localStorage.clear()`
- Refresh page with Ctrl+Shift+R
- Check browser console
- Test in incognito mode

## Support & Documentation

- **Firebase Docs**: https://firebase.google.com/docs
- **Flutterwave Docs**: https://developer.flutterwave.com
- **GitHub Issues**: https://github.com/Jerronce/RadarApp/issues
- **Email Support**: support@radarapp.com

## License

MIT License - See LICENSE file for details

## Author

**Jerronce** - AI Engineer & Full-Stack Developer
- GitHub: https://github.com/Jerronce
- Portfolio: https://jerronce.com

## Changelog

### Version 1.0.0 (December 19, 2025)
- Initial release
- Firebase authentication
- Firestore integration
- Flutterwave payments
- Complete UI/UX
- Mobile responsive
- Dark mode support

