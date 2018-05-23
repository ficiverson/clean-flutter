package com.mobgen.cleanflutter.cleanflutter;

import android.os.Bundle;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {

	private static final String METHOD_CHANNEL = "clean.flutter.io/cameraResult";
	private static final String STREAM = "clean.flutter.io/stream";

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		GeneratedPluginRegistrant.registerWith(this);

		new MethodChannel(getFlutterView(), METHOD_CHANNEL).setMethodCallHandler(
				new MethodCallHandler() {
					@Override
					public void onMethodCall(MethodCall call, Result result) {
						boolean isNative = true;
						if (call.method.equals("getNativeData")) {
							if (isNative) {
								result.success(true);
							} else {
								result.error("UNAVAILABLE", "Battery level not available.", null);
							}
						} else {
							result.notImplemented();
						}
					}
				});

		new EventChannel(getFlutterView(), STREAM).setStreamHandler(
				new EventChannel.StreamHandler() {
					@Override
					public void onListen(Object args, final EventChannel.EventSink events) {
						Log.w("listen:>", "adding listener");
						events.success("new event");
						//events.endOfStream();
						//events.error("Error","Failed GPS",null);
					}

					@Override
					public void onCancel(Object args) {
						Log.w("Cancel:>", "cancelling listener");
					}
				}
		);
	}
}
