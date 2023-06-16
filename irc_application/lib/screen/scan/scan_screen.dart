import 'package:flutter/material.dart';
import 'package:irc_application/widgets/Custom_bg.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomBg(body: Column());
  }
}
