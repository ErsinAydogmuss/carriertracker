import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yetis_mobile/screens/admin/assign_to_carrier_screen.dart';
import 'package:yetis_mobile/services/order_service.dart';
import '../../constants/app_color.dart';
import '../../constants/constants.dart';
import '../../models/order.dart';
import '../../utils/notification_provider.dart';
import '../../widgets/modals/info_modal.dart';
import '../../widgets/other/loading.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  OrderListScreenState createState() => OrderListScreenState();
}

class OrderListScreenState extends State<OrderListScreen> {
  bool isLoading = true;

  int? userId;
  GetStorage box = GetStorage();
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    userId = box.read('user')['id'];
    getOrdersByPending();
    print(Provider.of<NotificationProvider>(context, listen: false).notificationList.length);
  }

  getOrdersByPending() async {
    setState(() {
      isLoading = true;
    });

    var response = await OrderService().getPendingOrderList();

    if (response.success) {
      setState(() {
        isLoading = false;
      });

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
                      builder: (context) => AssignToCarrierScreen(
                        order: orders[index],
                        getPendingCarrierList: getOrdersByPending,
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
                      subtitle: Text(orders[index].user!.name, style: GoogleFonts.inconsolata(
                        color: AppColor(whiteColor),
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
