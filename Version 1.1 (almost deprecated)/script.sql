use prueba;
create table template_html(
	id int primary key,
    name varchar(8) not null,
    html varchar(4096) not null
);
select * from template_html;
insert into template_html (id, name, html) values (1, 'base', '<!DOCTYPE html>
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
            {header}
            <!-- ======= End Header ======= -->

          </td>
        </tr>
      </thead>

      <!-- ======= Body ======= -->
      <tr>
        <td>
          <!-- Start Print Content -->
          {body}
        </td>
      </tr>
      <!-- ======= End Body ======= -->

      <!-- ======= Footer: space to place it ======= -->
      <tfoot>
        <tr>
          <td class="table-footer-place">
            <!-- Leave this empty and dont remove it. This space is where footer will be placed on print -->
          </td>
        </tr>
      </tfoot>
      <!-- ======= End Footer ======= -->

    </table>
    <!-- ============ End of the report ============ -->

    <!-- ======= Footer (to be placed in the space above) ======= -->
    {footer}

  </body>
</html>
');

insert into template_html (id, name, html) values (2, 'css', 'body {
    color: rgb(72, 72, 105);
    font-family: "Open Sans", sans-serif;
    font-size: 15px;
    /* font-size: 15px; */
}

/* Body styles */
table {
    table-layout: auto;
    word-wrap: break-word;
    text-align: left;
}
thead.table-body, th.table-body, td.table-body {
    border: 2px solid rgb(209, 139, 10);
    border-collapse: collapse !important;
}
th.table-body {
    color: rgb(209, 139, 10); /* For a header with color */
}

/* Header styles */
.header {
    padding: 8px;
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

/* Footer styles */
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
    height: 3.5cm; /* A fixed height for the space where footer will place */
}

/* More configs for printing */
@media print {
    table {
        margin: 10px;
    }
    .print-footer {
        position: fixed;
        bottom: 3.5%;
        left: 0;
    }
}');

insert into template_html (id, name, html) values (3, 'header', '<div class="header">
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
        height=100px>
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

insert into template_html (id, name, html) values (4, 'body', '<table class="table-sm"> <!-- Bootstrap class small table -->

  <!-- Generate columns/headers for the report -->
  <thead class="table-body">
    <tr class="table-body">

      <!-- Index (if you dont need it, pass includeIndex = false
          or just take this off, according your needs) -->
      <% if (includeIndex) { %>
      <th id="column0" scope="col" class="table-body">N°</th>
      <% } %>

      <!-- Data -->
      <% headerNames.slice(0, headerNames.length).map((headerName, idx) => { %>
      <th id="column<%= idx + 1 %>" scope="col" class="table-body"><%= headerName %></th>
      <% }) %>

    </tr>
  </thead>
  
  <!-- Display the data -->
  <tbody class="table-body">
    <% data.map((elem, j) => { %>
      <tr class="table-body">

        <!-- Index (if you dont need it, pass includeIndex = false
          or just take this off) -->
        <% if (includeIndex) { %>
        <td scope="row" class="table-body">
          <b><%= (j+1) %></b>
        </td>
        <% } %>

        <!-- Data -->
        <% dataKeys.slice(0, dataKeys.length).map((header, k) => { %>
        <td scope="row"  class="table-body"><%= elem[header] %></td>
        <% }) %>
        
      </tr>   
    <% }) %>
  </tbody>
</table>');

insert into template_html (id, name, html) values (5, 'footer', '<div id="footer" class="footer print-footer">
    <strong>Novosystem.io</strong>
</div>');