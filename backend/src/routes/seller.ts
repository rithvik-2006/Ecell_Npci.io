import express, { json } from 'express';
import { Request, Response } from 'express';
import connection from '../connectMySql';
const router = express.Router();

router.post('/api/seller', async (req: Request, res: Response) => {

    // displqay name, perfoemance metrics = [monthly_sales, reward_token_value, recent_sales, recent_sales, graphs: []]

    const uid: string = req.body.uid;
    let jsonRes: any = {};

    connection.query(`SELECT display_name FROM users where uid = '${uid}'`, async (err: any, res1: any[]) => {
        if (err) {
            console.log(err);
            res.status(500).json({ error: err });
            return;
        }

        connection.query(`SELECT * FROM companies where name = '${res1[0].display_name}'`, async (err: any, result: any[]) => {
            if (err) {
                console.log(err);
                res.status(500).json({ error: err });
                return;
            }

            jsonRes = {
                display_name: result[0].name,
                reward_token_value: result[0].reward_token_value,
                sales: [],
            }

            connection.query(`SELECT last_20_transactions FROM users`, async (err: any, res2: any[]) => {
                if (err) {
                    console.log(err);
                    res.status(500).json({ error: err });
                    return;
                }

                res2.forEach(t => {
                    if (t.last_20_transactions.length === 0) return;
                    console.log(t.last_20_transactions);
                    t.last_20_transactions.forEach((temp: { date: any; change: any; }) => {
                        t.company_name = result[0].name ? jsonRes.sales.push({ date: temp.date, price: temp.change.replace("-", "+") }) : null;
                    });
                });

                jsonRes.sales = jsonRes.sales.sort((a: { date: any; }, b: { date: any; }) => {
                    return new Date(a.date).getTime() - new Date(b.date).getTime();
                });

                connection.query(`SELECT image_path, points_earned from companies where name = '${res1[0].display_name}'`, async (err: any, res3: any[]) => {
                    if (err) {
                        console.log(err);
                        res.status(500).json({ error: err });
                        return;
                    }

                    jsonRes.image_path = res3[0].image_path;
                    jsonRes.monthly_sales = res3[0].points_earned;

                    res.status(200).json(jsonRes);
                });
            });


        });

    });

});

export default router;