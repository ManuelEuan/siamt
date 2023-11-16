import ApiService from "@/services/api.service";

export default class AdminService extends ApiService {
  static DOMAIN_CONFIG_KEY = "dmn-config";
  static USER_CONFIG_KEY = "usr-config";
  static MODULES_CONFIG_KEY = "mod-config";

  constructor(basePath) {
    super(basePath);
    console.log("AdminService Created");
  }

  async getModulesConfig() {
    let config = this.getLoadedModulesConfig();

    if (config == null) {
      config = await this.loadModulesConfig();
    }

    return config;
  }

  async fetchUsers() {
    return await this.get("/users");
  }

  async getUsers(data) {
    return await this.post("/users", JSON.stringify(data));
  }

  async getModules(params = {}) {
    return await this.get("/modules", params);
  }

  /* eslint-disable no-unused-vars */
  async updateModule(id, data) {
    return await this.post(`/modules/${id}`, data);
  }

  async saveModule(data) {
    return await this.post("/modules", data);
  }

  async getModule(id) {
    return await this.get(`/modules/${id}`);
  }

  async activateModule(id) {
    return await this.post(`/modules/${id}/activate`);
  }

  async deactivateModule(id) {
    return await this.post(`/modules/${id}/deactivate`);
  }

  async deleteModule(id) {
    return await this.delete(`/modules/${id}`);
  }

  async batchModules(data) {
    return await this.post("/modules/batch", data);
  }

  //Para los permisos y los perfiles
  async getAllUsers() {
    return await this.post("/users/");
  }
  async getAllPermissions() {
    return await this.get("/permissions");
  }

  //Para los roles (grupos)
  async getAllRoles() {
    return await this.get("/groups");
  }

  //Para usuarios alta y edición
  async getEditUserInfo(data) {
    return await this.post("/users/getedituserinfo", JSON.stringify(data));
  }

  async deleteUser(id) {
    return await this.delete(`/users/${id}`);
  }
}
