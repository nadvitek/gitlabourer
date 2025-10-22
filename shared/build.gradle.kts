import org.jetbrains.kotlin.gradle.ExperimentalKotlinGradlePluginApi
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.plugin.mpp.apple.XCFramework

plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.androidLibrary)
    alias(libs.plugins.kotlinxSerialization)
    alias(libs.plugins.ksp)
    alias(libs.plugins.kmpNativeCoroutines)
}

kotlin {
    explicitApi()

    androidTarget {
        @OptIn(ExperimentalKotlinGradlePluginApi::class)
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_11)
        }
    }

    val xcf = project.XCFramework()
    listOf(
        iosX64(),
        iosArm64(),
        iosSimulatorArm64(),
    ).forEach {
        it.binaries.framework {
            isStatic = false
            xcf.add(this)
        }
    }

    sourceSets {
        androidMain.dependencies {
            implementation(libs.ktor.client.okhttp)
        }
        iosMain.dependencies {
            implementation(libs.ktor.client.darwin)
        }
        commonMain.dependencies {
            implementation(libs.ktor.client.core)
            implementation(libs.ktor.client.content.negotiation)
            implementation(libs.ktor.serialization.kotlinx.json)
            implementation(libs.koin.core)
            implementation(libs.koinKmmExport.core)
            implementation(libs.ktor.client.logging)
            implementation("com.russhwolf:multiplatform-settings:1.1.1")           // core (includes ObservableSettings)
            implementation("com.russhwolf:multiplatform-settings-coroutines:1.1.1")
            implementation("org.jetbrains.kotlinx:kotlinx-datetime:0.6.1")
            api(libs.kmp.observable.viewmodel)
        }

        all {
            languageSettings.optIn("kotlinx.cinterop.ExperimentalForeignApi")
            languageSettings.optIn("kotlin.experimental.ExperimentalObjCName")
        }
    }
}

ksp {
    arg("packageName", "com.nadvitek")
    arg("exportsFileName", "AppDependency")
    arg("mode", "properties")
}

android {
    namespace = "com.jetbrains.kmpapp.shared"
    compileSdk = 35
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    defaultConfig {
        minSdk = 24
    }
}

dependencies {
    implementation(libs.crash.plugin)
}

/*tasks.register<org.jetbrains.kotlin.gradle.tasks.FatFrameworkTask>("assembleXCFramework") {
    baseName = "SharedModule"

    from(
        kotlin.targets.getByName<org.jetbrains.kotlin.gradle.plugin.mpp.KotlinNativeTarget>("iosArm64").binaries.getFramework("debug"),
        kotlin.targets.getByName<org.jetbrains.kotlin.gradle.plugin.mpp.KotlinNativeTarget>("iosSimulatorArm64").binaries.getFramework("debug"),
        kotlin.targets.getByName<org.jetbrains.kotlin.gradle.plugin.mpp.KotlinNativeTarget>("iosX64").binaries.getFramework("debug")
    )

    destinationDir = buildDir.resolve("xcframeworks")
}
 */
