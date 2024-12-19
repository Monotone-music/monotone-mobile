import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monotone_flutter/controller/payment/subscription_controller.dart';

class TransactionStatusPage extends StatefulWidget {
  final SubscriptionController subscriptionController;
  final int amount;
  final String currency;
  final String membershipType;

  TransactionStatusPage({
    required this.subscriptionController,
    required this.amount,
    required this.currency,
    required this.membershipType,
  });

  @override
  _TransactionStatusPageState createState() => _TransactionStatusPageState();
}

class _TransactionStatusPageState extends State<TransactionStatusPage> {
  String _status = 'processing'; // Initial status

  @override
  void initState() {
    super.initState();
    _startSubscriptionProcess();
  }

  void _startSubscriptionProcess() async {
    final secretKey = await widget.subscriptionController.createSubscription(
      widget.amount,
      widget.currency,
      widget.membershipType,
    );
    if (secretKey.isNotEmpty) {
      await widget.subscriptionController.initPaymentSheet(secretKey);
      widget.subscriptionController.processPayment(_updateStatus);
    } else {
      _updateStatus('failed');
    }
  }

  void _updateStatus(String status) {
    setState(() {
      _status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Status'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: _getStatusIcon(_status),
            ),
            SizedBox(height: 20),
            Text(
              _getStatusMessage(_status),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (_status == 'succeeded' ||
                _status == 'failed' ||
                _status == 'canceled')
              ElevatedButton(
                onPressed: () {
                  print('Go to Profile');
                  GoRouter.of(context).go('/profile');
                },
                child: Text('Go to Profile'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _getStatusIcon(String status) {
    switch (status) {
      case 'processing':
        return Icon(Icons.hourglass_empty,
            key: ValueKey('processing'), size: 100, color: Colors.orange);
      case 'succeeded':
        return Icon(Icons.check_circle,
            key: ValueKey('succeeded'), size: 100, color: Colors.green);
      case 'failed':
        return Icon(Icons.error,
            key: ValueKey('failed'), size: 100, color: Colors.red);
      case 'canceled':
        return Icon(Icons.cancel,
            key: ValueKey('canceled'), size: 100, color: Colors.grey);
      default:
        return Container();
    }
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case 'processing':
        return 'Processing Payment...';
      case 'succeeded':
        return 'Payment Successful!';
      case 'failed':
        return 'Payment Failed!';
      case 'canceled':
        return 'Payment Canceled!';
      default:
        return '';
    }
  }
}
