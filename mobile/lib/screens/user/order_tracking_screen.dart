import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:yetis_mobile/models/enums.dart';
import 'package:yetis_mobile/widgets/texts/head.dart';
import '../../constants/app_color.dart';
import '../../constants/constants.dart';
import '../../models/order.dart';
import '../../widgets/other/loading.dart';

class OrderTrackingScreen extends StatefulWidget {
  final Order order;

  const OrderTrackingScreen({
    super.key,
    required this.order,
  });

  @override
  OrderTrackingScreenState createState() => OrderTrackingScreenState();
}

class OrderTrackingScreenState extends State<OrderTrackingScreen> {
  bool isLoading = false;
  int? userId;
  GetStorage box = GetStorage();

  @override
  void initState() {
    super.initState();
    userId = box.read('user')['id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        title: Head(
          text: "Kuryenizi ve ulaşacağı yeri takip edin!",
          size: Size.medium,
          color: AppColor(mainColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  height: 500,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(widget.order.moveTo!.latitude, widget.order.moveTo!.longitude),
                      initialZoom: 17,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app/yetis_mobile',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(widget.order.moveTo!.latitude, widget.order.moveTo!.longitude),
                            child: const Icon(
                              Icons.card_giftcard,
                              color: Colors.blue,
                              size: 30,
                            ),
                          ),
                          if (widget.order.status == OrderStatus.ASSIGNED)
                            Marker(
                              point: LatLng(widget.order.assignedTo!.location!.latitude, widget.order.assignedTo!.location!.longitude),
                              child: Icon(
                                Icons.delivery_dining_rounded,
                                color: AppColor(mainColor),
                                size: 30,
                              ),
                            ),
                        ],
                      ),
                      widget.order.status == OrderStatus.ASSIGNED ?
                      PolylineLayer(polylines: [
                        Polyline(
                          points: [
                            LatLng(widget.order.moveTo!.latitude, widget.order.moveTo!.longitude),
                            LatLng(widget.order.assignedTo!.location!.latitude, widget.order.assignedTo!.location!.longitude),
                          ],
                          strokeWidth: 2,
                          color: AppColor(mainColor),
                        ),
                      ]) : const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                widget.order.assignedTo != null ?
                Column(
                  children: [
                    Head(
                      text: "Kuryenizin Bilgileri",
                      size: Size.medium,
                      color: AppColor(mainColor),
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 10),
                    Card(
                      color: AppColor(mainLightColor),
                      child: ListTile(
                        title: Text(widget.order.assignedTo!.user!.name, style: GoogleFonts.inconsolata(
                          color: AppColor(whiteColor),
                          fontSize: mediumFontSize,
                          fontWeight: FontWeight.bold,
                        ),),
                        subtitle: Text(widget.order.assignedTo!.user!.email, style: GoogleFonts.inconsolata(
                          color: AppColor(whiteColor),
                          fontSize: smallFontSize,
                        ),),
                        trailing: Icon(
                          Icons.phone,
                          color: AppColor(whiteColor),
                        ),
                      ),
                    ),
                  ],
                ) : const SizedBox(),
              ],
            ),
          ),
          if (isLoading) const Loading(),
        ],
      ),
    );
  }
}
