# Flutter rules are compiled into the base Flutter Gradle script. See
# https://github.com/flutter/flutter/blob/master/packages/flutter_tools/gradle/src/main/groovy/flutter.groovy

# Proguard rule for TensorFlow Lite.
-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }
-dontwarn org.tensorflow.lite.**
