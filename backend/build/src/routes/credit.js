"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const connectMySql_1 = __importDefault(require("../connectMySql"));
const router = express_1.default.Router();
router.post("/api/customer/credit", (req, res) => {
    const name = req.body.partner_name;
    const uid = req.body.uid;
    const credit = req.body.credit;
    connectMySql_1.default.query('UPDATE users set points = points + ? where uid = ?', [credit, uid], (err, result) => {
        if (err) {
            console.log(err);
            res.status(500).send('Error updating credit');
        }
        const currentDate = new Date();
        const formattedDate = `${currentDate.getDate()}/${currentDate.getMonth() + 1}/${currentDate.getFullYear()}`;
        connectMySql_1.default.query(`UPDATE users set last_transaction_date = ? where uid = ?`, [formattedDate, uid], (err) => {
            if (err) {
                console.log(err);
                res.status(500).send('Error updating last transaction date');
                return;
            }
            // add the transaction to the last_20_transactions, if the size is greater than 20, remove the oldest transaction and add the newest one on top
            connectMySql_1.default.query(`SELECT last_20_transactions FROM users WHERE uid = ?`, [uid], (err, rows) => {
                if (err) {
                    console.log(err);
                    res.status(500).send('Error updating transactions');
                    return;
                }
                let transactions = rows[0].last_20_transactions;
                try {
                    transactions.reverse();
                    if (transactions.length >= 20)
                        transactions.pop();
                    transactions.push({ company_name: name, change: `+${parseFloat(credit).toFixed(2)}`, date: formattedDate });
                    transactions.reverse();
                }
                catch (e) {
                    console.error(e);
                }
                connectMySql_1.default.query(`UPDATE users SET last_20_transactions = ? WHERE uid = ?`, [JSON.stringify(transactions), uid], (err) => {
                    if (err) {
                        console.log(err);
                        res.status(500).send('Error updating transactions');
                        return;
                    }
                    connectMySql_1.default.query(`SELECT pool from pool WHERE name = ?`, [name], (err, rows) => {
                        if (err) {
                            console.log(err);
                            res.status(500).send('Error updating pool');
                            return;
                        }
                        let pool = rows[0].pool;
                        pool.forEach((entry) => {
                            entry.uid == uid ? entry.points = 0 : entry.points;
                        });
                        console.log(pool);
                        connectMySql_1.default.query(`UPDATE pool set pool = ? WHERE name = ?`, [JSON.stringify(pool), name], (err) => {
                            if (err) {
                                console.log(err);
                                res.status(500).send('Error updating pool');
                                return;
                            }
                            res.status(200).json({ result: "Credit updated" });
                        });
                    });
                });
            });
        });
    });
});
exports.default = router;
