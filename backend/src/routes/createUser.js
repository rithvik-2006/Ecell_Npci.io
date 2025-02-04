// check mysql database and fetch balance
const connection = require('../connectMySql');
const admin = require('../utils/firebase');
const express = require('express');
const router = express.Router();
const encryptedString = require('../encrypt');

router.post('/api/customer/create', async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        res.status(400).json({ error: 'Email and password are required' });
        return
    }

    try {
        const userRecord = await admin.auth().getUserByEmail(email).catch(() => null);

        if (userRecord) {
            res.status(401).json({ error: 'User already exists' });
            return
        }

        const newUser = await admin.auth().createUser({
            email,
            password,
        });

        const newUserSQL = {
            uid: newUser.uid,
            points: 0.00,
            last_transaction_date: null,
            last_20_transactions: "[]",
            created_at: new Date(),
            updated_at: new Date(),
            email: await encryptedString(req.body.email),
            display_name: newUser.displayName || "N/A",
        };

        connection.query('INSERT INTO users SET ?', newUserSQL, (err, results) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }

            res.status(200).json({ message: 'User registered successfully', uid: newUser.uid });
        });

    } catch (error) {
        console.error('Error registering user:', error);
        res.status(500).json({ error: `Error: ${error}` });
    }
});

module.exports = router;