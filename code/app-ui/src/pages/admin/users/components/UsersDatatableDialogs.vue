<template>
  <div class="wrapper">
    <v-dialog transition="dialog-top-transition" max-width="600" v-model="show.view">
      <v-card>
        <v-card-title class="text-uppercase primary--text text-h6 py-2"> ver usuario </v-card-title>
        <v-divider></v-divider>
        <v-card-text class="py-0 my-0">
          <v-list class="pa-0 ma-0">
            <v-container class="pa-0 ma-0">
              <v-row dense>
                <template v-for="(value, key, index) in user">
                  <v-col v-if="!chips.includes(key)" class="pa-0 ma-0" cols="6" :key="index">
                    <v-list-item>
                      <v-list-item-content class="py-2">
                        <v-list-item-title class="text-capitalize text-h7">
                          {{ headers[key] ?? key }}
                        </v-list-item-title>
                        <v-list-item-subtitle class="text-lowercase text-body-1">
                          {{ value }}
                        </v-list-item-subtitle>
                      </v-list-item-content>
                    </v-list-item>
                  </v-col>
                </template>
              </v-row>
            </v-container>
          </v-list>
        </v-card-text>
        <v-divider></v-divider>
        <v-card-text class="py-0 my-0">
          <v-list class="pa-0 ma-0">
            <v-container class="pa-0 ma-0">
              <v-row dense>
                <template v-for="(value, key, index) in user">
                  <v-col v-if="chips.includes(key)" class="pa-0 ma-0" cols="12" :key="index">
                    <v-list-item>
                      <v-list-item-content class="py-2">
                        <v-list-item-title class="text-capitalize text-h7">
                          {{ headers[key] ?? key }}
                        </v-list-item-title>
                        <v-list-item-subtitle class="text-lowercase text-body-1">
                          <v-chip v-for="(element, index) in value" :key="index">
                            {{ element }}
                          </v-chip>
                        </v-list-item-subtitle>
                      </v-list-item-content>
                    </v-list-item>
                  </v-col>
                </template>
              </v-row>
            </v-container>
          </v-list>
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions class="py-2">
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="show.view = false"> Cerrar </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog transition="dialog-top-transition" max-width="600" v-model="show.delete">
      <v-card>
        <v-card-title class="text-uppercase primary--text text-h6 py-2">
          {{ user.activo ? "desactivar" : "activar" }} usuario
        </v-card-title>
        <v-divider></v-divider>
        <v-card-text class="text-lowercase text-body-1 py-2">
          ¿est&aacute;s seguro de que deseas {{ user.activo ? "desactivar" : "activar" }} este
          usuario?
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions class="py-2">
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="show.delete = false"> Cerrar </v-btn>
          <v-btn color="primary" text @click="deleteUser">
            {{ user.activo ? "Desactivar" : "Activar" }}
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog transition="dialog-top-transition" max-width="600" v-model="show.change">
      <v-card>
        <v-card-title class="text-uppercase primary--text text-h6 py-2">
          cambiar contrase&ntilde;a
        </v-card-title>
        <v-divider></v-divider>
        <v-card-text class="text-lowercase text-body-1 py-2">
          <v-form ref="form" v-model="form.valid">
            <v-row dense>
              <v-col class="pa-0 ma-0 pb-2" cols="12">
                <v-text-field
                  v-model="user.clave"
                  :append-icon="cf.icon1"
                  :type="cf.type1"
                  :rules="[rules.required, rules.min8char]"
                  @click:append="form.show1 = !form.show1"
                  label="Contraseña*"
                  hide-details="auto"
                  clearable
                  dense
                  outlined
                />
              </v-col>
              <v-col class="pa-0 ma-0" cols="12">
                <v-text-field
                  v-model="form.pass"
                  :append-icon="cf.icon2"
                  :type="cf.type2"
                  :rules="[rules.required, rules.min8char, rules.samePass]"
                  @click:append="form.show2 = !form.show2"
                  label="Confirmar contraseña*"
                  hide-details="auto"
                  clearable
                  dense
                  outlined
                />
              </v-col>
            </v-row>
          </v-form>
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions class="py-2">
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="show.change = false"> Cerrar </v-btn>
          <v-btn color="primary" text :disabled="!valid" @click="changePass"> Cambiar </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog transition="dialog-top-transition" max-width="600" :value="show.reset">
      <v-card>
        <v-card-title class="text-uppercase primary--text text-h6 py-2">
          restablecer contrase&ntilde;a
        </v-card-title>
        <v-divider></v-divider>
        <v-card-text class="text-lowercase text-body-1 py-2">
          ¿esta seguro que desea restablecer la contrase&ntilde;a?
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions class="py-2">
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="show.reset = false"> Cerrar </v-btn>
          <v-btn color="primary" text @click="resetPass"> Restablecer </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import rules from "@/core/rules.forms";
