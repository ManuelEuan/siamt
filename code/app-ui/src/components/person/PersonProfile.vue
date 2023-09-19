<template>

    <Widget title="Perfil" :loading.sync="loading" :collapsable="collapsable" :expandable="expandable">
      <v-row >
        <v-col cols="12" md="4" class="text-center">
          <img class="img-thumbnail" :src="image">
        </v-col>
        <v-col cols="12" md="4">
          <v-list dense>
            <v-list-item-group>
              <v-list-item>
                <v-list-item-content>
                  <v-list-item-title class="text-uppercase">Nombre</v-list-item-title>
                  <v-list-item-subtitle v-text="data.vnombrecompleto"></v-list-item-subtitle>
                </v-list-item-content>
              </v-list-item>
              <v-list-item>
                <v-list-item-content>
                  <v-list-item-title class="text-uppercase">Genero</v-list-item-title>
                  <v-list-item-subtitle v-text="data.genero"></v-list-item-subtitle>
                </v-list-item-content>
              </v-list-item>
              <v-list-item>
                <v-list-item-content>
                  <v-list-item-title class="text-uppercase">Estado Civil</v-list-item-title>
                  <v-list-item-subtitle v-text="data.estado_civil"></v-list-item-subtitle>
                </v-list-item-content>
              </v-list-item>
              <v-list-item>
                <v-list-item-content>
                  <v-list-item-title class="text-uppercase">Nacimiento</v-list-item-title>
                  <v-list-item-subtitle v-text="data.dtfechanacimiento"></v-list-item-subtitle>
                </v-list-item-content>
              </v-list-item>
            </v-list-item-group>
          </v-list>
        </v-col>

        <v-col cols="12" md="4" class="">
          <v-list dense>
          <v-list-item-group>
            <v-list-item>
              <v-list-item-content>
                <v-list-item-title class="text-uppercase">CURP</v-list-item-title>
                <v-list-item-subtitle v-text="data.vcurp"></v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
            <v-list-item>
              <v-list-item-content>
                <v-list-item-title class="text-uppercase">INE</v-list-item-title>
                <v-list-item-subtitle v-text="data.vine"></v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
            <v-list-item>
              <v-list-item-content>
                <v-list-item-title class="text-uppercase">RFC</v-list-item-title>
                <v-list-item-subtitle v-text="data.vrfc"></v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
          </v-list-item-group>
        </v-list>
        </v-col>
      </v-row>
    </Widget>

  
</template>

<script>
import Widget from '@/components/common/Widget'
import services from '@/services';

