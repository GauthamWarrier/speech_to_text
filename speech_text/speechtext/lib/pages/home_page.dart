import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnable = false;
  String _wordsSpoken = "";

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnable = await _speechToText.initialize();
    setState(() {});
  }

  // Start listening continuously
  void _startListening() async {
    if (_speechEnable) {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: Duration(
          seconds: 30,
        ), // Keep listening for 30 seconds, or adjust as needed
        // pauseFor: Duration(seconds: 5),   // Pause for 5 seconds before automatically resuming listening
        partialResults:
            true, // Return partial results to update the text while speaking
      );
      setState(() {});
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text(
          'Speech Demo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Text(
                _speechToText.isListening
                    ? "Listening..."
                    : _speechEnable
                    ? "Tap the microphone to start listening..."
                    : "Speech not available",
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Card(
                elevation: 8,
                shadowColor: Colors.deepOrange,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      _wordsSpoken.isEmpty ? "Say something..." : _wordsSpoken,
                      style: const TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.deepOrange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        tooltip: 'Listen',
        child: Icon(
          _speechToText.isListening ? Icons.mic_off : Icons.mic,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}
