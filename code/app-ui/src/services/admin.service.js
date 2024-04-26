import ApiService from "@/services/api.service";

export default class AdminService extends ApiService {
  static DOMAIN_CONFIG_KEY = "dmn-config";
  static USER_CONFIG_KEY = "usr-config";
  static MODULES_CONFIG_KEY = "mod-config";

  constructor(basePath) {
    super(basePath);
    console.log("AdminService Created");
  }

  //Módulos

  async getModulesConfig() {
    let config = this.getLoadedModulesConfig();

    if (config == null) {
      config = await this.loadModulesConfig();
    }

    return config;
  }

  async getModules(params = {}) {
    return await this.get("/modules", params);
  }

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

  //Permisos

  async getPermissions() {
    return await this.get("/permissions");
  }

  //Perfiles

  async getRoles() {
    return await this.get("/roles");
  }

  //Dominios

  async getDomains() {
    return await this.get("/domains");
  }

  //Usuarios

  async getUsers(data) {
    return await this.post("/users", JSON.stringify(data));
  }

  async createUser(data) {
    return await this.post("/users/new", JSON.stringify(data));
  }

  async deleteUser(id) {
    return await this.delete(`/users/${id}`);
  }

  async updateUser(data) {
    return await this.put("/users", JSON.stringify(data));
  }

  async getPermissionsFromUser(id) {
    return await this.post(`/users/${id}/permissions`, JSON.stringify(id));
  }

  async resetUserPass(data) {
    return await this.put("/users/reset", JSON.stringify(data));
  }

  async changeUserPass(data) {
    return await this.put("/users/change", JSON.stringify(data));
  }

  async getEditUserInfo(data) {
    return await this.post("/users/getedituserinfo", JSON.stringify(data));
  }

  async getActivePermissionsFromUser(id) {
    return await this.post("/users/getActivePermissionsFromUser", JSON.stringify(id));
  }

  getPermissionsFromUser

    //Perfiles

    async getProfiles(data) {
      return await this.post("/profiles", JSON.stringify(data));
    }

    async getEditProfileInfo(data) {
      return await this.post("/profiles/geteditprofileinfo", JSON.stringify(data));
    }

    async getUsersFromProfile(id) {
      return await this.post(`/profiles/${id}/users`, JSON.stringify(id));
    }

    async getPermissionsFromProfile(id) {
      return await this.post(`/profiles/${id}/permissions`, JSON.stringify(id));
    }

    async getModulesFromProfile(id) {
      return await this.post(`/profiles/${id}/modules`, JSON.stringify(id));
    }

    
    async createProfile(data) {
      return await this.post("/profiles/new", JSON.stringify(data));
    }

    async deleteProfile(id) {
      return await this.delete(`/profiles/${id}`);
    }

    async updateProfile(data) {
      return await this.put("/profiles", JSON.stringify(data));
    }

    async getServiceVindenUrlDebitaciones() {
      return await this.get("/debits/getServiceVindenUrlDebitaciones");
    }
    
}
