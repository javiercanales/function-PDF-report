# Function PDF Reports
Aquí encontrará los archivos necesarios para crear un reporte con la función generatePdfReport()
- Esta función permite generar reportes PDF responsivos generando subtotales y totales para columnas deseadas.
- Con esta función usted puede abordar tanto subtotales y totales, sólo totales, o reportes básicos.
- La función admite múltiples criterios (keys) para el agrupamiento de subtotales.
- Para ver un ejemplo de uso click [aquí](#ejemplo-de-uso).

# Observaciones
- Si desea generar reportes para muchos registros (e.g. +10.000), se sugiere reducir el tamaño de la letra (en el body del css). El rendimiento para reportes gigantes dependerá del equipo servidor.
- También se sugiere controlar desde el front-end las peticiones, para que el navegador no vuelva a pedir una petición si es que sigue esperando el reporte (podría ocurrir para reportes grandes según pruebas realizadas).

# Archivos necesarios

## generate-report-pdf.js
Este archivo incluye la funcion para generar reportes PDFs
- generatePdfReport : la función para generar reportes PDF, que retorna un PDF como buffer.

## script.sql
Este archivo contiene las script de creación de tabla report_template y inserción de tuplas para base, css, header, body y footer del reporte HTML (EJS) para MySQL (en realidad casi cualquier motor SQL tipico)

# Archivos opcionales

## ReportController.js
Este archivo contiene un ejemplo de servicio/controlador para llamar a la función (similar al del [ejemplo de uso](#ejemplo-de-uso))

## data.js
Archivo con datos de prueba (la misma de los [datos de prueba utilizados](#datos-de-prueba-utilizados))

## ReportTemplate.js
Este archivo contiene el modelo para la tabla report_template, para el framework Sails.js

## Carpeta Template EJS-CSS files
Contiene los archivos de plantilla para el reporte:
- TemplateHTML.ejs: el reporte completo
- base.ejs + header.ejs + body.ejs + footer.ejs: la separación del reporte en partes (utilizadas para almacenar en BD)
- style.css : hoja de estilos del reporte

# Ejemplo de uso

## Para definir criterios de subtotales:
- Estos criterios deben indicarse también en las columnas en caso que desee identificarlos con un header (si no los indica funcionará igual, pero sólo se mostrará el valor asociado. Para ver detalles, vea el siguiente ejemplo de columns)
```javascript
const subtotalCriteriaKeys = ['region','town','rut'];
```

## Para definir columnas del reporte:

- Los valores clave (key) son requeridos para identificar los datos (data)
- Un header para personalizar el reporte es opcional
- El ancho (width) es opcional (debe cuidar que no sumen más de 100 estos porcentajes width)
- Si usted indica que una columna pasa a ser criterio de subtotal, ésta no se ubicará como columna sino como fila completa de subtotal (por ello, ignorará valores width -pues seria redundante-, pero podrá definirle headers).
```javascript
const columns = [
    {
        key: 'name',
        header: 'Nombre',
        width: 25,
    },
    {
        key: 'rut',
        header: 'RUT Encargado',
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
        header: 'Comuna'
    },
];
```

## Para definir información de negocio o empresarial (business), de usuario y del reporte:
```javascript
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
```

## Para indicar el uso de un indice (opcional):
```javascript
const index = {
    includeIndex: true, // In case your data doesn't have an index, and you need it in the report
    width: 3 // Percentage value of width (e.g. 3%)
};
```

## Para llamar a la función y generar un PDF como buffer, a enviar en el response:
```javascript
generatePdfReport(data, columns, subtotalCriteriaKeys, business, user, report, index).then((pdf) => {
    res.set({
        'Content-Type': 'application/pdf',
        'Content-Length': pdf.length
    });
    res.status(200).send(pdf);
});
```

## Datos de prueba utilizados:
```javascript
const data = [
    {
        "name": "Cabañas Pepito",
        "rut": "18.808.707-3",
        "basePrice": 66000,
        "address": "Avenida Siempre Grande 007",
        "town": "Coñaripe",
        "region": "La Araucanía",
        "promoPrice": 65000
    },
    {
        "name": "Cabañas Juanito",
        "rut": "19.805.607-5",
        "basePrice": 56000,
        "address": "Calle Grande 005",
        "town": "Coñaripe",
        "region": "La Araucanía",
        "promoPrice": 55000
    },
    {
        "name": "Cabañas Juanito Gold",
        "rut": "19.805.607-5",
        "basePrice": 120000,
        "address": "Calle Grande 004",
        "town": "Coñaripe",
        "region": "La Araucanía",
        "promoPrice": 106990
    },
    {
        "name": "Cabañas Juanito Elite",
        "rut": "19.805.607-5",
        "basePrice": 150000,
        "address": "Calle Grande 004",
        "town": "Coñaripe",
        "region": "La Araucanía",
        "promoPrice": 136990
    },
    {
        "name": "Cabañas Vertientes",
        "rut": "16.705.807-1",
        "basePrice": 66000,
        "address": "Calle Grande 005",
        "town": "Coñaripe",
        "region": "La Araucanía",
        "promoPrice": 58000
    },
    {
        "name": "Posada La Aguita",
        "rut": "16.705.807-1",
        "basePrice": 66000,
        "address": "Avenida La Avenida",
        "town": "Puerto Fuy",
        "region": "La Araucanía",
        "promoPrice": 65000
    },
    {
        "name": "Cabañas Aguas Tranquilas",
        "rut": "18.808.707-3",
        "basePrice": 78000,
        "address": "Avenida Siempre Grande 007",
        "town": "Lican Ray",
        "region": "La Araucanía",
        "promoPrice": 77000
    },
    {
        "name": "Camping La Lluvia",
        "rut": "19.805.607-5",
        "basePrice": 66000,
        "address": "Mucha Sed 008",
        "town": "Lican Ray",
        "region": "La Araucanía",
        "promoPrice": 55000
    },
    {
        "name": "Cabañas Vertiendo",
        "rut": "16.705.807-1",
        "basePrice": 66000,
        "address": "Calle Grande 005",
        "town": "Lican Ray",
        "region": "La Araucanía",
        "promoPrice": 45000.03
    },
    {
        "name": "Cabañas Lluvia",
        "rut": "16.705.807-1",
        "basePrice": 66000,
        "address": "Calle Grande 305",
        "town": "Lican Ray",
        "region": "La Araucanía",
        "promoPrice": 45000.03
    },
    {
        "name": "Posada La Aguita",
        "rut": "13.568.708-K",
        "basePrice": 66000,
        "address": "Avenida La Avenida",
        "town": "Puerto Fuy",
        "region": "La Araucanía",
        "promoPrice": 65000
    },
    {
        "name": "La Cascada",
        "rut": "11.589.707-1",
        "basePrice": 66000,
        "address": "Avenida La Avenida",
        "town": "Caburgua",
        "region": "La Araucanía",
        "promoPrice": 65000
    },
    {
        "name": "La Casa de la Pradera",
        "rut": "10.577.707-7",
        "basePrice": 66000,
        "address": "Calle Picaflor 233",
        "town": "Caburgua",
        "region": "La Araucanía",
        "promoPrice": 65000
    },
    {
        "name": "La Casa de la Pradera 2",
        "rut": "10.577.707-7",
        "basePrice": 56000,
        "address": "Calle Picaflor 233",
        "town": "Caburgua",
        "region": "La Araucanía",
        "promoPrice": 55000
    },
    {
        "name": "La Casa de la Pradera 3",
        "rut": "10.577.707-7",
        "basePrice": 46000,
        "address": "Calle Picaflor 236",
        "town": "Caburgua",
        "region": "La Araucanía",
        "promoPrice": 45000
    },
    {
        "name": "El Árbol",
        "rut": "13.678.606-3",
        "basePrice": 86000,
        "address": "Avenida Lala",
        "town": "Caburgua",
        "region": "La Araucanía",
        "promoPrice": 85000
    },
    {
        "name": "Ruka Lelbún",
        "rut": "15.678.606-3",
        "basePrice": 86000,
        "address": "Ruta Lelbún",
        "town": "Contulmo",
        "region": "Bío-Bío",
        "promoPrice": 85000
    },
    {
        "name": "Las Vertientes",
        "rut": "15.678.606-3",
        "basePrice": 46000,
        "address": "Camino Paraguay",
        "town": "Salto del Laja",
        "region": "Bío-Bío",
        "promoPrice": 45000
    },
    {
        "name": "Camping Paraguay",
        "rut": "15.678.606-3",
        "basePrice": 56000,
        "address": "Camino Paraguay",
        "town": "Salto del Laja",
        "region": "Bío-Bío",
        "promoPrice": 55000
    },
    {
        "name": "Camping Salto del Laja",
        "rut": "11.158.706-5",
        "basePrice": 36000,
        "address": "Camino Paraguay",
        "town": "Salto del Laja",
        "region": "Bío-Bío",
        "promoPrice": 25000
    },
    {
        "name": "Cabañas Pepito",
        "rut": "12.808.707-3",
        "basePrice": 66000,
        "address": "Avenida Siempre Grande 007",
        "town": "Coñaripe",
        "region": "La Araucanía",
        "promoPrice": 65000
    },
];
```
