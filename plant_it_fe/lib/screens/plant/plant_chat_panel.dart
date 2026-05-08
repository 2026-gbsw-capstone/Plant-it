part of '../app_screen.dart';

class PlantChatScreen extends StatefulWidget {
  const PlantChatScreen({required this.plantId, super.key});

  final int plantId;

  @override
  State<PlantChatScreen> createState() => _PlantChatScreenState();
}

class _PlantChatScreenState extends State<PlantChatScreen> {
  final _controller = TextEditingController();
  final _messages = <_ChatMessage>[];
  late final Future<PlantModel> _plant = ApiService.instance.getPlant(
    widget.plantId,
  );
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _messages.add(_ChatMessage('식물 상태나 관리 방법을 물어보세요.', false));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final question = _controller.text.trim();
    if (question.isEmpty || _sending) return;
    setState(() {
      _messages.add(_ChatMessage(question, true));
      _controller.clear();
      _sending = true;
    });
    try {
      final response = await ApiService.instance.chat(
        plantId: widget.plantId,
        question: question,
      );
      setState(() => _messages.add(_ChatMessage(response.answer, false)));
    } catch (error) {
      setState(() => _messages.add(_ChatMessage(error.toString(), false)));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PlantModel>(
      future: _plant,
      builder: (context, snapshot) {
        final plant = snapshot.data;
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 26, 12, 10),
                  child: _TopBar(
                    title: plant?.name ?? '식물 채팅',
                    onBack: () => context.pop(),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 260),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: PlantItColors.paper,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '식물의 상태나 관리 방법을 물어보세요.',
                            style: TextStyle(fontSize: 12, height: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      if (plant != null)
                        Align(
                          alignment: Alignment.centerRight,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 104,
                              height: 104,
                              child: _PlantImage(url: plant.plantImageUrl),
                            ),
                          ),
                        ),
                      const SizedBox(height: 18),
                      for (final message in _messages)
                        _ChatBubble(text: message.text, mine: message.mine),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    8,
                    16,
                    MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(hintText: '물어보기'),
                          onSubmitted: (_) => _send(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: _sending ? null : _send,
                        icon: const _NavIcon(
                          'assets/icons/send.svg',
                          color: Colors.white,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: PlantItColors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChatMessage {
  const _ChatMessage(this.text, this.mine);

  final String text;
  final bool mine;
}
