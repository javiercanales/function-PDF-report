/**
 * Function to generate PDF reports, based on EJS template, HTML table structure and CSS.
 */

/**
 * PDF libraries required.
 */
const Puppeteer = require('puppeteer'); // PDF generator (Chromium headless)
const ejs = require('ejs'); // JavaScript embebbed on HTML templates

// If you need use the files directly and not from the DB
const fs = require('fs');
const path = require('path');
const ejsPathV1D1 = path.join(__dirname, '../../files/Template-V1.1/TemplateHTML.ejs');

module.exports = {
    /**
     * This function generate a PDF file by printing an HTML document.
     * The HTML is generated by a EJS template (HTML with JS embebbed)
     * @Version {1.1 (Final)}: This versión it's based on a whole table, and
     * allows to generate responsive reports from columns to rows, with
     * the header-body-footer format per page.
     * 
     * @param {*} data : the data for the report
     * @param {*} columns : the columns names that will be headers of the data, can be used
     * to filter columns from the data (by adding to @columns only what you want), or can be null (takes all columns)
     * @param {*} business : the business info for the report
     * @param {*} user : user that generates the report
     * @param {*} report : report's info: title and subtitle
     * @param {*} index : when need index, you can set it by defining true/false a includeIndex and a width
     */
    generatePDFv1: async function (data, columns, business, user, report, index) {
        let d = new Date();
        const day = d.getDate();
        const month = d.getMonth() + 1; //Month starts from 0
        const year = d.getFullYear();
        const date = `${day}-${month}-${year}`;
    
        // Charging the EJS template from file, then render to HTML
        //let templateEjs = fs.readFileSync(ejsPathV1D1, 'utf8');

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
    
        // Load the css, to be asigned with the puppeteer call
        let css = await TemplateHTML.findOne({ id: 2 });
        css = css.html; // That html doesn't mind something, it's just CSS

        // Variable to get the column keys (identifiers), to generate the html body
        let dataKeys;

        // Variable to get the header names (names for the report)
        let headerNames;

        // Widths for the columns (only if columns is defined)
        let colWidths = [];
        
        // If there's no columns defined, we use the default names
        if (!columns) {

            headerNames = Object.keys(data[0]); // Get the keys from data
            dataKeys = headerNames.slice(); // The keys to match data
        }
        else { // If columns are defined
            dataKeys = Object.keys(columns); // The keys to match data

            let headers = Object.values(columns);
            headerNames = [];

            // Define header names and col widths for the corresponding case
            headers.forEach((value, i) => {
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
            includeIndex: includeIndex
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
        //await page.addStyleTag({path: 'files/Template-V1.1/style.css'});

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

        const pdf = await page.pdf({
            format: 'A4',
            printBackground: true
        });
    
        // Close the puppeteer API and return the PDF buffer
        await browser.close();
        return pdf;
    }

};