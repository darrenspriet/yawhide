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
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
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

					String url = "http://192.168.1.113:3000/getNearestStores/42.49/-80.5467/50";
					AsyncHttpClient.getDefaultInstance().getJSONArray(url, new AsyncHttpClient.JSONArrayCallback() {

						@Override
						public void onCompleted(Exception arg0,
								AsyncHttpResponse arg1, JSONArray arg2) {
							// TODO Auto-generated method stub
							if (arg0 != null) {
								arg0.printStackTrace();
		                        return;
		                        
		                    }
							TextView mTextView;
							String mString;

							mTextView = (TextView) findViewById(R.id.mTextView);
							for (int i = arg2.length() - 1; i >= 0; i--) {
								try {
									JSONArray jj = arg2.getJSONObject(i).getJSONArray("currFlyer");
									for (int j = jj.length() - 1; j >= 0; j--) {
										System.out.println(jj.getJSONObject(i));
									}
								} catch (JSONException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
							};
							mTextView.setText(arg2.toString());
						
							// \n is for new line
							Toast.makeText(
									getApplicationContext(),
									"Your Location is - \nLat: " + latitude
											+ "\nLong: " + longitude + " something...." + arg2, 20000)
									.show();
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
