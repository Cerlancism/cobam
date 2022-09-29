"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vue_1 = require("vue");
const vue_router_1 = require("vue-router");
const Home_vue_1 = require("../views/Home.vue");
vue_1.default.use(vue_router_1.default);
const routes = [
    {
        path: '/',
        name: 'home',
        component: Home_vue_1.default
    },
    // {
    //   path: '/about',
    //   name: 'about',
    //   // route level code-splitting
    //   // this generates a separate chunk (about.[hash].js) for this route
    //   // which is lazy-loaded when the route is visited.
    //   component: () => import(/* webpackChunkName: "about" */ '../views/AboutView.vue')
    // }
];
const router = new vue_router_1.default({
    routes
});
exports.default = router;
//# sourceMappingURL=index.js.map