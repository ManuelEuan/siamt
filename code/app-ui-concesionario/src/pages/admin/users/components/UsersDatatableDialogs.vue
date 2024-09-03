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
                          {{ typeof value === 'boolean' ? '' : value }}
                          <v-icon v-show="value===true" size="medium" color="green"> mdi-check </v-icon>
                          <v-icon v-show="value===false" size="medium" color="red">mdi-close</v-icon>
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
                          <template v-if="key == 'permisos'">
                            <div v-for="(item, i) in user.permisos" :key="i">
                              <v-row v-if="item.permisos.length > 0" class="mx-0">
                                <v-col cols="12" class="px-0 py-1">Módulo de {{ item.nombre }}</v-col>
                                <v-chip class="mr-2 my-1" v-for="(permission, id) in item.permisos" :key="id">
                                  {{ permission.nombre }}
                                </v-chip>
                              </v-row>
                            </div>
                          </template>
                          <template v-else>
                            
                            <v-chip-group column>
                              <v-chip v-for="(element, index) in value" :key="index">
                                {{ element }}
                              </v-chip>
                            </v-chip-group>
                          </template>
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
                  :append-icon="showPass.icon1"
                  :type="showPass.type1"
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
                  :append-icon="showPass.icon2"
                  :type="showPass.type2"
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
import { mapActions } from "vuex";

export default {
  name: "UsersDatatableDialogs",
  data() {
    return {
      chips: ["dominios", "permisos", "roles"],
      headers: {
        id: "no. usuario",
        roles: "perfiles",
        apepat: "apellido paterno",
        apemat: "apellido materno",
        fecha_creacion: "fecha creacion",
        fecha_modificacion: "fecha modificación",
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
    showPass() {
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
    }
  },
  methods: {
    ...mapActions('app', ['showError', 'showSuccess']),
    async viewUser() {
      try {
        const { id } = this.user;
        let [domains, roles, permissions, { usuario }] = await Promise.all([
          services.admin().getDomains(),
          services.admin().getRoles(),
          services.admin().getPermissionsFromUser({ id }),
          // services.admin().getPermissions(),
          services.admin().getEditUserInfo({ id }),
        ]);
        const { dominios, perfiles, ...user } = usuario;
        for (const key in user) if (!user[key] || key === 'admin') delete user[key];
        const convToName = (objs, ids) => objs.filter(o => ids.includes(o.id)).map(o => o.nombre);
        domains = convToName(domains, dominios);
        roles = convToName(roles, perfiles);
        this.user = { ...user };
        if (domains.length > 0) this.user.dominios = domains;
        if (roles.length > 0) this.user.roles = roles;
        // if (permissions.length > 0) this.user.permisos = permissions;
        this.user.permisos = permissions;
        
        this.show.view = true;
      }
      catch(error) {
        const message = 'Error al cargar la información.';
        this.showError({ message, error });
      }
    },
    async deleteUser() {
      try {
        const { message } = await services.admin().deleteUser(this.user.id);
        this.$parent.loadUsersTable();
        this.showSuccess(message);
      } catch (error) {
        const message = 'Error al activar/desactivar usuario.';
        this.showError({ message, error });
      }

      this.show.delete = false;
    },
    async changePass() {
      if (!this.valid) return;

      try {
        const { id, clave } = this.user;
        const { message } = await services.admin().changeUserPass({ id, clave });
        this.showSuccess(message);
      } catch (error) {
        const message = 'Error al modificar contraseña de usuario.';
        this.showError({ message, error });
      }

      this.show.change = false;
    },
    async resetPass() {
      try {
        const { id } = this.user;
        const { message } = await services.admin().resetUserPass({ id });
        this.showSuccess(message);
      } catch (error) {
        const message = 'Error al restablecer contraseña de usuario.';
        this.showError({ message, error });
      }

      this.show.reset = false;
    },
  },
  watch: {
    ["show.change"](newValue) {
      if (newValue) return;
      this.$refs.form.reset();
    },
  },
};
</script>
