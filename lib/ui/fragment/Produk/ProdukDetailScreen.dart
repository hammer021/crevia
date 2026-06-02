import 'package:flutter/material.dart';
import 'package:kmob/model/produk_model.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ProdukDetailScreen extends StatelessWidget {
  final Produk produk;

  const ProdukDetailScreen({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDetail(context, produk.namaProduk) as PreferredSizeWidget,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slider Gambar
            if (produk.attachment.isNotEmpty)
              SizedBox(
                height: 250,
                width: double.infinity,
                child: PageView.builder(
                  itemCount: produk.attachment.length,
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
                                  itemCount: produk.attachment.length,
                                  builder: (context, i) {
                                    return PhotoViewGalleryPageOptions(
                                      imageProvider: NetworkImage(
                                          produk.attachment[i].imagePath),
                                      minScale:
                                          PhotoViewComputedScale.contained,
                                      maxScale:
                                          PhotoViewComputedScale.covered * 2.0,
                                      heroAttributes: PhotoViewHeroAttributes(
                                          tag: "promoImage_$i"),
                                    );
                                  },
                                  backgroundDecoration:
                                      BoxDecoration(color: Colors.black),
                                  pageController:
                                      PageController(initialPage: index),
                                  scrollPhysics: BouncingScrollPhysics(),
                                ),
                                Positioned(
                                  top: 40,
                                  right: 20,
                                  child: IconButton(
                                    icon: Icon(Icons.close,
                                        color: Colors.white, size: 30),
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
                            produk.attachment[index].imagePath,
                            fit: BoxFit.contain,
                          ),
                          backgroundDecoration:
                              BoxDecoration(color: Colors.white),
                          minScale: PhotoViewComputedScale.contained,
                          maxScale: PhotoViewComputedScale.covered * 2.0,
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
                  child:
                      Icon(Icons.shopping_bag, size: 100, color: Colors.blue),
                ),
              ),

            SizedBox(height: 16),
            Text(
              produk.namaProduk,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Kategori: ${produk.kategoriProduk}",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              "Deskripsi:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              produk.content ?? "Tidak ada deskripsi",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Hubungi:",
              style: TextStyle(fontSize: 14),
            ),
            if (produk.waAdmin != null)
              ...produk.waAdmin.map((admin) => Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: InkWell(
                      onTap: () {
                        //  String phone = admin.phone;
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(Icons.message,
                                    size: 20, color: Colors.green),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "${admin.note}",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.blue),
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
                                    mode: LaunchMode.externalApplication);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Tidak dapat membuka WhatsApp')),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  )),
            if (produk.waAdmin == null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  "Admin",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
