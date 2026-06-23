var express = require('express');
var router = express.Router();
var placesController = require('../controllers/placesController');
var auth = require('../middleware/auth');

router.get('/', placesController.getPlaces);
router.post('/', auth.verifyToken, placesController.createPlace);
router.put('/:id', auth.verifyToken, placesController.updatePlace);
router.delete('/:id', auth.verifyToken, placesController.deletePlace);

module.exports = router;
