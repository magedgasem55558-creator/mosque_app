plugins {
    id("com.android.application")
    id("kotlin-android")
    // هنا التعديل الصحيح بدلاً من classpath
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.yourname.mosque_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // 1. تفعيل Desugaring
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // تأكد من أن هذا الـ ID يطابق الموجود في ملف google-services.json
        applicationId = "com.yourname.mosque_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // 2. تفعيل MultiDex
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // أضف هذا السطر إذا لم يكن موجوداً لضمان عمل الفايربيز بشكل صحيح
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))

    // 3. إضافة مكتبة Desugaring بحسب صيغة Kotlin DSL
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
