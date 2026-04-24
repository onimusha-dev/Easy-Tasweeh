# Drift / SQLite rules
-keep class androidx.sqlite.db.framework.FrameworkSQLiteOpenHelperFactory { *; }
-keep class net.sqlcipher.database.SQLiteDatabase { *; }
-keep class net.sqlcipher.database.SQLiteOpenHelper { *; }
-keep class net.sqlcipher.database.SQLiteCursor { *; }
-keep class net.sqlcipher.database.SQLiteProgram { *; }
-keep class net.sqlcipher.database.SQLiteQuery { *; }
-keep class net.sqlcipher.database.SQLiteStatement { *; }
-keep class net.sqlcipher.database.SQLiteQueryBuilder { *; }
-keep class net.sqlcipher.database.SQLiteContentValues { *; }
-keep class net.sqlcipher.database.SQLiteDatabaseCursorFactory { *; }

# Flutter rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

# Fix for Missing Play Core classes (referenced by Flutter engine)
# These are only needed if you use deferred components (SplitInstall)
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.gms.**
-dontwarn com.google.android.material.**

# General keep rules for common plugins
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.mushalabs.easytasbeeh.** { *; }
