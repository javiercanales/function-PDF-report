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
    
    <title>Reporte</title>
  </head>

  <% let currentRows = 0 %>
  <body>
  <% arrayData.map((data, i) => { %>
    <!-- ======= Header ======= -->
    {header}

    <!-- ======= Body ======= -->
    {body}

    <!-- ======= Footer ======= -->
    {footer}

    <div class="pagebreak"></div>
    <% currentRows += arrayRowsPerPage[i] %>
  <% }); %>
  </body>
</html>');

insert into template_html (id, name, html) values (2, 'css', 'body {
    color: rgb(72, 72, 105);
    font-family: "Open Sans", sans-serif;
}
td {
    border: 2px solid rgb(209, 139, 10);
    word-wrap: normal;
}
th {
    border: 2px solid rgb(209, 139, 10);
    color: rgb(209, 139, 10);
    word-wrap: break-word;
}
table {
    table-layout: fixed;
    word-break: break-all;
}
table.table-striped > thead > tr > th {
    border: 2px solid rgb(209, 139, 10);
}
.table-body {
    height: 78vh;
    width: 97vw;
}
.table-first-col {
    width: 4.5%;
}
/* .table-cols in the function */
.table-last-col {
    width: auto;
}
.header {
    height: 15vh;
    width: 100vw;
    padding: 12px;
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
.footer {
    color: orange;
    font-size: 23px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 4vh;
    width: 100vw;
}
@media print {
    .pagebreak { 
        page-break-before: always;
    }
    /* page-break-after works, as well */
}');

insert into template_html (id, name, html) values (3, 'header', '<header class="container-fluid header">
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
            Página:
          </div>
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
            <%= i+1 +'' de ''+pages %>
          </div>
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
</header>');

insert into template_html (id, name, html) values (4, 'body', '<div class="row justify-content-center">
  <div class="col-auto">
    <table class="table table-sm table-striped table-body">
      <thead>
        <tr>
          <!-- To generate columns/headers for the report -->
          <th scope="col" class="table-first-col">N°</th>
          <% columns.slice(0, columns.length-1).map((column, idx) => { %>
          <th scope="col" class="table-cols"><%= column %></th>
          <% }) %>
          <th scope="col" class="table-last-col"><%= columns[columns.length-1] %></th>
        </tr>
      </thead>
      <tbody>
        <% data.map((elem, j) => { %>
          <tr>
            <td scope="row" class="table-first-col">
              <b><%= (currentRows) + (j+1) %></b>
            </td>
            <% dataColumns.slice(0, dataColumns.length-1).map((header, k) => { %>
            <td scope="row" class="table-cols"><%= elem[header] %></td>
            <% }) %>
            <td scope="row" class="table-last-col"><%= elem[dataColumns[dataColumns.length-1]] %></td>
          </tr>   
        <% }) %>
      </tbody>
    </table>
  </div>
</div>');

insert into template_html (id, name, html) values (5, 'footer', '<footer class="container footer">
    <strong>Novosystem.io</strong>
</footer>');