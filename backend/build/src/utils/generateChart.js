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
const chartjs_to_image_1 = __importDefault(require("chartjs-to-image"));
const generateShoppingFrequencyChart = (frequencyData) => __awaiter(void 0, void 0, void 0, function* () {
    const labels = Object.keys(frequencyData);
    const data = Object.values(frequencyData);
    const chart = new chartjs_to_image_1.default();
    chart.setConfig({
        type: 'doughnut',
        data: {
            labels: labels,
            datasets: [{
                    data: data
                }]
        },
        options: {
            legend: {
                display: false,
            },
            plugins: {
                datalabels: {
                    display: true,
                    formatter: (val, ctx) => {
                        // Grab the label for this value
                        const label = ctx.chart.data.labels[ctx.dataIndex];
                        // Format the number with 0 decimal places
                        const formattedVal = Intl.NumberFormat('en-US', {
                            minimumFractionDigits: 0,
                        }).format(val);
                        // Put them together
                        return `${label}: ${formattedVal}`;
                    },
                    color: '#fff',
                    backgroundColor: '#404040',
                    font: { size: 32 }
                },
            },
        },
    });
    chart.setWidth(600);
    chart.setHeight(600);
    chart.setBackgroundColor('transparent');
    return yield chart.toBinary();
});
exports.default = generateShoppingFrequencyChart;
