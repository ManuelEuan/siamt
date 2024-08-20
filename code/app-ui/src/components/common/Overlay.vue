<template>
    <v-overlay :value="value">
      <v-progress-circular indeterminate size="64"></v-progress-circular>
    </v-overlay>
  </template>
  
  <script>
  export default {
    props: {
      value: Boolean
    }
  };
  </script>
  