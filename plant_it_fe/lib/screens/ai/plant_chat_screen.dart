import 'package:flutter/material.dart';
import 'package:plant_it_fe/screens/shared/app_theme.dart';
import 'package:plant_it_fe/screens/shared/app_widgets.dart';

class PlantChatScreen extends StatefulWidget {
  const PlantChatScreen({super.key});

  @override
  State<PlantChatScreen> createState() => _PlantChatScreenState();
}

class _PlantChatScreenState extends State<PlantChatScreen> {
  final _controller = TextEditingController();
  final _messages = <_ChatMessage>[
    const _ChatMessage(text: '사진을 올리거나 증상을 말해주면 같이 확인해볼게요.', mine: false),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, mine: true));
      _messages.add(
        const _ChatMessage(
          text: '흙이 마른 정도와 최근 물 준 날짜를 먼저 확인해 주세요.',
          mine: false,
        ),
      );
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('질문'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const AssetIcon(name: 'back'),
        ),
        actions: [
          IconButton(
            onPressed: () => _showUploadSheet(context),
            icon: const AssetIcon(name: 'image'),
          ),
        ],
      ),
      body: PrototypeScaffold(
        includeBottomSafeArea: false,
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                itemCount: _messages.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment: message.mine
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 292),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: message.mine
                            ? AppColors.green
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: message.mine ? Colors.white : AppColors.text,
                          height: 1.5,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(hintText: '메시지 입력'),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    RoundIconButton(
                      onPressed: _send,
                      icon: const AssetIcon(
                        name: 'send',
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool mine;

  const _ChatMessage({required this.text, required this.mine});
}

void _showUploadSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.background,
    showDragHandle: true,
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('갤러리에서 선택'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightGreen,
            ),
            child: const Text('사진 촬영'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
        ],
      ),
    ),
  );
}
