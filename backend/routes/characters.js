var express = require('express');
var router = express.Router();
var charactersController = require('../controllers/charactersController');

router.get('/', charactersController.getCharacters);
router.get('/:id', charactersController.getCharacterById);

module.exports = router;
