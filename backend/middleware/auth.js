var auth = require('../config/firebase').auth;

function verifyToken(req, res, next) {
  var authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Missing or invalid Authorization header' });
  }
  var token = authHeader.slice(7).trim();
  if (!token) {
    return res.status(401).json({ error: 'Missing or invalid Authorization header' });
  }
  auth.verifyIdToken(token)
    .then(function(decoded) {
      req.user = decoded;
      next();
    })
    .catch(function() {
      res.status(401).json({ error: 'Invalid or expired token' });
    });
}

module.exports = { verifyToken: verifyToken };
