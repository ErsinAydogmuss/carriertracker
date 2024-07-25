import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:yetis_mobile/services/carrier_service.dart';
import 'package:yetis_mobile/services/order_service.dart';
import 'package:yetis_mobile/widgets/button/button.dart';
import 'package:yetis_mobile/widgets/texts/head.dart';
import '../../constants/app_color.dart';
import '../../constants/constants.dart';
import '../../models/enums.dart';
import '../../models/order.dart';
import '../../services/socket.dart';
import '../../widgets/modals/info_modal.dart';
import '../../widgets/other/loading.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  DeliveryScreenState createState() => DeliveryScreenState();
}

class DeliveryScreenState extends State<DeliveryScreen> {
  bool isLoading = false;
  LatLng? _currentLocation;
  Future<LatLng>? _locationFuture;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _mapInitialized = false;
  int? carrierId;
  GetStorage box = GetStorage();
  Order? order;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    carrierId = box.read('user')['carrierId'];
    _locationFuture = _determinePosition();
    _startLocationUpdates();
    getMyDelivery();
    _startPeriodicLocationUpdate();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  getMyDelivery() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await OrderService().getMyDelivery(carrierId!);

      if (response.success) {
        if(response.data == null) {
          if(!mounted) return;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return InfoModal(
                iconColor: AppColor(mainColor),
                text: 'Henüz teslim edilecek paketiniz yok',
                icon: Icons.warning,
              );
            },
          );
          return;
        } else {
          setState(() {
            order = response.data;
          });
        }
      } else {
        if(!mounted) return;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return InfoModal(
              iconColor: AppColor(mainColor),
              text: response.message!,
              icon: Icons.warning,
            );
          },
        );
      }
    } catch (e) {
      if(!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return InfoModal(
            iconColor: AppColor(mainColor),
            text: 'Bir hata oluştu',
            icon: Icons.warning,
          );
        },
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _startPeriodicLocationUpdate() {
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      if (_currentLocation != null) {
        updateLocation();
      }
    });
  }

  updateLocation() async {
    setState(() {
      isLoading = true;
    });

    await CarrierService().updateLocation(
        carrierId: carrierId!,
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude
    );

    setState(() {
      isLoading = false;
    });
  }

  Future<LatLng> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    try {
      var location = await Geolocator.getCurrentPosition();
      final latLng = LatLng(location.latitude, location.longitude);

      setState(() {
        _currentLocation = latLng;
        _mapInitialized = true;
      });

      return latLng;

    } catch (e) {
      return Future.error('Location permissions are denied');
    }
  }

  void _startLocationUpdates() {
    _positionStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      if (_mapInitialized ) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });
      }
    });
  }

  finishDelivery() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await CarrierService().finishDelivery(orderId: order!.id);

      if (response.success) {


        final socketService = Provider.of<SocketService>(context, listen: false);


        print(order!.user!.id.toString());
        print(order!.id.toString());
        print(OrderStatus.COMPLETED.toString().split('.').last);
        print(DateTime.now().toString());

        socketService.sendNotification(
          order!.assignedBy!.user!.id.toString(),
          order!.id.toString(),
          OrderStatus.COMPLETED.toString().split('.').last,
          DateTime.now().toString(),
        );

        setState(() {
          order = null;
        });

        if(!mounted) return;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return InfoModal(
              iconColor: AppColor(mainColor),
              text: response.message!,
              icon: Icons.check_circle,
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
    } catch (e) {
      print(e);
      if(!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return InfoModal(
            iconColor: AppColor(mainColor),
            text: 'Bir hata oluştu',
            icon: Icons.error,
          );
        },
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Head(
                text: order == null ? 'Teslimatınız bulunmamaktadır' : 'Teslimatınız Devam Ediyor',
                size: Size.small,
                color: AppColor(mainColor),
                icon: Icons.location_on,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 500,
                child: FutureBuilder<LatLng>(
                  future: _locationFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Hata: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return FlutterMap(
                        options: MapOptions(
                          onMapReady: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                _mapInitialized = true;
                              });
                            });
                          },
                          initialCenter: _currentLocation ?? snapshot.data!,
                          initialZoom: 17,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app/yetis_mobile',
                          ),
                          MarkerLayer(
                            markers: [
                              if (order != null)
                                Marker(
                                  point: LatLng(order!.moveTo!.latitude, order!.moveTo!.longitude),
                                  child: Icon(
                                    Icons.card_giftcard,
                                    color: AppColor(mainColor),
                                    size: 30,
                                  ),
                                ),
                              if (_currentLocation != null)
                                Marker(
                                  point: _currentLocation!,
                                  child: const Icon(
                                    Icons.circle,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                ),
                            ],
                          ),
                          order == null ? const SizedBox() :
                          PolylineLayer(polylines: [
                            Polyline(
                              points: [
                                _currentLocation ?? snapshot.data!,
                                LatLng(order!.moveTo!.latitude, order!.moveTo!.longitude),

                              ],
                              strokeWidth: 2,
                              color: AppColor(mainColor),
                            ),
                          ]),
                        ],
                      );
                    } else {
                      return const Center(child: Text('Konum alınamadı'));
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Button(
                  onTap: () async {
                    await finishDelivery();
                  },
                  buttonText: "Teslimatı Tamamla",
                size: Size.large,
              )
            ],
          ),
        ),
        if (isLoading) const Loading(),
      ],
    );
  }
}
