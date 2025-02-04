import express, { Request, Response } from 'express';
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.get('/', (req: Request, res: Response) => {
    res.send('Hello World');
});

import companiesRouter from './routes/companies';
import createUserRouter from './routes/createUser';
import infoRouter from './routes/info';
import redeemRouter from './routes/redeem';
import statsRouter from './routes/stats';
import transferRouter from './routes/transfer';
import sellerRouter from './routes/seller';
import convertRouter from './routes/convert';
import creditRouter from './routes/credit'; 

app.use('/', companiesRouter);
app.use('/', createUserRouter);
app.use('/', infoRouter);
app.use('/', redeemRouter);
app.use('/', statsRouter);
app.use('/', transferRouter);
app.use('/', sellerRouter);
app.use('/', convertRouter);
app.use('/', creditRouter);


app.listen(3006, () => {
    console.log('Server is running on http://localhost:3006');
});
