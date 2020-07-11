import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/services.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'shippingModel.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({Key key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  static const platform = const MethodChannel("razorpay_flutter");

  Razorpay _razorpay;

  @override
  Widget build(BuildContext context) {
    final ShippingModel model = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: SingleChildScrollView(
        // Running the Query in this widget
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ButtonTheme(
                minWidth: 200.0,
                height: 50.0,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Text("Open Shipping",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    color: Color(0xffFBB034),
                    textColor: Colors.white,
                    onPressed: () {
                      //openCheckout();
                      Navigator.pushNamed(context, '/shippingForm');
                    }),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(model.firstName, style: TextStyle(fontSize: 22)),
                Text(model.lastName, style: TextStyle(fontSize: 22)),
                Text(model.address, style: TextStyle(fontSize: 22)),
                Text(model.city, style: TextStyle(fontSize: 22)),
                Text(model.state, style: TextStyle(fontSize: 22)),
                Text(model.pinCode, style: TextStyle(fontSize: 22)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ButtonTheme(
                minWidth: 200.0,
                height: 50.0,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Text("Open Payment",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    color: Color(0xffFBB034),
                    textColor: Colors.white,
                    onPressed: () {
                      openCheckout();
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_GG0CC1HQcCmyMn',
      'amount': 1000,
      'name': 'Rhythm Corp.',
      'description': 'Protein',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // print("Successsssss");
    // Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId);
    showDialog(
        context: context,
        builder: (_) => NetworkGiffyDialog(
              image: Image.asset(
                'assets/success.gif',
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.TOP_LEFT,
              title: Text(
                'Success!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Thank you for shopping with us!',
                textAlign: TextAlign.center,
              ),
              onOkButtonPressed: () {},
            ));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message);
    showDialog(
        context: context,
        builder: (_) => NetworkGiffyDialog(
              image: Image.asset(
                'assets/fail.gif',
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.TOP_LEFT,
              title: Text(
                'Failed!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Please try again!',
                textAlign: TextAlign.center,
              ),
              onOkButtonPressed: () {},
            ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName);
  }
}
