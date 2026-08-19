buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.1")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// tamara_flutter_sdk ships with mismatched Java (1.8) / Kotlin (JVM 21)
// targets, which breaks kapt. Align its Kotlin JVM target with Java, and
// upgrade Dagger (its 2.52's shaded kotlinx-metadata-jvm cannot read
// Kotlin 2.0.20 metadata 2.2.0; 2.57+ uses kotlin-metadata-jvm 2.2.x).
// Note: this block must run BEFORE `evaluationDependsOn(":app")` below.
subprojects {
    afterEvaluate {
        if (project.name == "tamara_flutter_sdk") {
            tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
                compilerOptions.jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_1_8)
            }
            configurations.matching { it.name.startsWith("kapt") }.all {
                resolutionStrategy.force(
                    "com.google.dagger:dagger:2.59.2",
                    "com.google.dagger:dagger-spi:2.59.2",
                    "com.google.dagger:dagger-compiler:2.59.2",
                    "com.google.dagger:dagger-android-support:2.59.2",
                    "com.google.dagger:dagger-android-processor:2.59.2",
                )
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}