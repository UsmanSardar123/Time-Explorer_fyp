var express = require('express');
var router = express.Router();
var verifyToken = require('../middleware/auth').verifyToken;
var aiController = require('../controllers/ai.controller');

router.post('/ask', verifyToken, aiController.ask);

module.exports = router;
