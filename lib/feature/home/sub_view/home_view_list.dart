

/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_news_app/product/models/news.dart';
import 'package:flutter_firebase_news_app/product/utility/exception/custom_exception.dart';
import 'package:flutter_firebase_news_app/product/utility/firebase/firebase_collections.dart';
import 'package:kartal/kartal.dart';

class HomeListView extends StatelessWidget {
  const HomeListView({super.key});

  @override
  Widget build(BuildContext context) {
    

  

    return FutureBuilder(
      future: response,
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot<News?>> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Placeholder();
          case ConnectionState.waiting:
            return LinearProgressIndicator();
          case ConnectionState.active:
            return LinearProgressIndicator();
          case ConnectionState.done:
            if (snapshot.hasData) {
              final values = snapshot.data!.docs.map((e) => e.data()).toList();
              return ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: values.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Column(
                      children: [
                        Image.network(
                          values[index]?.backgroundImage ?? "",
                          height: context.sized.dynamicHeight(0.1),
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                        ),
                        Text(
                          values[index]?.title ?? "",
                          style: context.general.textTheme.labelLarge,
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const SizedBox.shrink();
            }
        }
      },
    );
  }
} */