require('dotenv').config();

var isProd = (process.env.NODE_ENV || 'development') === 'production';

module.exports = {
  PORT: process.env.PORT || 5000,
  NODE_ENV: process.env.NODE_ENV || 'development',
  GEMINI_API_KEY: process.env.GEMINI_API_KEY || '',
  ALLOWED_ORIGINS: process.env.ALLOWED_ORIGINS
    ? process.env.ALLOWED_ORIGINS.split(',').map(function(s) { return s.trim(); })
    : (isProd ? ['*'] : ['http://localhost:5000']),
};
