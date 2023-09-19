import Vue from 'vue';
import { extend, ValidationProvider, ValidationObserver, setInteractionMode } from 'vee-validate';
import * as rules from 'vee-validate/dist/rules';
//import { messages } from 'vee-validate/dist/locale/es.json';
import locale from 'vee-validate/dist/locale/es.json';

import moment from 'moment';
const {messages} = locale;
setInteractionMode('eager');

Object.keys(rules).forEach(rule => {
  extend(rule, {
    ...rules[rule], // copies rule configuration
    message: messages[rule] // assign message
  });
});

extend('isBefore', {
  params: ['target'],
  validate(value, { target }) {

    const minValue = Number.parseInt(value, 10);
    const maxValue = Number.parseInt(target, 10);

    if (!maxValue) {
      return true;
    }

    return minValue <= maxValue;
  },
  message: `El campo {_field_} no puede ser mayor de {target}`
});

extend('isBeforeDate', {
  params: ['target'],
  validate(value, { target }) {

    const date = moment(value, 'YYYY-MM-DD');
    const targetDate = moment(target, 'YYYY-MM-DD');

    return date.isSameOrBefore(targetDate);
  },
  message: `El campo {_field_} no puede ser despues de {target}`
});

extend('isBeforeTime', {
  params: ['target'],
  validate(value, { target }) {

    const date = moment(value, 'HH:mm');
    const targetDate = moment(target, 'HH:mm');

    return date.isSameOrBefore(targetDate);
  },
  message: `El campo {_field_} no puede ser despues de {target}`
});

extend('semester', {
  params: ['target'],
  validate(value, { target }) {
    const startDate = moment(target);
    const endDate = moment(value);

    const diff = endDate.diff(startDate, 'months', true);
    
    return diff <= 6.0;
  },
  message: 'El rango de fechas no puede ser mayor a seis meses'
});

extend('messageLimitter', {
  params: ['max', 'contentLength'],
  validate(value, { max, contentLength = 0 } = { }) {
    console.log('MAX: ', max);
    console.log('Content: ', contentLength);
    return Number.parseInt(contentLength, 10) <= Number.parseInt(max, 10);
  },
  message: `El mensaje no puede ser mayor a {max} caracteres`
});

// const isBetween = (value, { min, max } = {}) => {
//   return Number(min) <= value && Number(max) >= value;
// };

// The first param is called 'min', and the second is called 'max'.
// const paramNames = ['min', 'max'];

// Validator.extend('between', isBetween, {
//   paramNames //  pass it in the extend options.
// });

Vue.component('ValidationObserver', ValidationObserver);
Vue.component('ValidationProvider', ValidationProvider);