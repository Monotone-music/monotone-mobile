import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionStatusPage extends StatefulWidget {
  @override
  _TransactionStatusPageState createState() => _TransactionStatusPageState();
}

class _TransactionStatusPageState extends State<TransactionStatusPage> {
  String _status = 'processing'; // Initial status

  @override
  void initState() {
    super.initState();
    // Simulate a delay for status change
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _status =
            'succeeded'; // Change to 'failed' to simulate a failed transaction
      });
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
            ElevatedButton(
              onPressed: () {
                print('Go to Home Profile');
                // Navigate back to home profile page
                GoRouter.of(context).push('/profile');
              },
              child: Text('Go to Home Profile'),
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
      default:
        return '';
    }
  }
}
