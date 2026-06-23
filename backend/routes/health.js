var express = require('express');
var router = express.Router();
var healthController = require('../controllers/healthController');

router.get('/', healthController.getHealth);

module.exports = router;
