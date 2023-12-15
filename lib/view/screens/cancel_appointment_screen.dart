import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CancelAppointment extends StatefulWidget {
  const CancelAppointment({super.key});

  @override
  State<CancelAppointment> createState() => _CancelAppointmentState();
}

class _CancelAppointmentState extends State<CancelAppointment> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: ElevatedButton(
                onPressed: () {
                  
                },
                child: const Text('Cancel Appointment'))),
      ),
    );
  }
}
