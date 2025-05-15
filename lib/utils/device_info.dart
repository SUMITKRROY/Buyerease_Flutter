import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:buyerease/utils/fsl_log.dart';

import 'app_constants.dart';

// Placeholder for DeviceSession (to be implemented)
class DeviceSession {
    final BuildContext context;
    DeviceSession(this.context);
    String get fcmClientRegistrationId => ''; // Replace with actual FCM ID retrieval
}

// Callback for device info
typedef OnDeviceInfoListener = void Function(
    String devicesUniqueId,
    String deviceOsType,
    String deviceOsVersion,
    String appVersion,
    int appVersionCode,
    String deviceModelNo,
    double deviceScreenSize,
    String deviceScreenResolution,
    int deviceScreenDensity,
    String fcmClientRegistrationId,
    );

class DeviceInfo {
    static const String _tag = 'Device_Info';

    String? devicesUniqueId;
    String deviceOsType = 'Android'; // Default to Android for consistency
    String? deviceOsVersion;
    String? appVersion;
    int? appVersionCode;
    String? deviceModelNo;
    double? deviceScreenSize;
    String? deviceScreenResolution;
    int? deviceScreenDensity;
    String? fcmClientRegistrationId;

    final BuildContext context;
    OnDeviceInfoListener? _onDeviceInfoListener;

    DeviceInfo(this.context, {OnDeviceInfoListener? onDeviceInfoListener}) {
        if (onDeviceInfoListener != null) {
            setOnDeviceInfoListener(onDeviceInfoListener);

        }
    }

    void setOnDeviceInfoListener(OnDeviceInfoListener listener) {
        _onDeviceInfoListener = listener;
    }



    Future<String> getUniqueId() async {
        try {
            final deviceInfoPlugin = DeviceInfoPlugin();
            if (Platform.isAndroid) {
                final androidInfo = await deviceInfoPlugin.androidInfo;
                return androidInfo.id; // Android ID
            } else if (Platform.isIOS) {
                final iosInfo = await deviceInfoPlugin.iosInfo;
                return iosInfo.identifierForVendor ?? '';
            }
            return '';
        } catch (e, stackTrace) {
            FslLog.e(_tag, 'Error getting unique ID: $e', stackTrace);
            return '';
        }
    }

    Future<String?> getDeviceIp() async {
        // Note: Getting IP address requires platform-specific code or a package like `network_info_plus`
        // This is a placeholder, as `flutter_wifi` or similar is needed
        try {
            // Implement IP retrieval if needed (e.g., using network_info_plus)
            FslLog.w(_tag, 'Device IP retrieval not implemented');
            return null;
        } catch (e, stackTrace) {
            FslLog.e(_tag, 'Error getting device IP: $e', stackTrace);
            return null;
        }
    }

    Future<String> _getDeviceModel() async {
        try {
            final deviceInfoPlugin = DeviceInfoPlugin();
            if (Platform.isAndroid) {
                final androidInfo = await deviceInfoPlugin.androidInfo;
                final manufacturer = androidInfo.manufacturer?.toLowerCase().capitalize() ?? '';
                final model = androidInfo.model ?? '';
                if (model.toLowerCase().startsWith(manufacturer.toLowerCase())) {
                    return model.capitalize();
                }
                return '$manufacturer $model';
            } else if (Platform.isIOS) {
                final iosInfo = await deviceInfoPlugin.iosInfo;
                return iosInfo.model ?? 'iOS Device';
            }
            return 'Unknown';
        } catch (e, stackTrace) {
            FslLog.e(_tag, 'Error getting device model: $e', stackTrace);
            return 'Unknown';
        }
    }

    String _getDeviceResolution() {
        final size = window.physicalSize / window.devicePixelRatio;
        final width = size.width.round();
        final height = size.height.round();
        return '${width}X$height';
    }

    double _getDeviceSize() {
        final size = window.physicalSize / window.devicePixelRatio;
        final width = size.width;
        final height = size.height;
        final densityDpi = window.devicePixelRatio * 160; // Approximate DPI
        final wi = width / densityDpi;
        final hi = height / densityDpi;
        final screenInches = sqrt(pow(wi, 2) + pow(hi, 2));
        return screenInches;
    }

