<!-- eslint-disable no-unused-vars -->
<template>
  <div>
    <v-card class="text-center pa-2">
      <img :src="require('@/assets/images/Logo-oficial-ATY.svg')" alt="" width="70%" class="img-fluid d-inline-block align-text-top">
      <v-card-title class="justify-center display-1 mb-2">Iniciar sesión</v-card-title>
      <v-card-subtitle>Por favor ingresa tus credenciales para continuar</v-card-subtitle>

      <!-- sign in form -->
      <v-card-text>
        <v-form ref="form" v-model="isFormValid" lazy-validation>
          <v-text-field
              v-model="application"
              name="application"
              v-show="false"
              outlined
          ></v-text-field>

          <v-text-field
            v-model="email"
            :rules="[rules.required]"
            :validate-on-blur="false"
            :error="error"
            label="Usuario"
            name="email"
            outlined
            @keyup.enter="submit"
            @change="resetErrors"
          ></v-text-field>

          <v-text-field
            v-model="password"
            :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
            :rules="[rules.required]"
            :type="showPassword ? 'text' : 'password'"
            :error="error"
            :error-messages="errorMessages"
            label="Contraseña"
            name="password"
            outlined
            @change="resetErrors"
            @keyup.enter="submit"
            @click:append="showPassword = !showPassword"
          ></v-text-field>

          <v-btn
            :loading="isLoading"
            :disabled="isSignInDisabled"
            block
            x-large
            color="primary"
            dark
            @click="submit"
          >Entrar
            <v-icon right>
              mdi-arrow-right
            </v-icon>
          </v-btn>

          <!-- <div class="caption font-weight-bold text-uppercase my-3">{{ $t('login.orsign') }}</div> -->

          <!-- external providers list -->
          <v-btn
            v-for="provider in providers"
            :key="provider.id"
            :loading="provider.isLoading"
            :disabled="isSignInDisabled"
            class="mb-2 primary lighten-2 primary--text text--darken-3"
            block
            x-large
            to="/"
          >
            <v-icon small left>mdi-{{ provider.id }}</v-icon>
            {{ provider.label }}
          </v-btn>

          <div v-if="errorProvider" class="error--text">{{ errorProviderMessages }}</div>

          <!-- <div class="mt-5">
            <router-link to="/auth/forgot-password">
              {{ $t('login.forgot') }}
            </router-link>
          </div> -->
        </v-form>
      </v-card-text>
    </v-card>

    <!-- <div class="text-center mt-6">
      {{ $t('login.noaccount') }}
      <router-link to="/auth/signup" class="font-weight-bold">
        {{ $t('login.create') }}
      </router-link>
    </div> -->
  </div>
</template>

<script>
import rules from '@/core/rules.forms';
import services from '@/services';
/*
|---------------------------------------------------------------------
| Sign In Page Component
|---------------------------------------------------------------------
|
| Sign in template for user authentication into the application
|
*/
export default {
  data() {
    return {
      // sign in buttons
      isLoading: false,
      isSignInDisabled: false,

      // form
      isFormValid: true,
      email: '',
      password: '',
      application:'a554a189123ea67aa9407a54de9fc4c2',

      // form error
      error: false,
      errorMessages: '',

      errorProvider: false,
      errorProviderMessages: '',

      // show password field
      showPassword: false,

      providers: [],

      // input rules
      rules: rules
    }
  },
  methods: {
    submit() {
      if (this.$refs.form.validate()) {
        this.isLoading = true
        this.isSignInDisabled = true
        this.signIn(this.email, this.password, this.application)
      }
    },
    async signIn(email, password, application) {
      try{
        let s = await services.security().login(email, password, application);
        this.$router.push('/')
      }catch(e){
        // if (this.$store && this.$store.dispatch) this.$store.dispatch('app/showError',{message: e.message, error: e});
        this.error = true;
        this.errorMessages = e.message;
        this.isLoading = false;
        this.isSignInDisabled = false;
      }
      
    },
    signInProvider(provider) {},
    resetErrors() {
      this.error = false
      this.errorMessages = ''

      this.errorProvider = false
      this.errorProviderMessages = ''
    }
  }
}
</script>

<style>
:root {
  --v-primary-base: #59AF31;
}
</style>