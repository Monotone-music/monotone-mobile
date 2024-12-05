// import 'package:monotone_mobile/stripe_services.dart';

import 'package:dio/dio.dart';
import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/controller/payment/services/stripe_services.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';

class SubscriptionController {
  final StripeServices _stripeServices = StripeServices.instance;

  SubscriptionController() {
    // Initialization is handled in StripeServices
  }

  // Future<void> handleSubcription() async {
  //   try {
  //     await createSubscription(amount, currency);

  //     await initPaymentSheet();
  //     await processPayment();
  //   } catch (e) {
  //     print('Error handling subscription: $e');
  //   }
  // }

  Future<void> initPaymentSheet(String secretKey) async {
    try {
      await _stripeServices.init(secretKey);
    } catch (e) {
      print('Error initializing payment sheet: $e');
    }
  }

  Future<void> processPayment() async {
    try {
      await _stripeServices.processPayment();
    } catch (e) {
      print('Error processing payment: $e');
    }
  }

  Future<String> createSubscription(int amount, String currency) async {
    const api = '$BASE_URL/payment/create-intent';
    String resData;
    final dioClient = DioClient();
    try {
      final response = await dioClient.post(
        api,
        {
          'amount': amount,
          'currency': currency,
        },
      );
      if (response.statusCode == 200) {
        // Handle successful subscription creation
        print('Subscription created successfully');
        final Map<String, dynamic> data = response.data;
        data['data']['intent']['client_secret'];

        print('Client secret: ${data['data']['intent']['client_secret']}');
        return data['data']['intent']['client_secret'];
      } else {
        // Handle subscription creation failure
        print('Subscription creation failed');
      }
    } catch (e) {
      print('Error creating subscription: $e');
    }
    // return resData;
    return '';
  }

  Future<void> cancelSubscription(String subscriptionId) async {
    // Implement your backend API call to cancel the subscription
    // using the subscriptionId
  }
}
