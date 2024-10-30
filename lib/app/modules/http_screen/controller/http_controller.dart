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
        title: const Text('HTTP'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.secondary),
            ),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: controller.articles.length,
            itemBuilder: (context, index) {
              var article = controller.articles[index];
              return CardArticle(article: article);
            },
          );
        }
      }),
    );
  }
}
