import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:freshlink/const/api_key.dart'; // Replace with your API keys.

class StripeService {
  StripeService._();
  
  static final StripeService instance = StripeService._();
  
  
  Future<void> makePayment() async {
    try{
      String? paymentIntentClientSecret = await _createPaymentIntent(10, "inr",
      );

      if(paymentIntentClientSecret == null) return ;
      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: "Agri-connect",

      ),);
    }catch(e) {
      print(e);
    }
  }
  
}

Future<String?> _createPaymentIntent(int amount ,String Currency) async {
  try {
    final Dio dio = Dio();
    Map<String, dynamic> data = {
      "amount": _calculateAmount(amount,),
      "Currency": Currency,
    };
    var response = await dio.post("https://api.stripe.com/v1/payment_intents",
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType, headers: {
        "Authorization": "Bearer ${sk}",
        "Content-Type": 'application/x-www-form-urlencoded'
      },
      ),
    );
    await _processPayment();
    if (response.data == null) {
      return response.data;
    }

    return null;
  }
  catch (e) {
    print(e);
  }
  return null;
}

Future<void> _processPayment() async {
  try {
    await Stripe.instance.presentPaymentSheet();
  } catch (e) {
    print(e);
  }
}
  String _calculateAmount(int amount){
    
    final calculatedAmount= amount*100;
    return calculatedAmount.toString();
  
  }
