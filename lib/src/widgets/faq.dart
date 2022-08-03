import 'package:expandable/expandable.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Faq extends StatefulWidget {
  const Faq({Key? key}) : super(key: key);

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  final List<Map<String, String>> questionAnswerList = [
    {
      "question": "What is Lorem Ipsum?",
      "answer":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"
    },
    {
      "question": "Why do we use it?",
      "answer":
          "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here."
    },
    {
      "question": "Where does it come from?",
      "answer":
          "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old."
    },
    {
      "question": "Where can I get some?",
      "answer":
          "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable."
    },
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) => FaqItem(
          question: questionAnswerList[index]['question']!,
          answer: questionAnswerList[index]['answer']!),
      itemCount: questionAnswerList.length,
    );
  }
}

class FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const FaqItem({Key? key, required this.question, required this.answer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      surfaceTintColor: Colors.white,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: ExpandablePanel(
          theme: const ExpandableThemeData(
            useInkWell: false,
            iconColor: Colors.black,
            collapseIcon: FontAwesomeIcons.caretUp,
            expandIcon: FontAwesomeIcons.caretDown,
            headerAlignment: ExpandablePanelHeaderAlignment.center,
          ),
          collapsed: Container(),
          expanded: Column(
            children: [
              const Divider(thickness: 1),
              Text(
                answer,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          header: Text(
            question,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
