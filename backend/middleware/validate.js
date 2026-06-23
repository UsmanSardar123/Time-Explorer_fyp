var { body, query, validationResult } = require('express-validator');

function handleValidation(req, res, next) {
  var errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ error: errors.array()[0].msg });
  }
  next();
}

var userCreate = [
  body('email').isEmail().withMessage('Valid email is required').normalizeEmail(),
  body('name').isString().trim().notEmpty().withMessage('name is required').isLength({ max: 100 }),
  body('role').optional().isString().trim().isLength({ max: 50 }),
  handleValidation,
];

var userUpdate = [
  body('email').optional().isEmail().withMessage('Invalid email').normalizeEmail(),
  body('name').optional().isString().trim().notEmpty().isLength({ max: 100 }),
  body('role').optional().isString().trim().isLength({ max: 50 }),
  handleValidation,
];

var placeCreate = [
  body('name').isString().trim().notEmpty().withMessage('name is required').isLength({ max: 200 }),
  body('era').isString().trim().notEmpty().withMessage('era is required').isLength({ max: 100 }),
  body('description').optional().isString().trim().isLength({ max: 2000 }),
  body('coordinates').optional().isObject().withMessage('coordinates must be an object'),
  body('mediaUrls').optional().isArray({ max: 20 }).withMessage('mediaUrls must be an array'),
  handleValidation,
];

var placeUpdate = [
  body('name').optional().isString().trim().notEmpty().isLength({ max: 200 }),
  body('era').optional().isString().trim().notEmpty().isLength({ max: 100 }),
  body('description').optional().isString().trim().isLength({ max: 2000 }),
  body('coordinates').optional().isObject().withMessage('coordinates must be an object'),
  body('mediaUrls').optional().isArray({ max: 20 }),
  handleValidation,
];

var personalityCreate = [
  body('name').isString().trim().notEmpty().withMessage('name is required').isLength({ max: 150 }),
  body('role').isString().trim().notEmpty().withMessage('role is required').isLength({ max: 150 }),
  body('bio').optional().isString().trim().isLength({ max: 3000 }),
  body('associatedPlaceId').optional().isString().trim().isLength({ max: 100 }),
  handleValidation,
];

var personalityUpdate = [
  body('name').optional().isString().trim().notEmpty().isLength({ max: 150 }),
  body('role').optional().isString().trim().notEmpty().isLength({ max: 150 }),
  body('bio').optional().isString().trim().isLength({ max: 3000 }),
  body('associatedPlaceId').optional().isString().trim().isLength({ max: 100 }),
  handleValidation,
];

var aiAsk = [
  body('prompt').isString().withMessage('prompt must be a string').trim().notEmpty().withMessage('prompt is required').isLength({ max: 4000 }).withMessage('prompt exceeds 4000 character limit'),
  handleValidation,
];

module.exports = {
  userCreate: userCreate,
  userUpdate: userUpdate,
  placeCreate: placeCreate,
  placeUpdate: placeUpdate,
  personalityCreate: personalityCreate,
  personalityUpdate: personalityUpdate,
  aiAsk: aiAsk,
};
