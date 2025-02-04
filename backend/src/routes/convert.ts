import express from 'express';
import { Response, Request } from 'express';

import connection from '../connectMySql';

const router = express.Router();

router.post('/api/customer/fetch', (req: Request, res: Response) => {

    const uid = req.body.uid;
    const jsonRes: { companies: { name: any; points: any; image_path: string }[], points: number } = { companies: [], points: 0 };
    const fetchData = () => {
        return new Promise((resolve, reject) => {
            connection.query('SELECT * from pool', (err: any, rows: any[]) => {
                if (err) {
                    console.log(err);
                    reject(err);
                    reject(err);
                    return;
                }
                if (rows.length === 0) {
                    reject(new Error('No pool found'));
                    reject(new Error('No pool found'));
                    return;
                }

                const promises = rows.map((row) => {
                    return new Promise((resolve, reject) => {
                        connection.query('SELECT image_path from companies where company_id = ?', [row.company_id], (err: any, rows: any[]) => {
                            if (err) {
                                console.log(err);
                                res.status(500).json({ message: 'Internal server error' });
                                reject(err);
                                return;
                            }
                            if (rows.length === 0) {
                                reject(new Error('No company found'));
                                reject(new Error('No company found'));
                                return;
                            }
                            row.pool.forEach((poolItem: any) => {
                                if (poolItem.uid === uid) {
                                    jsonRes.companies.push({ name: row.name, points: poolItem.points, image_path: rows[0].image_path });
                                }
                                resolve(null);
                            });
                        });
                    });
                });
                const userPointsPromise = new Promise((resolve, reject) => {
                    connection.query("SELECT points from users where uid = ?", [uid], (err: any, rows: any[]) => {
                        if (err) {
                            console.log(err);
                            reject(err);
                            return;
                        }
                        if (rows.length === 0) {
                            reject(new Error('No user found'));
                            return;
                        }
                        jsonRes.points = rows[0].points;
                        resolve(null);
                    });
                });

                promises.push(userPointsPromise);
                
                Promise.all(promises)
                .then(() => resolve(null))
                    .catch((err) => reject(err));
            });
        });
    };

    fetchData()
        .then(() => {
            res.status(200).json(jsonRes);
        })
        .catch((err) => {
            console.log(err);
        });
});




export default router;