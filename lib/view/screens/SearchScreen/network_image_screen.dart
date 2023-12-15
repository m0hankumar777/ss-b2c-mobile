import 'package:B2C/model/Search/search_product_model.dart';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:flutter/material.dart';

class NetworkImageView extends StatelessWidget {
  const NetworkImageView({required this.character, super.key});

  final SearchProductModel character;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      character.logoImageUrl,
      fit: BoxFit.contain,
      // When image is loading from the server it takes some time
      // So we will show progress indicator while loading
      loadingBuilder: (BuildContext context, Widget? child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child!;
        return Center(
          child: CircularProgressIndicator(
            color: Colr.primary,
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      // When dealing with networks it completes with two states,
      // complete with a value or completed with an error,
      // So handling errors is very important otherwise it will crash the app screen.
      // I showed dummy images from assets when there is an error, you can show some texts or anything you want.
      errorBuilder: (context, exception, stackTrace) {
        return Image.asset(
          'assets/images/star.png',
          fit: BoxFit.cover,
          /* height: (widget.hideBelowImage == null ||
                                            widget.hideBelowImage == false)
                                        ? 170.h
                                        : 130.h,
                                    width: double.infinity, */
        );
      },
    );
  }
}
