import ChartJsImage from 'chartjs-to-image';
import { sanitizeFilter } from 'mongoose';

interface FrequencyData {
    [key: string]: number;
}

const generateShoppingFrequencyChart = async (frequencyData: FrequencyData): Promise<Buffer> => {
    const labels = Object.keys(frequencyData);
    const data = Object.values(frequencyData);

    const chart = new ChartJsImage();
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
                    formatter: (val: any, ctx: any) => {
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

    return await chart.toBinary();
};

export default generateShoppingFrequencyChart;
