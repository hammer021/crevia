import 'package:flutter/material.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/home_model.dart';
import 'package:kmob/model/produk_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class NewsScreen extends StatefulWidget {
  final Promo? param;
  const NewsScreen({Key? key, this.param}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int _currentPage = 0;
  List<String> getImageList() {
    return [
      widget.param?.image ?? "",
      widget.param?.image2 ?? "",
      widget.param?.image3 ?? "",
      widget.param?.image4 ?? "",
      widget.param?.image5 ?? "",
    ].where((url) => url != null && url.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final imageList = getImageList();
    return SafeArea(
      child: PlatformScaffold(
        // appBar: new MyAppBar(_selectedDrawerIndex),
        appBar: appBarDetail(context, "Detail Berita") as PreferredSizeWidget,
        backgroundColor: Colors.white,
        body: Container(
          child: new ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              new Container(
                  // padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: new Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                            widget.param!.title,
                            style: TextStyle(
                                fontSize: 20.0, fontFamily: "NeoSans"),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),

                        //  new ClipRRect(
                        //   borderRadius: new BorderRadius.circular(8.0),
                        //   child: new Image(
                        //     width: double.infinity,
                        //     fit: BoxFit.cover,
                        //     image: NetworkImage(
                        //       widget.param.image,)
                        //       )
                        //     ),
                        if (imageList.isNotEmpty)
                          Column(
                            children: [
                              SizedBox(
                                height: 250,
                                child: PageView.builder(
                                  itemCount: imageList.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentPage = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => Dialog(
                                            backgroundColor: Colors.black,
                                            insetPadding: EdgeInsets.zero,
                                            child: Stack(
                                              children: [
                                                PhotoViewGallery.builder(
                                                  itemCount: imageList.length,
                                                  pageController:
                                                      PageController(
                                                          initialPage: index),
                                                  builder: (context, i) {
                                                    return PhotoViewGalleryPageOptions(
                                                      imageProvider:
                                                          NetworkImage(
                                                              imageList[i]),
                                                      minScale:
                                                          PhotoViewComputedScale
                                                              .contained,
                                                      maxScale:
                                                          PhotoViewComputedScale
                                                                  .covered *
                                                              2.0,
                                                      heroAttributes:
                                                          PhotoViewHeroAttributes(
                                                              tag:
                                                                  "newsImage_$i"),
                                                    );
                                                  },
                                                  backgroundDecoration:
                                                      BoxDecoration(
                                                          color: Colors.black),
                                                  scrollPhysics:
                                                      BouncingScrollPhysics(),
                                                ),
                                                Positioned(
                                                  top: 40,
                                                  right: 20,
                                                  child: IconButton(
                                                    icon: Icon(Icons.close,
                                                        color: Colors.white,
                                                        size: 30),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          imageList[index],
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.broken_image,
                                                      size: 100,
                                                      color: Colors.red),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  imageList.length,
                                  (index) => Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    width: _currentPage == index ? 10 : 6,
                                    height: _currentPage == index ? 10 : 6,
                                    decoration: BoxDecoration(
                                      color: _currentPage == index
                                          ? Colors.blue
                                          : Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(widget.param!.content,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 14.0, fontFamily: "NeoSans")),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
