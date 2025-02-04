import mysql from 'mysql2';
import dotenv from 'dotenv';
dotenv.config({ path: './backend/.env' });

interface ConnectionConfig {
  host: string;
  user: string;
  password: string;
  database: string;
  port: number;
}

const connectionConfig: ConnectionConfig = {
  host: process.env.DB_HOST as string,
  user: process.env.DB_USER as string,
  password: process.env.DB_PASSWORD as string,
  database: process.env.DB_NAME as string,
  port: parseInt(process.env.DB_PORT as string, 10),
};

const connection = mysql.createConnection(connectionConfig);

connection.connect((err: mysql.QueryError | null) => {
  if (err) {
    console.error('Database connection failed: ' + err.stack);
    return;
  }
  console.log('Connected to MySQL as ID ' + connection.threadId);
});

export default connection;
