import express, { Request, Response, Router } from 'express';
import connection from '../connectMySql';

const router = Router();

interface User {
    [key: string]: any;
}

router.post('/api/customer', (req: Request, res: Response) => {
    const uid: string = req.body.uid;

    try {
        connection.query(`SELECT * FROM users WHERE uid = ?`, [uid], (err: any, results: any[]) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (results.length === 0) {
                res.status(400).json({ error: 'User not found' });
                return;
            }

            // Convert to numbers
            Object.keys(results[0]).forEach(key => {
                const value = results[0][key];
                if (!isNaN(value) && value !== null && value !== '') results[0][key] = Number(value);
            });
            res.status(200).json(results[0]);
        });
    } catch (error) {
        console.error('Error fetching user:', error);
        res.status(500).json({ error: `Error: ${error}` });
    }
});

export default router;