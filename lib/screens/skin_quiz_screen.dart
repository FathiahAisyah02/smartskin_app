import 'package:flutter/material.dart';
import 'result_screen.dart';

class SkinQuizScreen extends StatefulWidget {
  const SkinQuizScreen({super.key});

  @override
  State<SkinQuizScreen> createState() => _SkinQuizScreenState();
}

class _SkinQuizScreenState extends State<SkinQuizScreen> {
  int currentQuestion = 0;
  int oilyScore = 0;
  int dryScore = 0;
  int comboScore = 0;
  int sensitiveScore = 0;

  void _nextQuestion(String answer) {
    // ✅ Improved scoring logic
    final q = questions[currentQuestion]['question'];
    if (q.contains("few hours after washing")) {
      if (answer == "Shiny or greasy") oilyScore++;
      if (answer == "Tight or flaky") dryScore++;
      if (answer == "Oily T-zone, dry cheeks") comboScore++;
      if (answer == "Red or itchy") sensitiveScore++;
    } else if (q.contains("acne or pimples")) {
      if (answer == "Often") oilyScore++;
      if (answer == "Rarely") dryScore++;
      if (answer == "Sometimes (mainly T-zone)") comboScore++;
      if (answer == "Easily irritated bumps") sensitiveScore++;
    } else if (q.contains("after applying skincare")) {
      if (answer == "Feels greasy fast") oilyScore++;
      if (answer == "Feels dry quickly") dryScore++;
      if (answer == "Sometimes both") comboScore++;
      if (answer == "Burns or stings") sensitiveScore++;
    } else if (q.contains("forehead and nose look like")) {
      if (answer == "Shiny") oilyScore++;
      if (answer == "Dull or rough") dryScore++;
      if (answer == "Shiny in some areas") comboScore++;
      if (answer == "Red or patchy") sensitiveScore++;
    } else if (q.contains("your pores")) {
      if (answer == "Large and visible") oilyScore++;
      if (answer == "Almost invisible") dryScore++;
      if (answer == "Visible in T-zone only") comboScore++;
      if (answer == "Normal but irritated") sensitiveScore++;
    }

    // Go next or show result
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    String skinType;
    String description;
    List<String> suggestions;

    if (oilyScore > dryScore &&
        oilyScore > comboScore &&
        oilyScore > sensitiveScore) {
      skinType = "Oily Skin";
      description =
          "Your skin produces excess oil, leading to shine and possible breakouts.";
      suggestions = [
        "Use oil-free skincare products.",
        "Cleanse twice daily with a gentle foaming cleanser.",
        "Avoid alcohol-based toners.",
        "Try lightweight, non-comedogenic moisturizers."
      ];
    } else if (dryScore > comboScore && dryScore > sensitiveScore) {
      skinType = "Dry Skin";
      description =
          "Your skin tends to feel tight and rough, especially after cleansing.";
      suggestions = [
        "Use hydrating cleansers and rich moisturizers.",
        "Avoid hot water during washing.",
        "Apply moisturizer immediately after showering.",
        "Look for products with hyaluronic acid or ceramides."
      ];
    } else if (comboScore > sensitiveScore) {
      skinType = "Combination Skin";
      description =
          "You have an oily T-zone (forehead, nose, chin) but dry cheeks.";
      suggestions = [
        "Use a mild, pH-balanced cleanser.",
        "Moisturize dry areas more frequently.",
        "Avoid heavy creams on oily zones.",
        "Use blotting paper for mid-day shine."
      ];
    } else {
      skinType = "Sensitive Skin";
      description =
          "Your skin easily reacts to products, causing redness or irritation.";
      suggestions = [
        "Choose fragrance-free, hypoallergenic skincare.",
        "Avoid scrubbing or over-exfoliating.",
        "Patch-test new products first.",
        "Stick to minimal, soothing ingredients."
      ];
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          skinType: skinType,
          description: description,
          suggestions: suggestions,
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'How does your skin feel a few hours after washing your face?',
      'options': [
        'Shiny or greasy',
        'Tight or flaky',
        'Oily T-zone, dry cheeks',
        'Red or itchy'
      ]
    },
    {
      'question': 'How often do you get acne or pimples?',
      'options': [
        'Often',
        'Rarely',
        'Sometimes (mainly T-zone)',
        'Easily irritated bumps'
      ]
    },
    {
      'question': 'How does your skin feel after applying skincare products?',
      'options': [
        'Feels greasy fast',
        'Feels dry quickly',
        'Sometimes both',
        'Burns or stings'
      ]
    },
    {
      'question': 'What do your forehead and nose look like during the day?',
      'options': [
        'Shiny',
        'Dull or rough',
        'Shiny in some areas',
        'Red or patchy'
      ]
    },
    {
      'question': 'How would you describe your pores?',
      'options': [
        'Large and visible',
        'Almost invisible',
        'Visible in T-zone only',
        'Normal but irritated'
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];
    return Scaffold(
      appBar: AppBar(
        title: const Text("SmartSkin Quiz 💕"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFC1CC), Color(0xFFF8BBD0), Color(0xFFFCE4EC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Question ${currentQuestion + 1} of ${questions.length}",
                  style: TextStyle(
                    color: Colors.pink.shade700,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  question['question'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                ...question['options'].map<Widget>((option) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent.shade100,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _nextQuestion(option),
                      child: Text(option, textAlign: TextAlign.center),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
