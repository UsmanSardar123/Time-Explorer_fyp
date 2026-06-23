require('dotenv').config();

var isProd = (process.env.NODE_ENV || 'development') === 'production';

module.exports = {
  PORT: process.env.PORT || 5000,
  NODE_ENV: process.env.NODE_ENV || 'development',
  // Default to '*' in production so the server works even if ALLOWED_ORIGINS is forgotten.
  // In development, default to localhost:5000.
  ALLOWED_ORIGINS: process.env.ALLOWED_ORIGINS
    ? process.env.ALLOWED_ORIGINS.split(',').map(function(s) { return s.trim(); })
    : (isProd ? ['*'] : ['http://localhost:5000']),
};
