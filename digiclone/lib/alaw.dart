import 'package:flutter/material.dart';

class ALawPage extends StatefulWidget {
  @override
  _ALawPageState createState() => _ALawPageState();
}

class _ALawPageState extends State<ALawPage> with SingleTickerProviderStateMixin {
  TextEditingController _numberController = TextEditingController();
  String _encodedNumber = '';
  String _decodedNumber = '';

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }
  bool isBinary(String input) {
    return RegExp(r'^[0-1]+$').hasMatch(input);
  }
  String encodeALaw(String? n) {
    if (n == null || n.isEmpty) {
      showSnackBar('Please enter a binary number');
      return ''; // Handle the case where the input is null or empty
    }

    if (n.length != 13 || !isBinary(n)) {
      showSnackBar('Entered number must be 13-bit long and binary');
      return ''; // Invalid input, return empty string
    }

    String msb = n[0];
    String nt = n.substring(1);
    Map<int, String> dt = {7: "000", 6: "001", 5: "010", 4: "011", 3: "100", 2: "101", 1: "110", 0: "111"};

    int ct = 0;
    for (int i = 0; i < nt.length; i++) {
      if (nt[i] == "1") {
        break;
      } else {
        ct += 1;
      }
    }

    String sr = nt.substring(ct + 1, ct + 5);
    showSnackBar('Encoding successful');
    return msb + dt[ct]! + sr;
  }

  String decodeALaw(String? n) {
    if (n == null || n.isEmpty) {
      showSnackBar('Please encode first');
      return ''; // Handle the case where the input is null or empty
    }

    String msb = n[0];
    String nt = n.substring(1);
    Map<String, int> dt = {"000": 7, "001": 6, "010": 5, "011": 4, "100": 3, "101": 2, "110": 1, "111": 0};

    String st = msb + '0' * dt[nt.substring(0, 3)]! + '1' + nt.substring(3) + '1';
    String sr = '0' * (13 - st.length);
    showSnackBar('Decoding successful');
    return st + sr;
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _encodeNumber() {
    setState(() {
      String inputNumber = _numberController.text;
      _encodedNumber = encodeALaw(inputNumber);
      _decodedNumber = ''; // Reset the decoded number when encoding a new one
    });

    _controller.forward(from: 0);
  }

  void _decodeNumber() {
    setState(() {
      String inputNumber = _encodedNumber;
      _decodedNumber = decodeALaw(inputNumber);
    });

    _controller.forward(from: 0);
  }

  void _clearFields() {
    setState(() {
      _numberController.text = '';
      _encodedNumber = '';
      _decodedNumber = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_image.jpg"), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16.0),
              TextField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter a number',
                  border: OutlineInputBorder(),
                  hintText: 'Binary number (Ex: 1000010001000)',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.6), // Translucent white background
                  contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0), // Adjust size here
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _encodeNumber,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Encode',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _decodeNumber,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Decode',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0), // Increased the height of SizedBox
              ElevatedButton(
                onPressed: _clearFields,
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Clear',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue.withOpacity(0.7), // Translucent blue background
                ),
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      'Encoded Number:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      _encodedNumber,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.orange.withOpacity(0.7), // Translucent orange background
                ),
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      'Decoded Number:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      _decodedNumber,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
