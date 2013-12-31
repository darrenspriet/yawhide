package com.yawhide.yawhide;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.app.Activity;
import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;
import android.widget.Toast;
import com.yawhide.yawhide.JSONParser;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import com.koushikdutta.async.http.AsyncHttpClient;
import com.koushikdutta.async.http.AsyncHttpResponse;
import android.content.Context;
import android.graphics.Color;
import android.util.Log;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.ScrollView;

public class Home extends Activity {
    ListView list;
    TextView ver;
    TextView name;
    TextView api;
    Button Btngetdata;
    ArrayList<HashMap<String, String>> oslist = new ArrayList<HashMap<String, String>>();
    
    //JSON Node Names
    private static final String TAG_OS = "storeLocation";
    private static final String TAG_VER = "urlNumber";
    private static final String TAG_NAME = "city";
    private static final String TAG_API = "postalCode";
    JSONArray android = null;
    
    Button btnShowLocation;
    GPSTracker gps;
    double latitude;
    double longitude;
    
    //URL to get JSON Array
    
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);
        oslist = new ArrayList<HashMap<String, String>>();
        Btngetdata = (Button)findViewById(R.id.getdata);
        Btngetdata.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                 new JSONParse().execute();
            }
        });
        
        btnShowLocation = (Button) findViewById(R.id.showLoc);

    	// show location button click event
    	btnShowLocation.setOnClickListener(new View.OnClickListener() {

    		@Override
    		public void onClick(View arg0) {
    			// create class object
    			gps = new GPSTracker(Home.this);

    			// check if GPS enabled
    			if (gps.canGetLocation()) {

    				latitude = gps.getLatitude();
    				longitude = gps.getLongitude();
    				Toast.makeText(
    						getApplicationContext(),
    						"Your Location is - \nLat: " + latitude
    						+ "\nLong: " + longitude, 5000).show();
    					
    				    // Callback is invoked with any exceptions/errors, and the result, if available.
    			} else {
    				// can't get location
    				// GPS or Network is not enabled
    				// Ask user to enable GPS/network in settings
    				gps.showSettingsAlert();
    			}
    		}
    	});
    }
    private class JSONParse extends AsyncTask<String, String, JSONObject> {
         private ProgressDialog pDialog;
        @Override
        protected void onPreExecute() {
            super.onPreExecute();
             ver = (TextView)findViewById(R.id.vers);
             name = (TextView)findViewById(R.id.name);
             api = (TextView)findViewById(R.id.api);
            pDialog = new ProgressDialog(Home.this);
            pDialog.setMessage("Getting Data ...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(true);
            pDialog.show();
        }
        @Override
        protected JSONObject doInBackground(String... args) {
            JSONParser jParser = new JSONParser();
            // Getting JSON from URL
            System.out.println(latitude + " " + longitude + " test");
            String url = "http://192.168.1.100:3000/getNearestStores/" + latitude +"/"+ longitude +"/20";
            System.out.println(url);
            JSONObject json = jParser.getJSONFromUrl(url);
            return json;
        }
         @Override
         protected void onPostExecute(JSONObject json) {
             pDialog.dismiss();
             try {
                    // Getting JSON Array from URL
            	
            	System.out.println(json);
            	android = json.getJSONArray(TAG_OS);
                    for(int i = 0; i < android.length(); i++){
                    JSONObject c = android.getJSONObject(i);
                    // Storing  JSON item in a Variable
                    String ver = c.getString(TAG_VER);
                    String name = c.getString(TAG_NAME);
                    String api = c.getString(TAG_API);
                    // Adding value HashMap key => value
                    HashMap<String, String> map = new HashMap<String, String>();
                    map.put(TAG_VER, ver);
                    map.put(TAG_NAME, name);
                    map.put(TAG_API, api);
                    oslist.add(map);
                    list=(ListView)findViewById(R.id.list);
                    ListAdapter adapter = new SimpleAdapter(Home.this, oslist,
                            R.layout.list_v,
                            new String[] { TAG_VER,TAG_NAME, TAG_API }, new int[] {
                                    R.id.vers,R.id.name, R.id.api});
                    list.setAdapter(adapter);
                    list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                        @Override
                        public void onItemClick(AdapterView<?> parent, View view,
                                                int position, long id) {
                            Toast.makeText(Home.this, "You Clicked at "+oslist.get(+position).get("name"), Toast.LENGTH_SHORT).show();
                        }
                    });
                    }
            } catch (JSONException e) {
                e.printStackTrace();
            }
         }
    }
}


