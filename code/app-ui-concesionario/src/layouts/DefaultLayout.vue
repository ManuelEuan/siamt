<!-- eslint-disable no-unused-vars -->
<template>
    <div v-shortkey="['ctrl', '/']" class="d-flex flex-grow-1" @shortkey="onKeyup">
        <!-- Navigation -->
        <v-navigation-drawer v-model="drawer" app floating class="elevation-1" :right="$vuetify.rtl" :light="menuTheme === 'light'" :dark="menuTheme === 'dark'" style="z-index: 100000">
            <!-- Navigation menu info -->
            <template v-slot:prepend>
                <div class="pa-2 text-center">
                    <a href="/">
                        <img src="/images/logo-ATY.svg" alt="" id="logo-nav" class="d-inline-block align-text-top text-center" height="40px">
                    </a>
                    <!--          <div class="title font-weight-bold text-uppercase text-center primary&#45;&#45;text">{{ product.name }}</div>-->
                    <div class="overline grey--text text-center">{{ product.version }}</div>
                    <div class="grey--text" ref="userName"></div>
    
                </div>
            </template>
    
            <!-- Navigation menu -->
            <main-menu :menu="navigation" />
    
            <!-- Navigation menu footer -->
            <template v-slot:append>
                <!-- Footer navigation links -->
                <div class="pa-1 text-center">
                    <v-btn v-for="(item, index) in footer" :key="index" :href="item.href" :target="item.target" small text>
                        {{ item.key ? $t(item.key) : item.text }}
                    </v-btn>
                </div>
    
            </template>
        </v-navigation-drawer>
    
        <!-- Toolbar -->
        <v-app-bar app :color="isToolbarDetached ? 'surface' : undefined" :flat="isToolbarDetached" :light="toolbarTheme === 'light'" :dark="toolbarTheme === 'dark'">
            <v-card class="flex-grow-1 d-flex" :class="[isToolbarDetached ? 'pa-1 mt-3 mx-1' : 'pa-0 ma-0']" :flat="!isToolbarDetached">
                <div class="d-flex flex-grow-1 align-center">
    
                    <!-- search input mobile -->
                    <v-text-field v-if="showSearch" append-icon="mdi-close" placeholder="Search" prepend-inner-icon="mdi-magnify" hide-details solo flat autofocus @click:append="showSearch = false"></v-text-field>
    
                    <div v-else class="d-flex flex-grow-1 align-center">
                        <v-app-bar-nav-icon @click.stop="drawer = !drawer"></v-app-bar-nav-icon>
    
                        <v-spacer class="d-none d-lg-block"></v-spacer>
    
                        <!-- search input desktop -->
                        <!-- <v-text-field
                  ref="search"
                  class="mx-1 hidden-xs-only"
                  :placeholder="$t('menu.search')"
                  prepend-inner-icon="mdi-magnify"
                  hide-details
                  filled
                  rounded
                  dense
                ></v-text-field>
    
                <v-spacer class="d-block d-sm-none"></v-spacer>
    
                <v-btn class="d-block d-sm-none" icon @click="showSearch = true">
                  <v-icon>mdi-magnify</v-icon>
                </v-btn> -->
    
                        <!-- <toolbar-language /> -->
    
                        <!-- <div class="hidden-xs-only mx-1">
                  <toolbar-currency />
                </div> -->
    
                        <!-- <toolbar-apps /> -->
    
                        <!-- <div :class="[$vuetify.rtl ? 'ml-1' : 'mr-1']">
                  <toolbar-notifications />
                </div> -->
    
                        <toolbar-user />
                    </div>
                </div>
            </v-card>
        </v-app-bar>
    
        <v-main>
            <v-container class="fill-height" :fluid="!isContentBoxed">
                <v-layout>
                    <slot></slot>
                </v-layout>
            </v-container>
    
        </v-main>
    </div>
    </template>
    
    <script>
    import {
        mapState
    } from 'vuex'
    
    // navigation menu configurations
    import config from '../configs'
    
    import MainMenu from '../components/navigation/MainMenu'
    import ToolbarUser from '../components/toolbar/ToolbarUser'
    import ToolbarApps from '../components/toolbar/ToolbarApps'
    import ToolbarLanguage from '../components/toolbar/ToolbarLanguage'
    import ToolbarCurrency from '../components/toolbar/ToolbarCurrency'
    import ToolbarNotifications from '../components/toolbar/ToolbarNotifications'
    
    import services from '@/services'
    
    export default {
        components: {
            MainMenu,
            ToolbarUser,
            ToolbarApps,
            ToolbarLanguage,
            ToolbarCurrency,
            ToolbarNotifications
        },
        data() {
            return {
                drawer: null,
                showSearch: false,
                userName: '',
                navigation: [],
                footer: []
            }
        },
        computed: {
            ...mapState('app', ['product', 'isContentBoxed', 'menuTheme', 'toolbarTheme', 'isToolbarDetached'])
        },
        methods: {
            onKeyup(e) {
                this.$refs.search.focus()
            },
            transformModulesConfig(nav) {
                console.log("🚀 ~ file: DefaultLayout.vue ~ line 165 ~ transformModulesConfig ~ nav", nav)
                if (Array.isArray(nav)) {
                    nav.forEach((e) => {
                        if (e.code) {
                            let r = this.$router.getRoutes().find(r => r.meta.code == e.code);
                            if(r){

                                e.link = r.path;
                            }
                            this.transformModulesConfig(e.items);
                        } else if (e.items) {
                            this.transformModulesConfig(e.items);
                        }
                    })
                }
            },
            async loadModules() {
                let nav = await services.app().getModulesConfig();
                console.log("🚀 ~ file: DefaultLayout.vue ~ line 178 ~ loadModules ~ nav", nav)
                console.log("🚀 ~ Anexado el nombre", nav)
                this.loadUser();
                this.transformModulesConfig(nav);
                this.navigation = Array.isArray(nav) ? nav : [];
            },
            async loadUser() {
                let user = await services.app().getUserConfig();
                this.$refs.userName.textContent = user[0].usuario;
            }
        },
        created() {
            this.loadModules();
        },
        mounted() {
    
        }
    }
    </script>
    
    <style>
    :root {
        --v-primary-base: #59AF31 !important;
    }
    </style>
    <style scoped>
    .buy-button {
        box-shadow: 1px 1px 18px #ee44aa;
    }
    </style>
    