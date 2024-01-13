import 'package:flutter/material.dart';

import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFreaderExample extends StatefulWidget {
  @override
  _PDFreaderExampleState createState() => _PDFreaderExampleState();
}

// Example class for pdf text reader plugin
class _PDFreaderExampleState extends State<PDFreaderExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PDFView(),
    );
  }
}
