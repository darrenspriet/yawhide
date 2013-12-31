package com.yawhide.yawhide;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONArray;
import org.json.JSONException;

import com.koushikdutta.async.http.AsyncHttpClient;
import com.koushikdutta.async.http.AsyncHttpResponse;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

public class Home extends Activity {

	Button btnShowLocation;

	// GPSTracker class
	GPSTracker gps;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_home);
		
		final Context context = this;
		
		btnShowLocation = (Button) findViewById(R.id.btnShowLocation);

		// show location button click event
		btnShowLocation.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View arg0) {
				// create class object
				gps = new GPSTracker(Home.this);

				// check if GPS enabled
				if (gps.canGetLocation()) {

					final double latitude = gps.getLatitude();
					final double longitude = gps.getLongitude();
					System.out.println("lat and long are: " + latitude + " " + longitude);
					String url = "http://192.168.1.102:3000/getNearestStores/"+latitude + "/" + longitude + "/" +"20";
					AsyncHttpClient.getDefaultInstance().getJSONArray(url, new AsyncHttpClient.JSONArrayCallback() {

						@Override
						public void onCompleted(Exception arg0,
								AsyncHttpResponse arg1, JSONArray arg2) {
							// TODO Auto-generated method stub
							if (arg0 != null) {
								arg0.printStackTrace();
		                        return;
		                        
		                    }
							String mString;
							
							String[] stringArr = new String[5];
							System.out.println("there are: " + arg2.length() + " flyers");
							System.out.println("\n\n");
							for(int i = arg2.length() - 1; i >= 0; i--){
								try {
									System.out.println(arg2.getJSONObject(i).get("storeName"));
								} catch (JSONException e) {
									e.printStackTrace();
								}
							}
							//mTextView.setText(arg2.toString());
							//System.out.println(arg2);
							// \n is for new line
							Toast.makeText(
									getApplicationContext(),
									"Your Location is - \nLat: " + latitude
											+ "\nLong: " + longitude + "\nLength: " + arg2.length(), 5000)
									.show();
							LinearLayout ll = (LinearLayout)findViewById(R.id.linearLayout1);
							LayoutParams lp = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);
							for (int i = 0; i < arg2.length(); i++) {
								Button myButton = new Button(context);
								myButton.setText("Add Me");
								ll.addView(myButton, lp);
								System.out.println(i);
							}
							
						}
					    // Callback is invoked with any exceptions/errors, and the result, if available.
					   
					});
						                
					
				} else {
					// can't get location
					// GPS or Network is not enabled
					// Ask user to enable GPS/network in settings
					gps.showSettingsAlert();
				}

			}
		});
	}

}
