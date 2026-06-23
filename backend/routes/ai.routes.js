var express = require('express');
var router = express.Router();
var verifyToken = require('../middleware/auth').verifyToken;
var aiLimiter = require('../middleware/rateLimiter').aiLimiter;
var validate = require('../middleware/validate');
var aiController = require('../controllers/ai.controller');

router.post('/ask', aiLimiter, verifyToken, validate.aiAsk, aiController.ask);

module.exports = router;
