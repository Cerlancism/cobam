"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vue_1 = require("vue");
const App_vue_1 = require("./App.vue");
const router_1 = require("./router");
const vuetify_1 = require("./plugins/vuetify");
vue_1.default.config.productionTip = false;
new vue_1.default({
    router: router_1.default,
    vuetify: vuetify_1.default,
    render: h => h(App_vue_1.default)
}).$mount('#app');
//# sourceMappingURL=main.js.map