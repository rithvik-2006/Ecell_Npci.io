// check mysql database and fetch balance
const connection = require('../connectMySql');

const express = require('express');
const router = express.Router();

router.get('/api/companies', (req, res) => {
    
    connection.query(`SELECT * FROM companies`, (err, rows) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        if (rows.length === 0) {
            res.status(404).json({ error: 'No companies to show.' });
            return;
        }
        res.status(200);
        res.json(rows);
    });
});

module.exports = router;