import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edge_connectivity_pk/edge_connectivity_pk.dart';
import 'package:edge_connectivity_pk/src/models/connectivity_status.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

/// A simple wrapper layout that you can customize
class LayoutTemplate extends StatelessWidget {
  final Widget? child;
  const LayoutTemplate({this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [if (child != null) child!]);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: "Overlay Root Example",
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: "/home",
      onGenerateRoute: (settings) {
        if (settings.name == "/home") {
          return MaterialPageRoute(builder: (_) => const HomePage());
        }
        return null;
      },

      /// Wrap everything in a root Overlay so overlays always have a parent
      builder: (context, child) {
        return Overlay(
          initialEntries: [
            OverlayEntry(builder: (context) => LayoutTemplate(child: child)),
          ],
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize EdgeConnectivity with navigatorKey
      EdgeConnectivity.init(
        config: EdgeConnectivityConfig(
          navigatorKey: navigatorKey,
          overlayDelay: const Duration(seconds: 1),
          blockUserInteraction: true,
          title: "No Internet",
          description: "Please check your connection",
          retryText: "Retry",
          offlineBuilder: (retry) {
            return Material(
              color: Colors.black54,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "You are offline",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Please check your internet connection.",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: retry,
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );

      // Listen to connectivity status changes
      EdgeConnectivity.onStatusChanged.listen((status) {
        debugPrint(
          status == ConnectivityStatus.disconnected
              ? "Device is offline"
              : "Device is online",
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: const Center(
        child: Text(
          "This is the home page.\nTurn off your internet to see the overlay.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
