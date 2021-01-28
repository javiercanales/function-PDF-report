const data = require('../services/data.js').data; // The data used as example.
const generatePdfReport = require('../services/generate-report-pdf.js').generatePdfReport; // The Report function.

/**
 * An example of service/controller to request a PDF to the function presented.
 */
module.exports = {
    
    pdfReport: async function (req, res) {

        // Columns as JSON, can be used to filter attributes just by the columns needed
        // Can be null if you need, but if you need define widths please define columns.
        // width values represent percentages (%)
        const columns = [
            {
                key: 'name',
                header: 'Nombre',
                width: 25,
            },
            {
                key: 'rut',
                header: 'RUT Encargado',
                width: 13
            },
            {
                key: 'address',
                header: 'Dirección'
            },
            {
                key: 'basePrice',
                header: 'Precio Base',
                width: 15,
                total: true,
                subtotal: true,
                format: {
                    currency: '$',
                    numberOfDecimals: 0, // 1000.45 with 0 decimals => 1000
                    thousandSeparator: '.', // 1000 => 1.000
                    decimalSeparator: ',' // 1000.45 => 1.000,45
                }
            },
            {
                key: 'region',
                header: 'Región'
            },
            {
                key: 'promoPrice',
                header: 'Precio Promocional',
                width: 13,
                total: true,
                subtotal: true,
                format: {
                    currency: '$',
                    numberOfDecimals: 0, // 1000.45 with 0 decimals => 1000
                    thousandSeparator: '.', // 1000 => 1.000
                    decimalSeparator: ',' // 1000.45 => 1.000,45
                }
            },
            {
                key: 'town',
                width: 15,
                header: 'Comuna'
            },
        ];
        const subtotalCriteriaKeys = ['region','town','rut'];

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

        generatePdfReport(data, columns, subtotalCriteriaKeys, business, user, report, index).then((pdf) => {
            res.set({
                'Content-Type': 'application/pdf',
                'Content-Length': pdf.length
            });
            res.status(200).send(pdf);
        });
        
        // Observation: the response data of the PDF it's a buffer type.
        // Most browsers will recognize the 'application/pdf' and open it for default with PDF.js (e.g. Chrome/Firefox/Edge-Chromium)
        // Few others will not, then we have to convert the buffer data into a .PDF file in the front-end if needed, but doesn't seem to be needed if we don't use IE or something.
    },
}