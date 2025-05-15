import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:buyerease/utils/fsl_log.dart';

// Callback for GPS status
typedef OnGpsStatus = void Function();

class GPSDialog {
    static const String tag = 'GPSDialog';

    // Private constructor to prevent instantiation
    GPSDialog._();

    // Check if GPS is enabled and prompt user if needed
    static Future<void> checkEnableAndShowDialog(
        BuildContext context, {
            required OnGpsStatus onSuccess,
        }) async {
        try {
            // Check if location services are enabled
            bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
            FslLog.d(tag, 'GPS status: $serviceEnabled');

            if (serviceEnabled) {
                // GPS is enabled, invoke success callback
                onSuccess();
            } else {
                // Prompt user to enable location services
                await Geolocator.openLocationSettings();
                // Note: We can't reliably detect if the user enabled GPS after the prompt,
                // so we log the attempt and rely on the app to recheck if needed
                FslLog.d(tag, 'Opened location settings to enable GPS');
            }
        } catch (e, stackTrace) {
            FslLog.e(tag, 'Error checking GPS status: $e', stackTrace);
        }
    }

    // Check if GPS is enabled
    static Future<bool> isGpsEnable(BuildContext context) async {
        try {
            bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
            FslLog.d(tag, '$serviceEnabled: GPS status using Geolocator');
            return serviceEnabled;
        } catch (e, stackTrace) {
            FslLog.e(tag, 'Error checking GPS status: $e', stackTrace);
            return false;
        }
    }
}