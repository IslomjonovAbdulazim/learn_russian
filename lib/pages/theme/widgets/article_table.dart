import 'package:flutter/material.dart';
import '../../../models/article_component_model.dart';
import '../../../utils/text_styles.dart';
import '../../../utils/colors.dart';
import '../../../utils/helpers.dart';

class ArticleTable extends StatelessWidget {
  final ArticleComponentModel component;
  final double fontSize;

  const ArticleTable({
    super.key,
    required this.component,
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final data = component.tableData;
    final headers = component.tableHeaders;
    final caption = component.caption;

    if (data.isEmpty) {
      return _buildEmptyTable();
    }

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Caption
          if (caption != null) ...[
            Text(
              caption,
              style: AppTextStyles.labelLarge.copyWith(
                fontSize: fontSize * 0.9,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Table
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor: MaterialStateProperty.all(
                    AppColors.primaryBlue.withOpacity(0.1),
                  ),
                  headingTextStyle: AppTextStyles.labelMedium.copyWith(
                    fontSize: fontSize * 0.9,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlueDark,
                  ),
                  dataTextStyle: _getTableTextStyle().copyWith(
                    fontSize: fontSize * 0.9,
                  ),
                  columns: _buildColumns(headers, data),
                  rows: _buildRows(data),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTable() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.table_chart, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            'Bo\'sh jadval',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  List<DataColumn> _buildColumns(List<String>? headers, List<List<String>> data) {
    final columnCount = data.isNotEmpty ? data.first.length : 0;

    if (headers != null && headers.isNotEmpty) {
      return headers.take(columnCount).map((header) =>
          DataColumn(
            label: Expanded(
              child: Text(
                header,
                style: AppTextStyles.labelMedium.copyWith(
                  fontSize: fontSize * 0.9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ).toList();
    } else {
      // Generate generic column headers
      return List.generate(columnCount, (index) =>
          DataColumn(
            label: Expanded(
              child: Text(
                'Ustun ${index + 1}',
                style: AppTextStyles.labelMedium.copyWith(
                  fontSize: fontSize * 0.9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      );
    }
  }

  List<DataRow> _buildRows(List<List<String>> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final row = entry.value;

      return DataRow(
        color: MaterialStateProperty.all(
          index.isEven
              ? Colors.transparent
              : Colors.grey.withOpacity(0.05),
        ),
        cells: row.map((cell) =>
            DataCell(
              Container(
                constraints: const BoxConstraints(minWidth: 80),
                child: Text(
                  cell,
                  style: _getCellTextStyle(cell).copyWith(
                    fontSize: fontSize * 0.9,
                  ),
                ),
              ),
            ),
        ).toList(),
      );
    }).toList();
  }

  TextStyle _getTableTextStyle() {
    return AppTextStyles.bodyMedium;
  }

  TextStyle _getCellTextStyle(String cellText) {
    // Use Russian text style if the text contains Cyrillic characters
    if (AppHelpers.isRussianText(cellText)) {
      return AppTextStyles.russianMedium;
    } else {
      return AppTextStyles.bodyMedium;
    }
  }
}