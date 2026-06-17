import 'package:flutter/material.dart';

import '../theme.dart';
import 'legal_model.dart';

/// LegalDoc 를 Growve 디자인 톤으로 렌더링하는 공통 페이지.
class LegalPage extends StatelessWidget {
  const LegalPage({super.key, required this.doc});

  final LegalDoc doc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrowveColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(title: doc.title),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: GrowveTheme.maxContentWidth,
                  ),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 64),
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        doc.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: GrowveColors.text,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '시행일: ${doc.effectiveDate}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: GrowveColors.muted,
                        ),
                      ),
                      if (doc.intro != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: GrowveColors.greenSoft,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            doc.intro!,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.7,
                              color: GrowveColors.greenDark,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      for (final section in doc.sections)
                        _SectionView(section: section),
                      if (doc.closing != null) ...[
                        const SizedBox(height: 16),
                        const Divider(color: GrowveColors.line, height: 32),
                        Text(
                          doc.closing!,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.8,
                            color: GrowveColors.muted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: GrowveColors.cream,
        border: Border(bottom: BorderSide(color: GrowveColors.line)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: GrowveTheme.maxContentWidth,
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back, color: GrowveColors.text),
                tooltip: '뒤로',
              ),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: GrowveColors.text,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionView extends StatelessWidget {
  const _SectionView({required this.section});

  final LegalSection section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.heading,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: GrowveColors.green,
              height: 1.4,
            ),
          ),
          if (section.body != null) ...[
            const SizedBox(height: 10),
            Text(
              section.body!,
              style: const TextStyle(
                fontSize: 14.5,
                height: 1.75,
                color: GrowveColors.text,
              ),
            ),
          ],
          if (section.bullets != null) ...[
            const SizedBox(height: 10),
            for (final bullet in section.bullets!) _Bullet(text: bullet),
          ],
          if (section.table != null) ...[
            const SizedBox(height: 14),
            _LegalTable(rows: section.table!),
          ],
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 9, right: 10),
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: GrowveColors.green,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14.5,
                height: 1.7,
                color: GrowveColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalTable extends StatelessWidget {
  const _LegalTable({required this.rows});

  /// 첫 번째 행을 헤더로 사용.
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    final header = rows.first;
    final body = rows.skip(1).toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Table(
        border: TableBorder.symmetric(
          inside: const BorderSide(color: GrowveColors.line),
        ),
        defaultVerticalAlignment: TableCellVerticalAlignment.top,
        children: [
          TableRow(
            decoration: const BoxDecoration(color: GrowveColors.green),
            children: [
              for (final cell in header)
                _Cell(text: cell, isHeader: true),
            ],
          ),
          for (var i = 0; i < body.length; i++)
            TableRow(
              decoration: BoxDecoration(
                color: i.isEven ? GrowveColors.paper : GrowveColors.cream,
              ),
              children: [
                for (final cell in body[i]) _Cell(text: cell),
              ],
            ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.text, this.isHeader = false});

  final String text;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          height: 1.55,
          fontWeight: isHeader ? FontWeight.w700 : FontWeight.w400,
          color: isHeader ? Colors.white : GrowveColors.text,
        ),
      ),
    );
  }
}
