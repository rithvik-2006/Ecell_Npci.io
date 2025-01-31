// check mysql database and fetch balance
const connection = require('../connectMySql');

const express = require('express');
const router = express.Router();

router.get('/api/customer/:id', (req, res) => {
    const customerId = req.params.id;
    connection.query(`SELECT * FROM users WHERE id = ?`, [customerId], (err, rows) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        if (rows.length === 0) {
            res.status(404).json({ error: 'Customer not found' });
            return;
        }
        res.json({ balance: rows[0].balance });
    });
});

module.exports = router;