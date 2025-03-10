import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../providers/pdfProvider.dart';
import '../services/filePickerService.dart';
import '../widgets/pdfCard.dart';
import 'PdfViewerScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pdfProvider = Provider.of<PdfProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Reader"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings screen

            },
          ),
        ],
      ),
      body: pdfProvider.pdfFiles.isEmpty
          ? const Center(child: Text("No PDFs found."))
          : ListView.builder(
        itemCount: pdfProvider.pdfFiles.length,
        itemBuilder: (context, index) {
          final pdf = pdfProvider.pdfFiles[index];
          return PdfCard(
            pdf: pdf,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfViewerScreen(pdfPath: pdf.path),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await requestStoragePermission()) {
            String? path = await FilePickerService.pickPDF();
            if (path != null) {
              pdfProvider.addPdf(path);
            }
          } else {
            // Show an alert to the user about missing permissions
          }
          /*String? path = await FilePickerService.pickPDF();
          if (path != null) {
            pdfProvider.addPdf(path);
          }*/
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
Future<bool> requestStoragePermission() async {
  PermissionStatus status = await Permission.storage.request();
  return status.isGranted;

}
