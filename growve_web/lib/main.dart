import 'package:flutter/material.dart';

import 'legal/legal_content.dart';
import 'legal/legal_page.dart';
import 'screen/main.dart';
import 'theme.dart';

void main() {
  runApp(const Web());
}

class Web extends StatelessWidget {
  const Web({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Growve',
      debugShowCheckedModeBanner: false,
      theme: GrowveTheme.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const Main(),
        '/terms': (context) => const LegalPage(doc: termsOfService),
        '/privacy': (context) => const LegalPage(doc: privacyPolicy),
        '/third-party': (context) => const LegalPage(doc: thirdPartyConsent),
        '/overseas': (context) => const LegalPage(doc: overseasTransferConsent),
      },
    );
  }
}
