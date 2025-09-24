package com.example.ball_lock_app // 이 부분은 원래 파일의 내용과 같아야 합니다.

import android.util.Log
import com.google.firebase.FirebaseApp
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine // 추가

class MainActivity: FlutterActivity() {
    // [핵심] onCreate 대신 configureFlutterEngine을 사용합니다.
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        try {
            // 이 시점에는 Flutter가 Firebase를 초기화한 후입니다.
            val projectId = FirebaseApp.getInstance().options.projectId
            Log.d("MyProjectCheck", "SUCCESS: Currently connected to Firebase Project ID -> $projectId")
        } catch (e: Exception) {
            Log.e("MyProjectCheck", "ERROR: Could not get Firebase Project ID.", e)
        }
    }
}