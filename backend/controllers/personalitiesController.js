var db = require('../config/firebase').db;

function getPersonalities(req, res, next) {
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
  var name = req.body.name;
  var role = req.body.role;
  var bio = req.body.bio;
  var associatedPlaceId = req.body.associatedPlaceId;
  db.collection('personalities').add({ name: name, role: role, bio: bio, associatedPlaceId: associatedPlaceId })
    .then(function(docRef) {
      res.status(201).json({ id: docRef.id, message: 'Personality created' });
    })
    .catch(next);
}

function updatePersonality(req, res, next) {
  var id = req.params.id;
  db.collection('personalities').doc(id).update(req.body)
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
