package org.qtproject.example;

import android.content.BroadcastReceiver; 
import android.content.Context; 
import android.content.Intent; 

public class BootBroadcastReceiver extends BroadcastReceiver { 
	static final String action_boot="android.intent.action.BOOT_COMPLETED"; 
	@Override 
	public void onReceive(Context context, Intent intent) { 
		if (intent.getAction().equals(action_boot)){ 
            Intent StartIntent=new Intent(context,org.qtproject.qt5.android.bindings.QtActivity.class); //���յ��㲥������ת��MainActivity
			StartIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK); 
			context.startActivity(StartIntent); 
		}
	}
}
