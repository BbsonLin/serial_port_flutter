package com.example.flutter_serial_port_example;

import android.os.Bundle;
import android.os.Build;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {

    Log.d("MainActivity", "VERSION.SDK_INT: " + Build.VERSION.SDK_INT);
    if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.KITKAT_WATCH) {
      // use software rendering (ideally only when you need to)
      getIntent().putExtra("enable-software-rendering", true);
    }

    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }
}
