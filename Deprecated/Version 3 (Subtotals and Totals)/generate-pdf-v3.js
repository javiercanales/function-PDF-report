/**
 * This file includes a util function to generate responsive PDF reports
 * with totals and subtotals for given columns (both if required).
 * 
 * To reach the total-subtotal functionality the function will use a GroupBy function, grouping given a criteria (key).
 * The function allows to use more than one column with subtotal/total,
 * but the criteria needs to be unique among the columns for the subtotal grouping.
 * 
 * This version 3 will not work without subtotals. If you need something without totals/subtotals, use freely the version 2 as a version 1 improved, will allow it.
 * @Version : 3
 */

/* PDF libraries required */
const Puppeteer = require('puppeteer'); // PDF generator (Chromium headless)
const ejs = require('ejs'); // JavaScript embebbed on HTML templates

// If you need use the files directly and not from the DB
const fs = require('fs');
const path = require('path');
const ejsPathV3 = path.join(__dirname, '../../files/Template-V3/TemplateHTML.ejs');

module.exports = {
    /**
     * This function generate a PDF file by printing an HTML document.
     * The HTML is generated by a EJS template (HTML with JS embebbed)
     * @Version {3}: This versión it's based on a whole table, and
     * allows to generate responsive reports from columns to rows, with
     * the header-body-footer format per page, and gives a total value and subtotal value for
     * given columns (via a total boolean and subtotal key -to group subtotals- attributes of columns).
     * Also allows transform a column number to a price format.
     * 
     * @param {*} data : the data for the report
     * @param {*} columns : the columns names that will be headers of the data, can be used
     * to filter columns from the data (by adding to @columns only what you want), or can be null (takes all columns)
     * @param {*} business : the business info for the report
     * @param {*} user : user that generates the report
     * @param {*} report : report's info: title and subtitle
     * @param {*} index : when need index, you can set it by defining true/false a includeIndex and a width
     */
    generatePDFv3: async function (data, columns, business, user, report, index) {
        let d = new Date();
        const day = d.getDate();
        const month = d.getMonth() + 1; // Month starts from 0
        const year = d.getFullYear();
        
        let hours = d.getHours();
        let minutes =  d.getMinutes();

        if (hours < 10) {
            hours = `0${hours}`
        }

        if (minutes < 10) {
            minutes = `0${minutes}`
        }

        const date = `${day}-${month}-${year} ${hours}:${minutes}`;

        /**
         * FormatMoney.
         * A internal function to format a number to a money string
         * @param {*} decPlaces : number of decimals (decPlaces = 2 => 0.00)
         * @param {*} thouSeparator : separator for thousands (e.g. ',' or '.')
         * @param {*} decSeparator : separator for decimals (e.g. ',' or '.')
         */
        Number.prototype.formatMoney = function(decPlaces, thouSeparator, decSeparator) {
            var n = this,
                decPlaces = isNaN(decPlaces = Math.abs(decPlaces)) ? 2 : decPlaces,
                decSeparator = decSeparator == undefined ? "." : decSeparator,
                thouSeparator = thouSeparator == undefined ? "," : thouSeparator,
                sign = n < 0 ? "-" : "",
                i = parseInt(n = Math.abs(+n || 0).toFixed(decPlaces)) + "",
                j = (j = i.length) > 3 ? j % 3 : 0;
            return sign + (j ? i.substr(0, j) + thouSeparator : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + thouSeparator) + (decPlaces ? decSeparator + Math.abs(n - i).toFixed(decPlaces).slice(2) : "");
        };

        /**
         * GroupBy.
         * A internal function to group the data by a given criteria (key), like the SQL one
         * @param {*} xs : the data
         * @param {*} key : the criteria to group by
         */
        var groupBy = function(xs, key) {
            return xs.reduce(function(rv, x) {
              (rv[x[key]] = rv[x[key]] || []).push(x);
              return rv;
            }, {});
        };
        
        // Charging the EJS template from file, then render to HTML
        //let templateEjs = fs.readFileSync(ejsPathV3, 'utf8');

        // This will be used if you have the template in the database
        // Read from database (table template_html)
        let base = await TemplateHTML.findOne({ id: 1 });
        let header = await TemplateHTML.findOne({ id: 3 });
        let body = await TemplateHTML.findOne({ id: 4 });
        let footer = await TemplateHTML.findOne({ id: 5 });
        
        // Initialize the html's base and add each module (header, body, footer)
        let templateEjs = base.html;
        templateEjs = templateEjs.replace('{header}', header.html);
        templateEjs = templateEjs.replace('{body}', body.html);
        templateEjs = templateEjs.replace('{footer}', footer.html);
        
        // Load the css, to be assigned with the puppeteer call
        let css = await TemplateHTML.findOne({ id: 2 });
        css = css.html; // That html doesn't mind something, it's just CSS
        
        let dataKeys; // Variable to get the column keys (identifiers to match data), to generate the html body
        let headerNames; // Variable to get the header names (names for the report)
        let colWidths = []; // Widths for the columns (only if columns is defined)

        /* Totals */
        let subtotals = []; // Variable to add lists of subtotals for columns that will have a subtotal
        let totals = []; // Variable to add columns that will display totals (sum)
        
        /* Subtotals */
        let dataGrouped; // Variable to apply GroupBy function by a given criteria (key)
        let dataValuesGroupBy; // Variable to get the values (identifiers) obtained with the GroupBy
        
        // To control the grouping of data,
        // the first criteria will be applied
        // and the nexts will be ignored
        // We suggest to use -true- boolean for the 2nd and+ subtotals
        // But just putting something will work
        // (subtotal: 'town' or subtotal: true will be the same for the 2nd and nexts column subtotals)
        let defined = false; 

        // If there's no columns defined, we use the default names
        if (!columns) {
            
            headerNames = Object.keys(data[0]); // Get the keys from data
            dataKeys = headerNames.slice(); // The keys to match data
        }
        else { // If columns are defined
            
            dataKeys = [];
            let headers = Object.values(columns);
            headerNames = [];

            // Grouping the data by the first criteria non-boolean appearing
            // We expect that you will use a criteria like 'town' for the subtotal
            // And next just use -true- boolean for more subtotals.
            // In fact you can use the same criteria like 'town' in each column, just it will do the work (groupBy) n times
            // but remember, if you use different criterias, like 'town' and next 'country', it will re-orderBy again with the last criteria)
            headers.map((value, i) => {
                if (typeof value.subtotal === 'string' || value.subtotal instanceof String) {
                    dataGrouped = groupBy(data, value.subtotal); // The original data its altered, then we use a copy
                    dataValuesGroupBy = Object.keys(dataGrouped);
                }
            })

            // Define header names and col widths for the corresponding case
            headers.map((value, i) => {
                if (value.key) {
                    dataKeys.push(value.key);
                } else {
                    return; // If value key isn't defined it's impossible to guess
                }
                if (value.header) {
                    headerNames.push(value.header);
                } else {
                    headerNames.push(dataKeys[i]);
                }
                if (value.width) {
                    colWidths.push(value.width);
                } else {
                    colWidths.push('auto');
                }

                // First add the col as true and with his sum if has a total
                if (value.total) { // There's a numeric value that will display a total sum at the end
                    
                    let totalSum = 0;
                    data.map(row => { // Iterate data to sum values and format the money number
                        if (row[value.key]) {
                            totalSum += row[value.key];
                        }
                    });
                    if (value.format) {
                        totalSum = value.format.currency + totalSum.formatMoney(value.format.numDecimals,value.format.thousandSep,value.format.decimalSep);
                    }
                    // If the value has a subtotal, set the subtotal and total to true
                    if (value.subtotal) {
                        /**
                         * Section to generate the subtotals relative to the total.
                         * Finally adds the list of subtotals in the object.
                         */
                        let subtotalsTemp = []; // Variable to add rows for each subtotal (defined by dataValuesGroupBy length)

                        let subtotalSum = 0;
                        dataValuesGroupBy.map((valueGroupBy, i) => {
                            dataGrouped[valueGroupBy].map((elem, j) => {
                                subtotalSum += elem[value.key] // Key value of the money value
                            });
                            
                            if (value.format) {
                                console.log(subtotalSum)
                                subtotalSum = value.format.currency + subtotalSum.formatMoney(value.format.numDecimals,value.format.thousandSep,value.format.decimalSep);
                                subtotalsTemp.push(subtotalSum);
                            }
                            
                            subtotalSum = 0; // Reset sum for next subtotal
                        });

                        subtotals.push({
                            hasSubtotal: true,
                            subtotalValues: subtotalsTemp
                        });
                        totals.push({
                            hasTotal: true,
                            totalValue: totalSum
                        });
                    // If the value hasn't a subtotal (but has total), set subtotal to false, and total to true
                    } else {
                        subtotals.push({
                            hasSubtotal: false
                        });
                        totals.push({
                            hasTotal: true,
                            totalValue: totalSum
                        });
                    }
                // If this col hasn't total, set to false
                } else {
                    subtotals.push({
                        hasSubtotal: false
                    });
                    totals.push({
                        hasTotal: false
                    });
                }
                // Iterate data to sum values and format the money number
                if (value.format) {
                    data.forEach(row => {
                        row[value.key] = value.format.currency + row[value.key].formatMoney(value.format.numDecimals,value.format.thousandSep,value.format.decimalSep);
                    });
                }
            });
        }

        let includeIndex;
        if (!index) { // If there's no index defined
            includeIndex = false;
        } else { // If index attribute is defined
            includeIndex =  index.includeIndex;
        }
    
        let html;
        // Creates the HTML passing the request data (as example)
        html = ejs.render(templateEjs, {
            headerNames: headerNames,
            dataKeys: dataKeys,
            data: data,
            business: business,
            user: user,
            date: date,
            report: report,
            includeIndex: includeIndex,
            subtotals: subtotals,
            totals: totals,
            dataGrouped: dataGrouped,
            dataValuesGroupBy: dataValuesGroupBy
        });
        
        // Start the puppeteer API, headless
        const browser = await Puppeteer.launch({ 
            headless: true, 
            args: ['--no-sandbox'] 
        });
        const page = await browser.newPage();
        
        // Set the HTML to the puppeteer page, then the PDF (buffer) it's generated with some options
        await page.setContent(html);

        // If you have the CSS in a database
        await page.addStyleTag({content: css})
        // If you have the CSS in a file
        //await page.addStyleTag({path: 'files/Template-V3/style.css'});

        if (columns) {
            colWidths.forEach(async (colWidth, i) => {
                await page.addStyleTag({content: `#column${i+1} {
                    width: ${colWidth}%;
                }`});
            })
        }
        // Define a width for index column just when columns
        // and includeIndex are defined (if columns isn't defined,
        // then let the auto-layout to define widths for all columns)
        if (columns && index.width) {
            await page.addStyleTag({content: `#column0 {
                width: ${index.width}%;
            }`});
        }

        // Create the PDF.
        // This also will generate the Pagination at the bottom (after the footer, its the only way to generate pagination with this responsive approach as far I know)
        const pdf = await page.pdf({
            format: 'A4',
            printBackground: true,
            displayHeaderFooter: true,
            footerTemplate: '<div style="font-size:8.5px; margin: auto;">Página <span class="pageNumber"></span> de <span class="totalPages"></span></div>',
            margin: {
                bottom: '75px'
            }
        });
    
        // Close the puppeteer API and return the PDF buffer
        await browser.close();
        return pdf;
    }
};