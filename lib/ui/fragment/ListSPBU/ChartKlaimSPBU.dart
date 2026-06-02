import 'dart:convert';
// import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/model/nota_model.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChartKlaimSPBU extends StatefulWidget {
  const ChartKlaimSPBU({super.key});

  @override
  State<ChartKlaimSPBU> createState() => _ChartKlaimSPBUState();
}

class _ChartKlaimSPBUState extends State<ChartKlaimSPBU> {
  List<NotaChartModel> dataChart = [];
  late String tokens;

  String tanggalString = "*belum dipilih";
  String tanggal = "";
  DateTime? dates;

  String tanggalStringEnd = "*belum dipilih";
  String tanggalEnd = "";
  DateTime? datesEnd;

  bool isFilter = false;
  bool isLoading = false;
  String url = "";

  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };

  @override
  void initState() {
    super.initState();
    fetchChart();
  }

  Future<void> fetchChart() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';

    url = "${APIConstant.urlBase}${APIConstant.serverApi}nota/chart1?var=test";
    if (tanggal.isNotEmpty) url += "&tgl_awal=$tanggal";
    if (tanggalEnd.isNotEmpty) url += "&tgl_akhir=$tanggalEnd";

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List rest = json.decode(response.body);
      setState(() {
        dataChart = rest.map((e) => NotaChartModel.fromJson(e)).toList();
      });
    } else if (response.statusCode == 401 && mounted) {
      Navigator.pushReplacementNamed(context, '/LoginScreen');
    }
  }

  Widget getTextWidgets(List<NotaChartModel> item) {
    return Column(
      children: item
          .map((e) => Text('${e.status} : ${formatCurrency(e.qty)}'))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (dataChart.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Mohon Tunggu'),
          ],
        ),
      );
    }

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2 < 400
                    ? 400
                    : MediaQuery.of(context).size.height / 2,
                child: SfCircularChart(
                  legend: const Legend(
                      isVisible: true, position: LegendPosition.bottom),
                  series: <CircularSeries>[
                    PieSeries<NotaChartModel, String>(
                      dataSource: dataChart,
                      xValueMapper: (e, _) => e.status,
                      yValueMapper: (e, _) => e.qty,
                      dataLabelMapper: (e, _) =>
                          '${e.status}\n${formatCurrency(e.qty)}',
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.inside,
                        textStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isFilter)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text('Periode: $tanggalString - $tanggalStringEnd'),
                ),
              const SizedBox(height: 10),
              getTextWidgets(dataChart),
              const SizedBox(height: 100),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton.icon(
              icon: const Icon(FontAwesomeIcons.filter, size: 12),
              label: const Text('Filter'),
              onPressed: () => tampilkanModalBottom(context),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> tampilkanModalBottom(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => _buildFilter(),
    );
  }

  Widget _buildFilter() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Filter Transaksi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildDatePicker("Tanggal Awal", tanggalString, (date) {
            dates = date;
            tanggal = DateFormat("yyyy-MM-dd").format(date);
            setState(() {
              tanggalString =
                  formatDateNew(date.toString(), format: "dd/mmm/yyyy");
            });
          }),
          _buildDatePicker("Tanggal Akhir", tanggalStringEnd, (date) {
            datesEnd = date;
            tanggalEnd = DateFormat("yyyy-MM-dd").format(date);
            setState(() {
              tanggalStringEnd =
                  formatDateNew(date.toString(), format: "dd/mmm/yyyy");
            });
          }),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(FontAwesomeIcons.filter, size: 12),
            label: const Text('Filter'),
            onPressed: _validateInputs,
          )
        ],
      ),
    );
  }

  Widget _buildDatePicker(
      String label, String value, Function(DateTime) onConfirm) {
    return Row(
      children: [
        const Icon(FontAwesomeIcons.calendar, color: Colors.blue),
        const SizedBox(width: 10),
        Text("$label : $value"),
        IconButton(
          icon: const Icon(FontAwesomeIcons.caretSquareDown),
          onPressed: () {
            DatePicker.showDatePicker(
              context,
              maxTime: DateTime.now(),
              locale: LocaleType.id,
              onConfirm: onConfirm,
            );
          },
        ),
      ],
    );
  }

  void _validateInputs() {
    if (tanggal.isEmpty || tanggalEnd.isEmpty) return;
    isFilter = true;
    isLoading = true;
    setState(() {});
    fetchChart().then((_) {
      isLoading = false;
      setState(() {});
    });
  }
}
