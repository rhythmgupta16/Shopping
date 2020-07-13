import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/services.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'shippingModel.dart';
import 'editShippingModel.dart';

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
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "Checkout",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        // Running the Query in this widget
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Summary",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  model.prodName,
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Rs. " + model.price,
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Shipping',
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                        ),
                        iconSize: 40,
                        color: Colors.grey,
                        splashColor: Colors.purple,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/shippingForm',
                            arguments: EditShippingModel(
                                productName: model.prodName,
                                productPrice: model.price),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              (model.firstName == "-")
                  ? Text(
                      "Update Details",
                      style: TextStyle(fontSize: 20),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          model.firstName,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          model.lastName,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          model.address,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          model.city,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          model.state,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          model.pinCode,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          color: Colors.black87,
          height: 50.0,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 200,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Colors.yellow[600])),
                      onPressed: () {
                        openCheckout();
                      },
                      color: Colors.yellow[600],
                      textColor: Colors.black,
                      child: Text(
                        "Pay Now".toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                'PAYMENT SUCCESSFUL',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Thank you for shopping with us! \n\nNeed help? Please contact: \nsupport@shop.com',
                textAlign: TextAlign.center,
              ),
              onOkButtonPressed: () {
                Navigator.of(context).pop();
              },
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
                'PAYMENT FAILED',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Please try again!\n\n Need help? Please contact: \nsupport@shop.com',
                textAlign: TextAlign.center,
              ),
              onOkButtonPressed: () {
                Navigator.of(context).pop();
              },
            ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName);
  }
}
