import 'package:flutter/material.dart';
import 'package:monotone_flutter/view/payment/transaction_status.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Scan the QR code to pay'),
              Center(
                child: QrImageView(
                  data:
                      'https://example.com/payment', // Replace with your payment URL
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Simulate payment process
                  _processPayment(context);
                },
                child: Text('Complete Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processPayment(BuildContext context) {
    // Simulate a delay for payment processing
    Future.delayed(Duration(seconds: 2), () {
      // Navigate to transaction status page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TransactionStatusPage()),
      );
    });
  }
}
