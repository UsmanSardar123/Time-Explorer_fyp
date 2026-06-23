var db = require('../config/firebase').db;

function getPlaces(req, res, next) {
  db.collection('places').get()
    .then(function(snapshot) {
      var places = snapshot.docs.map(function(doc) {
        return Object.assign({ id: doc.id }, doc.data());
      });
      res.json(places);
    })
    .catch(next);
}

function createPlace(req, res, next) {
  var name = req.body.name;
  var era = req.body.era;
  var coordinates = req.body.coordinates;
  var description = req.body.description;
  var mediaUrls = req.body.mediaUrls;
  db.collection('places').add({ name: name, era: era, coordinates: coordinates, description: description, mediaUrls: mediaUrls })
    .then(function(docRef) {
      res.status(201).json({ id: docRef.id, message: 'Place created' });
    })
    .catch(next);
}

function updatePlace(req, res, next) {
  var id = req.params.id;
  db.collection('places').doc(id).update(req.body)
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
  createPlace: createPlace,
  updatePlace: updatePlace,
  deletePlace: deletePlace,
};
