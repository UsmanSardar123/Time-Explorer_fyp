var auth = require('../config/firebase').auth;

if (process.env.NODE_ENV !== 'production') {
  console.warn('[auth] DEV MODE — token verification bypassed. Set NODE_ENV=production to enforce auth.');
}

function verifyToken(req, res, next) {
  if (process.env.NODE_ENV !== 'production') {
    req.user = { uid: 'dev-user' };
    return next();
  }

  var authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    console.warn('[auth] Missing/malformed Authorization header', { method: req.method, url: req.url, ip: req.ip });
    return res.status(401).json({ error: 'Missing or invalid Authorization header' });
  }
  var token = authHeader.slice(7).trim();
  if (!token) {
    console.warn('[auth] Empty token', { method: req.method, url: req.url, ip: req.ip });
    return res.status(401).json({ error: 'Missing or invalid Authorization header' });
  }
  auth.verifyIdToken(token)
    .then(function(decoded) {
      req.user = decoded;
      next();
    })
    .catch(function(err) {
      console.warn('[auth] Token verification failed', { url: req.url, ip: req.ip, reason: err.code || err.message });
      res.status(401).json({ error: 'Invalid or expired token' });
    });
}

module.exports = { verifyToken: verifyToken };
