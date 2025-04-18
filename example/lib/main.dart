import 'package:flutter/material.dart';
import 'package:interactive_chart/interactive_chart.dart';

import 'mock_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<CandleData> _data = MockDataTesla.candles;
  bool _darkMode = true;
  bool _showAverage = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        brightness: _darkMode ? Brightness.dark : Brightness.light,
      ),
      home: Scaffold(
        backgroundColor: Color(0xFF0F0F0F),
        appBar: AppBar(
          title: const Text("Interactive Chart Demo"),
          actions: [
            IconButton(
              icon: Icon(_darkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: () => setState(() => _darkMode = !_darkMode),
            ),
            IconButton(
              icon: Icon(
                _showAverage ? Icons.show_chart : Icons.bar_chart_outlined,
              ),
              onPressed: () {
                setState(() => _showAverage = !_showAverage);
                if (_showAverage) {
                  _computeTrendLines();
                } else {
                  _removeTrendLines();
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(24.0),
          child: InteractiveChart(
            /** Only [candles] is required */
            candles: _data,
            /** Uncomment the following for examples on optional parameters */
          
            /** Example styling */
            style: ChartStyle(
              priceGainColor: Color(0xFF089981),
              priceLossColor: Color(0xFFF23645),
              volumeColor: Colors.transparent,
              trendLineStyles: [
                Paint()
                  ..strokeWidth = 1
                  ..strokeCap = StrokeCap.round
                  ..color = Colors.white,
                Paint()
                  ..strokeWidth = 1
                  ..strokeCap = StrokeCap.round
                  ..color = Colors.green,
              ],
              priceGridLineColor: Color(0xFF1C1C1C),
              priceLabelStyle: TextStyle(color: Color(0xFFB8B8B8)),
              timeLabelStyle: TextStyle(color: Color(0xFFB8B8B8)),
              selectionHighlightColor: Colors.red.withOpacity(0.2),
              overlayBackgroundColor: Colors.red[900]!.withOpacity(0.6),
              overlayTextStyle: TextStyle(color: Colors.red[100]),
              volumeHeightFactor: 0, // volume area is 20% of total height
            ),
            /** Customize axis labels */
            //timeLabel: (timestamp, visibleDataCount) => "📅",
            //priceLabel: (price) => "${price.round()} 💎",
            /** Customize overlay (tap and hold to see it)
             ** Or return an empty object to disable overlay info. */
            overlayInfo: (candle) => {
              "💎": "🤚    ",
              "Hi": "${candle.high?.toStringAsFixed(2)}",
              "Lo": "${candle.low?.toStringAsFixed(2)}",
            },
            /** Callbacks */
            onTap: (candle) => print("user tapped on $candle"),
            onCandleResize: (width) => print("each candle is $width wide"),
          ),
        ),
      ),
    );
  }

  _computeTrendLines() {
    final ma20 = CandleData.computeMA(_data, 20);
    final ma66 = CandleData.computeMA(_data, 66);

    for (int i = 0; i < _data.length; i++) {
      _data[i].trends = [ma20[i], ma66[i]];
    }
  }

  _removeTrendLines() {
    for (final data in _data) {
      data.trends = [];
    }
  }
}
