var firebase = require('../config/firebase');
var db = firebase.db;
var admin = firebase.admin;

function getPlaces(req, res, next) {
  var category = req.query.category;
  var eraId = req.query.eraId;
  var ids = req.query.ids ? req.query.ids.split(',').filter(Boolean).slice(0, 10) : null;
  var MAX_LIMIT = 50;
  var requestedLimit = req.query.limit ? parseInt(req.query.limit, 10) : null;
  var limit = requestedLimit ? Math.min(requestedLimit, MAX_LIMIT) : MAX_LIMIT;

  var query = db.collection('places');

  if (ids) {
    query = query.where(admin.firestore.FieldPath.documentId(), 'in', ids);
  } else {
    if (category) query = query.where('category', '==', category);
    if (eraId) query = query.where('eraId', '==', eraId);
    if (limit) query = query.limit(limit);
  }

  query.get()
    .then(function(snapshot) {
      var places = snapshot.docs.map(function(doc) {
        return Object.assign({ id: doc.id }, doc.data());
      });
      res.json(places);
    })
    .catch(next);
}

function getPlaceById(req, res, next) {
  var id = req.params.id;
  db.collection('places').doc(id).get()
    .then(function(doc) {
      if (!doc.exists) {
        return res.status(404).json({ error: 'Place not found' });
      }
      res.json(Object.assign({ id: doc.id }, doc.data()));
    })
    .catch(next);
}

function getTimeline(req, res, next) {
  var id = req.params.id;
  db.collection('places').doc(id).collection('timeline')
    .orderBy('orderIndex')
    .get()
    .then(function(snapshot) {
      var events = snapshot.docs.map(function(doc) {
        return Object.assign({ id: doc.id }, doc.data());
      });
      res.json(events);
    })
    .catch(next);
}

function createPlace(req, res, next) {
  var doc = {
    name: req.body.name,
    era: req.body.era,
    coordinates: req.body.coordinates || null,
    description: req.body.description || '',
    mediaUrls: req.body.mediaUrls || [],
  };
  db.collection('places').add(doc)
    .then(function(docRef) {
      res.status(201).json({ id: docRef.id, message: 'Place created' });
    })
    .catch(next);
}

function updatePlace(req, res, next) {
  var id = req.params.id;
  // Whitelist updatable fields — prevents arbitrary Firestore field injection
  var allowed = ['name', 'era', 'coordinates', 'description', 'mediaUrls', 'category', 'eraId'];
  var update = {};
  allowed.forEach(function(key) {
    if (req.body[key] !== undefined) update[key] = req.body[key];
  });
  if (Object.keys(update).length === 0) {
    return res.status(400).json({ error: 'No valid fields provided for update' });
  }
  db.collection('places').doc(id).update(update)
    .then(function() {
      res.json({ message: 'Place updated' });
    })
    .catch(next);
}

function deletePlace(req, res, next) {
  var id = req.params.id;
  db.collection('places').doc(id).delete()
    .then(function() {
      res.json({ message: 'Place deleted' });
    })
    .catch(next);
}

module.exports = {
  getPlaces: getPlaces,
  getPlaceById: getPlaceById,
  getTimeline: getTimeline,
  createPlace: createPlace,
  updatePlace: updatePlace,
  deletePlace: deletePlace,
};
