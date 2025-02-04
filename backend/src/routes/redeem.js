const express = require('express');
const router = express.Router();

const connection = require('../connectMySql');

router.post('/api/customer/redeem', (req, res) => {
    const uid = req.body.uid;
    
    if (!uid) {
        res.status(400).json({ error: 'UID is required' });
        return
    }
    let returnObj = {
        points: 0,
    };

    connection.query(`SELECT * FROM users WHERE uid = ?`, [uid], (err, rows) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        if (rows.length === 0) {
            res.status(400).json({ error: 'User not found' });
            return;
        }

        returnObj.points = rows[0].points;

        // iterate through the companies in "companies table"

        connection.query(`SELECT * FROM companies`, (err, rows) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (rows.length === 0) {
                res.status(400).json({ error: 'No companies found' });
                return;
            }

            let partners = [];

            
            rows.forEach(company => {
                let mult =  parseFloat(( company.scaling_constant * company.monthly_sales / company.points_earned).toFixed(2))
                let temp = {
                    name: company.name,
                    image_path: company.image_path,
                    normalised_points: parseFloat((returnObj.points * mult).toFixed(2)),
                    multiplier: mult
                }

                partners.push(temp);
            });

            returnObj.partners = partners;
            res.json(returnObj);
        });
    });
});

module.exports = router;