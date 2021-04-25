using Toybox.WatchUi;
using Toybox.System;
using Toybox.Lang;

class holfuyView extends WatchUi.View {

    hidden var _data;
    private var _arrow = [[0,0], [-2,1], [0,-4], [2,1], [0,0]];

    function initialize(data) {
        View.initialize();
        _data = data;
        System.println(data);
    }  

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
        try {
            // View.findDrawableById("date").setText(_data["dateTime"]);
            View.findDrawableById("temperature").setText(_data["temperature"].format("%.2f") + " °C");
            View.findDrawableById("wind_speed").setText(_data["wind"]["speed"].format("%.1f") + " " + _data["wind"]["unit"]);
            View.findDrawableById("wind_gust").setText("+ " + _data["wind"]["gust"].format("%.1f") + " " + _data["wind"]["unit"]);
        } catch (ex) {
            System.println(ex);
            WatchUi.switchToView(new textView("Error :\n" + ex), null, WatchUi.SLIDE_IMMEDIATE);
            // System.error(ex);
        }

    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        try {
            View.onUpdate(dc);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            fillPolygon(dc,5,5,dc.getWidth() / 2, dc.getHeight() / 2, 180 + _data["wind"]["direction"] , _arrow);
        } catch (ex) {
            System.println(ex);
            WatchUi.switchToView(new textView("Error :\n" + ex), null, WatchUi.SLIDE_IMMEDIATE);
            // System.error(ex);
        }

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    function fillPolygon(dc, sx, sy, dx, dy, theta, points) {
        if(dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }
        theta = degToRad(theta);
        var sin = Math.sin(theta);
        var cos = Math.cos(theta);

        var coords = new [points.size()];
        for (var i = 0; i < points.size(); ++i) {

            // make a copy so as to not modify the points array
            coords[i] = [ points[i][0] * sx, points[i][1] * sy ];

            var x = (coords[i][0] * cos) - (coords[i][1] * sin) + dx;
            var y = (coords[i][0] * sin) + (coords[i][1] * cos) + dy;
            coords[i][0] = x;
            coords[i][1] = y;
        }
        dc.fillPolygon(coords);
    }

    function degToRad(deg) {
        return deg*Math.PI/180;
    }

    function radToDeg(rad) {
        return rad*180/Math.PI;
    } 
}
    