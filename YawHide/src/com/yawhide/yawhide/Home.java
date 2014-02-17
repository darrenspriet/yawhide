package com.yawhide.yawhide;

import java.util.ArrayList;
import java.util.HashMap;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
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

public class Home extends Activity {
    ListView list;
    TextView ver;
    TextView name;
    TextView api;
    Button Btngetdata;
    ArrayList<HashMap<String, String>> oslist = new ArrayList<HashMap<String, String>>();
    
    //JSON Node Names
    private static final String TAG_STORENAME = "storeName";
    private static final String TAG_CITY = "city";
    private static final String TAG_POSTALCODE = "postalCode";
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
            	ConnectivityManager cm = (ConnectivityManager) (Home.this).getSystemService(Context.CONNECTIVITY_SERVICE);
            	NetworkInfo info = cm.getActiveNetworkInfo();
            	if(info != null && info.isConnected()){
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
        				new JSONParse().execute();
        			} else {
        				// can't get location
        				// GPS or Network is not enabled
        				// Ask user to enable GPS/network in settings
        				gps.showSettingsAlert();
        			}
            	}
            	else{
            		Toast.makeText(Home.this, "Please connect to wifi or turn data on", Toast.LENGTH_SHORT).show();
            	}
            }
        });
        
    }
    private class JSONParse extends AsyncTask<String, String, JSONArray> {
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
           // pDialog.show();
        }
        @Override
        protected JSONArray doInBackground(String... args) {
            JSONParser jParser = new JSONParser();
            // Getting JSON from URL
           // System.out.println(latitude + " " + longitude + " test");
            String lat ="43.567532";// String.valueOf(43.567532);
            String lon = "-79.770965";//String.valueOf(-79.770965");
            String url = "http://darrenspriet.apps.runkite.com/getNearestStores/" + lat +"/"+ lon +"/20";
           // System.out.println(url);
            JSONArray json = jParser.getJSONFromUrl(url);
            //System.out.println(json);
            return json;
        }
        
         @Override
         protected void onPostExecute(JSONArray json) {
             pDialog.dismiss();
             try {
                    // Getting JSON Array from URL
            	
            	//System.out.println(json);
            	android = json;
            	for(int i = 0; i < android.length(); i++){
            		JSONObject c = android.getJSONObject(i);
                    // Storing  JSON item in a Variable
                    String ver = "Sobeys - " + c.getString(TAG_STORENAME);
                    String name = c.getString(TAG_CITY);
                    String api = c.getString(TAG_POSTALCODE);
                    // Adding value HashMap key => value
                    HashMap<String, String> map = new HashMap<String, String>();
                    map.put(TAG_STORENAME, ver);
                    oslist.add(map);
                    list=(ListView)findViewById(R.id.list);
                    ListAdapter adapter = new SimpleAdapter(Home.this, oslist,
                            R.layout.list_v,
                            new String[] { TAG_STORENAME,TAG_CITY, TAG_POSTALCODE }, new int[] {
                                    R.id.vers,R.id.name, R.id.api});
                    list.setAdapter(adapter);
                    list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                        @Override
                        public void onItemClick(AdapterView<?> parent, View viewClicked,
                                                int position, long id) {
//                        	TextView textView = (TextView) viewClicked;
                        	TextView text = (TextView) viewClicked.findViewById(R.id.vers);
                            String lst_txt = text.getText().toString().trim();
                            System.out.println("this is value of string ::: :::: " + lst_txt);
                           Toast.makeText(Home.this, "You Clicked at "+position, Toast.LENGTH_SHORT).show();
                         	//TextView textView = (TextView) viewClicked;
//                        	String message = "You clicked # " + position + ", which is string: " + textView.getText().toString();
//                        	Toast.makeText(Home.this, message, Toast.LENGTH_LONG).show();
                        }
                    });
            	}
            } catch (JSONException e) {
                e.printStackTrace();
            }
         }
    }
}





