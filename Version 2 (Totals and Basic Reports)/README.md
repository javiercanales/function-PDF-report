# function-PDF-report v2
Aquí encontrará los archivos necesarios para crear un reporte con la función generatePDFv2(), versión 2
- Esta función permite generar reportes PDF responsivos con la opción de generar totales para columnas deseadas.
- La opción de totales es opcional, si lo desea, puede usar esta función como un reporte básico (como la v1.1).

# Archivos necesarios

## generate-pdf.js
Este archivo incluye la funcion para generar reportes PDFs
- generatePDFv1 : la función para generar reportes

## script.sql
Este archivo contiene las script de creación de tabla template_html y inserción de tuplas para base, css, header, body y footer del reporte HTML (EJS) para MySQL (en realidad cualquier motor SQL)

# Archivos opcionales

## PDFController.js
Este archivo contiene un ejemplo de servicio/controlador para llamar a la función generatePDFv2()

## data.js
Archivo con datos de prueba (incluye module exports, y también con require() de la data en el controlador anterior)

## TemplateHTML.js
Este archivo contiene el modelo para la tabla template_html, para el framework Sails.js

## Carpeta Template EJS-CSS files
Contiene los archivos de plantilla para el reporte:
- TemplateHTML.ejs: el reporte completo
- base.ejs + header.ejs + body.ejs + footer.ejs: la separación del reporte en partes (utilizadas para almacenar en BD)
- style.css : hoja de estilos del reporte
