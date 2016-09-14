(function (cordova) {
    cordova.define("cordova-plugin-DLoadingOverlay",
        function (require, exports, module) {
            var exec = require("cordova/exec");

            var DLoadingOverlay = function () {
                this.setVisible = function (shouldShow) {
                    exec(null, null, "DLoadingOverlay", "setVisible", [shouldShow]);
                };
            };

            var dLoadingOverlay = new DLoadingOverlay();
            module.exports = dLoadingOverlay;
            exports = dLoadingOverlay;
        }
    );
}(window.cordova));