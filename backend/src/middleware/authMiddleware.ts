
import { Request, Response, NextFunction } from 'express';
import admin from '../utils/firebase';

declare module "express-serve-static-core" {
  interface Request {
    user?: any;
  }
}

const authMiddleware = (req: Request, res: Response, next: NextFunction) => {
    const authHeader = req.headers.authorization;

    console.log("authHeader: ", authHeader);

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res.status(401).json({ error: "Unauthorized: No Token provided" });
        return;
    }

    const authToken = authHeader.split(" ")[1];

    admin.auth().verifyIdToken(authToken)
        .then((decodedToken) => {
            req.user = decodedToken;
            next();
        })
        .catch((err) => {
            res.status(401).json({ error: "Unauthorized: Invalid Token" });
        });
};

export default authMiddleware;



