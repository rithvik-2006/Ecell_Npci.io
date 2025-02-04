"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const router = express_1.default.Router();
const connectMySql_1 = __importDefault(require("../connectMySql"));
router.post('/api/customer/redeem', (req, res) => {
    const uid = req.body.uid;
    if (!uid) {
        res.status(400).json({ error: 'UID is required' });
        return;
    }
    let returnObj = {
        points: 0,
        partners: []
    };
    connectMySql_1.default.query('SELECT * FROM users WHERE uid = ?', [uid], (err, rows) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        if (rows.length === 0) {
            res.status(400).json({ error: 'User not found' });
            return;
        }
        returnObj.points = rows[0].points;
        connectMySql_1.default.query('SELECT * FROM companies', (err, rows) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (rows.length === 0) {
                res.status(400).json({ error: 'No companies found' });
                return;
            }
            rows.forEach((company) => {
                const mult = parseFloat((company.scaling_constant * company.monthly_sales / company.points_earned).toFixed(2));
                const temp = {
                    name: company.name,
                    image_path: company.image_path,
                    normalised_points: parseFloat((returnObj.points * mult).toFixed(2)),
                    multiplier: mult
                };
                returnObj.partners.push(temp);
            });
            res.json(returnObj);
        });
    });
});
exports.default = router;
