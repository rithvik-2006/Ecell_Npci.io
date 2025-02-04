const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/authMiddleware');

router.post('/api/customer/login', authMiddleware, async (req, res) => {
    const user = req.user;

    if (!user) {
        res.status(400).json({ error: 'User is required' });
        return
    }

    // console.log(user)

    try {
        const [rows] = await db.query('SELECT email FROM users WHERE email = ?', [user.email]);
        let newUser;
        if (rows.length === 0) {
            // res.status(404).json({ error: 'User not found in MySQL database' });
            newUser = {
                email: user.email,
                points: 0,
                last_transaction_date: null,
                last_20_transactions: "[]",
                created_at: new Date(),
                updated_at: new Date()
            };
        }

        await db.query('INSERT INTO users SET ?', newUser);
        res.status(200).json({ error: 'User logged in successfully' });
    } catch (error) {
        console.error('Error logging in user:', error);
        res.status(500).json({ error: `Error: ${error}` });
    }
})

module.exports = router;