"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const app = (0, express_1.default)();
app.use(express_1.default.json());
app.use(express_1.default.urlencoded({ extended: true }));
app.get('/', (req, res) => {
    res.send('Hello World');
});
const companies_1 = __importDefault(require("./routes/companies"));
const createUser_1 = __importDefault(require("./routes/createUser"));
const info_1 = __importDefault(require("./routes/info"));
const redeem_1 = __importDefault(require("./routes/redeem"));
const stats_1 = __importDefault(require("./routes/stats"));
const transfer_1 = __importDefault(require("./routes/transfer"));
const seller_1 = __importDefault(require("./routes/seller"));
const convert_1 = __importDefault(require("./routes/convert"));
const credit_1 = __importDefault(require("./routes/credit"));
app.use('/', companies_1.default);
app.use('/', createUser_1.default);
app.use('/', info_1.default);
app.use('/', redeem_1.default);
app.use('/', stats_1.default);
app.use('/', transfer_1.default);
app.use('/', seller_1.default);
app.use('/', convert_1.default);
app.use("/", credit_1.default);
app.listen(3006, () => {
    console.log('Server is running on http://localhost:3006');
});
