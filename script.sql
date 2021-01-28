use prueba;
drop table report_template;

create table report_template(
	id int primary key,
    name varchar(8) not null,
    html varchar(4096) not null
);

select * from report_template;

insert into report_template (id, name, html) values (1, 'base', '<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link
      rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css"
      integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2"
      crossorigin="anonymous"
    />
    <script
      src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
      integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
      crossorigin="anonymous"
    ></script>
    
    <link rel="stylesheet" href="style.css" />
    <title>Reporte</title>
  </head>

  <body>

    <!-- This report is designed as a whole table,
      to reach the responsiveness per page,
      by forcing the PDF generation to include a header and footer
      as a part of the table
    -->

    <!-- ============ Start of the report ============ -->
    <table>
      <thead>
        <tr>
          <td>

            <!-- ======= Header ======= -->
            {{{header}}}
            <!-- ======= End Header ======= -->

          </td>
        </tr>
      </thead>

      <!-- ======= Body ======= -->
      <tr>
        <td>
          <!-- Start Print Content -->
          {{{body}}}
          <!-- End Print Content -->
        </td>
      </tr>
      <!-- ======= End Body ======= -->

      <!-- ======= Footer: space to place it ======= -->
      <tfoot>
        <tr>
          <td class="table-footer-place">
            <!-- Leave this empty and don''t remove it. This space is where footer will be placed on print -->
          </td>
        </tr>
      </tfoot>
      <!-- ======= End Footer ======= -->

    </table>
    <!-- ============ End of the report ============ -->

    <!-- ======= Footer (to be placed in the space above) ======= -->
    {{{footer}}}

  </body>
</html>
');

insert into report_template (id, name, html) values (2, 'css', '/****************************************************************/
/************** HTML''s body (main) element styles ***************/
body {
    color: rgb(72, 72, 105);
    font-family: "Open Sans", sans-serif;
    font-size: 12px;
}
/****************************************************************/


/****************************************************************/
/**************** Body''s report (table) styles ******************/
/* For the header <th> of the table''s/body''s report */
.table-header {
    border: 2px solid rgb(209, 139, 10);
    color: rgb(209, 139, 10); /* For a header with color */
}

/* For the cells of the table''s/body''s report */
.table-row-values {
    border: 2px solid rgb(209, 139, 10);
}
.table-cell-values {
    border: 2px solid rgb(209, 139, 10);
    text-align: right;
}

/* For the subtotal-info cells*/
.table-criteria { /* Styles for the subtotals and totals */
    border: 2px solid rgb(243, 144, 15);
    font-weight: bold;
    text-align: left;
    color:rgb(164, 93, 0);
}

/* For the subtotal-info cells*/
.table-subtotal-info { /* Styles for the subtotals and totals */
    border: 2px solid rgb(209, 139, 10);
    font-weight: bold;
    text-align: right;
    background-color:  rgb(240, 241, 161);
}
/* For the subtotal-value cells */
.table-subtotal-values { /* Styles for the subtotals and totals */
    border: 2px solid rgb(209, 139, 10);
    text-align: right;
    background-color:  rgb(240, 241, 161);
}

/* For the total-info cells*/
.table-total-info { /* Styles for the subtotals and totals */
    border: 2px solid rgb(209, 139, 10);
    font-weight: bold;
    text-align: right;
    background-color:  rgb(226, 228, 86);
}
/* For the total-value cells*/
.table-total-values { /* Styles for the subtotals and totals */
    border: 2px solid rgb(209, 139, 10);
    text-align: right;
    background-color:  rgb(226, 228, 86);
}
/*********************** End body styles ***********************/


/***************************************************************/
/*********************** Header styles *************************/
.header {
    padding: 13px;
}
.header-row-1 {
    display: flex;
    flex-direction: row;
    margin: auto;
}
.header-row-2 {
    text-align: center;
}
.header-row-3 {
    text-align: center;
}
.header-c1 {
    display: flex;
    flex-direction: column;
}
.header-c2 {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}
.header-c3 {
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
    align-items: flex-end;
}
.header-c3-info {
    display: flex;
    flex-direction: column;
    align-items: flex-end;
}
/********************** End header styles **********************/


/***************************************************************/
/************************ Footer styles ************************/
.footer {
    color: orange;
    font-size: 23px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    width: 100%;
}
.table-footer-place {
    height: 2.5cm; /* A fixed height for the space where footer will place */
}
/********************** End footer styles **********************/


/***************************************************************/
/****************** More configs for printing ******************/
@media print {
    table {
        table-layout: fixed;
        word-wrap: break-word;
        text-align: left;
        width: 98%;
        margin-left: auto;
        margin-right: auto;
    }
    .print-footer {
        position: fixed;
        bottom: 2.2%;
        left: 0;
    }
}
/**************************** End ******************************/');


insert into report_template (id, name, html) values (3, 'header', '<div class="header">
  <div class="row header-row-1">
    <div class="col-3 header-c1">
      <div class="row">
        <%= business.name %>
      </div>
      <div class="row">
        <%= business.address %>
      </div>
      <div class="row">
        <%= business.town %>
      </div>
      <div class="row">
        <%= business.city %>
      </div>
    </div>
    <div class="col-6 header-c2">
      <img 
        src="https://novosystem.io/assets/images/logo-novosystem.png"
        width=180px
        height=100px
      >
    </div>
    <div class="col-3">
      <div class="row">
        <div class="col-4">
          <div class="row">
            Fecha:
          </div>
          <div class="row">
            Usuario:
          </div>
          <div class="row">
            Módulo:
          </div>
        </div>
        <div class="col-8 header-c3-info">
          <div class="row">
            <%= date %>
          </div>
          <div class="row">
            <%= user.name %>
          </div>
          <div class="row">
            <%= user.module %>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="container" style="padding: 5px">
    <div class="header-row-2">
      <h1><%= report.title %></h1>
    </div>
    <div class="header-row-3" style="color: rgb(255, 168, 7);">
      <h3><%= report.subtitle %></h3>
    </div>
  </div>
</div>');

insert into report_template (id, name, html) values (4, 'body', '<table class="table-sm"> <!-- Bootstrap class small table -->

  <!-- Generate columns/headers for the report -->
  <thead>
    <tr>

      <!-- Index (if you don''t need it, pass includeIndex = false
          or just take this off, according your needs) -->
      <% if (includeIndex) { %>
        <th id="column0" scope="col" class="table-header">N°</th>
      <% } %>
      
      <!-- Data headers -->
      <% if (hasSubtotal) { %>
        <% subtotalHeaderNames.map((headerName, idx) => { %>
          <th id="column<%= idx + 1 %>" scope="col" class="table-header"><%= headerName %></th>
        <% }) %>
      <% } else { %>
        <% headerNames.map((headerName, idx) => { %>
          <th id="column<%= idx + 1 %>" scope="col" class="table-header"><%= headerName %></th>
        <% }) %>
      <% } %>

    </tr>
  </thead>
  
  <!-- Display the body -->
  <tbody>

    <!-- Defining (if it''s included) an index with a counter that starts at 1 -->
    <% if (includeIndex) { %>
      <% var indexCounter = 1 %>
      <% var indexOffset = 1 %>
    <% } else { %>
      <% var indexOffset = 0 %>
    <% } %>
    
    <!------------------------------->
    <!--- Case: INCLUDE SUBTOTALS --->
    <!-- START: Display the data for each value of the grouped values -->
    <% if (hasSubtotal) { %>
      <% var indexRow = 1 %>
      <% dataGrouped.map((groupedRows, i) => { %>
        <% if (i == 0) { %>
          <!-- For the first grouped rows print the group'' headers -->
          <% currentKeys.map((key, k) => { %>
            <tr>
              <td
                colspan="<%= subtotalHeaderNames.length + indexOffset %>"
                scope="row"
                class="table-criteria"
              >
                <%= headerCriteriaNames[k] %>: <%= currentKeys[k] %>
              </td>
            </tr>
          <% }) %>
        <% } else { %>
          <!-- From the 2nd+ grouped rows -->
          <% for(let j=1; j<=subtotalCriteriaKeys.length; j++) { %>

            <!-- If the value in the current key is different -->
            <% if (groupedRows[`k${j}`] != currentKeys[j-1]) { %>

                <!-- Print subtotals -->
                <% for (let h=subtotalCriteriaKeys.length; h>=j; h--) { %>
                    <tr>
                      <td
                        colspan="<%= subtotalOffset[0] + indexOffset %>"
                        scope="row"
                        class="table-subtotal-info"
                      >
                        <%= "Subtotal " + headerCriteriaNames[h-1] %>
                      </td>
                      <% for (let k=0; k < subtotalList.length; k++) { %>
                        <td
                          colspan="<%= subtotalOffset[k+1] %>"
                          scope="row"
                          class="table-subtotal-values"
                        >
                          <% if (criteriaFormatters[k]) { %>
                            <%= criteriaFormatters[k].currency + formatMoney(subtotalList[k][h-1], criteriaFormatters[k].numberOfDecimals, criteriaFormatters[k].thousandSeparator, criteriaFormatters[k].decimalSeparator) %>
                          <% } else { %>
                            <%= subtotalList[k][h-1] %>
                          <% } %>
                        </td>
                      <% subtotalList[k][h-1] = 0; %>
                      <% } %>
                    </tr>
                <% } %>

                <!-- Print new headers if have changed -->
                <% for (let h=j; h <= subtotalCriteriaKeys.length; h++) { %>
                    <% currentKeys[h-1] = groupedRows[`k${h}`] %>
                    <tr>
                      <td
                        colspan="<%= subtotalHeaderNames.length + indexOffset %>"
                        scope="row"
                        class="table-criteria"
                      >
                        <%= headerCriteriaNames[h-1] %>: <%= currentKeys[h-1] %>
                      </td>
                    </tr>
                <% } %>
            <% } %>
          <% } %>
        <% } %>

        <!-- Print the rows of a set of given grouped rows -->
        <% groupedRows.data.map(value => { %>

            <!-- First delete the properties that are keys -->
            <% subtotalCriteriaKeys.map(key => { %>
                <% delete value[key] %>
            <% }) %>
    
            <!-- Sum the subtotals -->
            <% subtotalKeys.map((key, j) => { %>
                <% for (k=0; k < subtotalCriteriaKeys.length; k++) { %>
                    <% subtotalList[j][k] += value[key] %>
                <% } %>
                <% totalsForSubtotals[j] += value[key] %>
            <% }) %>

            <tr class="table-row-values">
              <!-- Index (if you don''t need it, pass includeIndex = false
              or just take this off) -->
              <% if (includeIndex) { %>
                <td scope="row" class="table-cell-values">
                  <%= (indexRow) %>
                  <% indexRow++ %>
                </td>
              <% } %>

              <!-- Print rows grouped by -->
              <% subtotalDataKeys.map((key, k) => { %>
                <td scope="row" class="table-cell-values">
                  <% if (subtotalFormatters[k]) { %>
                    <%= subtotalFormatters[k].currency + formatMoney(value[key], subtotalFormatters[k].numberOfDecimals, subtotalFormatters[k].thousandSeparator, subtotalFormatters[k].decimalSeparator) %>
                  <% } else { %>  
                    <%= value[key] %>
                  <% } %>  
                </td>
              <% }) %>

            </tr> 
        <% }) %>

        <!-- The last subtotal row -->
        <% if (i == dataGrouped.length-1) { %>
          <!-- Print subtotals -->
          <% for (let j=subtotalCriteriaKeys.length-1; j >= 0; j--) { %>
              <tr>
                <td
                  colspan="<%= subtotalOffset[0] + indexOffset %>"
                  scope="row"
                  class="table-subtotal-info"
                >
                  <%= "Subtotal " + headerCriteriaNames[j] %>
                </td>
              <% for (let k=0; k < subtotalList.length; k++) { %>
                    <td
                      colspan="<%= subtotalOffset[k+1] %>"
                      scope="row"
                      class="table-subtotal-values"
                    >
                      <% if (criteriaFormatters[k]) { %>
                        <%= criteriaFormatters[k].currency + formatMoney(subtotalList[k][j], criteriaFormatters[k].numberOfDecimals, criteriaFormatters[k].thousandSeparator, criteriaFormatters[k].decimalSeparator) %>
                      <% } else { %>
                        <%= subtotalList[k][j] %>
                      <% } %>  
                    </td>
              <% } %>
              </tr>
          <% } %>
        <% } %>
      <% }) %>

      <!-- Totals of subtotals -->
      <tr>
          <td
            colspan="<%= subtotalOffset[0] + indexOffset %>"
            scope="row"
            class="table-total-info"
          >
            Total
          </td>
          <% for (let k=0; k < totalsForSubtotals.length; k++) { %>
            <td
              colspan="<%= subtotalOffset[k+1] %>"
              scope="row"
              class="table-total-values"
            >
              <% if (totalFormatters[k]) { %>
                <%= totalFormatters[k].currency + formatMoney(totalsForSubtotals[k], totalFormatters[k].numberOfDecimals, totalFormatters[k].thousandSeparator, totalFormatters[k].decimalSeparator) %>
              <% } else { %>
                <%= totalsForSubtotals[k] %>
              <% } %> 
            </td>
          <% } %>
      </tr>
    <% } %>
    <!------- END Case SUBTOTALS -------->
    <!----------------------------------->
   
    <!------------------------------------------------>
    <!--- Case: Display the data without subtotals --->
    <% if (!hasSubtotal) { %>
      <!-- START -->
      <% data.map((elem, i) => { %>
        <tr class="table-row-values">

          <!-- Index (if you don''t need it, pass includeIndex = false
            or just take this off) -->
          <% if (includeIndex) { %>
            <td scope="row" class="table-cell-values">
              <%= (i+1) %>
            </td>
          <% } %>

          <!-- Data -->
          <% dataKeys.map((header, k) => { %>
            <td scope="row" class="table-cell-values">
              <% if (formatters[k]) { %>
                <%= formatters[k].currency + formatMoney(elem[header], formatters[k].numberOfDecimals, formatters[k].thousandSeparator, formatters[k].decimalSeparator) %>
              <% } else { %>
                <%= elem[header] %>
              <% } %>
            </td>
          <% }) %>
          
        </tr>   
      <% }) %>
    <% } %>
    <!-- END display data without subtotal -->

    <!-- Display the totals -->
    <% if (hasTotalButNotSubtotal) { %>
      <% let countCols %> <!-- To count how many cols are previous the col with total -->
      <% if (includeIndex) { %>
        <% countCols = 1 %>
      <% } else { %>
        <% countCols = 0 %>
      <% } %>

      <% let definedTotal = false %>
      <tr>
        <% totals.map(elem => { %>
          <% if (elem.hasTotal) { %>
            <% if (!definedTotal) { %>  
              <td
                colspan="<%= countCols %>"
                scope="row"
                class="table-total-info"
              >
                Total
              </td>

              <% definedTotal = true %>

              <td 
                scope="row" 
                class="table-total-values"
              >
                <% if (elem.totalFormat) { %>
                  <%= elem.totalFormat.currency + formatMoney(elem.totalValue, elem.totalFormat.numberOfDecimals, elem.totalFormat.thousandSeparator, elem.totalFormat.decimalSeparator) %>
                <% } else { %>
                  <%= elem.totalValue %>
                <% } %>
              </td>
              <% countCols = 0 %> <!-- Restart -->

            <% } else { %>

              <td
                colspan="<%= countCols + 1 %>"
                scope="row" 
                class="table-total-values"
              >
                <% if (elem.totalFormat) { %>
                  <%= elem.totalFormat.currency + formatMoney(elem.totalValue, elem.totalFormat.numberOfDecimals, elem.totalFormat.thousandSeparator, elem.totalFormat.decimalSeparator) %>
                <% } else { %>
                  <%= elem.totalValue %>
                <% } %>
              </td>
              <% countCols = 0 %> <!-- Restart -->

            <% } %>
          <% } else { %>
            <% countCols++ %>
          <% } %>
        <% }) %>
      </tr>
    <% } %>
    <!-- End Display totals -->

  </tbody>
</table>');

insert into report_template (id, name, html) values (5, 'footer', '<div id="footer" class="footer print-footer">
    <strong>Novosystem.io</strong>
</div>');