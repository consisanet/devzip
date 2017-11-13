package cordova.plugin.devzip;

import org.apache.cordova.CordovaArgs;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaResourceApi;

import android.net.Uri;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;

/**
 * This class echoes a string called from JavaScript.
 */
public class DevZip extends CordovaPlugin {

    private static final String LOG_TAG = "DevZip";

    @Override
    public boolean execute(String action, CordovaArgs args, CallbackContext callbackContext) throws JSONException {
        if ("decompressToString".equals(action)) {
            byte[] zipFile = args.getArrayBuffer(0);
            this.decompressToString(zipFile, callbackContext);
            return true;
        }else if ("compress".equals(action)) {
            byte[] zipFile = args.getArrayBuffer(0);
//            this.compress(zipFile, callbackContext);
            return true;
        }
        return false;
    }

    private void decompressToString(byte[] zipFile, CallbackContext callbackContext) {
        final int BUFFER_SIZE = 1024;
        try {
            ByteArrayInputStream is = new ByteArrayInputStream(zipFile);
            GZIPInputStream gis = new GZIPInputStream(is);

            StringBuilder string = new StringBuilder();
            byte[] data = new byte[BUFFER_SIZE];
            int bytesRead;
            while ((bytesRead = gis.read(data)) != -1) {
                string.append(new String(data, 0, bytesRead));
            }
            gis.close();
            is.close();
            Log.i(LOG_TAG, string.toString());
            callbackContext.success(string.toString());
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
            Log.e(LOG_TAG, e.getMessage(), e);
        }
    }

    private Uri getUriForArg(String arg) {
        CordovaResourceApi resourceApi = webView.getResourceApi();
        Uri tmpTarget = Uri.parse(arg);
        return resourceApi.remapUri(
                tmpTarget.getScheme() != null ? tmpTarget : Uri.fromFile(new File(arg)));
    }

    private void compress(String string,CallbackContext callbackContext){
        try {
            ByteArrayOutputStream os = new ByteArrayOutputStream(string.length());
            GZIPOutputStream gos = new GZIPOutputStream(os);
            gos.write(string.getBytes());
            gos.close();
            byte[] compressed = os.toByteArray();
            os.close();
            callbackContext.success(compressed);
        }catch(Exception e){
            callbackContext.error(e.getMessage());
        }
    }
}
