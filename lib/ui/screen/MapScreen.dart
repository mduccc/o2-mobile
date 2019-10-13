import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:o2_mobile/blocs/LoginBloC.dart';
import 'package:o2_mobile/models/AccModel.dart';
import '../ThemseColors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';

class MapScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapScreen();
  }
}

class _MapScreen extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    loginBloC.info();
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

  Widget _map(double lat, double lon, String place_name, String place_id) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
          child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, lon),
                zoom: 13,
              ),
              onMapCreated: (GoogleMapController controller) {
                print('Map created');
                Completer().complete(controller);
              },
              circles: Set.from([
                Circle(
                    circleId: CircleId(place_id),
                    center: LatLng(lat, lon),
                    strokeColor: Colors.red,
                    fillColor: Colors.red,
                    strokeWidth: 30,
                    radius: 15,
                    visible: true)
              ]),
              markers: Set.from([
                Marker(
                  markerId: MarkerId(place_id),
                  position: LatLng(lat, lon),
                  infoWindow: InfoWindow(
                    title: place_name,
                    snippet: 'Vị trí đặt cảm biến',
                  ),
                ),
              ])),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Permission.getPermissionsStatus([PermissionName.Location]).then((_) async {
      if (_[0].permissionStatus != PermissionStatus.allow) {
        print('No permission');
        await Permission.requestPermissions([PermissionName.Location]);
      }
    });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: ThemseColors.primaryColor,
          elevation: 0,
          title: Text(''),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: ThemseColors.primaryColor,
        body: Container(
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: ThemseColors.secondColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: StreamBuilder(
                    stream: accInfoPublishSubject.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasError) {
                        if (snapshot.hasData) {
                          AccModel accModel = snapshot.data;
                          if (accModel.code == 200) {
                            return FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                accModel.place_name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else
                            return Text('');
                        }
                      }
                      return Text('');
                    },
                  ),
                ),
              ),
              Expanded(
                  flex: 10,
                  child: StreamBuilder(
                    stream: accInfoPublishSubject.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasError) {
                        if (snapshot.hasData) {
                          AccModel accModel = snapshot.data;
                          if (accModel.code == 200) {
                            return _map(
                                double.parse(accModel.place_coord.lat),
                                double.parse(accModel.place_coord.lon),
                                accModel.place_name,
                                accModel.place_id);
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }
                      }

                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ))
            ],
          ),
        ));
  }
}
