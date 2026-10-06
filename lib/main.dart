import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:fl_chart/fl_chart.dart';
import 'splash_screen.dart';
import 'intro_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spam Detector',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/intro': (context) => const IntroScreen(),
        '/home': (context) => SpamClassifier(),
      },
    );
  }
}

class SpamClassifier extends StatefulWidget {
  @override
  _SpamClassifierState createState() => _SpamClassifierState();
}

class _SpamClassifierState extends State<SpamClassifier> {
  final TextEditingController _controller = TextEditingController();

  String _prediction = '';
  String _category = '';
  String _confidence = '';

  bool _isLoading = false;

  List<String> _history = [];

  int spamCount = 0;
  int hamCount = 0;

  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isListening = false;

  String _warningMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech Status: $status'),
      onError: (error) => print('Speech Error: $error'),
    );

    if (!available) {
      print('Speech recognition not available');
    }
  }

  Future<void> classifyMessage() async {
    final String serverUrl =
        'http://10.0.2.2:5000/predict';

    if (_controller.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _prediction = '';
      _category = '';
      _confidence = '';
      _warningMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "message": _controller.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        String classifiedText = _controller.text.trim();

        String predictionResult =
            result['prediction'] ?? 'No prediction returned';

        String categoryResult =
            result['category'] ?? 'Unknown';

        String confidenceScore =
            result['confidence'] ?? 'N/A';

        setState(() {
          _prediction = predictionResult;
          _category = categoryResult;
          _confidence = confidenceScore;

          _history.insert(
            0,
            "$classifiedText: $_prediction ($_category) | Confidence: $_confidence",
          );

          if (_prediction.toLowerCase() == 'spam') {
            spamCount++;
          } else {
            hamCount++;
          }

          // The Flask ML model is now responsible for
          // deciding whether the message is spam.
          if (_prediction.toLowerCase() == 'spam') {
            _warningMessage =
            'Warning: This message may be spam.';
          } else {
            _warningMessage = '';
          }
        });
      } else {
        setState(() {
          _prediction = 'Error: Unable to classify message';
          _category = '';
          _confidence = '';
          _warningMessage = '';
        });
      }
    } catch (e) {
      setState(() {
        _prediction = 'Error: Server Connection Failed';
        _category = '';
        _confidence = '';
        _warningMessage = '';
      });

      print('Connection error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SpamX'),
        backgroundColor: Colors.deepPurple.shade700,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(
                      color: Colors.white,
                    ),

                    decoration: InputDecoration(
                      hintText: 'Enter a message...',

                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),

                      filled: true,

                      fillColor: Colors.grey.shade900,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed:
              _isLoading ? null : classifyMessage,

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,

                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              child: _isLoading
                  ? CircularProgressIndicator(
                color: Colors.white,
              )
                  : Text(
                'Classify',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),

            SizedBox(height: 20),

            if (_warningMessage.isNotEmpty)
              Text(
                _warningMessage,

                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),

            SizedBox(height: 20),

            Text(
              'Prediction: $_prediction',

              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),

            if (_category.isNotEmpty)
              Text(
                'Category: $_category',

                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 16,
                ),
              ),

            if (_confidence.isNotEmpty)
              Text(
                'Confidence: $_confidence',

                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 16,
                ),
              ),

            SizedBox(height: 20),

            Container(
              height: 200,

              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: spamCount.toDouble(),
                      title: 'Spam',
                      color: Colors.red,
                      radius: 50,

                      titleStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    PieChartSectionData(
                      value: hamCount.toDouble(),
                      title: 'Ham',
                      color: Colors.green,
                      radius: 50,

                      titleStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            Text(
              'History:',

              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: _history.length,

                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _history[index],

                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}