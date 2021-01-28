/**
 * ReportTemplate.js
 *
 * A template HTML-EJS and CSS.
 */
module.exports = {
    
    tableName: 'report_template',
    attributes: {
      id: { 
          type: 'number',
          columnType: 'int',
          required: true
      },
      name: { 
        type: 'string',
        columnType: 'varchar(8)',
        required: true 
      },
      html: { 
        type: 'string',
        columnType: 'text',
        required: true
      }

        /**********************************
         * Fields standard for all Tables
         ***********************************/
        /*
      createdAt: {
          type: 'ref',
          columnType: 'DateTime',
          autoCreatedAt: true
      },
      updatedAt: {
          type: 'ref',
          columnType: 'DateTime',
          autoUpdatedAt: true
      },
      */
    },
};