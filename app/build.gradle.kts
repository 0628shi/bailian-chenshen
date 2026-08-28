plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
}

android {
    namespace = "com.example.fitness"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.fitness"
        minSdk = 26
        targetSdk = 34
        versionCode = 4
        // 版本号自动跟随 versionCode：V1.00 -> V1.01 -> V1.02 ...（每次更新 +0.01）
        versionName = "1." + String.format("%02d", (versionCode ?: 1) - 1)
    }

    buildTypes {
        release {
            isMinifyEnabled = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
}

// 零外部依赖：仅用 Android 框架类（Activity + WebView），完全离线可构建
dependencies {
}
