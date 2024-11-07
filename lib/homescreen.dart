import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen>
    with SingleTickerProviderStateMixin {
  bool inOn = false;
  AnimationController? controller;
  Animation<Color?>? coloranimationbigbutton;
  Animation<Color?>? coloranimationmidbutton;
  Animation<Color?>? coloranimationsmallbutton;

  Color? bigbuttoncolor = const Color(0xFF312C27);
  Color? midbuttoncolor = const Color(0xFF484242);
  Color? smallbuttoncolor = const Color(0xFF504847);

  bool _isColorChanged = false;

  void _changeColor() {
    if (_isColorChanged) {
      controller!.reverse();
    } else {
      controller!.forward();
    }
    _isColorChanged = !_isColorChanged;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    torchavailable();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    coloranimationbigbutton = ColorTween(
            begin: const Color(0xFF312C27),
            end: const Color(0xFFFF8E01).withOpacity(0.3))
        .animate(controller!);

    coloranimationmidbutton = ColorTween(
            begin: const Color(0xFF484242),
            end: const Color(0xFFFF8E01).withOpacity(0.4))
        .animate(controller!);

    coloranimationsmallbutton =
        ColorTween(begin: const Color(0xFF504847), end: const Color(0xFFFF8E01))
            .animate(controller!);

    controller?.addListener(() {
      setState(() {
        bigbuttoncolor = coloranimationbigbutton?.value;
        midbuttoncolor = coloranimationmidbutton?.value;
        smallbuttoncolor = coloranimationsmallbutton?.value;
      });
    });
  }

  Future<bool> torchavailable() async {
    try {
      return await TorchLight.isTorchAvailable();
    } on Exception catch (e) {
      print("error");
      print(e);
      showmessage('could not check if the device has an  available torch');
      rethrow;
    }
  }

  Future<void> torchlight() async {
    if (inOn) {
      try {
        return await TorchLight.enableTorch();
      } on Exception catch (_) {
        showmessage('Could not enable torch');
        rethrow;
      }
    } else {
      try {
        return await TorchLight.disableTorch();
      } on Exception catch (_) {
        showmessage('Could not disable torch');
        rethrow;
      }
    }
  }

  void showmessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              const Center(
                child: Text(
                  'ALERT',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  message,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Torch App'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              // Image.asset(
              //   '1.jpg',
              // ),
              Icon(
                inOn
                    ? Icons.wb_sunny
                    : Icons
                        .wb_sunny_outlined, // Use different icons based on condition
                size: 100, // Set the icon size
                color: inOn ? const Color(0xFFFF8E01) : const Color(0xFF504847),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Flashlight:${(inOn) ? "ON" : "OFF"}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 90,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Circlecontain(
                    w: 300,
                    h: 300,
                    colour: bigbuttoncolor!,
                  ),
                  Circlecontain(
                    w: 260,
                    h: 260,
                    colour: midbuttoncolor!,
                  ),
                  Container(
                    width: 190,
                    height: 190,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          if (inOn)
                            inOn = false;
                          else
                            inOn = true;
                        });
                        torchlight();
                        _changeColor();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          backgroundColor: smallbuttoncolor!,
                          foregroundColor: inOn
                              ? const Color(0xFF504847)
                              : const Color(0xFFFF8E01)),
                      child: const Icon(
                        Icons.power_settings_new,
                        size: 150,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Circlecontain extends StatelessWidget {
  const Circlecontain({required this.w, required this.h, required this.colour});

  final double w;
  final double h;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(shape: BoxShape.circle, color: colour),
    );
  }
}

class Buttoncustom extends StatefulWidget {
  const Buttoncustom(
      {required this.tap,
      required this.colour,
      required this.text,
      required this.textColor});

  final VoidCallback tap;
  final Color colour;
  final String text;
  final Color textColor;

  @override
  State<Buttoncustom> createState() => _ButtoncustomState();
}

class _ButtoncustomState extends State<Buttoncustom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: widget.tap,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.colour,
          foregroundColor: widget.textColor,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(30.0), // Adjust the radius as needed
          ),
        ),
        child: Center(
            child: Text(
          widget.text,
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
        )),
      ),
    );
  }
}
