<template>
  <v-container fluid>
    <v-row justify="center">
      <v-col cols="12" class="pa-0">
        <v-card flat>
          <v-toolbar>
            <v-toolbar-title>{{ createMode ? "Nuevo" : "Editar" }} Usuario</v-toolbar-title>
          </v-toolbar>
        </v-card>
      </v-col>
      <v-col cols="12" class="pa-0 mt-2">
        <v-tabs v-model="tab" centered icons-and-text>
          <v-tabs-slider color="primary" />
          <v-tab href="#generaltab">
            Datos Generales
            <v-icon> mdi-clipboard-text </v-icon>
          </v-tab>
          <v-tab href="#rolestab">
            Perfiles
            <v-icon> mdi-card-account-details </v-icon>
          </v-tab>
          <!-- <v-tab href="#permissionstab">
            Permisos
            <v-icon> mdi-list-status </v-icon>
          </v-tab> -->
        </v-tabs>
        <v-tabs-items v-model="tab">
          <v-card flat>
            <v-tab-item :key="1" value="generaltab" class="py-1">
              <v-card-text>
                <v-form v-model="valid">
                  <v-row>
                    <v-col cols="4">
                      <v-text-field
                        v-model="user.nombre"
                        label="Nombre*"
                        :rules="[rules.required]"
                        hide-details="auto"
                        clearable
                        dense
                        outlined
                      />
                    </v-col>
                    <v-col cols="4">
                      <v-text-field
                        v-model="user.apepat"
                        label="Apellido Paterno*"
                        :rules="[rules.required]"
                        hide-details="auto"
                        clearable
                        dense
                        outlined
                      />
                    </v-col>
                    <v-col cols="4">
                      <v-text-field
                        v-model="user.apemat"
                        label="Apellido Materno"
                        :hint="hints.optional"
                        hide-details="auto"
                        clearable
                        dense
                        outlined
                      />
                    </v-col>
                    <v-col cols="5">
                      <v-text-field
                        v-model="user.usuario"
                        label="Usuario*"
                        :hint="hints.user"
                        :rules="[rules.required, rules.user, rules.min5char]"
                        hide-details="auto"
                        clearable
                        dense
                        outlined
                      />
                    </v-col>
                    <v-col cols="7">
                      <v-text-field
                        v-model="user.correo"
                        label="Correo Electrónico"
                        :hint="hints.optional"
                        :rules="!!user.correo ? [rules.email] : []"
                        hide-details="auto"
                        clearable
                        dense
                        outlined
                      />
                    </v-col>
                    <v-col cols="8">
                      <v-select
                        v-model="user.dominios"
                        label="Dominios*"
                        :rules="[rules.domain]"
                        :items="domains"
                        item-text="nombre"
                        item-value="id"
                        hide-details="auto"
                        small-chips
                        clearable
                        dense
                        multiple
                        outlined
                      />
                    </v-col>
                  </v-row>
                </v-form>
              </v-card-text>
            </v-tab-item>
            <v-tab-item :key="2" value="rolestab">
              <!-- <v-container>
                <v-checkbox
                  v-for="(role, id) in roles"
                  v-model="user.perfiles"
                  :key="id"
                  :value="role.id"
                  @click="click.role = true"
                >
                  <template v-slot:label>
                    <v-tooltip right>
                      <template v-slot:activator="{ on }">
                        <span v-on="on">{{ role.nombre }}</span>
                      </template>
                      {{ role.descripcion }}
                    </v-tooltip>
                  </template>
                </v-checkbox>
              </v-container> -->
              <v-container>
                <v-checkbox
                  v-for="(role, id) in roles"
                  :key="id"
                  v-model="user.perfiles"
                  :value="role.id"
                  :input-value="user.perfiles.includes(role.id)"
                  @click="click.role = true"
                  >
                  <!-- @click="toggleCheckbox(role.id)" -->
                  <template v-slot:label>
                    <v-tooltip right>
                      <template v-slot:activator="{ on }">
                        <span v-on="on">{{ role.nombre }}</span>
                      </template>
                      {{ role.descripcion }}
                    </v-tooltip>
                  </template>
                </v-checkbox>
              </v-container>
            </v-tab-item>
            <!-- <v-tab-item :key="3" value="permissionstab">
              <v-expansion-panels>
                <v-expansion-panel v-for="(item, i) in permissions" :key="i">
                  <v-expansion-panel-header>
                    {{ item.nombre }}
                  </v-expansion-panel-header>
                  <v-expansion-panel-content>
                    <v-checkbox
                      v-for="(permission, id) in item.permisos"
                      v-model="user.permisos"
                      :key="id"
                      :value="permission.id"
                      @click="click.permission = true"
                    >
                      <template v-slot:label>
                        <v-tooltip right>
                          <template v-slot:activator="{ on }">
                            <span v-on="on">{{ permission.nombre }}</span>
                          </template>
                          {{ permission.descripcion }}
                        </v-tooltip>
                      </template>
                    </v-checkbox>
                  </v-expansion-panel-content>
                </v-expansion-panel>
              </v-expansion-panels>
            </v-tab-item> -->
            <v-card-actions>
              <v-spacer />
              <v-btn color="error" text @click="exitWindow()"> Cerrar </v-btn>
              <v-btn color="primary" text :disabled="!valid" @click="saveUser()"> Guardar </v-btn>
            </v-card-actions>
          </v-card>
        </v-tabs-items>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import rules from "@/core/rules.forms";
