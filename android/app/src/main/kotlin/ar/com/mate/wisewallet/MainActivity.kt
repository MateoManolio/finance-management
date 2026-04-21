package ar.com.mate.wisewallet

import android.content.Intent
import android.os.Environment
import android.net.Uri
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "ar.com.mate.wisewallet/storage"

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "openDownloadsFolder" -> {
                        try {
                            // Use the Downloads app directly
                            val intent = Intent(Intent.ACTION_GET_CONTENT)
                            intent.type = "*/*"
                            val downloadsUri = Uri.parse(
                                "content://com.android.externalstorage.documents/document/primary%3ADownload"
                            )
                            intent.setDataAndType(downloadsUri, "application/json")
                            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

                            // Preferred: open Downloads via the dedicated manager URI
                            val downloadIntent = Intent(Intent.ACTION_VIEW).apply {
                                data = Uri.parse(
                                    "content://com.android.externalstorage.documents/root/primary"
                                )
                                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            }
                            startActivity(downloadIntent)
                            result.success(true)
                        } catch (e: Exception) {
                            try {
                                // Fallback: open the generic file manager
                                val fallback = Intent(Intent.ACTION_VIEW).apply {
                                    data = Uri.fromFile(Environment.getExternalStoragePublicDirectory(
                                        Environment.DIRECTORY_DOWNLOADS
                                    ))
                                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                }
                                startActivity(fallback)
                                result.success(true)
                            } catch (e2: Exception) {
                                result.success(false)
                            }
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
