import express, { Request, Response } from 'express';
import { Connection } from 'mysql';
const router = express.Router();
import connection from '../connectMySql';

router.post('/api/customer/transfer', (req: Request, res: Response) => {
    const uid: string = req.body.uid;
    const points: number = parseFloat(req.body.points);
    const partner: string = req.body.partner_name;
    let mult: number;

    if (!uid || !points || !partner) {
        res.status(400).json({ error: 'UID, Points, and Partner name are required' });
        return;
    }

    // get company multiplier
    connection.query("SELECT points_earned, scaling_constant, monthly_sales FROM companies WHERE name = ?", [partner], (err, rows: any) => {
        if (err) {
            res.status(500).json({ error: "a" });
            return;
        }
        if (rows.length === 0) {
            res.status(400).json({ error: 'Partner not found' });
            return;
        }
        mult = parseFloat((rows[0].scaling_constant * rows[0].monthly_sales / rows[0].points_earned).toFixed(2));

        // check if user even has enough points
        connection.query("SELECT points FROM users WHERE uid = ?", [uid], (err, rows: any) => {
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

            // deduct points from user account
            connection.query("UPDATE users SET points = points - ? WHERE uid = ?", [points / mult, uid], (err, result: any) => {
                if (err) {
                    res.status(500).json({ error: "c" });
                    return;
                }
                if (result.affectedRows === 0) {
                    res.status(400).json({ error: 'User not found' });
                    return;
                }

                // add points to partner account
                connection.query("UPDATE companies SET monthly_sales = monthly_sales + 1 WHERE name = ?", [partner], (err, result: any) => {
                    if (err) {
                        res.status(500).json({ error: "d" });
                        return;
                    }
                    if (result.affectedRows === 0) {
                        res.status(400).json({ error: 'Partner not found' });
                        return;
                    }

                    // add points_earned to partner account
                    connection.query("UPDATE companies SET points_earned = points_earned + ? WHERE name = ?", [points, partner], (err, result: any) => {
                        if (err) {
                            res.status(500).json({ error: "e" });
                            return;
                        }
                        if (result.affectedRows === 0) {
                            res.status(400).json({ error: 'Partner not found' });
                            return;
                        }
                    });

                    // add transaction to user last_20_transactions and set last_transaction to current time
                    const currentDate = new Date();
                    const formattedDate = `${currentDate.getDate()}/${currentDate.getMonth() + 1}/${currentDate.getFullYear()}`;

                    connection.query(`UPDATE users set last_transaction_date = ? where uid = ?`, [formattedDate, uid], (err) => {
                        if (err) {
                            console.log(err);
                            return;
                        }

                        // add the transaction to the last_20_transactions, if the size is greater than 20, remove the oldest transaction and add the newest one on top
                        connection.query(`SELECT last_20_transactions FROM users WHERE uid = ?`, [uid], (err, rows: any) => {
                            if (err) {
                                console.log(err);
                                return;
                            }
                            let transactions = rows[0].last_20_transactions;
                            try {
                                transactions.reverse();
                                if (transactions.length >= 20) transactions.pop();
                                transactions.push({ company_name: partner, change: `-${points.toFixed(2)}`, date: formattedDate });
                                transactions.reverse();
                            } catch (e) {
                                console.error(e);
                            }
                            connection.query(`UPDATE users SET last_20_transactions = ? WHERE uid = ?`, [JSON.stringify(transactions), uid], (err) => {
                                if (err) {
                                    console.log(err);
                                    return;
                                }
                            });
                        });
                    });

                    res.status(200).json({ success: 'Points transferred successfully' });
                });
            });
        });
    });
});

export default router;
