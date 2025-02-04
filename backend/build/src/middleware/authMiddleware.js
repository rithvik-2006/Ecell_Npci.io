"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const firebase_1 = __importDefault(require("../utils/firebase"));
const authMiddleware = (req, res, next) => {
    const authHeader = req.headers.authorization;
    console.log("authHeader: ", authHeader);
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res.status(401).json({ error: "Unauthorized: No Token provided" });
        return;
    }
    const authToken = authHeader.split(" ")[1];
    firebase_1.default.auth().verifyIdToken(authToken)
        .then((decodedToken) => {
        req.user = decodedToken;
        next();
    })
        .catch((err) => {
        res.status(401).json({ error: "Unauthorized: Invalid Token" });
    });
};
exports.default = authMiddleware;
