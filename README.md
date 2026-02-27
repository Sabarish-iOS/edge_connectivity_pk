# edge_connectivity_pk

**edge_connectivity_pk** is a lightweight Flutter package for Android and iOS that detects real internet connectivity (not just network type) without using `connectivity_plus`. It performs HTTP or DNS checks and integrates with **GetX** for state management.

## Features

- Initialize via `EdgeConnectivity.init()` in `main()` with `GetMaterialApp`.
- Automatically monitors connectivity while the app is in the foreground (pauses in background, re-checks on resume).
- Global overlay appears when internet is lost, with configurable delay to prevent flicker.
- Overlay can optionally block user interaction.
- Retry action included in the overlay, allowing immediate connectivity re-check.
- Fully customizable UI via default parameters or a custom builder.
- Exposes a stream of connectivity status for reactive programming.

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  edge_connectivity_pk: ^0.0.1

Then run:

flutter pub get
Basic Usage

Initialize in main() before running the app:

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  EdgeConnectivity.init();
  runApp(GetMaterialApp(home: MyHomePage()));
}

Listen to connectivity status changes:

EdgeConnectivity.statusStream.listen((status) {
  if (status == ConnectivityStatus.connected) {
    print("Internet is available");
  } else {
    print("No internet connection");
  }
});
Overlay Customization

You can customize the offline overlay using the default parameters:

EdgeConnectivity.init(
  overlayTitle: "No Internet",
  overlayDescription: "Please check your connection",
  overlayRetryText: "Retry",
  overlayDelaySeconds: 2,
  overlayBlocking: true,
);

Or provide a fully custom overlay builder:

EdgeConnectivity.init(
  overlayBuilder: (context, retryCallback) {
    return Center(
      child: ElevatedButton(
        onPressed: retryCallback,
        child: Text("Try Again"),
      ),
    );
  },
);

retryCallback can be used to manually re-check connectivity and dismiss the overlay if restored.

Stream for Connectivity Status

The package exposes a stream for real-time connectivity updates:

EdgeConnectivity.statusStream.listen((status) {
  switch (status) {
    case ConnectivityStatus.connected:
      print("Connected");
      break;
    case ConnectivityStatus.disconnected:
      print("Disconnected");
      break;
  }
});
Example App

You can see a working example in the example folder of this repository.

License

MIT License. See the LICENSE file for details.