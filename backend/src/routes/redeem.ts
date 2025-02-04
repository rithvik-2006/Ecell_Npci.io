import express, { Request, Response } from 'express';
import { Connection } from 'mysql';

const router = express.Router();
import connection from '../connectMySql';

interface Company {
    name: string;
    image_path: string;
    scaling_constant: number;
    monthly_sales: number;
    points_earned: number;
}

interface User {
    points: number;
}

router.post('/api/customer/redeem', (req: Request, res: Response) => {
    const uid: string = req.body.uid;

    if (!uid) {
        res.status(400).json({ error: 'UID is required' });
        return;
    }

    let returnObj = {
        points: 0,
        partners: [] as {
            name: string;
            image_path: string;
            normalised_points: number;
            multiplier: number;
        }[]
    };

    connection.query('SELECT * FROM users WHERE uid = ?', [uid], (err: any, rows: any) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        if (rows.length === 0) {
            res.status(400).json({ error: 'User not found' });
            return;
        }

        returnObj.points = rows[0].points;

        connection.query('SELECT * FROM companies', (err: any, rows: any) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (rows.length === 0) {
                res.status(400).json({ error: 'No companies found' });
                return;
            }

            rows.forEach((company: { scaling_constant: number; monthly_sales: number; points_earned: number; name: any; image_path: any; }) => {
                const mult = parseFloat((company.scaling_constant * company.monthly_sales / company.points_earned).toFixed(2));
                const temp = {
                    name: company.name,
                    image_path: company.image_path,
                    normalised_points: parseFloat((returnObj.points * mult).toFixed(2)),
                    multiplier: mult
                };

                returnObj.partners.push(temp);
            });

            res.json(returnObj);
        });
    });
});

export default router;