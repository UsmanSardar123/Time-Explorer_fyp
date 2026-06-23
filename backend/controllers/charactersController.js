var db = require('../config/firebase').db;

function getCharacters(req, res, next) {
  db.collection('characters').get()
    .then(function(snapshot) {
      var characters = snapshot.docs.map(function(doc) {
        return Object.assign({ id: doc.id }, doc.data());
      });
      res.json(characters);
    })
    .catch(next);
}

function getCharacterById(req, res, next) {
  var id = req.params.id;
  db.collection('characters').doc(id).get()
    .then(function(doc) {
      if (!doc.exists) {
        return res.status(404).json({ error: 'Character not found' });
      }
      res.json(Object.assign({ id: doc.id }, doc.data()));
    })
    .catch(next);
}

module.exports = {
  getCharacters: getCharacters,
  getCharacterById: getCharacterById,
};
