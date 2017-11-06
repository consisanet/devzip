var exec = require('cordova/exec');

exports.decompressToString = function(zipFile, success, error) {
    exec(success, error, "DevZip", "decompressToString", [zipFile]);
};
exports.compress = function(str, success, error) {
    exec(success, error, "DevZip", "compress", [str]);
};