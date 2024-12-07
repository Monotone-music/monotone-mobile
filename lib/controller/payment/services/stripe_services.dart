import 'package:flutter_stripe/flutter_stripe.dart';

class StripeServices {
  StripeServices._();
  static final StripeServices instance = StripeServices._();

  StripeServices() {
    Stripe.publishableKey =
        'pk_test_51PR8baLcSoLMTRiQjjqFJopXNY76FOx5YuYfyrQ9WwK4iA32jyWvNXzNdesfHkfyJv4QKXEhceUjL7qltHnaaLxk00qdPpyN4O';
    // init();
  }

  Future<void> init(String secretKey) async {
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: secretKey,
      merchantDisplayName: 'Monotone',
    ));
  }

  Future<void> processPayment() async {
    try {
      // Simulate a delay for payment processing
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print('Error caught in processPayment $e');
    }
  }

  // Future<String?> createPaymentIntent() async {
  //   try {} catch (e) {
  //     print('Error caught in createPaymentIntent $e');
  //   }
  // }

  String calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
