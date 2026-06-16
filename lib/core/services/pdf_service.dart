import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  static Future<void> generateAndPrintUnifiedDossier({
    List<Map<String, dynamic>>? whys,
    List<Map<String, dynamic>>? actions,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
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
              pw.Text("1. Evidências (Mock):", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
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
              pw.SizedBox(height: 20),

              if (whys != null && whys.isNotEmpty) ...[
                pw.Text("2. Análise 5 Porquês:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                pw.SizedBox(height: 10),
                ...whys.map((w) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Text("${w['number']}. ${w['question']}\nR: ${w['answer']}${w['isRootCause'] ? ' [CAUSA RAIZ]' : ''}"),
                )),
                pw.SizedBox(height: 20),
              ],

              if (actions != null && actions.isNotEmpty) ...[
                pw.Text("3. Plano de Ação (5W2H):", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                pw.SizedBox(height: 10),
                pw.TableHelper.fromTextArray(
                  headers: ['O Que', 'Quem', 'Quando', 'Status', 'PDCA'],
                  data: actions.map((a) => [
                    a['what'].toString(),
                    a['who'].toString(),
                    a['when'].toString(),
                    a['status'].toString(),
                    a['pdcaPhase'].toString(),
                  ]).toList(),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                  cellStyle: const pw.TextStyle(fontSize: 10),
                  cellAlignment: pw.Alignment.centerLeft,
                ),
                pw.SizedBox(height: 20),
              ],

              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.red),
                ),
                child: pw.Text(
                  "Conclusão: O evento foi uma combinação de fadiga operacional agravada por pista úmida, necessitando de imediata intervenção nos Planos de Ação (PDCA) do Turno C.",
                ),
              ),
            ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
