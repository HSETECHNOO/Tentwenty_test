import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tentwenty_test/app/commons/error_message_widget.dart';
import 'package:tentwenty_test/app/modules/home/widgets/movies_listview.dart';
import 'package:tentwenty_test/app/providers/app_provider/app_base_provider.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<AppBaseProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const CircularProgressIndicator();
            } else if (provider.errorMessage != null) {
              return ErrorMessageWidget(
                message: provider.errorMessage!,
                onRetry: provider.initializeApp,
              );
            } else {
              return const MoviesListView();
            }
          },
        ),
      ),
    );
  }
}
