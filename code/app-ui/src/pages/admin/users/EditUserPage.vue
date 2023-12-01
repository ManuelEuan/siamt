<template>
  <v-container fluid>
    <v-row justify="center">
      <v-col cols="12" class="pa-0">
        <v-card flat>
          <v-toolbar>
            <v-toolbar-title
              >{{
                isCreatingUser ? "Nuevo" : "Editar"
              }}
              Usuario</v-toolbar-title
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
                      :rules="[rules.required]"
                      outlined
                      clearable
                      dense
                      hide-details="auto"
                      required
                    />
                  </v-col>
                  <v-col cols="4">
                    <v-text-field
                      v-model="user.apepat"
                      label="Apellido Paterno*"
                      :rules="[rules.required]"
                      outlined
                      clearable
                      dense
                      hide-details="auto"
                      required
                    />
                  </v-col>
                  <v-col cols="4">
                    <v-text-field
                      v-model="user.apemat"
                      label="Apellido Materno"
                      :hint="hint.optional"
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
                      :hint="hint.uUser"
                      :rules="[rules.required, rules.user, rule.uUser]"
                      outlined
                      clearable
                      dense
                      hide-details="auto"
                      required
                    />
                  </v-col>
                  <v-col cols="4">
                    <v-text-field
                      v-model="user.clave"
                      :append-icon="showPass ? 'mdi-eye' : 'mdi-eye-off'"
                      label="Contraseña*"
                      :rules="[rules.required]"
                      :type="showPass ? 'text' : 'password'"
                      :hint="hint.uPass"
                      outlined
                      clearable
                      dense
                      hide-details="auto"
                      required
                      @click:append="showPass = !showPass"
                    />
                  </v-col>
                  <v-col cols="4">
                    <v-text-field
                      v-model="clave"
                      label="Confirmar Contraseña*"
                      :rules="[rules.required, rule.pass]"
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
                      :hint="hint.optional"
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
                  v-model="user.roles"
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
              <v-spacer></v-spacer>
              <v-btn color="error" text @click="exitWindow()"> Cerrar </v-btn>
              <v-btn
                color="primary"
                text
                :disabled="!isValid"
                @click="isCreatingUser ? createUser() : updateUser()"
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
import rules from "@/core/rules.forms";
import services from "@/services";

export default {
  components: {},
  computed: {
    isCreatingUser() {
      return !this.$route.params.id;
    },
    isSamePassword() {
      return this.user.clave === this.clave;
    },
    isValid() {
      if (!this.isCreatingUser && this.user.clave === "")
        return !!this.user.nombre && !!this.user.apepat && !!this.user.usuario;

      return (
        !!this.user.nombre &&
        !!this.user.apepat &&
        !!this.user.usuario &&
        !!this.user.clave &&
        this.isSamePassword
      );
    },
    rule() {
      return {
        pass: this.isSamePassword || "Las contraseñas no coinciden.",
        uUser: this.created || "El nombre de usuario ya se encuentra en uso.",
      };
    },
    hint() {
      return {
        uUser: "Se permiten: . _ - números y letras sin acentos ni espacios.",
        uPass: this.isCreatingUser
          ? ""
          : "Si se deja en blanco la contraseña actual no se verá afectada.",
        optional: "Este campo es opcional.",
      };
    },
  },
  data() {
    return {
      principalTabs: 0,
      showPass: false,
      showPass2: false,
      permissions: [],
      roles: [],
      modules: [],
      rules: rules,
      clave: "",
      created: true,
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
      this.modules = await services.admin().getModules();
    },
    async getPermissions() {
      const res = await services.admin().getAllPermissions();
      this.modules.forEach((mod) => {
        const m = {
          nombre: mod.nombre,
          permisos: res.filter((p) => p.idmodulo === mod.id),
        };
        this.permissions.push(m);
      });
    },
    async isEditMode() {
      let params = { id: this.$route.params.id };
      const res = await services.admin().getEditUserInfo(params);
      this.user = res.usuario;
      this.user.clave = "";
    },
    setUserModules() {
      const um = this.permissions
        .flatMap((p) => p.permisos)
        .filter((p) => this.user.permisos.includes(p.id))
        .map((p) => p.idmodulo);

      this.user.modulos = [...new Set(um)];
      this.user.admin = this.user.roles.includes(1);
    },
    async updateUser() {
      console.log("=>(EditUserPage.vue) updateUser()");
    },
    async createUser() {
      if (!this.isValid) return;
      this.setUserModules();

      const res = await services.admin().createUser(this.user);
      this.created = res.created;
      if (this.created) this.exitWindow();
    },
    exitWindow() {
      this.$router.push("/users");
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
  watch: {
    ["user.usuario"]() {
      this.created = true;
    },
  },
};
</script>
