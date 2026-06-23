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
app.use(cors({ origin: env.ALLOWED_ORIGINS, credentials: true }));
app.use(morgan(env.NODE_ENV === 'production' ? 'combined' : 'dev'));
app.use(rateLimiter.globalLimiter);
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use('/api', routes);

app.use(function(_req, res) {
  res.status(404).json({ error: 'Route not found' });
});

app.use(errorHandler);

app.listen(env.PORT, function() {
  console.log('Time Explorer API running on port ' + env.PORT + ' [' + env.NODE_ENV + ']');
});
