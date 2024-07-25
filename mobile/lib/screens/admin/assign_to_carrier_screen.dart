import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:yetis_mobile/services/carrier_service.dart';
import 'package:yetis_mobile/widgets/texts/head.dart';
import '../../constants/app_color.dart';
import '../../constants/constants.dart';
import '../../models/carrier.dart';
import '../../models/order.dart';
import '../../widgets/modals/info_modal.dart';
import '../../widgets/other/loading.dart';

class AssignToCarrierScreen extends StatefulWidget {
  final Order order;
  final Function getPendingCarrierList;

  const AssignToCarrierScreen({
    super.key,
    required this.order,
    required this.getPendingCarrierList,
  });

  @override
  AssignToCarrierScreenState createState() => AssignToCarrierScreenState();
}

class AssignToCarrierScreenState extends State<AssignToCarrierScreen> {
  bool isLoading = false;
  bool isHasCarrier = false;

  StreamSubscription<Position>? _positionStreamSubscription;
  int? userId;

  List<Carrier> carriers = [];

  @override
  void initState() {
    super.initState();
    getPendingCarrierList();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  getPendingCarrierList() async {
    setState(() {
      isLoading = true;
    });

    var response = await CarrierService().getPendingCarrierList();

    if (response.success) {
      setState(() {
        carriers = response.data;
      });

      if (carriers.isNotEmpty) {
        isHasCarrier = true;
      } else {
        isHasCarrier = false;
      }
    } else {
      if(!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return InfoModal(
            iconColor: AppColor(mainColor),
            text: response.message!,
            icon: Icons.error,
          );
        },
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  assignToCarrier(int carrierId) async {
    setState(() {
      isLoading = true;
    });


    var response = await CarrierService().assignToCarrier(
      orderId: widget.order.id,
      carrierId: carrierId,
    );

    if (response.success) {

      setState(() {
        carriers.where((element) => element.id == carrierId).first.isReady = false;
      });

      if(!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return InfoModal(
            iconColor: AppColor(mainColor),
            text: response.message!,
            icon: Icons.check_circle,
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              widget.getPendingCarrierList();
            },
          );
        },
      );
    } else {
      if(!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return InfoModal(
            iconColor: AppColor(mainColor),
            text: response.message!,
            icon: Icons.error,
          );
        },
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        title: Head(
          text: "Taşıyıcı Ata",
          size: Size.large,
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
            child: isHasCarrier ? Column(
              children: [
                Head(
                  text: "Müsait olan bir taşıyıcıyı seçiniz",
                  size: Size.small,
                  color: AppColor(mainColor),
                  icon: Icons.location_on,
                ),
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
                            child: IconButton(
                              icon : Icon(
                                Icons.card_giftcard,
                                color: AppColor(mainColor),
                                size: 30,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          for (Carrier carrier in carriers)
                            Marker(
                              point: LatLng(carrier.location!.latitude, carrier.location!.longitude),
                              child: IconButton(
                                icon : Icon(
                                  Icons.delivery_dining_rounded,
                                  color: carrier.isReady ? AppColor(mainColor) : AppColor(grayColor),
                                  size: 40,
                                ),
                                onPressed: () {
                                  if (carrier.isReady) {
                                    assignToCarrier(carrier.id);
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return InfoModal(
                                          iconColor: AppColor(mainColor),
                                          text: "Taşıyıcı şu anda müsait değil",
                                          icon: Icons.error,
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ) :
            Center(
              child: Text(
                "Müsait taşıyıcı bulunamadı",
                style: TextStyle(
                  color: AppColor(mainColor),
                  fontSize: mediumFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (isLoading) const Loading(),
        ],
      ),
    );
  }
}
