import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kmob/utils/constant.dart';
import 'package:kmob/model/produk_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/ui/fragment/produk/ProdukDetailScreen.dart';

class ProdukFragment extends StatefulWidget {
  @override
  _ProdukFragmentState createState() => _ProdukFragmentState();
}

class _ProdukFragmentState extends State<ProdukFragment> {
  String url = APIConstant.urlBase + APIConstant.serverApi + "product";
  String url_cat =
      APIConstant.urlBase + APIConstant.serverApi + "product/kategori";

  String tokens = "";
  List<Produk> _produkList = [];
  List<KategoriProduk> _kategoriList = [];
  bool isLoading = true;

  Map<String, String> get headers => {
        'Authorization': 'Bearer ${tokens ?? ""}',
        'Content-Type': 'application/json',
      };

  Future<void> fetchKategori() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';

    final response = await executeRequest(
      url_cat,
      method: RequestMethod.GET,
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;

      setState(() {
        _kategoriList = data
            .map<KategoriProduk>((json) => KategoriProduk.fromJson(json))
            .toList();
      });
    }
  }

  Future<void> fetchProduk() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';

    final response = await executeRequest(
      url,
      method: RequestMethod.GET,
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;

      setState(() {
        _produkList =
            data.map<Produk>((json) => Produk.fromJson(json)).toList();
      });
    }
  }

  String? selectedCategoryId;
  List<Produk> getFilteredProduk() {
    if (selectedCategoryId == "0" || selectedCategoryId == null) {
      return _produkList;
    }
    return _produkList
        .where((produk) => produk.kategoriProdukId == selectedCategoryId)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await fetchKategori();
    await fetchProduk();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
            child:
                CircularProgressIndicator()), // Tampilkan loading saat data diambil
      );
    }

    return Scaffold(
      body: Column(
        children: [
          // Dropdown Filter Kategori
          SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0), // Padding untuk seluruh baris
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Pastikan sejajar secara vertikal
              children: [
                Text(
                  "Kategori: ",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(width: 10), // Beri jarak antara teks dan dropdown
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedCategoryId,
                    isExpanded: true,
                    hint: Text("Pilih Kategori"),
                    items: [
                      DropdownMenuItem<String>(
                        value: "0",
                        child: Text("Semua"),
                      ),
                      ..._kategoriList.map((KategoriProduk kategori) {
                        return DropdownMenuItem<String>(
                          value: kategori.kategoriProdukId,
                          child: Text(kategori.kategoriProduk),
                        );
                      }).toList(),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategoryId = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // GridView Produk
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: getFilteredProduk().length,
              itemBuilder: (context, index) {
                final produk = getFilteredProduk()[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProdukDetailScreen(produk: produk),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          produk.attachment.isNotEmpty
                              ? Image.network(
                                  produk.attachment[0]
                                      .imagePath, // Ambil gambar pertama
                                  width: 125,
                                  height: 125,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.broken_image,
                                          size: 50, color: Colors.red),
                                )
                              : Icon(Icons.shopping_bag,
                                  size: 50, color: Colors.blue),
                          SizedBox(height: 10),
                          Text(
                            produk.namaProduk,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            produk.kategoriProduk,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
