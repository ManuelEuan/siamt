<template>
  <v-container fluid>
    <v-row justify="center">
      <v-col cols="12" class="pa-0">
        <v-card flat>
          <v-toolbar>
            <v-toolbar-title
              >{{ isCreatingUser ? "Nuevo" : "Editar" }} Usuario</v-toolbar-title
            >
          </v-toolbar>
        </v-card>
      </v-col>
      <v-col cols="12" class="pa-0 mt-2">
        <!-- Inician los tabs de tipos de info-->
        <v-tabs v-model="principalTabs" centered icons-and-text>
          <v-tabs-slider color="primary"> </v-tabs-slider>
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
        <v-tabs-items v-model="principalTabs">
          <v-card flat>
            <v-tab-item :key="1" value="generaltab" class="py-1">
              <v-card-text>
                <v-row>
                  <v-col cols="4">
                    <v-text-field
                      v-model="user.nombre"
                      label="Nombre*"
                      outlined
                      clearable
                      dense
                      hide-details="auto"
                    />
                  </v-col>
                  <v-col cols="4">
                    <v-text-field
                      v-model="user.apepat"
                      label="Apellido Paterno*"
                      outlined
                      clearable
                      dense
                      hide-details="auto"
                    />
                  </v-col>
                  <v-col cols="4">
                    <v-text-field
                      v-model="user.apemat"
                      label="Apellido Materno"
                      outlined
                      clearable
                      dense
                      hide-details="auto"
                    />
                  </v-col>
                  <v-col cols="4">
                    <v-text-field
                      v-model="user.usuario"
                      label="Usuario*"
                      outlined
                      clearable
                      dense
                      hide-details="auto"
                    />
                  </v-col>
                  <v-col cols="4">
                    <v-text-field
                      v-model="user.clave"
                      :append-icon="showPass ? 'mdi-eye' : 'mdi-eye-off'"
                      label="Contraseña*"
                      :type="showPass ? 'text' : 'password'"
                      :hint="
                        isCreatingUser
                          ? ''
                          : 'Si se deja en blanco la contraseña actual no se afectará'
                      "
                      outlined
                      clearable
                      dense
                      hide-details="auto"
                      @click:append="showPass = !showPass"
                    />
                  </v-col>
                  <v-col cols="4">
                    <v-text-field
                      label="Confirmar Contraseña"
                      :append-icon="showPass2 ? 'mdi-eye' : 'mdi-eye-off'"
                      :type="showPass2 ? 'text' : 'password'"
                      outlined
                      clearable
                      dense
                      hide-details="auto"
                      @click:append="showPass2 = !showPass2"
                    />
                  </v-col>
                  <v-col cols="6">
                    <v-text-field
                      v-model="user.correo"
                      label="Correo Electrónico"
                      outlined
                      clearable
                      dense
                      hide-details="auto"
                    />
                  </v-col>
                </v-row>
              </v-card-text>
            </v-tab-item>
            <v-tab-item :key="2" value="profilestab">
              <v-container>
                <v-checkbox
                  v-for="(role, id) in roles"
                  :key="id"
                  v-model="selectedRoles"
                  :value="role.id"
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
                      v-model="selectedPermissions"
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
              <v-btn
                color="primary"
                text
                :disabled="invalid"
                @click="isCreatingUser ? saveUser() : updateUser()"
              >
                Guardar
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-tabs-items>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import services from "@/services";

export default {
  components: {},
  computed: {
    isCreatingUser() {
      return !this.$route.params.id;
    },
  },
  async mounted() {
    await this.getModules();
    await this.getPermissions();
    await this.getRoles();
    if (!this.isCreatingUser) {
      await this.isEditMode();
    }
  },
  data() {
    return {
      invalid: true,
      principalTabs: 0,
      showPass: false,
      showPass2: false,
      permissions: [],
      selectedPermissions: [],
      selectedRoles: [],
      roles: [],
      modules: [],
      user: {
        id: 0,
        usuario: "",
        clave: "",
        nombre: "",
        apepat: "",
        apemat: "",
        correo: "",
        admin: false,
        activo: true,
        modulos: [],
        roles: [],
        permisos: [],
      },
    };
  },
  methods: {
    async getRoles() {
      this.roles = await services.admin().getAllRoles();
    },
    async getModules() {
      const res = await services.admin().getModules();
      this.modules = res.data;
    },
    async getPermissions() {
      const resp = await services.admin().getAllPermissions();
      this.modules.forEach((module) => {
        let modulo = {
          nombre: module.nombre,
          permisos: resp.filter((p) => p.idmodulo === module.id),
        };
        this.permissions.push(modulo);
      });
    },
    async isEditMode() {
      let params = {
        id: this.$route.params.id,
      };
      const res = await services.admin().getEditUserInfo(params);
      console.log("=>(EditUserPage.vue:251) res", res);
      this.user = res.usuario;
      // this.selectedRoles = resw.perfiles;
      // this.user.roles.forEach((role) => this.selectedRoles.push(role.id));
      // console.log("(EditUserPage.vue:255) selectedRoles", this.selectedRoles);
      // this.selectedPermissions = res.permisos;
      this.user.clave = "";
    },
    updateUser() {},
    saveUser() {},
    exitWindow() {
      this.$router.push("/users");
    },
  },
};
</script>
