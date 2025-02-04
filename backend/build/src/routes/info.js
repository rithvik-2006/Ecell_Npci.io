"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const connectMySql_1 = __importDefault(require("../connectMySql"));
const router = (0, express_1.Router)();
router.post('/api/customer', (req, res) => {
    const uid = req.body.uid;
    try {
        connectMySql_1.default.query(`SELECT * FROM users WHERE uid = ?`, [uid], (err, results) => {
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
                if (!isNaN(value) && value !== null && value !== '')
                    results[0][key] = Number(value);
            });
            res.status(200).json(results[0]);
        });
    }
    catch (error) {
        console.error('Error fetching user:', error);
        res.status(500).json({ error: `Error: ${error}` });
    }
});
exports.default = router;
