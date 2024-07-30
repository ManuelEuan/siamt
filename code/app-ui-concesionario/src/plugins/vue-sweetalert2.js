import Vue from 'vue';
import VueSweetalert2 from 'vue-sweetalert2';

// If you don't need the styles, do not connect
import 'sweetalert2/dist/sweetalert2.min.css';

Vue.use(VueSweetalert2, { 
  target: '#app',
  reverseButtons: false,
  confirmButtonText: 'Aceptar',
  cancelButtonText: 'Cancelar',
  customClass: {
    // container: '...',
    // popup: '...',
    // header: '...',
    // title: '...',
    // closeButton: '...',
    // icon: '...',
    // image: '...',
    // htmlContainer: '...',
    // input: '...',
    // inputLabel: '...',
    // validationMessage: '...',
    // actions: '...',
    confirmButton: 'v-btn theme--light v-size--default primary',
    // denyButton: '...',
    cancelButton: 'v-btn v-btn--outlined theme--light v-size--default warning--text ml-1',
    // loader: '...',
    // footer: '....',
    // timerProgressBar: '....',
  },
  buttonsStyling: false
});

Vue.prototype.$rswal = new class RSwal {
  constructor() {
    this.Toast = Vue.swal.mixin({
      toast: true,
      position: 'top-end',
      showConfirmButton: false,
      timer: 2000,
      timerProgressBar: true,
      didOpen: (toast) => {
        toast.addEventListener('mouseenter', Vue.swal.stopTimer)
        toast.addEventListener('mouseleave', Vue.swal.resumeTimer)
      }
    });
  }

  toast(options) {
    return this.Toast.fire(options);
  }

  toastInfo(title) {
    return this.toast({ title, icon: 'info' });
  }

  toastSuccess(title) {
    return this.toast({ title, icon: 'success' });
  }

  toastError(title) {
    return this.toast({ title, icon: 'error' });
  }
  
  toastWarning(title) {
    return this.toast({ title, icon: 'warning' });
  }

  // #alert(options) {
  //   return this.$swal.fire(options);
  // }

  warning(title, text) {
    
    if (!text) {
      text = title;
      title = null;
    }
    
    return Vue.swal.fire({
      title, 
      html: text,
      icon: 'warning'
    });
  }
  
  success(title, text) {
    
    if (!text) {
      text = title;
      title = null;
    }
    
    return Vue.swal.fire({
      title, 
      html: text,
      icon: 'success'
    });
  }
  
  error(title, text) {
    
    if (!text) {
      text = title;
      title = null;
    }
    
    return Vue.swal.fire({
      title, 
      html: text,
      icon: 'error'
    });
  }
};