import 'package:flutter/material.dart';
import 'package:kkiapay_flutter_sdk/kkiapay_flutter_sdk.dart';
import 'package:kkiapay_fedapay/Screens/kSuccessScreen.dart';

void callback(response, context) {
  switch ( response['status'] ) {

    case PAYMENT_CANCELLED:
      Navigator.pop(context);
      debugPrint(PAYMENT_CANCELLED);
      break;

    case PAYMENT_INIT:
      debugPrint(PAYMENT_INIT);
      break;

    case PENDING_PAYMENT:
      debugPrint(PENDING_PAYMENT);
      break;

    case PAYMENT_SUCCESS:
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessScreen(
            amount: response['requestData']['amount'],
            transactionId: response['transactionId'],
          ),
        ),
      );
      break;

    default:
      debugPrint(UNKNOWN_EVENT);
      break;
  }
}


final kkiapay = KKiaPay(
    amount: 1000,//
    countries: ["BJ","CI","SN","TG"],//
    phone: "22961000000",//
    name: "John Doe",//
    email: "email@mail.com",//
    reason: 'Transaction reason',//
    data: 'Fake data',//
    sandbox: true,//
    apikey: 'bc46cb50800611efbca255daf9c4feeb',//
    callback: callback,//
    theme: defaultTheme, // Ex : "#222F5A",
    partnerId: 'AxXxXXxId',//
    paymentMethods: ["momo","card"]//
);

class Kkiapay extends StatelessWidget {
  const Kkiapay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kkiapay", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),

      body: Center(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight:Radius.circular(20) )
            ),
            child: IconButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => kkiapay),
              );
            }, icon: Icon(Icons.ac_unit_rounded, color: Colors.white,))),
      ),
    );
  }
}
