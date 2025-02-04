import express from "express"
import { Response, Request } from "express"
import connection from "../connectMySql";

const router = express.Router();

router.post("/api/customer/credit", (req: Request, res: Response) => {
    const name: string = req.body.partner_name;
    const uid: string = req.body.uid;
    const credit: string = req.body.credit;

    connection.query('UPDATE users set points = points + ? where uid = ?', [credit, uid], (err, result) => {
        if (err) {
            console.log(err);
            res.status(500).send('Error updating credit');
        }
        const currentDate = new Date();
        const formattedDate = `${currentDate.getDate()}/${currentDate.getMonth() + 1}/${currentDate.getFullYear()}`;

        connection.query(`UPDATE users set last_transaction_date = ? where uid = ?`, [formattedDate, uid], (err) => {
            if (err) {
                console.log(err);
                res.status(500).send('Error updating last transaction date');
                return;
            }

            // add the transaction to the last_20_transactions, if the size is greater than 20, remove the oldest transaction and add the newest one on top
            connection.query(`SELECT last_20_transactions FROM users WHERE uid = ?`, [uid], (err, rows: any) => {
                if (err) {
                    console.log(err);
                    res.status(500).send('Error updating transactions');
                    return;
                }
                let transactions = rows[0].last_20_transactions;
                try {
                    transactions.reverse();
                    if (transactions.length >= 20) transactions.pop();


                    transactions.push({ company_name: name, change: `+${parseFloat(credit).toFixed(2)}`, date: formattedDate });
                    transactions.reverse();
                } catch (e) {
                    console.error(e);
                }
                connection.query(`UPDATE users SET last_20_transactions = ? WHERE uid = ?`, [JSON.stringify(transactions), uid], (err) => {
                    if (err) {
                        console.log(err);
                        res.status(500).send('Error updating transactions');
                        return;
                    }
                    connection.query(`SELECT pool from pool WHERE name = ?`, [name], (err: any, rows: any[]) => {
                        if (err) {
                            console.log(err);
                            res.status(500).send('Error updating pool');
                            return;
                        }

                        let pool = rows[0].pool
                        pool.forEach((entry: { uid: string; points: number; }) => {
                            entry.uid == uid ? entry.points = 0 : entry.points;
                        });

                        console.log(pool);

                        connection.query(`UPDATE pool set pool = ? WHERE name = ?`, [JSON.stringify(pool), name], (err: any) => {
                            if (err) {
                                console.log(err);
                                res.status(500).send('Error updating pool');
                                return;
                            }
                            res.status(200).json({result: "Credit updated"});
                        });
                        
                    });

                });
            });
        });

    });

});


export default router;