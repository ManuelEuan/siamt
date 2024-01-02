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
          <v-tab href="#profilestab">
            Perfiles
            <v-icon> mdi-card-account-details </v-icon>
          </v-tab>
          <v-tab href="#permissionstab">
            Permisos
            <v-icon> mdi-list-status </v-icon>
          </v-tab>
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
                        label="Dominio*"
                        :rules="[rules.domain]"
                        :items="domains"
                        item-text="nombre"
                        item-value="id"
                        hide-details="auto"
                        chips
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
            <v-tab-item :key="2" value="profilestab">
              <v-container>
                <v-checkbox
                  v-for="(role, id) in roles"
                  :key="id"
                  :value="role.id"
                  v-model="user.roles"
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
              </v-container>
            </v-tab-item>
            <v-tab-item :key="3" value="permissionstab">
              <v-expansion-panels>
                <v-expansion-panel v-for="(item, i) in permissions" :key="i">
                  <v-expansion-panel-header>
                    {{ item.nombre }}
                  </v-expansion-panel-header>
                  <v-expansion-panel-content>
                    <v-checkbox
                      v-for="(permission, id) in item.permisos"
                      :key="id"
                      v-model="user.permisos"
                      :value="permission.id"
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
            </v-tab-item>
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

export default {
  components: {},
  data() {
    return {
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
        activo: true,
        dominios: [],
        modulos: [],
        roles: [],
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
    async loadSelectableData() {
      this.roles = await services.admin().getAllRoles();
      this.modules = await services.admin().getModules();

      let res = await services.admin().getDomains();
      this.domains = res.map(({ id, nombre }) => ({ id, nombre }));

      res = await services.admin().getAllPermissions();
      this.permissions = this.modules.map(({ nombre, id }) => ({
        nombre,
        permisos: res.filter(p => p.idmodulo === id),
      }));
    },
    async setEditMode() {
      const { id } = this.$route.params;
      const { usuario } = await services.admin().getEditUserInfo({ id });
      const { fecha_creacion, fecha_modificacion, clave, ...user } = usuario;
      this.user = user;
    },
    setUserModules() {
      const m = this.permissions
        .flatMap(p => p.permisos)
        .filter(p => this.user.permisos.includes(p.id))
        .map(p => p.idmodulo);

      this.user.modulos = [...new Set(m)];
      this.user.admin = this.user.roles.includes(1);
    },
    async saveUser() {
      if (!this.valid) return;

      this.setUserModules();

      const { success, message, error } = await (this.createMode
        ? services.admin().createUser(this.user)
        : services.admin().updateUser(this.user));

      const msg = error === "El usuario ya se encuentra en uso." ? error : message;
      if (msg) {
        success
          ? this.$store.dispatch('app/showSuccess', msg)
          : this.$store.dispatch('app/showError', { msg });
      }

      if(error) console.error(error);
      if (success) this.exitWindow();
    },
    exitWindow() {
      this.$router.push("/users");
    },
  },
  async mounted() {
    await this.loadSelectableData();
    if (!this.createMode) await this.setEditMode();
  },
};
</script>
