var express = require('express');
var router = express.Router();
var placesController = require('../controllers/placesController');
var auth = require('../middleware/auth');
var validate = require('../middleware/validate');

router.get('/', placesController.getPlaces);
router.get('/:id/timeline', placesController.getTimeline);
router.get('/:id', placesController.getPlaceById);
router.post('/', auth.verifyToken, validate.placeCreate, placesController.createPlace);
router.put('/:id', auth.verifyToken, validate.placeUpdate, placesController.updatePlace);
router.delete('/:id', auth.verifyToken, placesController.deletePlace);

module.exports = router;
