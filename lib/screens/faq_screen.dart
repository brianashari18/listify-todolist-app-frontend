import 'package:flutter/material.dart';
import 'package:listify/screens/help_center_screen.dart';
import 'package:listify/screens/feedback_screen.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF393646), // Background color
      appBar: AppBar(
        backgroundColor: const Color(0xFF393646), // Same as background
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HelpCenter()), // Assuming HelpCenterPage is your Help Center page
            );
          },
        ),
        toolbarHeight: 90,
        title: const Text(
          "FAQ",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // General Questions Section
              const SectionWidget(
                title: "General Questions",
                items: [
                  "What is Listify?",
                  "How do I create a new task?",
                  "How do I mark a task as complete?",
                  "How do I delete a task?",
                ],
                answers: [
                  "Listify is a task management app that helps you organize tasks effectively.",
                  "To create a new task, click the 'Add Task' button and fill in the details.",
                  "To mark a task as complete, click the checkbox next to the task.",
                  "To delete a task, swipe left on the task and press the delete icon.",
                ],
                hasBorder: true, // Add border
              ),
              const SizedBox(height: 20),
              // Organization and Prioritization Section
              const SectionWidget(
                title: "Organization and Prioritization",
                items: [
                  "How do I organize my tasks?",
                  "How do I set a due date for a task?",
                ],
                answers: [
                  "You can organize tasks by categorizing them or setting priorities.",
                  "To set a due date, open the task and click on the 'Due Date' section.",
                ],
                hasBorder: true,
              ),
              const SizedBox(height: 40),
              // Bug Report Button
              Center(
                child: Column(
                  children: [
                    const Text(
                      "Still unsure about something?",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const FeedbackPage()), // Navigate to feedback page
                        );
                        // Handle submit bug report
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Button stays white
                        foregroundColor:
                            const Color(0xFF393646), // Text matches background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          // side: const BorderSide(color: Colors.black, width: 2), // Black border
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 85, vertical: 15),
                      ),
                      child: const Text(
                        "Submit Bug Report",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
}

class SectionWidget extends StatelessWidget {
  final String title;
  final List<String> items;
  final List<String> answers;
  final bool hasBorder;

  const SectionWidget({
    super.key,
    required this.title,
    required this.items,
    required this.answers, // Required to pass answers
    this.hasBorder = false, // Optional border flag
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF393646), // Same as background
        borderRadius: BorderRadius.circular(35),
        border: hasBorder
            ? Border.all(color: Colors.black, width: 2)
            : null, // Add border if required
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color.fromRGBO(123, 119, 148, 1),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          ...items.asMap().entries.map((entry) {
            int index = entry.key; // Get the index of the question
            String item = entry.value; // Get the question text
            String answer = answers[index]; // Get the corresponding answer

            return ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 0),
              title: Text(
                item,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              iconColor: Colors.white70,
              collapsedIconColor: Colors.white70,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical, // Enable vertical scroll
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      answer,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
