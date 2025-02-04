// check mysql database and fetch balance
const connection = require('../connectMySql');

const express = require('express');
const router = express.Router();

router.post('/api/customer', (req, res) => {
    const uid = req.body.uid;

    try {
        connection.query(`SELECT * FROM users WHERE uid = ?`, [uid], (err, rows) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (rows.length === 0) {
                res.status(400).json({ error: 'User not found' });
                return;
            }

            //convert to numbers
            Object.keys(rows[0]).forEach(key => {
                const value = rows[0][key];
                if (!isNaN(value) && value !== null && value !== '') rows[0][key] = Number(value);
            });

            res.json(rows[0]);
        });
    } catch {
        console.error('Error fetching user:', error);
        res.status(500).json({ error: `Error: ${error}` });
    }
});

module.exports = router;