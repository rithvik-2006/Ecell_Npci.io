// write a basic express app
const express = require('express');
const fs = require('fs');
const connection = require('./connectMySql').connection;

const balanceRouter = require('./routes/balance');

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));


app.get('/', (req, res) => {
    res.send('Hello World');
    
});

app.use(balanceRouter);

app.listen(3000, () => {
    console.log('Server is running on http://localhost:3000');
});
