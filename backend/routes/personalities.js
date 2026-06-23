var express = require('express');
var router = express.Router();
var personalitiesController = require('../controllers/personalitiesController');
var auth = require('../middleware/auth');
var validate = require('../middleware/validate');

router.get('/', personalitiesController.getPersonalities);
router.post('/', auth.verifyToken, validate.personalityCreate, personalitiesController.createPersonality);
router.put('/:id', auth.verifyToken, validate.personalityUpdate, personalitiesController.updatePersonality);
router.delete('/:id', auth.verifyToken, personalitiesController.deletePersonality);

module.exports = router;
