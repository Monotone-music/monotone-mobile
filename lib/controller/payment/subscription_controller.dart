import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/controller/payment/services/stripe_services.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';

class SubscriptionController {
  final StripeServices _stripeServices = StripeServices.instance;

  SubscriptionController() {}

  Future<void> initPaymentSheet(String secretKey) async {
    try {
      await _stripeServices.init(secretKey);
      print('Payment sheet initialized successfully.');
    } catch (e) {
      print('Error initializing payment sheet: $e');
    }
  }

  Future<void> processPayment(Function(String) updateStatus) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      updateStatus('succeeded');
    } on StripeException catch (e) {
      print('StripeException caught: $e');
      if (e.error.code == FailureCode.Canceled) {
        updateStatus('canceled');
      } else {
        updateStatus('failed');
      }
    } catch (e) {
      print('Error processing payment: $e');
      updateStatus('failed');
    }
  }

  Future<String> createSubscription(
      int amount, String currency, String membershipType) async {
    const storage = FlutterSecureStorage();
    // final token = await storage.read(key: 'accessToken');
    // print('Token: $token');
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ], retryPolicy: ExpiredTokenRetryPolicy());

    const api = '$BASE_URL/payment/create-intent';
    print('Creating subscription...');

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
                'type': membershipType,
              },
            },
          ));
      if (response.statusCode == 200) {
        print('Subscription created successfully');
        var body = jsonDecode(response.body);
        final Map<String, dynamic> data = body;
        return data['data']['intent']['client_secret'];
      } else {
        print('Subscription creation failed');
        return '';
      }
    } catch (e) {
      print('Error creating subscription: $e');
      return '';
    }
  }

  Future<void> cancelSubscription(String subscriptionId) async {
    // Implement your backend API call to cancel the subscription
    // using the subscriptionId
  }
}
