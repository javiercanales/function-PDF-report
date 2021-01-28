# function-PDF-report v3
Aquí encontrará los archivos necesarios para crear un reporte con la función generatePDFv3(), versión 3
- Esta función permite generar reportes PDF responsivos generando subtotales y totales para columnas deseadas.
- Si utiliza esta función debe utilizar la opción de subtotales, sino fallará (puesto que la plantilla fue diseñada para interpretar datos agrupados para subtotales).
- Si requiere una función para reportes básicos (sin subtotales), puede utilizar la versión 2 que da libertad en el uso de totales opcionalmente.

# Archivos necesarios

## generate-pdf.js
Este archivo incluye la funcion para generar reportes PDFs
- generatePDFv1 : la función para generar reportes

## script.sql
Este archivo contiene las script de creación de tabla template_html y inserción de tuplas para base, css, header, body y footer del reporte HTML (EJS) para MySQL (en realidad casi cualquier motor SQL tipico)

# Archivos opcionales

## PDFController.js
Este archivo contiene un ejemplo de servicio/controlador para llamar a la función generatePDFv3()

## data.js
Archivo con datos de prueba (incluye module exports, y también con require() de la data en el controlador anterior)

## TemplateHTML.js
Este archivo contiene el modelo para la tabla template_html, para el framework Sails.js

## Carpeta Template EJS-CSS files
Contiene los archivos de plantilla para el reporte:
- TemplateHTML.ejs: el reporte completo
- base.ejs + header.ejs + body.ejs + footer.ejs: la separación del reporte en partes (utilizadas para almacenar en BD)
- style.css : hoja de estilos del reporte
