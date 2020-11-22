# function-PDF-report v1.1
Aquí encontrará los archivos necesarios para crear un reporte con la función generatePDFv1(), actual versión 1.1

# Archivos necesarios

## generate-pdf.js
Este archivo incluye las dos funciones necesarias para generar reportes PDFs responsivos
- generatePDFv1 : la función para generar reportes
- calculateRows : función para calcular cuántas filas tendrá cada página (requiere de entrada algunos valores como colWidth, para controlar que no se exceda anchura del reporte y mantener responsividad)

## script.sql
Este archivo contiene las script de creación de tabla template_html y inserción de tuplas para base, css, header, body y footer del reporte HTML (EJS) para MySQL (en realidad cualquier motor SQL)

# Archivos opcionales

## PDFController.js
Este archivo contiene un ejemplo de servicio/controlador para llamar a la función generatePDFv1()

## data.js
Archivo con datos de prueba (incluye module exports, y también con require() de la data en el controlador anterior)

## TemplateHTML.js
Este archivo contiene el modelo para la tabla template_html, para el framework Sails.js

## TemplateHTML.ejs y style.css
Archivos de plantilla HTML/CSS con EJS (JavaScript embebido). Se adjunta por si se requiere implementar manualmente y no desde MySQL (líneas comentadas con // en la función generatePDFv1() para importar archivos respectivos, por si se requiere).
