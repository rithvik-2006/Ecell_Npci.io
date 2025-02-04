import express, { Request, Response } from "express";
import { Connection } from "mysql";
import makeChart from "../utils/generateChart";

const router = express.Router();
import connection from "../connectMySql";

router.post("/api/customer/statistics", async (req: Request, res: Response) => {
    const uid: string = req.body.uid;

    connection.query("SELECT created_at, display_name, last_20_transactions, points FROM users WHERE uid = ?", [uid], async (err: any, result: any) => {
        if (err) {
            console.log(err);
            res.status(500).json({ error: "Internal Server Error" });
            return;
        }
        if (result.length === 0) {
            res.status(404).json({ error: "Customer not found" });
            return;
        }

        const transactions = result[0].last_20_transactions;
        const categories: { [key: string]: number } = {};
        const companies: { [key: string]: number } = {};

        const transactionPromises = transactions.map((transaction: any) => {
            return new Promise<void>((resolve, reject) => {
                let name = transaction.company_name;
                connection.query("SELECT company_type FROM companies where name = ?", [name], (err, result: any[]) => {
                    if (err) {
                        return reject(err);
                    }
                    if (result.length === 0) {
                        return reject(new Error("Company not found"));
                    }
                    let category = result[0].company_type;

                    if (category in categories) {
                        categories[category] += 1;
                    } else {
                        categories[category] = 1;
                    }

                    if (name in companies) {
                        companies[name] += 1;
                    } else {
                        companies[name] = 1;
                    }
                    resolve();
                });
            });
        });

        try {
            await Promise.all(transactionPromises);
        } catch (err) {
            console.log(err);
            res.status(500).json({ error: "Internal Server Error" });
            return;
        }

        const jsonResult = {
            created_at: result[0].created_at,
            display_name: result[0].display_name,
            chart: await makeChart(categories),
            points: result[0].points
        };

        res.status(200).json(jsonResult);
    });
});

export default router;
