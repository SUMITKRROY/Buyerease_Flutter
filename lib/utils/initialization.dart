import 'package:flutter/material.dart';
import 'dart:async';

/// A utility class that holds application-level variables and state
class Initialization {
  // Singleton pattern
  static final Initialization _instance = Initialization._internal();
  
  factory Initialization() {
    return _instance;
  }
  
  Initialization._internal();
  
  // Alert dialog reference
  static AlertDialog? alertDialog;
  
  // Activity reference using WeakReference equivalent in Dart
  static WeakReference<BuildContext>? contextWeakReference;
  
  // Other application configuration variables can be added here
  static bool isInitialized = false;
  static String appVersion = "";
  static String deviceId = "";
  
  // Initialize the app with necessary configurations
  static Future<void> initialize() async {
    // Perform initialization tasks here
    isInitialized = true;
  }
}

/// A simple implementation of WeakReference for Dart
/// Note: Dart has garbage collection but doesn't have built-in WeakReference like Java
/// This is a simplified version for conceptual purposes
class WeakReference<T> {
  T? _reference;
  
  WeakReference(this._reference);
  
  T? get() {
    return _reference;
  }
  
  void clear() {
    _reference = null;
  }
}
