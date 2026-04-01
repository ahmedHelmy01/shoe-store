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
        create("webstore") {
            dimension = "version"
            applicationIdSuffix = ".webstore"
            versionNameSuffix = "-webstore"
            resValue("string", "app_name", "متجر الويب")
        }
        create("sales") {
            dimension = "version"
            applicationIdSuffix = ".sales"
            versionNameSuffix = "-sales"
            resValue("string", "app_name", "نظام المبيعات")
        }
        create("purchases") {
            dimension = "version"
            applicationIdSuffix = ".purchases"
            versionNameSuffix = "-purchases"
            resValue("string", "app_name", "نظام المشتريات")
        }
        create("inventory") {
            dimension = "version"
            applicationIdSuffix = ".inventory"
            versionNameSuffix = "-inventory"
            resValue("string", "app_name", "نظام المخازن")
        }
        create("hrm") {
            dimension = "version"
            applicationIdSuffix = ".hrm"
            versionNameSuffix = "-hrm"
            resValue("string", "app_name", "الموارد البشرية")
        }
        create("accounting") {
            dimension = "version"
            applicationIdSuffix = ".accounting"
            versionNameSuffix = "-accounting"
            resValue("string", "app_name", "المحاسبة المالية")
        }
        create("lis") {
            dimension = "version"
            applicationIdSuffix = ".lis"
            versionNameSuffix = "-lis"
            resValue("string", "app_name", "نظام المختبرات")
        }
        create("pos") {
            dimension = "version"
            applicationIdSuffix = ".pos"
            versionNameSuffix = "-pos"
            resValue("string", "app_name", "نقاط البيع")
        }
        create("production") {
            dimension = "version"
            applicationIdSuffix = ".production"
            versionNameSuffix = "-production"
            resValue("string", "app_name", "نظام الإنتاج")
        }
        create("crm") {
            dimension = "version"
            applicationIdSuffix = ".crm"
            versionNameSuffix = "-crm"
            resValue("string", "app_name", "علاقات العملاء")
        }
        create("cmms") {
            dimension = "version"
            applicationIdSuffix = ".cmms"
            versionNameSuffix = "-cmms"
            resValue("string", "app_name", "نظام الصيانة")
        }
        create("qms") {
            dimension = "version"
            applicationIdSuffix = ".qms"
            versionNameSuffix = "-qms"
            resValue("string", "app_name", "نظام الجودة")
        }
        create("full") {
            dimension = "version"
            // No suffix for full version
            resValue("string", "app_name", "نظام ERP الشامل")
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
