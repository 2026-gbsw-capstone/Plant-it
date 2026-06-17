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
  bool _waitingForAnswer = false;

  @override
  void initState() {
    super.initState();
    _loadLocalMessages();
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
      _controller.clear();
      _sending = true;
      _waitingForAnswer = true;
    });
    _addMessages(_ChatMessage(text: question, mine: true));
    try {
      final response = await ApiService.instance.chat(
        plantId: widget.plantId,
        question: question,
      );
      _addMessages(_ChatMessage(text: response.answer, mine: false));
    } catch (error) {
      _addMessages(_ChatMessage(text: _chatErrorMessage(error), mine: false));
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
          _waitingForAnswer = false;
        });
      }
    }
  }

  Future<void> _showUploadSheet() async {
    final result = await showModalBottomSheet<_ChatUploadResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PlantChatUploadSheet(plantId: widget.plantId),
    );
    if (result == null || !mounted) return;

    _addMessages(
      _ChatMessage(
        text: result.question,
        mine: true,
        imageUrl: result.imageUrl,
      ),
      _ChatMessage(text: result.answer, mine: false),
    );
  }

  String _chatErrorMessage(Object error) {
    final message = error.toString();
    if (message.contains('서버 오류') || message.contains('OpenAI')) {
      return '지금 AI 답변을 만들지 못했어요. 서버 AI 설정을 확인한 뒤 다시 시도해 주세요.';
    }
    return message;
  }

  Future<void> _loadLocalMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final rawMessages = prefs.getStringList(_historyKey()) ?? const [];
    final messages = rawMessages
        .map(_ChatMessage.tryDecode)
        .whereType<_ChatMessage>()
        .toList();
    if (!mounted) return;
    setState(() {
      _messages
        ..clear()
        ..addAll(
          messages.isEmpty
              ? const [_ChatMessage(text: '식물 상태나 관리 방법을 물어보세요.', mine: false)]
              : messages,
        );
    });
  }

  void _addMessages(_ChatMessage first, [_ChatMessage? second]) {
    setState(() {
      _messages.add(first);
      if (second != null) _messages.add(second);
    });
    _saveLocalMessages();
  }

  Future<void> _saveLocalMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _historyKey(),
      _messages.map((message) => message.encode()).toList(),
    );
  }

  String _historyKey() => 'plant_chat_messages_${widget.plantId}';

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
                        _ChatMessageBubble(message: message),
                      if (_waitingForAnswer) const _ChatTypingBubble(),
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
                      _SquareIconButton(
                        icon: Icons.add_a_photo_outlined,
                        onTap: _sending ? null : _showUploadSheet,
                      ),
                      const SizedBox(width: 8),
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
  const _ChatMessage({required this.text, required this.mine, this.imageUrl});

  final String text;
  final bool mine;
  final String? imageUrl;

  String encode() {
    return jsonEncode({'text': text, 'mine': mine, 'imageUrl': imageUrl});
  }

  static _ChatMessage? tryDecode(String value) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is! Map<String, dynamic>) return null;
      return _ChatMessage(
        text: decoded['text'] as String? ?? '',
        mine: decoded['mine'] as bool? ?? false,
        imageUrl: decoded['imageUrl'] as String?,
      );
    } catch (_) {
      return null;
    }
  }
}

class _ChatMessageBubble extends StatelessWidget {
  const _ChatMessageBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    if (message.imageUrl == null || message.imageUrl!.isEmpty) {
      return _ChatBubble(text: message.text, mine: message.mine);
    }

    return Align(
      alignment: message.mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 248),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: message.mine ? PlantItColors.green : PlantItColors.greenSoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: _PlantImage(url: message.imageUrl),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message.text,
              style: TextStyle(
                color: message.mine ? Colors.white : PlantItColors.text,
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatTypingBubble extends StatelessWidget {
  const _ChatTypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: PlantItColors.greenSoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: PlantItColors.green,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '채팅 중...',
              style: TextStyle(
                color: PlantItColors.text,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlantChatUploadSheet extends StatefulWidget {
  const _PlantChatUploadSheet({required this.plantId});

  final int plantId;

  @override
  State<_PlantChatUploadSheet> createState() => _PlantChatUploadSheetState();
}

class _PlantChatUploadSheetState extends State<_PlantChatUploadSheet> {
  final _imagePath = TextEditingController();
  final _question = TextEditingController(text: '이 사진을 보고 식물 상태와 관리 방법을 알려줘');
  bool _analyzing = false;

  @override
  void dispose() {
    _imagePath.dispose();
    _question.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    final path = await ImageUploadService.instance.pickPlantImage(source);
    if (path == null || !mounted) return;
    setState(() => _imagePath.text = path);
  }

  Future<void> _pickFile() async {
    final path = await ImageUploadService.instance.pickPlantImageFile();
    if (path == null || !mounted) return;
    setState(() => _imagePath.text = path);
  }

  Future<void> _analyze() async {
    final question = _question.text.trim();
    if (_imagePath.text.trim().isEmpty || question.isEmpty || _analyzing) {
      return;
    }

    setState(() => _analyzing = true);
    try {
      final imageUrl = await ImageUploadService.instance.uploadIfLocalFile(
        _imagePath.text,
        type: 'ai',
      );
      if (imageUrl == null || imageUrl.isEmpty) {
        throw ApiException('분석할 이미지가 필요합니다.');
      }
      final result = await ApiService.instance.chat(
        plantId: widget.plantId,
        question: question,
        imageUrl: imageUrl,
      );
      if (!mounted) return;
      Navigator.pop(
        context,
        _ChatUploadResult(
          question: question,
          imageUrl: imageUrl,
          answer: result.answer,
        ),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_uploadErrorMessage(error))));
      }
    } finally {
      if (mounted) setState(() => _analyzing = false);
    }
  }

  String _uploadErrorMessage(Object error) {
    final message = error.toString();
    if (message.contains('서버 오류') || message.contains('OpenAI')) {
      return 'AI가 사진을 분석하지 못했어요. 서버 AI 설정을 확인해 주세요.';
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '식물 상태 확인',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          _ImagePickerPanel(
            imagePath: _imagePath.text,
            emptyLabel: '분석할 식물 사진',
            height: 220,
            onCamera: () => _pick(ImageSource.camera),
            onGallery: () => _pick(ImageSource.gallery),
            onFile: _pickFile,
            onClear: _imagePath.text.trim().isEmpty
                ? null
                : () => setState(() => _imagePath.clear()),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _question,
            minLines: 2,
            maxLines: 3,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: '질문',
              hintText: '사진과 함께 물어볼 내용을 입력해 주세요',
            ),
          ),
          const SizedBox(height: 16),
          _PrimaryButton(
            label: _analyzing ? '전송 중' : '사진으로 질문하기',
            expanded: true,
            onTap:
                _imagePath.text.trim().isEmpty ||
                    _question.text.trim().isEmpty ||
                    _analyzing
                ? null
                : _analyze,
          ),
        ],
      ),
    );
  }
}

class _ChatUploadResult {
  const _ChatUploadResult({
    required this.question,
    required this.imageUrl,
    required this.answer,
  });

  final String question;
  final String imageUrl;
  final String answer;
}
