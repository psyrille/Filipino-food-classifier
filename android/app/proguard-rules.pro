# Keep all TensorFlow Lite GPU delegate classes
-keep class org.tensorflow.lite.** { *; }

# Keep TensorFlow Lite Task API
-keep class org.tensorflow.lite.task.** { *; }

# Do not warn about TensorFlow Lite classes
-dontwarn org.tensorflow.lite.**