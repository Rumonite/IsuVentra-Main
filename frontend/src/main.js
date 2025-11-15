import { createApp } from 'vue';
import App from './App.vue';
import router from './router';
import { createPinia } from 'pinia';
import VueQrcodeReader from "vue-qrcode-reader";
import { setZXingModuleOverrides } from "vue-qrcode-reader";
import * as ZXing from "@zxing/library";

setZXingModuleOverrides({
    BrowserQRCodeReader: ZXing.BrowserQRCodeReader,
});

const app = createApp(App);
app.use(VueQrcodeReader);
app.use(createPinia());
app.use(router);
app.mount('#app');
