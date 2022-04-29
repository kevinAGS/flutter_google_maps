import 'package:flutter/material.dart';
import 'package:flutter_google_maps/app/ui/pages/home/home_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final controller = HomeController();
        controller.onMarkerTap.listen((String id) {
          print("go to $id");
        });
        return controller;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Map"),
        ),
        // El widget de googlemap tiene que estar en el body o en un widget
        // que defina sus dimensiones
        body: Selector<HomeController, bool>(
          selector: (_, controler) => controler.loading,
          builder: (context, loading, loadingWidget) {
            if (loading) {
              return loadingWidget!;
            }

            return Consumer<HomeController>(
              builder: (_, controller, gpsMessageWidget) {
                if (!controller.gpsEnable) {
                  return gpsMessageWidget!;
                }

                return GoogleMap(
                  markers: controller.markers,
                  initialCameraPosition: controller.initialCameraPosition,

                  // bloquea boton de tu locacion
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  //para los diferentes tipos de vistas
                  mapType: MapType.hybrid,

                  onLongPress: controller.onLongPress,
                );
              },
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Para acceder a tu localizacion \n Debes activar el GPS",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Encender GPS"),
                    ),
                  ],
                ),
              ),
            );
          },
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