    // int _getDeviceScreenDensity() {
    //     final density = window.devicePixelRatio;
    //     final densityString = density.toStringAsFixed(1);
    //
    //     if (densityString == FEnumerations.deviceDensityLdpi) {
    //         return FEnumerations.eDeviceDensityLdpi;
    //     } else if (densityString == FEnumerations.deviceDensityMdpi) {
    //         return FEnumerations.eDeviceDensityMdpi;
    //     } else if (densityString == FEnumerations.deviceDensityHdpi) {
    //         return FEnumerations.eDeviceDensityHdpi;
    //     } else if (densityString == FEnumerations.deviceDensityXhdpi) {
    //         return FEnumerations.eDeviceDensityXhdpi;
    //     } else if (densityString == FEnumerations.deviceDensityXxhdpi) {
    //         return FEnumerations.eDeviceDensityXxhdpi;
    //     } else if (densityString == FEnumerations.deviceDensityXxxhdpi) {
    //         return FEnumerations.eDeviceDensityXxxhdpi;
    //     }
    //
    //     if (density <= FEnumerations.deviceDensityLdpiValue) {
    //         return FEnumerations.eDeviceDensityLdpi;
    //     } else if (density <= FEnumerations.deviceDensityMdpiValue) {
    //         return FEnumerations.eDeviceDensityMdpi;
    //     } else if (density <= FEnumerations.deviceDensityHdpiValue) {
    //         return FEnumerations.eDeviceDensityHdpi;
    //     } else if (density <= FEnumerations.deviceDensityXhdpiValue) {
    //         return FEnumerations.eDeviceDensityXhdpi;
    //     } else if (density <= FEnumerations.deviceDensityXxhdpiValue) {
    //         return FEnumerations.eDeviceDensityXxhdpi;
    //     } else if (density <= FEnumerations.deviceDensityXxxhdpiValue) {
    //         return FEnumerations.eDeviceDensityXxxhdpi;
    //     }
    //
    //     return FEnumerations.eDeviceDensityMdpi; // Fallback
    // }

    String _getFcmId() {
        final deviceSession = DeviceSession(context);
        return deviceSession.fcmClientRegistrationId; // Placeholder
    }

    Future<String> _getDeviceOsVersion() async {
        try {
            final deviceInfoPlugin = DeviceInfoPlugin();
            if (Platform.isAndroid) {
                final androidInfo = await deviceInfoPlugin.androidInfo;
                return androidInfo.version.sdkInt.toString();
            } else if (Platform.isIOS) {
                final iosInfo = await deviceInfoPlugin.iosInfo;
                return iosInfo.systemVersion ?? 'Unknown';
            }
            return 'Unknown';
        } catch (e, stackTrace) {
            FslLog.e(_tag, 'Error getting OS version: $e', stackTrace);
            return 'Unknown';
        }
    }

    Future<PackageInfo> _getPackageInfo() async {
        try {
            final packageInfo = await PackageInfo.fromPlatform();
            FslLog.d(_tag, 'App version Name ${packageInfo.version}');
            FslLog.d(_tag, 'App version code ${packageInfo.buildNumber}');
            return packageInfo;
        } catch (e, stackTrace) {
            FslLog.e(_tag, 'Error getting package info: $e', stackTrace);
            return PackageInfo(
                appName: '',
                packageName: '',
                version: 'Unknown',
                buildNumber: '0',
            );
        }
    }

    Future<String> androidDeviceOsName() async {
        try {
            final deviceInfoPlugin = DeviceInfoPlugin();
            if (Platform.isAndroid) {
                final androidInfo = await deviceInfoPlugin.androidInfo;
                final release = androidInfo.version.release ?? 'Unknown';
                final sdkInt = androidInfo.version.sdkInt ?? 0;

                // Map SDK_INT to Android version name (approximation)
                const sdkToVersion = {
                    33: 'Tiramisu (13)',
                    32: 'Snow Cone (12L)',
                    31: 'Snow Cone (12)',
                    30: 'Red Velvet Cake (11)',
                    29: 'Quince Tart (10)',
                    28: 'Pie (9)',
                    27: 'Oreo (8.1)',
                    26: 'Oreo (8.0)',
                    25: 'Nougat (7.1)',
                    24: 'Nougat (7.0)',
                    23: 'Marshmallow (6.0)',
                    22: 'Lollipop (5.1)',
                    21: 'Lollipop (5.0)',
                    19: 'KitKat (4.4)',
                };

                final versionName = sdkToVersion[sdkInt] ?? 'Unknown';
                final result = 'Android $versionName';
                FslLog.d(_tag, 'OS: Android : $release : $versionName : sdk=$sdkInt');
                return result;
            }
            return 'Unknown';
        } catch (e, stackTrace) {
            FslLog.e(_tag, 'Error getting Android OS name: $e', stackTrace);
            return 'Android Unknown';
        }
    }
}

// Extension to capitalize strings
extension StringExtension on String {
    String capitalize() {
        if (isEmpty) return '';
        return this[0].toUpperCase() + substring(1);
    }
}