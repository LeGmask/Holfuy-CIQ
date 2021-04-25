using Toybox.Application;
using Toybox.System;
using Toybox.Communications;
using Toybox.WatchUi as Ui;
using Toybox.Application;
using Toybox.Application.Properties as Properties;

const BASE_URL = "https://api.holfuy.com/live/?m=JSON&tu=C&su=knots";


class holfuyApp extends Application.AppBase {

    private var _settings;

    function initialize() {
        AppBase.initialize();
        _settings = loadSettings();
        System.println(_settings);
    }

    // onStart() is called on application start up
    function onStart(state) {
        System.println( "Getting data!" );
        try {
            makeRequest();
        } catch (ex) {
            System.println(ex);
            Ui.switchToView(new textView("Error :\n" + ex), null, Ui.SLIDE_IMMEDIATE);
            System.error(ex);
        }
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new textView("Loading...") ];
    }

    function onSettingsChanged() {
        Ui.switchToView(new textView("Loading..."), null, Ui.SLIDE_IMMEDIATE);
        System.println( "Getting data!" );
        try {
            makeRequest();
        } catch (ex) {
            System.println(ex);
        }
        
    }

    function onReceive(responseCode, data) {
       Ui.switchToView(new holfuyView(data), null, Ui.SLIDE_IMMEDIATE);
    }

    function makeRequest() {
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        var responseCallback = method(:onReceive);
        System.println(BASE_URL + "&s=" + _settings["id"] + "&pw=" + _settings["pwd"]);

        Communications.makeWebRequest(BASE_URL + "&s=" + _settings["id"] + "&pw=" + _settings["pwd"], null, options, method(:onReceive));
    }

    function loadSettings() {
        var station_id = Storage.getValue("station_id");
        if (station_id == null) {
            station_id = 101;
            Storage.setValue("station_id", station_id);
        }
        var station_pwd = Storage.getValue("station_pwd");
        if (station_pwd == null) {
            station_pwd = "pass";
            Storage.setValue("station_pwd", station_pwd);
        }
        return {"id" => station_id, "pwd" => station_pwd};
    }
}


