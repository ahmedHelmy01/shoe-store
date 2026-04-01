plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.erp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.erp"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Product Flavors for Modular ERP System
    flavorDimensions += "version"
    productFlavors {
        create("representatives") {
            dimension = "version"
            applicationIdSuffix = ".representatives"
            versionNameSuffix = "-representatives"
            resValue("string", "app_name", "نظام المناديب")
        }
        create("accounts") {
            dimension = "version"
            applicationIdSuffix = ".accounts"
            versionNameSuffix = "-accounts"
            resValue("string", "app_name", "نظام الحسابات")
        }
        create("employees") {
            dimension = "version"
            applicationIdSuffix = ".employees"
            versionNameSuffix = "-employees"
            resValue("string", "app_name", "نظام الموظفين")
        }
        create("full") {
            dimension = "version"
            // No suffix for full version
            resValue("string", "app_name", "نظام ERP")
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
