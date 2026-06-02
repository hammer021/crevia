import 'package:flutter/material.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/home_model.dart';
import 'package:kmob/model/produk_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PromoScreen extends StatefulWidget {
  final Produk? param;
  const PromoScreen({Key? key, this.param}) : super(key: key);

  @override
  _PromoScreenState createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PlatformScaffold(
        // appBar: new MyAppBar(_selectedDrawerIndex),
        appBar:
            appBarDetail(context, widget.param?.namaProduk ?? "Detail Produk")
                as PreferredSizeWidget,
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
                            widget.param!.namaProduk,
                            style: TextStyle(
                                fontSize: 20.0, fontFamily: "NeoSans"),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        // new PhotoView(
                        //   imageProvider: NetworkImage(
                        //     widget.param.image,
                        //   ),
                        // ),
                        if (widget.param!.attachment.isNotEmpty)
                          SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: PageView.builder(
                              itemCount: widget.param!.attachment.length,
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
                                              itemCount: widget
                                                  .param!.attachment.length,
                                              builder: (context, i) {
                                                return PhotoViewGalleryPageOptions(
                                                  imageProvider: NetworkImage(
                                                      widget
                                                          .param!
                                                          .attachment[i]
                                                          .imagePath),
                                                  minScale:
                                                      PhotoViewComputedScale
                                                          .contained,
                                                  maxScale:
                                                      PhotoViewComputedScale
                                                              .covered *
                                                          2.0,
                                                  heroAttributes:
                                                      PhotoViewHeroAttributes(
                                                          tag: "promoImage_$i"),
                                                );
                                              },
                                              backgroundDecoration:
                                                  BoxDecoration(
                                                      color: Colors.black),
                                              pageController: PageController(
                                                  initialPage: index),
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
                                                    Navigator.of(context).pop(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRect(
                                    child: PhotoView.customChild(
                                      child: Image.network(
                                        widget
                                            .param!.attachment[index].imagePath,
                                        fit: BoxFit.contain,
                                      ),
                                      backgroundDecoration:
                                          BoxDecoration(color: Colors.white),
                                      minScale:
                                          PhotoViewComputedScale.contained,
                                      maxScale:
                                          PhotoViewComputedScale.covered * 2.0,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          Container(
                            height: 250,
                            color: Colors.grey[200],
                            child: Center(
                              child: Icon(Icons.shopping_bag,
                                  size: 100, color: Colors.blue),
                            ),
                          ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(widget.param!.content,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 14.0, fontFamily: "NeoSans")),
                        SizedBox(height: 8),
                        Text(
                          "Hubungi:",
                          style: TextStyle(fontSize: 14),
                        ),
                        if (widget.param!.waAdmin != null)
                          ...widget.param!.waAdmin.map((admin) => Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: InkWell(
                                  onTap: () {
                                    // String phone = admin.phone;
                                    // if (phone.startsWith('0')) {
                                    //   phone = '62' + phone.substring(1);
                                    // }
                                    // // final waUrl = Uri.parse("https://wa.me/${admin.phone}");
                                    // final waUrl = Uri.parse("https://wa.me/$phone?text=Halo,%20saya%20tertarik%20dengan%20produk%20ini");

                                    // if (await canLaunchUrl(waUrl)) {
                                    //   await launchUrl(waUrl, mode: LaunchMode.externalApplication);
                                    // } else {
                                    //   // Handle error kalau gagal launch
                                    //   ScaffoldMessenger.of(context).showSnackBar(
                                    //     SnackBar(content: Text('Tidak dapat membuka WhatsApp')),
                                    //   );
                                    // }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Icon(Icons.chat,
                                                size: 20, color: Colors.green),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                "${admin.note}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.blue),
                                                overflow: TextOverflow
                                                    .ellipsis, // biar nggak overflow
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      ElevatedButton(
                                        child: Text("Buka WhatsApp"),
                                        onPressed: () async {
                                          String phone = admin.phone;
                                          if (phone.startsWith('0')) {
                                            phone = '62' + phone.substring(1);
                                          }
                                          final waUrl = Uri.parse(
                                              "https://wa.me/$phone?text=Halo,%20saya%20tertarik%20dengan%20produk%20ini");

                                          if (await canLaunchUrl(waUrl)) {
                                            await launchUrl(waUrl,
                                                mode: LaunchMode
                                                    .externalApplication);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Tidak dapat membuka WhatsApp')),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        if (widget.param!.waAdmin == null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              "Tidak tersedia",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
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
