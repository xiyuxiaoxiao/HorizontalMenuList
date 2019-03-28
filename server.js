'use strict';

const express = require('express');
const SocketServer = require('ws').Server;
const path = require('path');
const PORT = process.env.PORT || 3000;
const INDEX = path.join(__dirname, 'index.html');
const server = express()
    .use((req, res) => res.sendFile(INDEX))
    .listen(PORT, () => console.log('Listening on ${ PORT }'));
const wss = new SocketServer({  server });
wss.on('connection', (ws) => {
    // ws.send("revice your connect!"); // 暂时去掉连接成功的回调
    ws.on('message', (message) => {
        // ws.send(message);
        wss.clients.forEach((client) => {
            client.send(message);
        })
    });
});