import 'package:B2C/controller/business_controller.dart';
import 'package:B2C/main.dart';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../utility/widget_helper/common_text_widget.dart';

// ignore: must_be_immutable
class CategoryImages extends StatefulWidget {
  int index;
  int businessId;
  int catId;
  CategoryImages(this.index, this.businessId, this.catId, {super.key});

  @override
  State<CategoryImages> createState() => _CategoryImagesState();
}

class _CategoryImagesState extends State<CategoryImages> {
  late PageController pageController;
  final transformationController = TransformationController();
  final businessController = Get.put(BusinessController());
  bool isLoad = false;
  bool isPan = false;

  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  fetchApi() async {
    pageController = PageController(initialPage: widget.index);
    await businessController.getCategoryImages(widget.businessId, widget.catId);
    isLoad = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          actions: [closeButton()],
          centerTitle: true,
          title: CommenTextWidget(
            s: "Gallery".tr,
            fw: FontWeight.bold,
            size: 23,
            clr: Colors.white,
          ),
        ),
        body: isLoad
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InteractiveViewer(
                    transformationController: transformationController,
                    panEnabled: isPan,
                    minScale: 1,
                    maxScale: 6,
                    scaleEnabled: true,
                    // boundaryMargin: EdgeInsets.all(double.infinity),
                    onInteractionEnd: (details) {
                      if (transformationController.value.getMaxScaleOnAxis() >
                          1.2) {
                        setState(() {
                          isPan = true;
                        });
                      } else {
                        isPan = false;
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      height: Get.height * .6,
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: businessController.categoryImages.length,
                        onPageChanged: (pageValue) {
                          setState(() {
                            widget.index = pageValue;
                            transformationController.value = Matrix4.identity();
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            businessController
                                .categoryImages[widget.index].imageUrl
                                .toString(),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * .6,
                    height: Get.height * .07,
                    child: Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // const Icon(
                            //   Icons.arrow_back_ios,
                            //   color: Colors.white,
                            //   size: 15,
                            // ),
                            // const SizedBox(
                            //   width: 15,
                            // )
                            IconButton(
                                onPressed: () {
                                  localizationController.isHebrew.value
                                      ? setState(() {
                                          if (widget.index !=
                                              businessController
                                                      .categoryImages.length -
                                                  1) {
                                            widget.index++;
                                            pageController
                                                .jumpToPage(widget.index);
                                          }
                                        })
                                      : setState(() {
                                          if (widget.index != 0) {
                                            widget.index--;
                                            pageController
                                                .jumpToPage(widget.index);
                                          }
                                        });
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 15,
                                )),
                            CommenTextWidget(
                              s: "${widget.index + 1}/${businessController.categoryImages.length}",
                              clr: Colors.white,
                            ),
                            // const SizedBox(
                            //   width: 15,
                            // ),
                            // const Icon(
                            //   Icons.arrow_forward_ios,
                            //   color: Colors.white,
                            //   size: 15,
                            // )
                            IconButton(
                                onPressed: () {
                                  localizationController.isHebrew.value
                                      ? setState(() {
                                          if (widget.index != 0) {
                                            widget.index--;
                                            pageController
                                                .jumpToPage(widget.index);
                                          }
                                        })
                                      : setState(() {
                                          if (widget.index !=
                                              businessController
                                                      .categoryImages.length -
                                                  1) {
                                            widget.index++;
                                            pageController
                                                .jumpToPage(widget.index);
                                          }
                                        });
                                },
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 15,
                                )),
                          ]),
                    ),
                  )
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                  color: Colr.primary,
                ),
              ),
      ),
    );
  }

  closeButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: Center(
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// InteractiveViewer(
//                           transformationController: transformationController,
//                           panEnabled: transformationController.value
//                                   .getMaxScaleOnAxis() >
//                               1.2,
//                           minScale: 1,
//                           maxScale: 6,
//                           boundaryMargin: const EdgeInsets.all(100),
//                           child: Image.network(
//                             businessController
//                                 .categoryImages[widget.index].imageUrl
//                                 .toString(),
//                             // fit: BoxFit.,
//                           ),
//                         );