const express = require('express');
const cors = require('cors');
const { db } = require('./firebase-config');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// Users Management
app.get('/api/users', async (req, res) => {
  try {
    const snapshot = await db.collection('users').get();
    const users = snapshot.docs.map(doc => ({ uid: doc.id, ...doc.data() }));
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/users', async (req, res) => {
  try {
    const { email, name, role } = req.body;
    const docRef = await db.collection('users').add({ email, name, role, progress: {} });
    res.json({ uid: docRef.id, message: 'User created' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.put('/api/users/:uid', async (req, res) => {
  try {
    const { uid } = req.params;
    await db.collection('users').doc(uid).update(req.body);
    res.json({ message: 'User updated' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.delete('/api/users/:uid', async (req, res) => {
  try {
    const { uid } = req.params;
    await db.collection('users').doc(uid).delete();
    res.json({ message: 'User deleted' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Places Management (Eras/Locations)
app.get('/api/places', async (req, res) => {
  try {
    const snapshot = await db.collection('places').get();
    const places = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.json(places);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/places', async (req, res) => {
  try {
    const { name, era, coordinates, description, mediaUrls } = req.body;
    const docRef = await db.collection('places').add({ name, era, coordinates, description, mediaUrls });
    res.json({ id: docRef.id, message: 'Place created' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Personalities Management
app.get('/api/personalities', async (req, res) => {
  try {
    const snapshot = await db.collection('personalities').get();
    const personalities = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.json(personalities);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/personalities', async (req, res) => {
  try {
    const { name, role, bio, associatedPlaceId } = req.body;
    const docRef = await db.collection('personalities').add({ name, role, bio, associatedPlaceId });
    res.json({ id: docRef.id, message: 'Personality created' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
