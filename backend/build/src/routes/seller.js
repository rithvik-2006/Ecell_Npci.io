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
const router = express_1.default.Router();
router.post('/api/seller', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    // displqay name, perfoemance metrics = [monthly_sales, reward_token_value, recent_sales, recent_sales, graphs: []]
    const uid = req.body.uid;
    let jsonRes = {};
    connectMySql_1.default.query(`SELECT display_name FROM users where uid = '${uid}'`, (err, res1) => __awaiter(void 0, void 0, void 0, function* () {
        if (err) {
            console.log(err);
            res.status(500).json({ error: err });
            return;
        }
        connectMySql_1.default.query(`SELECT * FROM companies where name = '${res1[0].display_name}'`, (err, result) => __awaiter(void 0, void 0, void 0, function* () {
            if (err) {
                console.log(err);
                res.status(500).json({ error: err });
                return;
            }
            jsonRes = {
                display_name: result[0].name,
                reward_token_value: result[0].reward_token_value,
                sales: [],
            };
            connectMySql_1.default.query(`SELECT last_20_transactions FROM users`, (err, res2) => __awaiter(void 0, void 0, void 0, function* () {
                if (err) {
                    console.log(err);
                    res.status(500).json({ error: err });
                    return;
                }
                res2.forEach(t => {
                    if (t.last_20_transactions.length === 0)
                        return;
                    console.log(t.last_20_transactions);
                    t.last_20_transactions.forEach((temp) => {
                        t.company_name = result[0].name ? jsonRes.sales.push({ date: temp.date, price: temp.change.replace("-", "+") }) : null;
                    });
                });
                jsonRes.sales = jsonRes.sales.sort((a, b) => {
                    return new Date(a.date).getTime() - new Date(b.date).getTime();
                });
                connectMySql_1.default.query(`SELECT image_path, points_earned from companies where name = '${res1[0].display_name}'`, (err, res3) => __awaiter(void 0, void 0, void 0, function* () {
                    if (err) {
                        console.log(err);
                        res.status(500).json({ error: err });
                        return;
                    }
                    jsonRes.image_path = res3[0].image_path;
                    jsonRes.monthly_sales = res3[0].points_earned;
                    res.status(200).json(jsonRes);
                }));
            }));
        }));
    }));
}));
exports.default = router;
