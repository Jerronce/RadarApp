// In android/build.gradle.kts

plugins {
    // No plugins are needed here in the root build file for a standard Flutter project
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}
