import * as admin from 'firebase-admin';
import dotenv from 'dotenv';
dotenv.config({ path: './.env' });

const serviceAccount = JSON.parse(process.env.GOOGLE_APPLICATION_CREDENTIALS_JSON as string);

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount as admin.ServiceAccount)
});

export default admin;