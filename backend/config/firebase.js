var admin = require('firebase-admin');

var serviceAccount;
try {
  serviceAccount = require('../serviceAccountKey.json');
} catch (e) {
  throw new Error(
    'serviceAccountKey.json not found in backend/. ' +
    'Download it from Firebase Console → Project Settings → Service Accounts → Generate new private key.'
  );
}

if (!serviceAccount.private_key) {
  throw new Error(
    'serviceAccountKey.json is missing the private_key field. ' +
    'Ensure you downloaded the correct service account JSON from Firebase Console.'
  );
}

if (!serviceAccount.client_email) {
  throw new Error(
    'serviceAccountKey.json is missing the client_email field. ' +
    'Ensure you downloaded the correct service account JSON from Firebase Console.'
  );
}

serviceAccount.private_key = serviceAccount.private_key.replace(/\\n/g, '\n');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

var db = admin.firestore();
var auth = admin.auth();

console.log('Firebase initialized successfully');

module.exports = { admin: admin, db: db, auth: auth };
