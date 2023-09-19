<template>
  <v-card class="pa-2">
    <v-card-title class="justify-center display-1 mb-2">Cambiar contraseña</v-card-title>
    <div class="overline">{{ status }}</div>
    <div class="error--text mt-2 mb-4">{{ error }}</div>

    <a href="/">Regresar</a>

    <v-form ref = "validPassword">
      <v-text-field
        v-model="newPassword"
        :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
        :rules="rules.passwordRules"
        :type="showPassword ? 'text' : 'password'"
        :error="errorNewPassword"
        :error-messages="errorNewPasswordMessage"
        name="password"
        label="Nueva contraseña"
        outlined
        class="mt-4"
        @change="resetErrors"
        @keyup.enter="confirmPasswordReset"
        @click:append="showPassword = !showPassword"
      ></v-text-field>
    </v-form>

    <v-btn
      :loading="isLoading"
      block
      depressed
      x-large
      color="primary"
      @click="confirmPasswordReset"
    >Establecer nueva contraseña e ingresar de nuevo</v-btn>
  </v-card>
</template>

this.$router.push('/auth/verify-email')
<script>
import services from '@/services';
/*
|---------------------------------------------------------------------
| Reset Page Component
|---------------------------------------------------------------------
|
| Page Form to insert new password and proceed to sign in
|
*/
export default {
  data() {
    return {
      isLoading: false,

      showNewPassword: true,
      newPassword: '',

      // form error
      errorNewPassword: false,
      errorNewPasswordMessage: '',

      // show password field
      showPassword: false,

      status: 'Cambiando contraseña',
      error: null,

      // input rules
      rules : {
        passwordRules : [
          v => !!v || 'Este campo es requerido',
          v => v.length >=8 || 'La contraseña debe contener al menos 8 caracteres'
        ],
      }
    }
  },
  methods: {
    async confirmPasswordReset() {
      this.isLoading = true
      if(!this.$refs.validPassword.validate()) {
            this.$toastr.e('La contraseña es obligatoria y debe tener al menos 8 caracteres');
            this.isLoading = false;
            return
        }
      let user = await services.security().getSubject();
      let response = await services.security().changePassword(user, this.newPassword);
      if(response.lError) {
        this.$toastr.e('No se ha podido cambiar la contraseña, intente de nuevo');
        return
      }

      this.$toastr.s('Contraseña cambiada con éxito, favor de ingresar sus credenciales de nuevo');
      services.security().logout();
    },
    resetErrors() {
      this.errorNewPassword = false
      this.errorNewPasswordMessage = ''
    }
  }
}
</script>
