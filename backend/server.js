const express = require('express');
const http = require('http');
const socketIO = require('socket.io');
const cors = require('cors');

const app = express();
const server = http.createServer(app);
const io = socketIO(server);

app.use(cors());

io.on('connection', (socket) => {
  console.log('Client connected');

  socket.on('gyroscopeData', (data) => {
    console.log('Gyroscope data received:', data);
  });

  socket.on('disconnect', () => {
    console.log('Client disconnected');
  });
});

const port = process.env.PORT || 8000;
server.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