import services from "@/services";

export default {
  name: "UsersDatatableDialogs",
  data() {
    return {
      chips: ["dominios", "modulos", "roles", "permisos"],
      headers: {
        roles: "perfiles",
        apepat: "apellido paterno",
        apemat: "apellido materno",
        fecha_creacion: "fecha de creacion",
        fecha_modificacion: "fecha de modificación",
      },
      show: {
        view: false,
        delete: false,
        change: false,
        reset: false,
      },
      user: {},
      form: {
        pass: "",
        show1: false,
        show2: false,
        valid: false,
      },
    };
  },
  computed: {
    cf() {
      return {
        type1: this.form.show1 ? "text" : "password",
        type2: this.form.show2 ? "text" : "password",
        icon1: this.form.show1 ? "mdi-eye" : "mdi-eye-off",
        icon2: this.form.show2 ? "mdi-eye" : "mdi-eye-off",
      };
    },
    samePass() {
      return this.form.pass === this.user.clave;
    },
    valid() {
      return this.samePass && this.form.valid;
    },
    rules() {
      return {
        ...rules,
        samePass: this.samePass || "Las contraseñas no coinciden.",
      };
    },
  },
  methods: {
    async viewUser() {
      const { id } = this.user;
      const { usuario } = await services.admin().getEditUserInfo({ id });
      const { dominios, modulos, roles, permisos, ...data } = usuario;

      for (const k in data) if (!data[k] || k === "nombre_completo") delete data[k];

      let dom = await services.admin().getDomains();
      let mod = await services.admin().getModules();
      let rol = await services.admin().getAllRoles();
      let per = await services.admin().getAllPermissions();

      const convToName = (objs, ids) => objs.filter(o => ids.includes(o.id)).map(o => o.nombre);
      dom = convToName(dom, dominios);
      mod = convToName(mod, modulos);
      rol = convToName(rol, roles);
      per = convToName(per, permisos);

      this.user = { ...data };
      if (dom.length > 0) this.user.dominios = dom;
      if (mod.length > 0) this.user.modulos = mod;
      if (rol.length > 0) this.user.roles = rol;
      if (per.length > 0) this.user.permisos = per;

      this.show.view = true;
    },
    async deleteUser() {
      const { success, message, error } = await services.admin().deleteUser(this.user.id);

      if (success) this.$parent.loadUsersTable();
      this.toast(success, message, error);
      this.show.delete = false;
    },
    async changePass() {
      if (!this.valid) return;

      const { id, clave } = this.user;
      const { success, message, error } = await services.admin().changeUserPass({ id, clave });

      this.toast(success, message, error);
      if (success) this.show.change = false;
    },
    async resetPass() {
      const { id } = this.user;
      const { success, message, error } = await services.admin().resetUserPass({ id });

      this.toast(success, message, error);
      this.show.reset = false;
    },
    toast(success, message, error) {
      if (message) {
        success
          ? this.$store.dispatch('app/showSuccess', message)
          : this.$store.dispatch('app/showError', { message });
      }
      if(error) console.error(error);
    }
  },
  watch: {
    ["show.change"](newValue) {
      if (newValue) return;
      this.$refs.form.reset();
    },
  },
};
</script>
