var admin = require('firebase-admin');

var serviceAccount;

if (process.env.FIREBASE_SERVICE_ACCOUNT_KEY) {
  // Production (Render / Railway): service account JSON stored as env var string
  try {
    serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_KEY);
  } catch (e) {
    throw new Error(
      'FIREBASE_SERVICE_ACCOUNT_KEY is not valid JSON. ' +
      'Paste the entire service account JSON as a single-line string in the env var.'
    );
  }
} else {
  // Development: read from local file (never committed to git)
  try {
    serviceAccount = require('../serviceAccountKey.json');
  } catch (e) {
    throw new Error(
      'No Firebase credentials found.\n' +
      '  Development: place serviceAccountKey.json in backend/\n' +
      '  Production:  set FIREBASE_SERVICE_ACCOUNT_KEY env var to the JSON string.\n' +
      '  Download key: Firebase Console → Project Settings → Service Accounts → Generate new private key.'
    );
  }
}

// Normalize escaped newlines in private_key — happens when JSON is stored in env vars
if (serviceAccount.private_key) {
  serviceAccount.private_key = serviceAccount.private_key.replace(/\\n/g, '\n');
}

if (!serviceAccount.private_key) {
  throw new Error('Service account is missing private_key. Verify the JSON is complete.');
}
if (!serviceAccount.client_email) {
  throw new Error('Service account is missing client_email. Verify the JSON is complete.');
}

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

var db = admin.firestore();
var auth = admin.auth();

console.log('[Firebase] Initialized — project:', serviceAccount.project_id || 'unknown');

module.exports = { admin: admin, db: db, auth: auth };