import services from "@/services";
import { mapActions } from "vuex";

export default {
  components: {},
  data() {
    return {
      click: {
        role: false,
        permission: false,
      },
      valid: false,
      tab: "generaltab",
      permissions: [],
      roles: [],
      modules: [],
      domains: [],
      user: {
        id: 0,
        usuario: "",
        nombre: "",
        apepat: "",
        apemat: "",
        correo: "",
        admin: false,
        dominios: [],
        modulos: [],
        perfiles: [],
        permisos: [],
      },
      hints: {
        user: "Solo . _ - números y letras sin acentos ni espacios.",
        optional: "Opcional.",
      },
      rules: {
        ...rules,
        domain: v => v.length > 0 || "Requerido.",
      },
    };
  },
  computed: {
    createMode() {
      return !this.$route.params.id;
    },
  },
  methods: {
    ...mapActions('app', ['showError', 'showSuccess']),
    async loadSelectableData() {
      try {
        const [domains, modules, roles, permissions] = await Promise.all([
          services.admin().getDomains(),
          services.admin().getModules(),
          services.admin().getRoles(),
          services.admin().getPermissions()
        ]);
  
        this.domains = domains.map(({ id, nombre }) => ({ id, nombre }));
        this.modules = modules;
        this.roles = roles;
        this.permissions = this.modules.map(({ nombre, id }) => ({
          nombre,
          permisos: permissions.filter(p => p.idmodulo === id),
        }));
      } catch (error) {
        const message = 'Error al cargar opciones para nuevo usuario.';
        this.showError({ message, error });
      }
    },
    async setEditMode() {
      try {
        const { id } = this.$route.params;
        const { usuario } = await services.admin().getEditUserInfo({ id });
        const { clave, admin, activo, fecha_creacion, fecha_modificacion, ...user } = usuario;
        this.user = user;
      } catch (error) {
        const message = 'Error al cargar información de usuario.';
        this.showError({ message, error });
      }
    },
    setUserModules() {
      const m = this.permissions
        .flatMap(p => p.permisos)
        .filter(p => this.user.permisos.includes(p.id))
        .map(p => p.idmodulo);

      this.user.modulos = [...new Set(m)];
      this.user.admin = this.user.perfiles.includes(1);
    },
    async saveUser() {
      if (!this.valid) return;

      this.setUserModules();

      try {
        const { message } = await (
          this.createMode
            ? services.admin().createUser(this.user)
            : services.admin().updateUser(this.user)
        );

        this.showSuccess(message);
        this.exitWindow();
      } catch (error) {
        const message = 'Error al guardar usuario.';
        this.showError({ message, error });
      }
    },
    exitWindow() {
      this.$router.push("/users");
    },
  },
  watch: {
    ['user.permisos'](newPermissions, oldPermissions) {
      if (this.click.permission === false) return;
      if (newPermissions.length === oldPermissions.length) return;

      this.user.perfiles = this.roles
        .filter(r => r.idpermiso.every(id => newPermissions.includes(id)))
        .map(r => r.id);

      this.click.permission = false;
    },
    ['user.perfiles'](newRoles, oldRoles) {
      // if (this.click.role === false) return;
      // if (oldRoles.length === newRoles.length) return;

      // if (newRoles.length < oldRoles.length) {
      //   const previousRoles = [...oldRoles];
      //   const roleId = previousRoles.pop();
      //   const role = this.roles.find(r => r.id === roleId);
      //   this.user.permisos = this.user.permisos.filter(p => !role.idpermiso.includes(p));
      // } else {
      //   const actualRoles = [...newRoles];
      //   const roleId = actualRoles.pop();
      //   const role = this.roles.find(r => r.id === roleId);
      //   this.user.permisos.push(...role.idpermiso);
      //   this.user.permisos = [...new Set(this.user.permisos)];
      // }

      this.user.permisos.filter(p => p !== 0);
      this.click.role = false;
    }
  },
  async mounted() {
    await this.loadSelectableData();
    if (!this.createMode) await this.setEditMode();
  },
};
</script>
