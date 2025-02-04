"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const connectMySql_1 = __importDefault(require("../connectMySql"));
const router = express_1.default.Router();
router.get('/api/companies', (req, res) => {
    connectMySql_1.default.query('SELECT * FROM companies', (err, rows) => {
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
exports.default = router;
