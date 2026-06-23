var admin = require('firebase-admin');

if (!process.env.FIREBASE_SERVICE_ACCOUNT_KEY) {
  throw new Error(
    'Missing FIREBASE_SERVICE_ACCOUNT_KEY env var. ' +
    'See backend/.env.example for setup instructions.'
  );
}

var serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_KEY);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

var db = admin.firestore();
var auth = admin.auth();

module.exports = { admin: admin, db: db, auth: auth };
