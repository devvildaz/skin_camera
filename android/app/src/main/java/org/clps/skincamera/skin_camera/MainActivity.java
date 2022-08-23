package org.clps.skincamera.skin_camera;

import android.os.Build;
import android.os.Bundle;
import android.graphics.Color;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            getWindow().setStatusBarColor(Color.rgb(252, 131, 131));
        }
    }
}
