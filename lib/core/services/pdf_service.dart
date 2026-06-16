import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  static Future<void> generateAndPrintUnifiedDossier() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  "Dossiê Unificado de Qualidade e Segurança",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                "Relatório de Análise de Causa Raiz (RCA)",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text("Data da Exportação: ${DateTime.now().toString()}"),
              pw.SizedBox(height: 20),
              pw.Text("Evidências (Mock):"),
              pw.Bullet(
                text: "Máquina: Falha no ABS detectada via telemetria.",
              ),
              pw.Bullet(
                text:
                    "Mão de Obra: Fadiga registrada no DMS na 8ª hora de trabalho.",
              ),
              pw.Bullet(
                text:
                    "Meio Ambiente: Pista molhada, redução de aderência em 40%.",
              ),
              pw.SizedBox(height: 30),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.red),
                ),
                child: pw.Text(
                  "Conclusão: O evento foi uma combinação de fadiga operacional agravada por pista úmida, necessitando de imediata intervenção nos Planos de Ação (PDCA) do Turno C.",
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
