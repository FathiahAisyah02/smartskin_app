import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/skin_detection_model.dart';
import '../models/navigation_model.dart';
import 'guidance_screen.dart'; 

// --- QUIZ DATA STRUCTURES ---

class QuizOption {
  final String text;
  final int oilyPoints; 
  final int dryPoints; 
  final int sensitivePoints;

  QuizOption({
    required this.text,
    this.oilyPoints = 0,
    this.dryPoints = 0,
    this.sensitivePoints = 0,
  });
}

class SkinQuizQuestion {
  final String questionText;
  final List<QuizOption> options;

  SkinQuizQuestion({
    required this.questionText,
    required this.options,
  });
}

final List<SkinQuizQuestion> skinQuizQuestions = [
  // ... (Your quiz questions remain unchanged) ...
  // Q1: Oiliness/Sebum Production
  SkinQuizQuestion(
    questionText: 'How does your skin feel and look by midday (without makeup)?',
    options: [
      QuizOption(text: 'Very shiny and oily all over.', oilyPoints: 3),
      QuizOption(text: 'Shiny/oily just in the T-zone (forehead, nose, chin).', oilyPoints: 2),
      QuizOption(text: 'Tight, dull, or flaky.', dryPoints: 3),
      QuizOption(text: 'Balanced and comfortable.', oilyPoints: 1),
    ],
  ),

  // Q2: Hydration/Tightness
  SkinQuizQuestion(
    questionText: 'How does your skin feel immediately after cleansing?',
    options: [
      QuizOption(text: 'Tight, dry, or "squeaky clean".', dryPoints: 3),
      QuizOption(text: 'A little tight, but gets better quickly.', dryPoints: 2),
      QuizOption(text: 'Completely comfortable and normal.', oilyPoints: 1),
      QuizOption(text: 'Immediately soft and oily.', oilyPoints: 2),
    ],
  ),

  // Q3: Pore Visibility
  SkinQuizQuestion(
    questionText: 'What is the size and visibility of your pores?',
    options: [
      QuizOption(text: 'Large and noticeable everywhere.', oilyPoints: 3),
      QuizOption(text: 'Visible primarily on the nose and forehead.', oilyPoints: 2),
      QuizOption(text: 'Small and almost invisible.', dryPoints: 1),
      QuizOption(text: 'No blackheads, but prone to clogged pores.', sensitivePoints: 1),
    ],
  ),

  // Q4: Breakouts/Acne
  SkinQuizQuestion(
    questionText: 'How often do you typically experience pimples or breakouts?',
    options: [
      QuizOption(text: 'Frequently (weekly or more).', oilyPoints: 3),
      QuizOption(text: 'Occasionally (monthly, usually hormonal).', oilyPoints: 2),
      QuizOption(text: 'Rarely or never.', dryPoints: 1),
      QuizOption(text: 'Often, and they leave red marks that last.', sensitivePoints: 2),
    ],
  ),

  // Q5: Sensitivity and Redness
  SkinQuizQuestion(
    questionText: 'How does your skin react to new products or weather changes?',
    options: [
      QuizOption(text: 'It often stings, gets red, or feels irritated.', sensitivePoints: 3),
      QuizOption(text: 'It gets dry and flaky easily.', dryPoints: 2),
      QuizOption(text: 'It might break out, but no redness/stinging.', oilyPoints: 1),
      QuizOption(text: 'Rarely reacts; it\'s very resilient.', sensitivePoints: 0),
    ],
  ),

  // Q6: Moisturization Needs
  SkinQuizQuestion(
    questionText: 'How quickly does your skin absorb moisturizer?',
    options: [
      QuizOption(text: 'It takes time, and sometimes feels like it sits on top.', oilyPoints: 2),
      QuizOption(text: 'It absorbs immediately, and still feels thirsty.', dryPoints: 3),
      QuizOption(text: 'Easily and feels comfortable all day.', dryPoints: 1),
    ],
  ),
];

// --- SKIN QUIZ SCREEN IMPLEMENTATION ---

class SkinQuizScreen extends StatefulWidget {
  const SkinQuizScreen({super.key});

  @override
  State<SkinQuizScreen> createState() => _SkinQuizScreenState();
}

class _SkinQuizScreenState extends State<SkinQuizScreen> {
  int _currentQuestionIndex = 0;
  final Map<String, int> _scores = {
    'oily': 0,
    'dry': 0,
    'sensitive': 0,
  };

  final List<SkinQuizQuestion> _quizData = skinQuizQuestions;

  void _answerQuestion(QuizOption selectedOption, NavigationModel navModel) {
    setState(() {
      // 1. Tally the score
      _scores['oily'] = (_scores['oily'] ?? 0) + selectedOption.oilyPoints;
      _scores['dry'] = (_scores['dry'] ?? 0) + selectedOption.dryPoints;
      _scores['sensitive'] = (_scores['sensitive'] ?? 0) + selectedOption.sensitivePoints;

      // 2. Check if the quiz is over
      if (_currentQuestionIndex < _quizData.length - 1) {
        _currentQuestionIndex++;
      } else {
        // Quiz finished
        _finalizeQuiz(navModel);
      }
    });
  }

