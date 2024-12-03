<template>
  <div class="wrapper">
    <v-dialog transition="dialog-top-transition" max-width="600" v-model="show.view">
      <v-card>
        <v-card-title class="text-uppercase primary--text text-h6 py-2"> ver perfil </v-card-title>
        <v-divider></v-divider>
        <v-card-text class="py-0 my-0">
          <v-list class="pa-0 ma-0">
            <v-container class="pa-0 ma-0">
              <v-row dense>
                <template v-for="(value, key, index) in profile">
                  <v-col v-if="!chips.includes(key)" class="pa-0 ma-0" cols="6" :key="index">
                    <v-list-item v-if="key !== 'modulos'">
                      <v-list-item-content class="py-2">
                        <v-list-item-title class="text-capitalize text-h7">
                          {{ headers[key] ?? key }}
                        </v-list-item-title>
                        <v-list-item-subtitle class="text-lowercase text-body-1">
                          {{ typeof value === 'boolean' ? '' : value }}
                          <v-icon v-show="value === true" size="medium" color="green"> mdi-check </v-icon>
                          <v-icon v-show="value === false" size="medium" color="red">mdi-close</v-icon>
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
                <template v-for="(value, key, index) in profile">
                  <!-- Verifica que exista la llave en la variable chips y que el arreglo tenga datos-->
                  <v-col v-if="chips.includes(key) && value.length > 0" class="pa-0 ma-0" cols="12" :key="index">
                    <v-list-item>
                      <v-list-item-content class="py-2">
                        <v-list-item-title class="text-capitalize text-h7">
                          {{ headers[key] ?? key }}
                        </v-list-item-title>
                        <v-list-item-subtitle class="text-lowercase text-body-1">
                          <template v-if="key == 'permisos'">
                            <div v-for="(item, i) in permissions" :key="i">
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
          {{ profile.activo ? "desactivar" : "activar" }} perfil
        </v-card-title>
        <v-divider></v-divider>
        <v-card-text class="text-lowercase text-body-1 py-2">
          ¿est&aacute;s seguro de que deseas {{ profile.activo ? "desactivar" : "activar" }} este
          perfil?
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions class="py-2">
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="show.delete = false"> Cerrar </v-btn>
          <v-btn color="primary" text @click="deleteProfile">
            {{ profile.activo ? "Desactivar" : "Activar" }}
          </v-btn>
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
  name: "ActividadesDatatableDialogs",
  data() {
    return {
      chips: ["actividades", "permisos"],
      headers: {
        id: "no. perfil",
        nombre: "Nombre",
        descripcion: "Descripcion",
        fecha_creacion: "fecha creacion",
        fecha_modificacion: "fecha modificación",
      },
      show: {
        view: false,
        delete: false,
        change: false,
      },
      permissions: [],
      profile: {},
      form: {
        valid: false,
      },
    };
  },
  computed: {
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
    async viewProfile() {
      try {
        const { id } = this.profile;
        let [modules, usuarios, permissions, { perfil }] = await Promise.all([
          services.admin().getModules(),
          services.admin().getUsersFromProfile({ id }),
          services.admin().getPermissionsFromProfile({ id }),
          services.admin().getEditProfileInfo({ id }),
        ]);
        console.log('DESDE EL SERVICIO');
        console.log(modules)
        console.log(usuarios)
        console.log(permissions);
        console.log(perfil)
        this.permissions = modules.data.map(({ nombre, id }) => (
          {
            nombre,
            permisos: permissions.filter(p => p.idmodulo === id),
          }
        ));
        console.log('PERMISOS FORMATEADOS');
        console.log(this.permissions);
        // const { modulos, permisos, ...profile } = perfil;
        const { ...profile } = perfil;
        console.log(profile);
        // const convToName = (objs, ids) => objs.filter(o => ids.includes(o.id)).map(o => o.nombre);
        const convToName = (objs, ids) => {
          // Verificar si objs es un array
          console.log('objs')
          console.log(objs)
          console.log(ids)
          // if (!Array.isArray(objs)) {
          //   return [];
          // }
          // Si es un array, aplicar el filtro y mapeo
          return objs.filter(o => ids.includes(o.id)).map(o => o.nombre);
        };
        modules = convToName(modules.data, profile.modulos);
        console.log(modules)
        usuarios = convToName(usuarios, profile.usuarios);
        permissions = convToName(permissions, profile.permisos);
        this.profile = { ...profile };
        if (modules.length > 0) this.profile.modulos = modules;
        if (usuarios.length > 0) this.profile.usuarios = usuarios;
        if (permissions.length > 0) this.profile.permisos = permissions;


        this.show.view = true;
      }
      catch (error) {
        const message = 'Error al cargar la información.';
        this.showError({ message, error });
      }
    },
    async deleteProfile() {
      try {
        const { message } = await services.admin().deleteProfile(this.profile.id);
        this.$parent.loadProfilesTable();
        this.showSuccess(message);
      } catch (error) {
        const message = 'Error al activar/desactivar perfil.';
        this.showError({ message, error });
      }

      this.show.delete = false;
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