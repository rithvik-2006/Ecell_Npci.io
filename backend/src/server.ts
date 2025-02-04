import express, { Request, Response, NextFunction } from 'express';
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.get('/', (req: Request, res: Response) => {
    res.send('Hello World');
});

import router from './routes/companies';
import router2 from './routes/createUser';
import router3 from './routes/info';
import router4 from './routes/redeem';
import router5 from './routes/stats';
import router6 from './routes/transfer';
import router7 from './routes/seller';
import router8 from './routes/convert';
import router9 from './routes/credit'; 

app.use('/', router);
app.use('/', router2);
app.use('/', router3);
app.use('/', router4);
app.use('/', router5);
app.use('/', router6);
app.use('/', router7);
app.use('/', router8);
app.use("/", router9);


app.listen(3006, () => {
    console.log('Server is running on http://localhost:3006');
});
