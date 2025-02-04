import mysql from 'mysql2';
import dotenv from 'dotenv';
dotenv.config({ path: './backend/.env' });

interface ConnectionConfig {
  host: string;
  user: string;
  password: string;
  database: string;
  port: number;
  ssl: {
    ca: string;
    rejectUnauthorized: boolean;
  };
}

const connectionConfig: ConnectionConfig = {
  host: process.env.DB_HOST as string,
  user: process.env.DB_USER as string,
  password: process.env.DB_PASSWORD as string,
  database: process.env.DB_NAME as string,
  port: parseInt(process.env.DB_PORT as string, 10),
  ssl: {
    ca : `-----BEGIN CERTIFICATE-----
MIIETTCCArWgAwIBAgIUBPlSrXXvii5bytfhL5vQTBegDvIwDQYJKoZIhvcNAQEM
BQAwQDE+MDwGA1UEAww1YTVhOThlZmEtZDJkZC00YzRjLWI1MTYtNzE0ZDEwYmRj
Mjg3IEdFTiAxIFByb2plY3QgQ0EwHhcNMjUwMjA0MjAzNDMzWhcNMzUwMjAyMjAz
NDMzWjBAMT4wPAYDVQQDDDVhNWE5OGVmYS1kMmRkLTRjNGMtYjUxNi03MTRkMTBi
ZGMyODcgR0VOIDEgUHJvamVjdCBDQTCCAaIwDQYJKoZIhvcNAQEBBQADggGPADCC
AYoCggGBAKKaJ6DP+N7dv1qP3JgUbSdee1VbWpE4jVawRudOCAbEBVk/snibMi+H
cnyK0h++3MBbCYhHm5frpW6lVGoCOa1lHlRzbtYjR1x1duj6EmvmtSKZUBDLd+75
CzHSVpb+E274eyAJ8TbcRuVC/sOuSJ/D2ab0kU+Gx7UQCcnk75LFTLIlseVJTtHr
HqBscY6aHJe938QO7CnyTDdWDPw7qESRaZDczb+YYzM87EHC5eqEJK5tEn+XlMRn
EswKwknZkxXmi/u41VUOA0jBFncDMETPgqee7G17d9dyWVg1EEbySVSikpFbDQOr
O6XmEO4EXlW3njxLUsmK5hCzRNe/FdCXtDW7XJQfZsO1x1yAaeJJUtYUmMR+almx
2wTX9fSLJUjCPl/NhoaBZ95a0ccfjn5eFIGJVg9gdplZ+7XP/NTKIQ3FPN/qFgM3
IE2oWflb+eY358Bb/8VSyvJiichHUvw4KqoKk7vucC4bAW9Dx4mGnu+Pufbsuuyo
B3GAyzLU8QIDAQABoz8wPTAdBgNVHQ4EFgQU8I4A1VJq4xO8MDVEXC9gmdMaAx0w
DwYDVR0TBAgwBgEB/wIBADALBgNVHQ8EBAMCAQYwDQYJKoZIhvcNAQEMBQADggGB
AD2zvPHr/i77F49V1YwNT9KWnlKlR4ytZ4RfW2uSdII67jCtsZfyqln6HbB2yRwA
BUA1BJF1WN3/J87SiJH2u2NbKTu/JSrJaRGr0ZXXfwDXtiwpAmGzTJUlFI5NJNAr
77IF2HgG3xkWx/Bdz/7QYQL2c2Mf/bWSpv/B8QxfFFrCeFW0/Cb7n/XrNnf8Fetf
aB8DwRvHdnFIuDj//VnjizUHy5JQHn7T5Va83MeXZLxi8azT0YN0AT2UONKB6OK+
146Qy/qs/CBpAjnFnyDtI4WuJ+x3ciPm7sM0ECPBCBqCboKRNfaHRcHN7qM44UPT
hczabHzSO3ACEvJ3q2biVCIwT0N/nHao7EXt+sZF91BBm/gMbPz5M10sw1zvWGy9
MXolt7BUuG99T99TRLR282FiqhndbQMcbDZd8sK8uJiPdbCNnZCk+5IYX1tu0QC5
hB2zJdmh9AATSaSG462kux+YpNyz92zphVmE+j9NN/teCiHjlAA2FrNR5uRLqhSg
ng==
-----END CERTIFICATE-----`,
    rejectUnauthorized: true
  }
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
