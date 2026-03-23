package com.example.finance_management

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.DocumentsContract
import android.provider.Settings
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.example.finance_management/storage"
    private val REQUEST_MANAGE_STORAGE = 1001

    private var pendingResult: MethodChannel.Result? = null

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "hasStoragePermission" -> {
                        result.success(hasManageStoragePermission())
                    }
                    "requestStoragePermission" -> {
                        if (hasManageStoragePermission()) {
                            result.success(true)
                        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                            pendingResult = result
                            val intent = Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION)
                            intent.data = Uri.parse("package:${applicationContext.packageName}")
                            startActivityForResult(intent, REQUEST_MANAGE_STORAGE)
                        } else {
                            result.success(true)
                        }
                    }
                    "openDocumentsFolder" -> {
                        try {
                            val uri = Uri.parse("content://com.android.externalstorage.documents/document/primary%3ADocuments")
                            val intent = Intent(Intent.ACTION_VIEW)
                            intent.setDataAndType(uri, DocumentsContract.Document.MIME_TYPE_DIR)
                            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            // Fallback: open any file manager
                            try {
                                val fallbackIntent = Intent(Intent.ACTION_VIEW)
                                fallbackIntent.data = Uri.parse("content://com.android.externalstorage.documents/root/primary")
                                fallbackIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                                startActivity(fallbackIntent)
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

    private fun hasManageStoragePermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            Environment.isExternalStorageManager()
        } else {
            true
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_MANAGE_STORAGE) {
            pendingResult?.success(hasManageStoragePermission())
            pendingResult = null
        }
    }
}
