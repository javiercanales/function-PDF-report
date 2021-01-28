# Function PDF Reports
Aquí encontrará los archivos necesarios para crear un reporte con la función generatePdfReport()
- Esta función permite generar reportes PDF responsivos generando subtotales y totales para columnas deseadas.
- Con esta función usted puede abordar tanto subtotales y totales, sólo totales, o reportes básicos.
- La función admite múltiples criterios (keys) para el agrupamiento de subtotales.

# Observaciones
- Si desea generar reportes para muchos registros (e.g. +10.000), se sugiere reducir el tamaño de la letra (en el body del css). El rendimiento para reportes gigantes dependerá del equipo servidor.
- También se sugiere controlar desde el front-end las peticiones, para que el navegador no vuelva a pedir una petición si es que sigue esperando el reporte (podría ocurrir para reportes grandes).

# Archivos necesarios

## generate-report-pdf.js
Este archivo incluye la funcion para generar reportes PDFs
- generatePDFv1 : la función para generar reportes

## script.sql
Este archivo contiene las script de creación de tabla template_html y inserción de tuplas para base, css, header, body y footer del reporte HTML (EJS) para MySQL (en realidad casi cualquier motor SQL tipico)

# Archivos opcionales

## ReportController.js
Este archivo contiene un ejemplo de servicio/controlador para llamar a la función generatePDFv3()

## data.js
Archivo con datos de prueba (incluye module exports, y también con require() de la data en el controlador anterior)

## ReportTemplate.js
Este archivo contiene el modelo para la tabla template_html, para el framework Sails.js

## Carpeta Template EJS-CSS files
Contiene los archivos de plantilla para el reporte:
- TemplateHTML.ejs: el reporte completo
- base.ejs + header.ejs + body.ejs + footer.ejs: la separación del reporte en partes (utilizadas para almacenar en BD)
- style.css : hoja de estilos del reporte

# Ejemplo de uso

```javascript
generatePdfReport(data, columns, subtotalCriteriaKeys, business, user, report, index).then((pdf) => {
            res.set({
                'Content-Type': 'application/pdf',
                'Content-Length': pdf.length
            });
            res.status(200).send(pdf);
        });
```
