// check mysql database and fetch balance
const connection = require('../connectMySql');

const express = require('express');
const router = express.Router();

router.get('/api/customer/:id', (req, res) => {
    const customerId = req.params.id;
    
    //check for sql injection
    if (customerId.match(/[\s\W]/)) {
        res.status(400).json({ error: 'Invalid customer ID' });
        return;
    }

    connection.query(`SELECT * FROM users WHERE user_id = ?`, [customerId], (err, rows) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        if (rows.length === 0) {
            res.status(404).json({ error: 'Customer not found' });
            return;
        }
        res.json(rows[0]);
    });
});

module.exports = router;