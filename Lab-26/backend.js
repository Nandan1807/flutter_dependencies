//install npm and create backend with node's express framework
//npm install express mysql body-parser

const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'yourpassword',
  database: 'yourdatabase'
});

// Fetch all items
app.get('/items', (req, res) => {
  db.query('CALL GetAllItems()', (err, results) => {
    if (err) throw err;
    res.json(results[0]);
  });
});

// Add item
app.post('/items', (req, res) => {
  const { title, description } = req.body;
  db.query('CALL AddItem(?, ?)', [title, description], (err, results) => {
    if (err) throw err;
    res.status(201).json({ message: 'Item added successfully' });
  });
});

// Update item
app.put('/items/:id', (req, res) => {
  const { id } = req.params;
  const { title, description } = req.body;
  db.query('CALL UpdateItem(?, ?, ?)', [id, title, description], (err, results) => {
    if (err) throw err;
    res.json({ message: 'Item updated successfully' });
  });
});

// Delete item
app.delete('/items/:id', (req, res) => {
  const { id } = req.params;
  db.query('CALL DeleteItem(?)', [id], (err, results) => {
    if (err) throw err;
    res.json({ message: 'Item deleted successfully' });
  });
});

// Start server
app.listen(3000, () => {
  console.log('Server running on http://localhost:3000');
});
