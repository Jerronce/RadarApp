// RadarApp - Simple initialization without ES6 modules

// Firebase configuration
const firebaseConfig = {
  apiKey: 'AIzaSyDExample',
  authDomain: 'radarapp-5176c.firebaseapp.com',
  projectId: 'radarapp-5176c',
  storageBucket: 'radarapp-5176c.appspot.com',
  messagingSenderId: '123456789',
  appId: '1:123456789:web:abc123def456'
};

// Initialize the app UI
function initializeApp() {
  console.log('RadarApp initialized successfully!');
  const appDiv = document.getElementById('app');
  if (appDiv) {
    appDiv.innerHTML = `
      <div style="padding: 20px; font-family: Arial, sans-serif;">
        <h1>Welcome to RadarApp - Ajo/Esusu Web App</h1>
        <p>Your application is now running!</p>
        <p>Version: 1.0</p>
        <p>Firebase Project: radarapp-5176c</p>
      </div>
    `;
  } else {
    console.error('App container not found!');
  }
}

// Initialize when DOM is ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initializeApp);
} else {
  initializeApp();
}

// Export for other modules
window.radarApp = {
  config: firebaseConfig,
  init: initializeApp
};