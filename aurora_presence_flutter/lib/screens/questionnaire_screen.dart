import 'package:flutter/material.dart';

class Question {
  final String questionText;
  final List<String> options;
  String? selectedOption;

  Question({
    required this.questionText,
    required this.options,
    this.selectedOption,
  });
}

class QuestionnaireScreen extends StatefulWidget {
  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final List<Question> questions = [
    Question(
      questionText: 'Bagaimana kepuasan Anda dengan lingkungan kerja?',
      options: ['Sangat Puas', 'Puas', 'Biasa Saja', 'Tidak Puas', 'Sangat Tidak Puas'],
    ),
    Question(
      questionText: 'Apakah Anda merasa didukung oleh manajemen?',
      options: ['Sangat Didukung', 'Didukung', 'Netral', 'Tidak Didukung', 'Sangat Tidak Didukung'],
    ),
    Question(
      questionText: 'Seberapa sering Anda berinteraksi dengan rekan kerja?',
      options: ['Sangat Sering', 'Sering', 'Kadang-kadang', 'Jarang', 'Tidak Pernah'],
    ),
    Question(
      questionText: 'Apakah Anda merasa beban kerja Anda seimbang?',
      options: ['Sangat Seimbang', 'Seimbang', 'Netral', 'Tidak Seimbang', 'Sangat Tidak Seimbang'],
    ),
    Question(
      questionText: 'Bagaimana pendapat Anda tentang fasilitas kantor?',
      options: ['Sangat Baik', 'Baik', 'Cukup', 'Kurang', 'Sangat Kurang'],
    ),
    Question(
      questionText: 'Apakah Anda merasa dihargai atas kontribusi Anda?',
      options: ['Sangat Dihargai', 'Dihargai', 'Netral', 'Tidak Dihargai', 'Sangat Tidak Dihargai'],
    ),
    Question(
      questionText: 'Seberapa baik komunikasi antar tim di perusahaan?',
      options: ['Sangat Baik', 'Baik', 'Cukup', 'Kurang', 'Sangat Kurang'],
    ),
    Question(
      questionText: 'Apakah Anda merasa ada peluang untuk berkembang dalam karir Anda?',
      options: ['Sangat Ada', 'Ada', 'Netral', 'Tidak Ada', 'Sangat Tidak Ada'],
    ),
    Question(
      questionText: 'Bagaimana kepuasan Anda terhadap keseimbangan kerja dan kehidupan?',
      options: ['Sangat Puas', 'Puas', 'Biasa Saja', 'Tidak Puas', 'Sangat Tidak Puas'],
    ),
    Question(
      questionText: 'Apakah Anda merasa gaji yang diterima sudah sesuai dengan beban kerja?',
      options: ['Sangat Sesuai', 'Sesuai', 'Netral', 'Tidak Sesuai', 'Sangat Tidak Sesuai'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00CEE8),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Kuisoner",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return QuestionCard(
              question: questions[index],
              onOptionSelected: (String? value) {
                setState(() {
                  questions[index].selectedOption = value;
                });
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitQuestionnaire,
        child: Icon(Icons.send),
      ),
    );
  }

  void _submitQuestionnaire() {
    if (questions.any((q) => q.selectedOption == null)) {
      // Jika ada pertanyaan yang belum dijawab, tampilkan snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap jawab semua pertanyaan sebelum mengirim.')),
      );
      return;
    }

    for (var question in questions) {
      print('Question: ${question.questionText}');
      print('Selected: ${question.selectedOption ?? 'Tidak ada jawaban'}');
    }

    // Tampilkan popup terima kasih
    showDialog(
      context: context,
      barrierDismissible: false, // Mencegah popup hilang jika klik di luar area popup
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Terima Kasih!"),
          content: Text("Kuisoner Anda sudah terkirim."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetQuestionnaire();
              },
              child: Text("✔"),
            ),
          ],
        );
      },
    );
  }

  void _resetQuestionnaire() {
    setState(() {
      for (var question in questions) {
        question.selectedOption = null;
      }
    });
  }
}

class QuestionCard extends StatelessWidget {
  final Question question;
  final ValueChanged<String?> onOptionSelected;

  QuestionCard({required this.question, required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF00CEE8), width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionText,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            ...question.options.map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: question.selectedOption,
                onChanged: onOptionSelected,
              );
            }).toList(),
          ],
        ),
    ),
);
}
}
