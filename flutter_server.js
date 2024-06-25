const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors'); // Import CORS middleware
const app = express();
const port = 3000;

// Middleware setup
app.use(bodyParser.json());
app.use(cors()); // Enable CORS for all routes

// Example in-memory storage (replace with database in production)
let users = [];
let suc = 0;
// Route to handle login
app.post('/login', (req, res) => {
  const { id, pw } = req.body;
  console.log('login start');
  // Example logic to check credentials (replace with your own logic)
  for(let i =0; i< users.length; i++){
    if(id=== users[i].id && pw === users[i].pw){
      res.status(200).send('success');
      console.log('success');
      suc = 1;
    }
  }
  if(suc === 0){
    res.status(401).send('failure');
    console.log('fail');
  }
  suc =0;
});

// Route to handle registration
app.post('/join', (req, res) => {
  const { id, pw } = req.body;
  console.log('입력된 아이디');
  console.log(id);
  console.log('입력된 비밀번호');
  console.log(pw);
  // Example logic to store user (replace with database logic)
  users.push({ id, pw });

  res.status(200).json({ message: 'User registered successfully' });
});

// Start server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
