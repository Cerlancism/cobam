"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sleepAsync = void 0;
async function sleepAsync(timeout) {
    return new Promise((r) => {
        setTimeout(() => r(), timeout);
    });
}
exports.sleepAsync = sleepAsync;
//# sourceMappingURL=common.js.map