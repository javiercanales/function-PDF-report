const data = require('../services/data.js').data;
const data1 = require('../services/data.js').data1;
const data2 = require('../services/data.js').data2;
const data3 = require('../services/data.js').data3;

const generatePDFv3 = require('../services/generate-pdf-v3.js').generatePDFv3;

/**
 * An example of service/controller to request a PDF to the function presented.
 */
module.exports = {
    
    reportPDFv3: async function (req, res) {

        // Columns as JSON, can be used to filter attributes just by the columns needed
        // Can be null if you need, but if you need define widths please define columns.
        // width values represent percentages (%)
        const columns = [
            {
                key: 'name',
                header: 'Nombre',
                width: 10,
            },
            {
                key: 'basePrice',
                header: 'Precio base',
                width: 15,
                total: true,
                subtotal: true,
                format: {
                    currency: '$',
                    numDecimals: 0, // 1000.45 with 0 decimals => 1000
                    thousandSep: '.', // 1000 => 1.000
                    decimalSep: ',' // 1000.45 => 1.000,45
                }
            },
            {
                key: 'rut',
                header: 'RUT',
                width: 23
            },
            {
                key: 'address'
            },
            {
                key: 'town',
                width: 15
            },
            {
                key: 'promoPrice',
                header: 'Precio promocional',
                width: 18,
                total: true,
                subtotal: 'town',
                format: {
                    currency: '$',
                    numDecimals: 0, // 1000.45 with 0 decimals => 1000
                    thousandSep: '.', // 1000 => 1.000
                    decimalSep: ',' // 1000.45 => 1.000,45
                }
            }
        ];
        const columns1 = [
            {
                key: 'name',
                header: 'Nombre',
                width: 10,
            },
            {
                key: 'rut',
                header: 'RUT',
                width: 7
            },
            {
                key: 'town',
                width: 15
            },
            {
                key: 'test',
                width: 18
            }
        ];

        // Another form to define columns, if you need filter
        // but don't set headers names or column widths
        const columns2 = {
            _id: {},
            about: {
                header: 'Sobre',
                width: 35
            },
            index: {},
            registered: {},
            latitude: {},
        }

        // Business, user and report info for the PDF
        const business = {
            name: 'Novosystem SpA',
            address: 'Av Pajaritos N°3195, Of 1411',
            town: 'Maipu',
            city: 'Santiago'
        };
        const user = {
            name: 'Javier Canales',
            module: 'Desarrollo web'
        };
        const report = {
            title: 'Un título',
            subtitle: 'Un subtítulo'
        };

        const index = {
            includeIndex: true, // In case your data doesn't have an index, and you need it in the report
            width: 3 // Percentage value of width (e.g. 3%)
        };

        // Use this dataTest as your data (its a copy of the data) if you use static data (rare thing, I use it because I have a file with the Json example, if isn't your case ignore this)
        //let dataTest = JSON.parse(JSON.stringify(data));

        generatePDFv3(data, columns, business, user, report, index).then((pdf) => {
            res.set({
                'Content-Type': 'application/pdf',
                'Content-Length': pdf.length
            });
            res.status(200).send(pdf);
        });
        
        // Observation: the response data of the PDF it's a buffer type.
        // Most browsers will recognize the 'application/pdf' and open it for default with PDF.js (e.g. Chrome/Firefox/Edge-Chromium)
        // Few others will not, then we have to convert the buffer data into a .PDF file in the front-end if needed, but doesn't seem to be needed if we don't use IE or something.
    }
};