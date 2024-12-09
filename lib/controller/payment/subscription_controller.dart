// import 'package:monotone_mobile/stripe_services.dart';

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';
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
      print('Payment sheet initialized successfully.');
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
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ], retryPolicy: ExpiredTokenRetryPolicy());

    ///
    const api = '$BASE_URL/payment/create-intent';
    const storage = FlutterSecureStorage();
    print('Creating subscription...');

    String resData;
    try {
      final accessToken = await storage.read(
        key: 'accessToken',
      );
      final response = await httpClient.post(Uri.parse(api),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
            {
              'amount': amount.toString(),
              'currency': currency,
              'metadata': {
                'token': accessToken,
                'type': 's',
              },
            },
          ));
      if (response.statusCode == 200) {
        // Handle successful subscription creation
        print('Subscription created successfully');
        var body = jsonDecode(response.body);
        print('Response body: ${body['data']['intent']['client_secret']}');
        final Map<String, dynamic> data = body;
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