  // Finalizes the quiz, determines the skin type, and displays the result
  Future<void> _finalizeQuiz(NavigationModel navModel) async {
    final skinModel = Provider.of<SkinDetectionModel>(context, listen: false);

    // Final Determination Logic (Rule-Based)
    final int oilyScore = _scores['oily']!; 
    final int dryScore = _scores['dry']!;   
    final int sensitiveScore = _scores['sensitive']!; 

    String resultType;
    String detail;
    
    // --- Rule Set ---
    // NOTE: Removed all ** Markdown syntax from detail strings.
    if (oilyScore >= 9 && dryScore < 5) {
      resultType = 'Oily';
      detail = 'Your quiz results strongly indicate high sebum production. 🧴 Key Tip: Use a lightweight, gel-based moisturizer and products containing Salicylic Acid (BHA). Avoid heavy oils and occlusive creams.';
    } 
    else if (dryScore >= 7 && oilyScore < 5) {
      resultType = 'Dry';
      detail = 'Your quiz results strongly indicate a lack of moisture and oils. ✨ Key Tip: Focus on Hyaluronic Acid and Ceramides. Avoid harsh foaming cleansers and hot showers. Wear sunscreen daily!';
    } 
    else if (oilyScore >= 5 && dryScore >= 4) {
      resultType = 'Combination';
      detail = 'Your skin shows varying needs across the face (e.g., oily T-Zone). 💧 Key Tip: Apply matte-finish products to the T-zone and hydrating products to dry areas. Always wear sunscreen.';
    } 
    else {
      resultType = 'Normal';
      detail = 'Your skin is balanced with minimal signs of oiliness or dryness. ⚖️ Key Tip: Maintain your current routine, focus on antioxidants (like Vitamin C), and ensure daily SPF protection.';
    }

    // Add sensitivity modifier if needed
    if (sensitiveScore >= 2 && resultType != 'Normal') {
      resultType += ' & Sensitive';
      detail += '\n\nNote on Sensitivity: You scored high on sensitivity. Introduce new products slowly and patch test them first.';
    } else if (sensitiveScore >= 2 && resultType == 'Normal') {
        resultType = 'Normal & Sensitive';
        detail = 'Your skin is balanced but shows signs of sensitivity. 🌿 Key Tip: Use gentle, fragrance-free products. Avoid harsh physical exfoliants.';
    }
    // --- End Rule Set ---


    // Record the result in the SkinDetectionModel
    await skinModel.recordDetection(
      method: 'Quiz Assessment',
      type: resultType,
      detail: detail,
    );

    // Guard context use after async gap
    if (!mounted) return; 

    // Remove the quiz screen from the stack
    Navigator.of(context).pop(); 

    // Show the pop-up with the analysis result
    _showResultDialog(
      context, 
      method: 'Quiz Assessment', 
      skinType: resultType, 
      analysisDetail: detail,
      navModel: navModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final navModel = Provider.of<NavigationModel>(context, listen: false);
    final currentQuestion = _quizData[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Skin Type Detection Quiz')),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Question Progress Tracker
                Text(
                  'Question ${_currentQuestionIndex + 1}/${_quizData.length}',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                ),
                const Divider(),
                const SizedBox(height: 20),
                
                // Display the current question
                Text(
                  currentQuestion.questionText, 
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 50),
                
                // Display the options dynamically
                ...currentQuestion.options.map((option) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildQuizOption(
                    context, 
                    option.text, 
                    () => _answerQuestion(option, navModel),
                  ),
                )),
                
                const SizedBox(height: 30), 

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizOption(BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(50), 
          foregroundColor: Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }

  // --- NEW HELPER FUNCTION TO FORMAT THE SUMMARY ---
  Widget _buildFormattedSummary(BuildContext context, String text) {
    // Split the string based on "Key Tip:" to format it differently
    final parts = text.split('Key Tip:');
    
    if (parts.length < 2) {
      // Handle non-standard or sensitivity note strings
      return Text(text, style: const TextStyle(fontSize: 14, height: 1.4));
    }

    final summary = parts[0].trim();
    final keyTip = parts[1].trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the first part (Summary)
        Text(summary, style: const TextStyle(fontSize: 14, height: 1.4)),
        const SizedBox(height: 8),
        // Use RichText to bold "Key Tip:"
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14, height: 1.4, color: Colors.black),
            children: [
              const TextSpan(
                text: 'Key Tip: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: keyTip,
                style: const TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ],
    );
  }
  // --------------------------------------------------

  // Reused result dialog for consistency
  void _showResultDialog(
    BuildContext context, 
    {required String method, 
     required String skinType, 
     required String analysisDetail,
     required NavigationModel navModel}) {
       
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('$method Result', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: Icon(Icons.face_retouching_natural, size: 40, color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: 15),
                const Text('Detected Skin Type:', style: TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  skinType,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                ),
                const Divider(),
                const Text('Summary & Key Tips:', style: TextStyle(fontWeight: FontWeight.w600)),
                
                // 3. FIX: Use the new formatted summary widget instead of raw Text
                _buildFormattedSummary(context, analysisDetail), 
                
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('View Full Details'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); 
                
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GuidanceScreen(skinType: skinType), 
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); 
                navModel.setIndex(0); 
              },
            ),
          ],
        );
      },
    );
  }
}