def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.projectDir.parentFile.toPath().resolve("android/key.properties").toFile()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.dio_receipe"
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
        applicationId = "com.example.dio_receipe"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        release {
            keyAlias = keystoreProperties['keyAlias']
            keyPassword = keystoreProperties['keyPassword']
            storeFile = keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword = keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            // 2. Updated from debug to release config
            signingConfig = signingConfigs.release
            
            // Recommended for production builds
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }

    flavorDimensions += "default"

    productFlavors {
        create("prod") {
            dimension = "default"
            resValue("string", "app_name", "dio_receipe")
        }
        
        create("dev") {
            dimension = "default"
            resValue("string", "app_name", "dio_receipe-dev")
            applicationIdSuffix = ".dev"
        }
    }
}

flutter {
    source = "../.."
}