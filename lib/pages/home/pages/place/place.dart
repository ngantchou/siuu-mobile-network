import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:Siuu/res/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesPage extends StatefulWidget {
  @override
  _PlacesPageState createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {
  GoogleMapController _mapController;
  LatLng _initialPosition = LatLng(51.514248, -0.093145);

  Set<Marker> _markers = HashSet<Marker>();
  // BitmapDescriptor _markerIcon;
  // Uint8List markerIcon;
  // Marker marker;

  Uint8List markerIcon;
  Marker marker;

  void _setMarkerIcon() async {
    markerIcon = await getBytesFromAsset('assets/images/marker.png', 100);

    // _markerIcon = await BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(), 'assets/images/marker.png');
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;

    setState(
      () {
        _markers.add(
          Marker(
            position: LatLng(51.515658, -0.053658),
            markerId: MarkerId('1'),
            icon: BitmapDescriptor.fromBytes(markerIcon),
          ),
        );
        _markers.add(
          Marker(
            position: LatLng(53.5, -1.016667),
            markerId: MarkerId('1'),
            icon: BitmapDescriptor.fromBytes(markerIcon),
          ),
        );
        _markers.add(
          Marker(
            position: LatLng(53.5, -0.0916667),
            markerId: MarkerId('1'),
            icon: BitmapDescriptor.fromBytes(markerIcon),
          ),
        );
        // _markers.add(
        //   Marker(
        //       markerId: MarkerId('1'),
        //       position: LatLng(51.515658, -0.053658),
        //       icon: _markerIcon),
        // );
        //   _markers.add(
        //     Marker(
        //         markerId: MarkerId('2'),
        //         position: LatLng(53.5, -2.216667),
        //         icon: _markerIcon),
        //   );
      },
    );

    _setMapStyle();
  }

  void _setMapStyle() async {
    String style = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _mapController.setMapStyle(style);
  }

  @override
  void initState() {
    super.initState();
    _setMarkerIcon();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: GoogleMap(
                myLocationButtonEnabled: true,
                compassEnabled: false,
                zoomControlsEnabled: false,
                markers: _markers,
                onMapCreated: _onMapCreated,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 12,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: new Container(
                height: height * 0.0585,
                width: width * 0.2430,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0.00, 20.00),
                      color: Color(0xff000000).withOpacity(0.16),
                      blurRadius: 20,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(40.00),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment(-1, 1),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3)),
                        height: height * 0.0541,
                        width: width * 0.0945,
                        child: Image.asset(
                          'assets/images/person1.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(-0.2, 1),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3)),
                        height: height * 0.0541,
                        width: width * 0.0945,
                        child: Image.asset(
                          'assets/images/person1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0.8, 1),
                      child: new Container(
                        height: height * 0.0541,
                        width: width * 0.0945,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: linearGradient,
                        ),
                        child: Center(
                          child: new Text(
                            "+5",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Arial",
                              fontSize: 11,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xff535353),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    height: height * 0.057,
                    width: width * 0.777,
                    decoration: BoxDecoration(
                      color: Color(0xffffffff).withOpacity(0.68),
                      border: Border.all(
                        width: width * 0.002,
                        color: Color(0xff433f59).withOpacity(0.68),
                      ),
                      borderRadius: BorderRadius.circular(30.00),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 10),
                          icon: SvgPicture.asset(
                            'assets/svg/search.svg',
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(width: width * 0.024),
                  SvgPicture.asset('assets/svg/rotate.svg')
                ],
              ),
            ),
            Positioned(
              bottom: 100,
              child: SizedBox(
                height: height * 0.161,
                width: width,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    buildListViewContainer(),
                    buildListViewContainer(),
                    buildListViewContainer(),
                    buildListViewContainer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildListViewContainer() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: Container(
        height: height * 0.161,
        width: width * 0.580,
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          boxShadow: [
            BoxShadow(
              offset: Offset(0.00, 20.00),
              color: Color(0xff000000).withOpacity(0.16),
              blurRadius: 20,
            ),
          ],
          borderRadius: BorderRadius.circular(5.00),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.073,
                        width: width * 0.121,
                        child: Image.asset(
                          'assets/images/christopher.png',
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.015),
                          buildText(
                            color: 0xff4D0CBB,
                            maxfontsize: 11,
                            minfontsize: 8,
                            text: 'Sarah Tyker',
                          ),
                          buildText(
                            maxfontsize: 7,
                            minfontsize: 5,
                            color: 0xff97abb3,
                            text: 'Mémories',
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/marker.svg',
                        color: Color(0xff3e494e),
                      ),
                      SizedBox(width: width * 0.024),
                      buildText(
                        maxfontsize: 5,
                        minfontsize: 3,
                        color: 0xff97abb3,
                        text: '2.0 m',
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: width * 0.121,
                  ),
                  buildText(
                    color: 0xff97abb3,
                    maxfontsize: 10,
                    minfontsize: 8,
                    fontWeight: FontWeight.w300,
                    text:
                        'Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  AutoSizeText buildText(
      {String text,
      double maxfontsize,
      double minfontsize,
      FontWeight fontWeight,
      double fontSize,
      int color}) {
    return AutoSizeText(
      text,
      maxFontSize: maxfontsize,
      minFontSize: minfontsize,
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontWeight: fontWeight,
        // fontSize: fontSize,
        color: Color(color),
      ),
    );
  }
}
