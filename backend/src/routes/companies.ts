import express, { Request, Response } from 'express';
import { Connection, MysqlError } from 'mysql';
import connection from '../connectMySql';

const router = express.Router();

router.get('/api/companies', (req: Request, res: Response) => {
    connection.query('SELECT * FROM companies', (err: MysqlError | null, rows: any[]) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        if (rows.length === 0) {
            res.status(404).json({ error: 'No companies to show.' });
            return;
        }
        res.status(200).json(rows);
    });
});

export default router;
