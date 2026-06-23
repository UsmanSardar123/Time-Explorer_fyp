require('dotenv').config();

const required = ['FIREBASE_SERVICE_ACCOUNT_KEY'];

required.forEach(function(key) {
  if (!process.env[key]) {
    throw new Error('Missing required env variable: ' + key);
  }
});

module.exports = {
  PORT: process.env.PORT || 5000,
  NODE_ENV: process.env.NODE_ENV || 'development',
  ALLOWED_ORIGINS: process.env.ALLOWED_ORIGINS
    ? process.env.ALLOWED_ORIGINS.split(',')
    : ['http://localhost:3000'],
};
