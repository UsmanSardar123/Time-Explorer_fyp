var db = require('../config/firebase').db;

function getUsers(req, res, next) {
  db.collection('users').get()
    .then(function(snapshot) {
      var users = snapshot.docs.map(function(doc) {
        return Object.assign({ uid: doc.id }, doc.data());
      });
      res.json(users);
    })
    .catch(next);
}

function createUser(req, res, next) {
  var email = req.body.email;
  var name = req.body.name;
  var role = req.body.role;
  db.collection('users').add({ email: email, name: name, role: role, progress: {} })
    .then(function(docRef) {
      res.status(201).json({ uid: docRef.id, message: 'User created' });
    })
    .catch(next);
}

function updateUser(req, res, next) {
  var uid = req.params.uid;
  db.collection('users').doc(uid).update(req.body)
    .then(function() {
      res.json({ message: 'User updated' });
    })
    .catch(next);
}

function deleteUser(req, res, next) {
  var uid = req.params.uid;
  db.collection('users').doc(uid).delete()
    .then(function() {
      res.json({ message: 'User deleted' });
    })
    .catch(next);
}

module.exports = {
  getUsers: getUsers,
  createUser: createUser,
  updateUser: updateUser,
  deleteUser: deleteUser,
};
