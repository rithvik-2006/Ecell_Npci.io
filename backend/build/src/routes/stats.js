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
const generateChart_1 = __importDefault(require("../utils/generateChart"));
const router = express_1.default.Router();
const connectMySql_1 = __importDefault(require("../connectMySql"));
router.post("/api/customer/statistics", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const uid = req.body.uid;
    connectMySql_1.default.query("SELECT created_at, display_name, last_20_transactions, points FROM users WHERE uid = ?", [uid], (err, result) => __awaiter(void 0, void 0, void 0, function* () {
        if (err) {
            console.log(err);
            res.status(500).json({ error: "Internal Server Error" });
            return;
        }
        if (result.length === 0) {
            res.status(404).json({ error: "Customer not found" });
            return;
        }
        const transactions = result[0].last_20_transactions;
        const categories = {};
        const companies = {};
        const transactionPromises = transactions.map((transaction) => {
            return new Promise((resolve, reject) => {
                let name = transaction.company_name;
                connectMySql_1.default.query("SELECT company_type FROM companies where name = ?", [name], (err, result) => {
                    if (err) {
                        return reject(err);
                    }
                    if (result.length === 0) {
                        return reject(new Error("Company not found"));
                    }
                    let category = result[0].company_type;
                    if (category in categories) {
                        categories[category] += 1;
                    }
                    else {
                        categories[category] = 1;
                    }
                    if (name in companies) {
                        companies[name] += 1;
                    }
                    else {
                        companies[name] = 1;
                    }
                    resolve();
                });
            });
        });
        try {
            yield Promise.all(transactionPromises);
        }
        catch (err) {
            console.log(err);
            res.status(500).json({ error: "Internal Server Error" });
            return;
        }
        const jsonResult = {
            created_at: result[0].created_at,
            display_name: result[0].display_name,
            chart: yield (0, generateChart_1.default)(categories),
            points: result[0].points
        };
        res.status(200).json(jsonResult);
    }));
}));
exports.default = router;
