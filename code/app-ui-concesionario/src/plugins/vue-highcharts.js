import Vue from 'vue';
import HighchartsVue from 'highcharts-vue';

import Highcharts from 'highcharts';
import exportingInit from 'highcharts/modules/exporting';

Highcharts.setOptions(
  {
    lang: {
      downloadCSV: 'Descargar CSV',
      downloadJPEG: 'Descargar imagen JPEG',
      downloadPDF: 'Descargar documento PDF',
      downloadPNG: 'Descargar imagen PNG',
      downloadSVG: 'Descargar imagen SVG',
      drillUpText: undefined,
      viewFullscreen: 'Pantalla completa',
      exitFullscreen: 'Salir de pantalla completa'
    }
  }
);

exportingInit(Highcharts);


Vue.use(HighchartsVue);
