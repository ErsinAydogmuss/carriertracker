import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yetis_mobile/models/enums.dart';
import 'package:yetis_mobile/models/order.dart';
import 'package:yetis_mobile/screens/user/order_tracking_screen.dart';
import 'package:yetis_mobile/services/order_service.dart';
import 'package:yetis_mobile/widgets/texts/head.dart';
import '../../constants/app_color.dart';
import '../../constants/constants.dart';
import '../../widgets/modals/info_modal.dart';
import '../../widgets/other/loading.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  MyOrdersScreenState createState() => MyOrdersScreenState();
}

class MyOrdersScreenState extends State<MyOrdersScreen> {
  bool isLoading = true;
  List<Order> orders = [];
  int? userId;
  GetStorage box = GetStorage();

  @override
  void initState() {
    super.initState();
    userId = box.read('user')['id'];
    getMyOrders();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getMyOrders() async {
    setState(() {
      isLoading = true;
    });

    var response = await OrderService().getMyOrders();

    if (response.success) {
      setState(() {
        orders = response.data;
      });
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
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child:
          ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderTrackingScreen(
                          order: orders[index],
                        )
                    ),
                  );
                },
                child: Card(
                  color: AppColor(mainLightColor),
                  child: ListTile(
                      title: Text(orders[index].product, style: GoogleFonts.inconsolata(
                        color: AppColor(whiteColor),
                        fontSize: mediumFontSize,
                        fontWeight: FontWeight.bold,
                      ),),
                      subtitle: Text(parseOrderStatus(orders[index].status!),
                        style: GoogleFonts.inconsolata(
                        color: orders[index].status == OrderStatus.PENDING ? AppColor(yellowColor) :
                        orders[index].status == OrderStatus.COMPLETED ? AppColor(redColor).withOpacity(0.7) :
                        AppColor(redColor),
                        fontSize: smallFontSize,
                      ),),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColor(whiteColor),
                      )
                  ),
                ),
              );
            },
          ),
        ),
        if (isLoading) const Loading(),
      ],
    );
  }
}
