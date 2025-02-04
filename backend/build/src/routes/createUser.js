"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const connectMySql_1 = __importDefault(require("../connectMySql"));
const firebase_1 = __importDefault(require("../utils/firebase"));
const encrypt_1 = __importDefault(require("../encrypt"));
const router = express_1.default.Router();
router.post('/api/customer/create', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { email, password } = req.body;
    if (!email || !password) {
        res.status(400).json({ error: 'Email and password are required' });
        return;
    }
    try {
        const userRecord = yield firebase_1.default.auth().getUserByEmail(email).catch(() => null);
        if (userRecord) {
            res.status(401).json({ error: 'User already exists' });
            return;
        }
        const newUser = yield firebase_1.default.auth().createUser({
            email,
            password,
        });
        const newUserSQL = {
            uid: newUser.uid,
            points: 0.00,
            last_transaction_date: null,
            last_20_transactions: "[]",
            created_at: new Date(),
            updated_at: new Date(),
            email: yield (0, encrypt_1.default)(req.body.email),
            display_name: newUser.displayName || "N/A",
        };
        connectMySql_1.default.query('INSERT INTO users SET ?', newUserSQL, (err, results) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.status(200).json({ message: 'User registered successfully', uid: newUser.uid });
        });
    }
    catch (error) {
        console.error('Error registering user:', error);
        res.status(500).json({ error: `Error: ${error}` });
    }
}));
exports.default = router;
