import 'dart:developer' as developer;
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

// Placeholder for FClientConfig (to be implemented)
class FClientConfig {
    static const int logFileMaxSizeInKB = 1024; // Default max size: 1MB
    static final String locID = "DEL";
}

class FslLog {
    static File? _logFile;

    // Private constructor to prevent instantiation
    FslLog._();

    // Informational log
    static void i(String tag, String message) {
        message = message.isEmpty ? ' ' : message;
        developer.log(message, name: tag, level: 800); // INFO level
        _appendLog('I', tag, message);
    }

    // Debug log
    static void d(String tag, String message) {
        message = message.isEmpty ? ' ' : message;
        developer.log(message, name: tag, level: 500); // DEBUG level
        _appendLog('D', tag, message);
    }

    // Warning log
    static void w(String tag, String message) {
        message = message.isEmpty ? ' ' : message;
        developer.log(message, name: tag, level: 900); // WARNING level
        _appendLog('W', tag, message);
    }

    // Error log
    static void e(String tag, String message, [StackTrace? stackTrace]) {
        message = message.isEmpty ? ' ' : message;
        developer.log(message, name: tag, level: 1000, stackTrace: stackTrace); // ERROR level
        _appendLog('E', tag, message);
    }

    // Verbose log for API-related JSON messages
    static void vc(String tag, String message) {
        message = message.isEmpty ? ' ' : message;
        developer.log(message, name: tag, level: 300); // VERBOSE level
        _appendLog('V', tag, message);
    }

    // Verbose log for Google API-related JSON messages
    static void vg(String tag, String message) {
        message = message.isEmpty ? ' ' : message;
        developer.log(message, name: tag, level: 300); // VERBOSE level
        _appendLog('V', tag, message);
    }

    // Append log to file
    static void _appendLog(String whichType, String tag, String text) async {
        bool initFlag = true;

        if (_logFile != null && await _logFile!.exists()) {
            if (_fileSize(_logFile!) >= FClientConfig.logFileMaxSizeInKB) {
                developer.log('Logger file more than ${FClientConfig.logFileMaxSizeInKB} KB, deleting file',
                    name: 'FslLog');
                await _logFile!.delete();
                _logFile = null;
            }
        }

        if (_logFile == null || !await _logFile!.exists()) {
            developer.log('Logger file object doesn\'t exist', name: 'FslLog');
            initFlag = await initializeLog(); // Corrected from _initializeLog to initializeLog
        }

        if (initFlag) {
            try {
                final time = _getTime();
                await _logFile!.writeAsString(
                    '$time:: $whichType/$tag: $text\n',
                    mode: FileMode.append,
                );
            } catch (e, stackTrace) {
                developer.log('Error writing to log file: $e',
                    name: 'FslLog', stackTrace: stackTrace);
            }
        } else {
            developer.log('Logger initialization failed', name: 'FslLog');
        }
    }

    // Initialize log file
    static Future<bool> initializeLog() async {
        try {
            final directory = await getApplicationDocumentsDirectory();
            _logFile = File('${directory.path}/FslLog.txt');

            developer.log('Logger file path - ${_logFile!.path}', name: 'FslLog');

            if (await _logFile!.exists()) {
                developer.log('Logger file exists', name: 'FslLog');
                if (_fileSize(_logFile!) >= FClientConfig.logFileMaxSizeInKB) {
                    developer.log('Logger file more than ${FClientConfig.logFileMaxSizeInKB} KB, deleting file',
                        name: 'FslLog');
                    await _logFile!.delete();
                }
            }

            if (!await _logFile!.exists()) {
                await _logFile!.create();
            }

            await _logFile!.writeAsString(
                '\n\n\n---------------------------Logging Initialized---------------------------------\n\n\n',
                mode: FileMode.append,
            );

            return true;
        } catch (e, stackTrace) {
            developer.log('Error initializing log file: $e',
                name: 'FslLog', stackTrace: stackTrace);
            return false;
        }
    }

    // Get current time in ddMMM hh:mm:ss.SSS aa format
    static String _getTime() {
        final now = DateTime.now();
        final formatter = DateFormat('ddMMM hh:mm:ss.SSS aa', 'en_US');
        return formatter.format(now);
    }

    // Get file size in KB
    static int _fileSize(File file) {
        return file.lengthSync() ~/ 1024;
    }
}