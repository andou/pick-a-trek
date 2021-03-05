
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

    var map = L.map(mapid);
    L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: 'Map data &copy; <a href="http://www.osm.org">OpenStreetMap</a>'
    }).addTo(map);

    new L.GPX(track_url, {
        polyline_options: {
            color: track_color,
            opacity: 0.75,
            weight: 3,
            lineCap: 'round'
        },
        async: true,
        marker_options: {
            startIconUrl: 'http://mpetazzoni.github.io/leaflet-gpx/pin-icon-start.png',
            endIconUrl: 'http://mpetazzoni.github.io/leaflet-gpx/pin-icon-end.png',
            shadowUrl: 'http://mpetazzoni.github.io/leaflet-gpx/pin-shadow.png'
        },
    }).on('loaded', function (e) {
        var gpx = e.target;
        map.fitBounds(gpx.getBounds());

        _c('track-name').textContent = gpx.get_name();
        _c('start').textContent = gpx.get_start_time().toDateString() + ', '
            + gpx.get_start_time().toLocaleTimeString();

        var mts = gpx.get_distance();
        var kms = mts / 1000;

        _c('distance').textContent = kms.toFixed(2);
        _c('duration').textContent = gpx.get_duration_string(gpx.get_moving_time());
        _c('elevation-max').textContent = gpx.get_elevation_max().toFixed(0);
        _c('elevation-min').textContent = gpx.get_elevation_min().toFixed(0);
    }).addTo(map);
}