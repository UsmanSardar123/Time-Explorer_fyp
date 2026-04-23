const admin = require('firebase-admin');

// Service account key path (to be provided via .env)
const serviceAccount = process.env.FIREBASE_SERVICE_ACCOUNT_KEY 
  ? JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_KEY)
  : require('./service-account.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://timeexplorer-fyp.firebaseio.com'
});

const db = admin.firestore();

module.exports = { admin, db };
