// write a basic express app
const express = require('express');
const fs = require('fs');

const app = express();

const path = require('path');
const routesPath = path.join(__dirname, 'routes');

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

fs.readdirSync(routesPath).forEach(file => {
    const route = require(path.join(routesPath, file));
    app.use(route);
});

app.get('/', (req, res) => {
    res.send('Hello World');
});

app.use((req, res, next) => {
    console.log(`\n${req.method} ${req.url} accessed`);
    console.log('Request body:', req.body);
    next();
});

app.listen(3002, () => {
    console.log('Server is running on http://localhost:3002');
});

