const express = require('express');
const router = express.Router();
const connection = require('../connectMySql');

router.post('/api/customer/transfer', (req, res) => {
    const uid = req.body.uid;
    const points = parseFloat(req.body.points);
    const partner = req.body.partner_name;
    var mult;
    // console.log(uid, points, partner);

    // get company mulitplier
    connection.query("SELECT points_earned, scaling_constant, monthly_sales FROM companies WHERE name = ?", [partner], (err, rows) => {
        if (err) {
            res.status(500).json({ error: "a" });
            return;
        }
        if (rows.length === 0) {
            res.status(400).json({ error: 'Partner not found' });
            return;
        }
        // console.log(parseFloat((rows[0].scaling_constant * rows[0].monthly_sales / rows[0].points_earned).toFixed(2)));
        mult = parseFloat((rows[0].scaling_constant * rows[0].monthly_sales / rows[0].points_earned).toFixed(2));
    });

    if (!uid || !points || !partner) {
        res.status(400).json({ error: 'UID, Points, and Partner name are required' });
        return;
    }
    
    // check if user even has enough points
    connection.query("SELECT points FROM users WHERE uid = ?", [uid], (err, rows) => {
        if (err) {
            res.status(500).json({ error: "b" });
            return;
        }
        if (rows.length === 0) {
            res.status(400).json({ error: 'User not found' });
            return;
        }
        if (rows[0].points < (points / mult)) {
            res.status(400).json({ error: 'Insufficient points' });
            return;
        }
        
        //deduct points from user account
        connection.query("UPDATE users SET points = points - ? WHERE uid = ?", [points / mult, uid], (err, result) => {
            if (err) {
                res.status(500).json({ error: "c" });
                return;
            }
            if (result.affectedRows === 0) {
                res.status(400).json({ error: 'User not found' });
                return;
            }
    
            // add points to partner account
            connection.query("UPDATE companies SET monthly_sales = monthly_sales + 1 WHERE name = ?", [partner], (err, result) => {
                if (err) {
                    res.status(500).json({ error: "d" });
                    return;
                }
                if (result.affectedRows === 0) {
                    res.status(400).json({ error: 'Partner not found' });
                    return;
                }
    
                // add points_earned to partner account
                connection.query("UPDATE companies SET points_earned = points_earned + ? WHERE name = ?", [points, partner], (err, result) => {
                    if (err) {
                        res.status(500).json({ error: "e" });
                        return;
                    }
                    if (result.affectedRows === 0) {
                        res.status(400).json({ error: 'Partner not found' });
                        return;
                    }
                });
    
                res.status(200).json({ success: 'Points transferred successfully' });
            });
        });
    });
});

module.exports = router;