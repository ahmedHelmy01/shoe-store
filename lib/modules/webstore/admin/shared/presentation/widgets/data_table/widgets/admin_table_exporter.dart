import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:erp/modules/webstore/admin/shared/export/admin_export.dart';
import 'package:excel/excel.dart' as ex;
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;
import 'package:arabic_reshaper/arabic_reshaper.dart';
import 'package:bidi/bidi.dart' as bidi;
import 'admin_table_models.dart';

class AdminTableExporter {
  static Future<void> exportCsv<T>({
    required BuildContext context,
    required List<T> rows,
    required List<AdminColumn<T>> columns,
    required String baseName,
    required String suffix,
  }) async {
    final cols = columns.where((c) => c.exportValue != null || c.sortValue != null).toList();

    String esc(String v) {
      final needs = v.contains(',') || v.contains('"') || v.contains('\n') || v.contains('\r');
      final out = v.replaceAll('"', '""');
      return needs ? '"$out"' : out;
    }

    final header = cols.map((c) => esc(c.title)).join(',');
    final lines = <String>[header];

    for (final r in rows) {
      final values = cols.map((c) {
        final v = c.exportValue?.call(r) ?? c.sortValue?.call(r)?.toString() ?? '';
        return esc(v);
      }).join(',');
      lines.add(values);
    }

    final csv = lines.join('\n');
    final filename = '${baseName}_$suffix.csv';
    await AdminExport.downloadText(
      filename: filename,
      content: csv,
      mimeType: 'text/csv;charset=utf-8',
    );

    _showSnackBar(context, 'Exported $suffix (${rows.length})');
  }

  static Future<void> exportExcel<T>({
    required BuildContext context,
    required List<T> rows,
    required List<AdminColumn<T>> columns,
    required String baseName,
    required String suffix,
  }) async {
    final cols = columns.where((c) => c.exportValue != null || c.sortValue != null).toList();
    final excel = ex.Excel.createExcel();
    final sheet = excel['Sheet1'];

    sheet.appendRow(cols.map((c) => ex.TextCellValue(c.title)).toList());
    for (final r in rows) {
      sheet.appendRow(
        cols.map((c) => ex.TextCellValue(c.exportValue?.call(r) ?? c.sortValue?.call(r)?.toString() ?? '')).toList(),
      );
    }

    final bytes = excel.save();
    if (bytes == null) return;

    final filename = '${baseName}_$suffix.xlsx';
    await AdminExport.downloadBytes(
      filename: filename,
      bytes: bytes,
      mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    );

    _showSnackBar(context, 'Exported $suffix (${rows.length})');
  }

  static Future<void> exportPdf<T>({
    required BuildContext context,
    required List<T> rows,
    required List<AdminColumn<T>> columns,
    required String baseName,
    required String suffix,
  }) async {
    final cols = columns.where((c) => c.exportValue != null || c.sortValue != null).toList();

    final document = sf.PdfDocument();
    final fontData = await rootBundle.load('assets/common/fonts/Harmattan-Regular.ttf');
    final fontBytes = fontData.buffer.asUint8List();
    final font = sf.PdfTrueTypeFont(fontBytes, 10);
    final boldFont = sf.PdfTrueTypeFont(fontBytes, 11, style: sf.PdfFontStyle.bold);

    final page = document.pages.add();
    final reshaper = ArabicReshaper();

    String shape(String text) {
      if (text.isEmpty) return '';
      final reshaped = reshaper.reshape(text);
      final visual = bidi.logicalToVisual(reshaped);
      return String.fromCharCodes(visual);
    }

    final grid = sf.PdfGrid();
    grid.columns.add(count: cols.length);
    grid.style.font = font;

    final format = sf.PdfStringFormat(
      alignment: sf.PdfTextAlignment.right,
      lineAlignment: sf.PdfVerticalAlignment.middle,
    );

    for (int i = 0; i < grid.columns.count; i++) {
      grid.columns[i].format = format;
    }

    grid.headers.add(1);
    final headerRow = grid.headers[0];
    for (int i = 0; i < cols.length; i++) {
      headerRow.cells[i].value = shape(cols[i].title);
      headerRow.cells[i].style.font = boldFont;
      headerRow.cells[i].style.stringFormat = format;
      headerRow.cells[i].style.backgroundBrush = sf.PdfBrushes.darkSlateBlue;
      headerRow.cells[i].style.textBrush = sf.PdfBrushes.white;
    }

    for (final r in rows) {
      final row = grid.rows.add();
      for (int i = 0; i < cols.length; i++) {
        final val = cols[i].exportValue?.call(r) ?? cols[i].sortValue?.call(r)?.toString() ?? '';
        row.cells[i].value = shape(val);
        row.cells[i].style.font = font;
        row.cells[i].style.stringFormat = format;
      }
    }

    grid.style.cellPadding = sf.PdfPaddings(left: 8, top: 8, right: 8, bottom: 8);
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, 60, page.getClientSize().width, page.getClientSize().height - 60),
    );

    page.graphics.drawString(
      shape('${baseName.toUpperCase()} (${rows.length})'),
      boldFont,
      bounds: Rect.fromLTWH(0, 10, page.getClientSize().width, 40),
      format: sf.PdfStringFormat(
        alignment: sf.PdfTextAlignment.center,
        lineAlignment: sf.PdfVerticalAlignment.middle,
      ),
    );

    final bytes = await document.save();
    document.dispose();

    final filename = '${baseName}_$suffix.pdf';
    await AdminExport.downloadBytes(
      filename: filename,
      bytes: Uint8List.fromList(bytes),
      mimeType: 'application/pdf',
    );

    _showSnackBar(context, 'Exported $suffix (${rows.length})');
  }

  static void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
