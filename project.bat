@echo off

REM Create core folders and files
mkdir lib\core\helpers
mkdir lib\core\services
mkdir lib\core\models

copy nul lib\core\constants.dart
copy nul lib\core\models\user_model.dart
copy nul lib\core\models\device_model.dart
copy nul lib\core\models\exercise_model.dart
copy nul lib\core\models\workout_model.dart
copy nul lib\core\models\program_model.dart
copy nul lib\core\models\goal_model.dart
copy nul lib\core\models\receipt_model.dart
copy nul lib\core\models\enums.dart
copy nul lib\core\services\auth_service.dart
copy nul lib\core\services\device_binding_service.dart
copy nul lib\core\services\analytics_service.dart
copy nul lib\core\services\subscription_service.dart
copy nul lib\core\services\notification_service.dart

REM Create feature folders, subfolders and files
for %%A in (auth workout exercise program goal subscription reminders settings admin) do (
    mkdir lib\features\%%A\screens
    mkdir lib\features\%%A\widgets
    mkdir lib\features\%%A\viewmodels
    mkdir lib\features\%%A\repository
)

copy nul lib\features\auth\screens\login_screen.dart
copy nul lib\features\auth\screens\otp_screen.dart
copy nul lib\features\auth\widgets\auth_form.dart

copy nul lib\features\workout\screens\workout_log_screen.dart
copy nul lib\features\workout\screens\workout_history_screen.dart
copy nul lib\features\workout\screens\streak_screen.dart
copy nul lib\features\workout\widgets\set_logger.dart
copy nul lib\features\workout\widgets\rest_timer.dart
copy nul lib\features\workout\widgets\pr_chart.dart

copy nul lib\features\exercise\screens\exercise_catalog_screen.dart
copy nul lib\features\exercise\screens\exercise_detail_screen.dart
copy nul lib\features\exercise\widgets\exercise_card.dart
copy nul lib\features\exercise\widgets\gif_viewer.dart

copy nul lib\features\program\screens\program_list_screen.dart
copy nul lib\features\program\screens\program_detail_screen.dart

copy nul lib\features\goal\screens\goal_screen.dart
copy nul lib\features\subscription\screens\subscription_screen.dart
copy nul lib\features\reminders\screens\reminders_screen.dart
copy nul lib\features\settings\screens\settings_screen.dart

copy nul lib\features\admin\screens\exercise_admin_screen.dart
copy nul lib\features\admin\screens\program_admin_screen.dart

REM Create data folder
mkdir lib\data\sources
mkdir lib\data\repository
mkdir lib\data\adapters

copy nul lib\data\sources\local_db.dart
copy nul lib\data\sources\firestore_service.dart
copy nul lib\data\sources\storage_service.dart
copy nul lib\data\sources\sync_service.dart

REM Create utils folder
mkdir lib\utils

copy nul lib\utils\extensions.dart
copy nul lib\utils\validators.dart
copy nul lib\utils\device_utils.dart
copy nul lib\utils\tts_utils.dart
copy nul lib\utils\audio_utils.dart
copy nul lib\utils\sensor_utils.dart

REM Create theme folder
mkdir lib\theme

copy nul lib\theme\styles.dart
copy nul lib\theme\colors.dart
copy nul lib\theme\text_theme.dart

REM Create generated folder
mkdir lib\generated

REM Create main.dart in root if needed
if not exist lib\main.dart copy nul lib\main.dart

echo Project structure created!
pause
