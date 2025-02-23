import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes1/app/data/services/http_controller.dart';
import '../../components/card_article.dart';

class HttpView extends GetView<HttpController> {
  const HttpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HTTP',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 228, 5, 5),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          // Display a progress indicator while loading
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
          );
        } else {
          // Display the list of articles
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: controller.articles.length,
              itemBuilder: (context, index) {
                var article = controller.articles[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CardArticle(article: article),
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }
}