export default {
  components: {
    Widget
  },
  props: {
    id: { type: Number, default: 0, required: true },
    collapsable: { type: Boolean, default: false, required: false },
    expandable: { type: Boolean, default: false, required: false },
  },
  data() {
    return {
      loading: false,
      data: {},
      image: null,
      defaultImage: "data:image/jpg;base64, /9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAgICAgICAkKCgkMDQwNDBIQDw8QEhsTFRMVExspGR4ZGR4ZKSQsJCEkLCRBMy0tM0FLPzw/S1tRUVtybHKVlckBCAgICAgICQoKCQwNDA0MEhAPDxASGxMVExUTGykZHhkZHhkpJCwkISQsJEEzLS0zQUs/PD9LW1FRW3JscpWVyf/CABEIAMgAyAMBIgACEQEDEQH/xAAbAAEBAQADAQEAAAAAAAAAAAAAAQIEBQYDB//aAAgBAQAAAAD9oAAASST6gAASSSfYAAEkTM+4Azxfn9OVpGUzJyAE6rq8mu07VJJMzkgOh4IHN7xJMs8oDrOmAk7jspJMzlgeY+QJH09KzMycwHx8yCJHpPpJmZ5wON5wIkT0P3kzM88Hz8uEiR6XUzM57EDznGJEjkd/JnMnYgcPz6JInfcrOZmZ7MB1nTZRHb9hmZzM57UBOL1PDzeV2fImczMxO2AnD4fL5GXF4XK5MzmZmO4Bx+j4qNfOTPI7f7ZzMZ7oON575pEkkjvPvnOc92M+Z+UiSSSZn075Mzux1fTSJJJJmSdpz8yd4PN8WJEzJJMz7d5JO9M+UyiSZjMmZPRI71Pn5aJJJJmTMmfRak76T5+WSSSSZkmZPQ6k75nHlpJJJMySZk9FT//EABUBAQEAAAAAAAAAAAAAAAAAAAAB/9oACAECEAAAAKAAAACiAFCAUEAUIAogAABQQFAQKAgUBAoBH//EABUBAQEAAAAAAAAAAAAAAAAAAAAB/9oACAEDEAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAB//xAA0EAABAgMGAQoGAwEAAAAAAAABAgMABBESICEwMVEQBRMyM0BBUmFxchUiQmKBkTSSoWD/2gAIAQEAAT8A/wCVUtKBVSgB5wqelk/XX0EfEmNl/qEz0sr66eohKkrFUqBHl2MkAEk0ETHKOqWf7GFrWs1Uok+dxC1oNUqIPlEvyjol7+wgEEAg1HYCQBUxNzZeUUpNED/ciUmyyoIUaoP+RUEVGfyi/ZSGknE4q9Mrk9+0ktK1GI9L9ch5wuurXucplwtOoXsc6YVZYdP2nMl1WmGj9oumK35v+M77cyV/jNe3ieBgm+6m20tO6SMxpJQ0hOyQLhMHJm2uafUO44jKlGudfSO4YngTwMHKnJfn28OknEZUoxzDeI+ZWtw8Tkzklbq42Pm7xvBBBoReoSQBEpJ2KOOD5u4bcTFYJzX5Rp/EiivEIdkH29BbHlCkqTgpJHrwSlSjRKSfSG5F9eosDzhiVaYxAqrc3TBgxWDkuzzDeFbR+2PiZtdWLPrjDc7LufXZOysIBSsYEERzaPAn9QSlAxIAhydYb+up2GMHlM2urFn1xhudYcwrZPnwNyuS/Mty6aqNSdBD806+cTRPhFypGhjnHPGr9wSTqbjM06xoap8JhmYQ+nDXvF2sG9NTKZdFdVHQQtanFFSjUnMQtTagpJoREvMJfRsoaiCYOQtQQlSjoBUw+8p9wrP4GwzmnVMrCh+RCVBaQpOhEHI5SeolLQ78TmG5IO1Sps92IyZtwuTDh2NB+OwSy7D6DuaH85BNATsIJJJJzzAJBBEA1AO4vudWv2nsSOgj2i+71a/aexI6CfaL7nVr9p7E30Ee0XP/xAAUEQEAAAAAAAAAAAAAAAAAAABw/9oACAECAQE/ACn/xAAUEQEAAAAAAAAAAAAAAAAAAABw/9oACAEDAQE/ACn/2Q==",
    }
  },
  computed: {
    imagen2: function(){
      return "data:image/jpg;base64, " + (this.data? this.data.imagen : this.defaultImage);
    },
  },
  watch: {

  },
  beforeDestroy() {

  },
  methods: {
    async loadData(id) {
      this.loading = true;
      let data = await services.person().getSingle(id);
      this.data = data;
      
      this.loadImage(data.iid_dim_persona);
    },
    async loadImage(id) {
      try{
        let data = await services.dwh().getPersonImage(id);
        this.image = 'data:image/jpg;base64, '+data.foto;
      }catch(e){
        console.log("No image");
      }
      
      this.loading = false;
    },
  },
  async created() {
    this.image = this.defaultImage;
    this.loadData(this.id);
    
    // this.loading = true;
    // 
    // setTimeout(() => { this.loading = false }, 3000);
  }
}
</script>

<style scoped>
.img-thumbnail
{
    padding: .25rem;
    background-color: #f9fbfd;
    border: 1px solid #d7dfe6;
    border-radius: .5rem;
    -webkit-box-shadow: 0 1px 2px rgb(0 0 0 / 8%);
    box-shadow: 0 1px 2px rgba(0,0,0,.075);
    max-width: 100%;
    height: auto;
}

</style>
