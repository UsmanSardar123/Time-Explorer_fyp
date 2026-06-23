var express = require('express');
var router = express.Router();
var usersController = require('../controllers/usersController');
var auth = require('../middleware/auth');

router.get('/', auth.verifyToken, usersController.getUsers);
router.get('/:uid', auth.verifyToken, usersController.getUserByUid);
router.post('/', auth.verifyToken, usersController.createUser);
router.put('/:uid', auth.verifyToken, usersController.updateUser);
router.delete('/:uid', auth.verifyToken, usersController.deleteUser);

module.exports = router;
