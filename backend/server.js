var env = require('./config/env');
require('./config/firebase');

var express = require('express');
var cors = require('cors');
var helmet = require('helmet');
var morgan = require('morgan');
var rateLimiter = require('./middleware/rateLimiter');
var errorHandler = require('./middleware/errorHandler');
var routes = require('./routes/index');

var app = express();

app.use(helmet());

// CORS — allow all origins when ALLOWED_ORIGINS=* (production mobile backend)
// otherwise restrict to the explicit list (development / web clients)
var allowedOrigins = env.ALLOWED_ORIGINS;
var isWildcard = allowedOrigins.length === 1 && allowedOrigins[0] === '*';
app.use(cors(
  isWildcard
    ? { origin: '*' }
    : { origin: allowedOrigins, credentials: true }
));

app.use(morgan(env.NODE_ENV === 'production' ? 'combined' : 'dev'));
app.use(rateLimiter.globalLimiter);
app.use(express.json({ limit: '50kb' }));
app.use(express.urlencoded({ extended: false, limit: '50kb' }));

app.use('/api', routes);

app.get('/', function(_req, res) {
  res.json({ status: 'ok', service: 'Time Explorer API', environment: env.NODE_ENV });
});

app.use(function(_req, res) {
  res.status(404).json({ error: 'Route not found' });
});

app.use(errorHandler);

app.listen(env.PORT, function() {
  console.log('[Server] Time Explorer API running on port ' + env.PORT + ' [' + env.NODE_ENV + ']');
  console.log('[Server] CORS: ' + (isWildcard ? '* (all origins)' : allowedOrigins.join(', ')));
});
