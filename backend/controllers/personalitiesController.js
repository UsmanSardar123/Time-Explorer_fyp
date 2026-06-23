var db = require('../config/firebase').db;

function getPersonalities(_req, res, next) {
  db.collection('personalities').get()
    .then(function(snapshot) {
      var personalities = snapshot.docs.map(function(doc) {
        return Object.assign({ id: doc.id }, doc.data());
      });
      res.json(personalities);
    })
    .catch(next);
}

function createPersonality(req, res, next) {
  var doc = {
    name: req.body.name,
    role: req.body.role,
    bio: req.body.bio || '',
    associatedPlaceId: req.body.associatedPlaceId || null,
  };
  db.collection('personalities').add(doc)
    .then(function(docRef) {
      res.status(201).json({ id: docRef.id, message: 'Personality created' });
    })
    .catch(next);
}

function updatePersonality(req, res, next) {
  var id = req.params.id;
  // Whitelist updatable fields — prevents arbitrary Firestore field injection
  var allowed = ['name', 'role', 'bio', 'associatedPlaceId'];
  var update = {};
  allowed.forEach(function(key) {
    if (req.body[key] !== undefined) update[key] = req.body[key];
  });
  if (Object.keys(update).length === 0) {
    return res.status(400).json({ error: 'No valid fields provided for update' });
  }
  db.collection('personalities').doc(id).update(update)
    .then(function() {
      res.json({ message: 'Personality updated' });
    })
    .catch(next);
}

function deletePersonality(req, res, next) {
  var id = req.params.id;
  db.collection('personalities').doc(id).delete()
    .then(function() {
      res.json({ message: 'Personality deleted' });
    })
    .catch(next);
}

module.exports = {
  getPersonalities: getPersonalities,
  createPersonality: createPersonality,
  updatePersonality: updatePersonality,
  deletePersonality: deletePersonality,
};
