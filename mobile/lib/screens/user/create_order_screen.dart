import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:yetis_mobile/services/order_service.dart';
import 'package:yetis_mobile/widgets/button/button.dart';
import 'package:yetis_mobile/widgets/form/input.dart';
import 'package:yetis_mobile/widgets/texts/head.dart';
import '../../constants/app_color.dart';
import '../../constants/constants.dart';
import '../../widgets/modals/info_modal.dart';
import '../../widgets/other/loading.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  CreateOrderScreenState createState() => CreateOrderScreenState();
}

class CreateOrderScreenState extends State<CreateOrderScreen> {
  bool isLoading = false;
  final TextEditingController _productController = TextEditingController();
  LatLng? _currentLocation;
  LatLng? _selectedLocation;
  Future<LatLng>? _locationFuture;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _mapInitialized = false;
  int? userId;
  GetStorage box = GetStorage();

  @override
  void initState() {
    super.initState();
    userId = box.read('user')['id'];
    _locationFuture = _determinePosition();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
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
        _mapInitialized = true;  // Set map as initialized here
      });

      return latLng;

    } catch (e) {
      return Future.error('Location permissions are denied');
    }

  }

  void _startLocationUpdates() {
    _positionStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      if (_mapInitialized) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });
      }
    });
  }

  createOrder() async {
    setState(() {
      isLoading = true;
    });

    var response = await OrderService().createOrder(
      product: _productController.text,
      latitude: _selectedLocation!.latitude.toString(),
      longitude: _selectedLocation!.longitude.toString(),
      userId: userId!,
    );

    if (response.success) {
      setState(() {
        isLoading = false;
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

    setState(() {
      _productController.clear();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              FormInput(
                labelText: "Taşınacak Ürün",
                hintText: "Ürünün adını giriniz",
                prefixIcon: Icons.shopping_bag,
                controller: _productController,
                hintFontSize: xSmallFontSize,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              Head(
                text: "Taşınacak yeri harita üzerinden işaretleyin",
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
                          onTap: (point, latlng) {
                            print(latlng);
                            setState(() {
                              _selectedLocation = latlng;
                            });
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app/yetis_mobile',
                          ),
                          MarkerLayer(
                            markers: [
                              if (_currentLocation != null)
                                Marker(
                                  point: _currentLocation!,
                                  child: const Icon(
                                    Icons.circle,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                ),
                              if (_selectedLocation != null)
                                Marker(
                                  point: _selectedLocation!,
                                  child: const Icon(
                                    Icons.card_giftcard,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: Text('Konum alınamadı'));
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Button(
                  onTap: () async {
                    if (_selectedLocation == null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return InfoModal(
                            iconColor: AppColor(mainColor),
                            text: 'Lütfen taşınacak yeri harita üzerinden işaretleyin',
                            icon: Icons.warning,
                          );
                        },
                      );
                    } else if (_productController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return InfoModal(
                            iconColor: AppColor(mainColor),
                            text: 'Lütfen taşınacak ürünü giriniz',
                            icon: Icons.warning,
                          );
                        },
                      );
                    }
                    else {
                      await createOrder();
                    }
                  },
                  size: Size.medium,
                  buttonText: 'Siparişi Oluştur',
                ),
              ),
            ],
          ),
        ),
        if (isLoading) const Loading(),
      ],
    );
  }
}
