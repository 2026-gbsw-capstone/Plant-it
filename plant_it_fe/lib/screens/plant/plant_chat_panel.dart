part of '../app_screen.dart';

class PlantChatPanel extends StatefulWidget {
  const PlantChatPanel({required this.plant, super.key});

  final PlantModel plant;

  @override
  State<PlantChatPanel> createState() => _PlantChatPanelState();
}

class _PlantChatPanelState extends State<PlantChatPanel> {
  final _controller = TextEditingController();
  final _messages = <_ChatMessage>[];
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
        plantId: widget.plant.id,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          for (final message in _messages)
            _ChatBubble(text: message.text, mine: message.mine),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: '상태를 입력하세요'),
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
        ],
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage(this.text, this.mine);

  final String text;
  final bool mine;
}
