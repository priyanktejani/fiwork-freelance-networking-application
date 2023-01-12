import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewFileWebView extends StatefulWidget {
  const ViewFileWebView({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  State<ViewFileWebView> createState() => _ViewFileWebViewState();
}

class _ViewFileWebViewState extends State<ViewFileWebView> {
  late WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(
          'https://firebasestorage.googleapis.com/v0/b/fiwork-app.appspot.com/o/deliveries%2F9gHfAuBrlfOxXfeBsCvYMaqi8zU2%2FGaribdas%20Ashram%202023%20(1).pdf?alt=media&token=39ed0cae-e6ea-4d27-9356-79dfdcbf67a6'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text('File view'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(widget.url),
            WebViewWidget(
                controller: controller,
              ),
          ],
        ),
      ),
    );
  }
}
