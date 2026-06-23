var express = require('express');
var router = express.Router();

router.use('/health', require('./health'));
router.use('/users', require('./users'));
router.use('/places', require('./places'));
router.use('/personalities', require('./personalities'));
router.use('/characters', require('./characters'));
router.use('/ai', require('./ai.routes'));

module.exports = router;
