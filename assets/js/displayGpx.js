function displayGpx(elt) {
    if (!elt) return;

    function _t(t) {
        return elt.getElementsByTagName(t)[0];
    }

    function _c(c) {
        return elt.getElementsByClassName(c)[0];
    }

    var mapid = elt.getAttribute('data-map-target');
    var track_url = elt.getAttribute('data-gpx-source');
    var track_color = elt.getAttribute('data-track-color');
    var hide_elevation_profile = elt.getAttribute('data-hide-elevation-profile');
    var pin_bp = elt.getAttribute('data-pin-base-path');

    var map = L.map(mapid);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: 'Map data &copy; <a href="http://www.osm.org">OpenStreetMap</a>'
    }).addTo(map);


    if (hide_elevation_profile != 'true') {
        var el = L.control.elevation({
            position: "bottom",
            theme: "lime-theme", //default: lime-theme
            height: 100,
            margins: {
                top: 10,
                right: 20,
                bottom: 30,
                left: 50
            },
            useHeightIndicator: false, //if false a marker is drawn at map position
            hoverNumber: {
                decimalsX: 3, //decimals on distance (always in km)
                decimalsY: 0, //deciamls on hehttps://www.npmjs.com/package/leaflet.coordinatesight (always in m)
                formatter: undefined //custom formatter function may be injected
            },
            xTicks: undefined, //number of ticks in x axis, calculated by default according to width
            yTicks: undefined, //number of ticks on y axis, calculated by default according to height
            collapsed: true,  //collapsed mode, show chart on click or mouseover
            imperial: false    //display imperial units instead of metric
        });
        el.addTo(map);
    }

    new L.GPX(track_url, {
        polyline_options: {
            color: track_color,
            opacity: 0.75,
            weight: 3,
            lineCap: 'round'
        },
        async: true,
        marker_options: {
            startIconUrl: pin_bp + 'pin-icon-start.png',
            endIconUrl: pin_bp + 'pin-icon-end.png',
            shadowUrl: pin_bp + 'pin-shadow.png'
        },
    }).on("addline", function (e) {
        if (hide_elevation_profile != 'true') {
            el.addData(e.line);
        }
    }).on('loaded', function (e) {
        var gpx = e.target;
        map.fitBounds(gpx.getBounds());

        //_c('track-name').textContent = gpx.get_name();
        //_c('start').textContent = gpx.get_start_time().toDateString() + ', '
            //+ gpx.get_start_time().toLocaleTimeString();

        var mts = gpx.get_distance();
        var kms = mts / 1000;

        _c('distance').textContent = kms.toFixed(2);
        //_c('duration').textContent = gpx.get_duration_string(gpx.get_moving_time());
        _c('elevation-max').textContent = gpx.get_elevation_max().toFixed(0);
        _c('elevation-min').textContent = gpx.get_elevation_min().toFixed(0);
    }).addTo(map);

    el.clear();
}