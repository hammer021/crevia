import java.util.Properties
import java.io.FileInputStream
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id ("com.google.gms.google-services")
}

android {
    namespace = "com.kopkarpkt.crevia"
    compileSdk = 36
    //ndkVersion = flutter.ndkVersion
    ndkVersion = "27.0.12077973"
    //ndkVersion = "26.1.10909125"
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.kopkarpkt.crevia"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = 6
        versionName = "1.0.6"
        multiDexEnabled = true
        // ndk {
         //       abiFilters += setOf("arm64-v8a")
         //   }

         ndk {
                abiFilters += setOf(
                    "arm64-v8a",
                    "armeabi-v7a",
                    "x86_64"
                )
            }
    }
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
   // packagingOptions {
   //     jniLibs {
   //         useLegacyPackaging = false
   //     }
   // }
   packaging {
        jniLibs {
            useLegacyPackaging = false

            pickFirsts += listOf(
                "**/libc++_shared.so"
            )
        }
    }

    splits {
        abi {
            isEnable = true
            reset()
            include("arm64-v8a", "armeabi-v7a", "x86_64")
            isUniversalApk = true
        }
    }
}

flutter {
    source = "../.."
}
configurations.all {
    resolutionStrategy.eachDependency {
        if (requested.group == "com.google.android.play" && requested.name == "core") {
            useTarget("com.google.android.play:app-update:2.1.0")
        }
    }
   // exclude(group = "com.google.mlkit", module = "text-recognition")
   // exclude(group = "com.google.mlkit", module = "barcode-scanning")
}
dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.9.23")
    implementation("androidx.multidex:multidex:2.0.1")

    // Pakai versi terbaru Google Play In-App Update
    implementation("com.google.android.play:app-update:2.1.0")
    implementation("com.google.android.play:app-update-ktx:2.1.0")
    // implementation("com.google.android.gms:play-services-mlkit-text-recognition:19.0.0")
    // Contoh: update core-ktx dan exclude play-core biar ga tabrakan
    implementation("androidx.core:core-ktx:1.12.0") {
        exclude(group = "com.google.android.play", module = "core")
    }
}
