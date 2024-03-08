import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


String userName = "";
String userPhone = "";
String userID = FirebaseAuth.instance.currentUser!.uid;

String googleMapKey = "AIzaSyAb-hN3ggF3AYjRma1aICIdus9EAx0vECM";
String serverKeyFCM = "key=AAAA94KBeYI:APA91bFg0qU4u5FFtObCJu4noLWDQsQHoI_vg4APoyCnLoGcXXq5MhZ8JuR3ojiJMC71u4NxdJ3hkQzcqeEK5GXg43m3ff255jiSm_8-f0r2b1wy2pBbDMGf7WPxV4eD6kstyad9q6dR";

const CameraPosition googlePlexInitialPosition = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);