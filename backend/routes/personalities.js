var express = require('express');
var router = express.Router();
var personalitiesController = require('../controllers/personalitiesController');
var auth = require('../middleware/auth');

router.get('/', personalitiesController.getPersonalities);
router.post('/', auth.verifyToken, personalitiesController.createPersonality);
router.put('/:id', auth.verifyToken, personalitiesController.updatePersonality);
router.delete('/:id', auth.verifyToken, personalitiesController.deletePersonality);

module.exports = router;
