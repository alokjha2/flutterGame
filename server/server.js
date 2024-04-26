const express = require('express');
const http = require('http');
const socketIo = require('socket.io');

const PORT = process.env.PORT || 8080;

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

// Array to store connected players
let players = [];

// Event handler for new player connections
io.on('connection', (socket) => {
    console.log('A new player has connected: ' + socket.id);

    // Add new player to the players array
    players.push({ id: socket.id });

    // Emit event to inform all clients about the updated player list
    io.emit('playerList', players);

    // Event handler for player disconnects
    socket.on('disconnect', () => {
        console.log('Player disconnected: ' + socket.id);

        // Remove disconnected player from the players array
        players = players.filter(player => player.id !== socket.id);

        // Emit event to inform all clients about the updated player list
        io.emit('playerList', players);
    });

    // Event handler for player moves
    socket.on('move', (data) => {
        // Broadcast the move to all other connected clients
        socket.broadcast.emit('move', data);
    });
});

// Start the server
server.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
