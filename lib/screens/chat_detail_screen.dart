import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  final bool isRead;
  final String? catalogItemName;
  final String? catalogItemPrice;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    this.isRead = true,
    this.catalogItemName,
    this.catalogItemPrice,
  });
}

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final String avatarUrl;
  final String initialMessage;
  final String? label;
  final Color? labelColor;

  const ChatDetailScreen({
    Key? key,
    required this.name,
    required this.avatarUrl,
    required this.initialMessage,
    this.label,
    this.labelColor,
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<ChatMessage> _messages;

  final List<String> _quickReplies = [
    'Thanks for reaching out! How can we assist you today?',
    'Your order is confirmed and will be ready for pickup.',
    'Our business hours are Mon-Fri 9AM-6PM.',
    'Please find our complete catalog attached.',
  ];

  @override
  void initState() {
    super.initState();
    _messages = [
      ChatMessage(
        text: 'Hello! I saw your business profile and wanted to inquire about your products.',
        isMe: false,
        time: '10:15 AM',
      ),
      ChatMessage(
        text: widget.initialMessage,
        isMe: false,
        time: '10:20 AM',
      ),
      ChatMessage(
        text: 'Hi ${widget.name.split(" ").first}! Thanks for getting in touch. Here is our best-selling blend:',
        isMe: true,
        time: '10:22 AM',
        catalogItemName: 'Artisan Espresso Roast (500g)',
        catalogItemPrice: '\$16.50',
      ),
    ];
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text, {String? itemName, String? itemPrice}) {
    if (text.trim().isEmpty && itemName == null) return;
    final now = TimeOfDay.now();
    final timeStr =
        '${now.hourOfPeriod}:${now.minute.toString().padLeft(2, "0")} ${now.period == DayPeriod.am ? "AM" : "PM"}';

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isMe: true,
        time: timeStr,
        catalogItemName: itemName,
        catalogItemPrice: itemPrice,
      ));
    });
    _textController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });

    // Simulate customer auto-reply
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: 'Thank you! That sounds perfect. Can you reserve one for me?',
            isMe: false,
            time: timeStr,
          ));
        });
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAttachOption(
                  icon: Icons.store,
                  label: 'Catalog',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    _sendMessage(
                      'Here is an item from our business catalog:',
                      itemName: 'Single Origin Colombia (250g)',
                      itemPrice: '\$14.00',
                    );
                  },
                ),
                _buildAttachOption(
                  icon: Icons.flash_on,
                  label: 'Quick Reply',
                  color: Colors.amber.shade800,
                  onTap: () {
                    Navigator.pop(context);
                    _showQuickReplyDialog();
                  },
                ),
                _buildAttachOption(
                  icon: Icons.insert_drive_file,
                  label: 'Document',
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.pop(context);
                    _sendMessage('Invoice_Order_842.pdf (124 KB)');
                  },
                ),
                _buildAttachOption(
                  icon: Icons.location_on,
                  label: 'Location',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    _sendMessage('📍 Business Location: 123 Commercial Ave, Downtown');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showQuickReplyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quick Replies', style: TextStyle(color: Color(0xFF075E54))),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _quickReplies.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE7FFDB),
                  child: Icon(Icons.flash_on, color: Color(0xFF00A884), size: 18),
                ),
                title: Text(_quickReplies[index], style: const TextStyle(fontSize: 14)),
                onTap: () {
                  Navigator.pop(context);
                  _sendMessage(_quickReplies[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFE7DE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade300,
              child: Text(
                widget.name.isNotEmpty ? widget.name[0] : 'C',
                style: const TextStyle(
                  color: Color(0xFF075E54),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Text(
                    'tap for business info',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Starting video call with ${widget.name}...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling ${widget.name}...')),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'view', child: Text('View customer info')),
              const PopupMenuItem(value: 'label', child: Text('Label chat')),
              const PopupMenuItem(value: 'media', child: Text('Media, links, and docs')),
              const PopupMenuItem(value: 'quick', child: Text('Quick replies')),
              const PopupMenuItem(value: 'clear', child: Text('Clear chat')),
            ],
            onSelected: (val) {
              if (val == 'quick') {
                _showQuickReplyDialog();
              } else if (val == 'clear') {
                setState(() => _messages.clear());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Action "$val" selected.')),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Business account header notice
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: const Color(0xFFFFF9C4),
            child: Row(
              children: [
                const Icon(Icons.lock, size: 14, color: Colors.brown),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Messages and calls are end-to-end encrypted. This is an official WhatsApp Business conversation.',
                    style: TextStyle(fontSize: 11, color: Colors.brown.shade800),
                  ),
                ),
              ],
            ),
          ),
          if (widget.label != null)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: widget.labelColor ?? const Color(0xFF00A884),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Label: ${widget.label!}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),
          // Quick reply shortcuts horizontal bar
          Container(
            height: 38,
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                ActionChip(
                  avatar: const Icon(Icons.flash_on, size: 14, color: Color(0xFF00A884)),
                  label: const Text('Quick Reply', style: TextStyle(fontSize: 11)),
                  backgroundColor: const Color(0xFFE7FFDB),
                  onPressed: _showQuickReplyDialog,
                ),
                const SizedBox(width: 6),
                ActionChip(
                  avatar: const Icon(Icons.store, size: 14, color: Colors.purple),
                  label: const Text('Share Catalog', style: TextStyle(fontSize: 11)),
                  backgroundColor: Colors.purple.shade50,
                  onPressed: () => _sendMessage(
                    'Explore our full business catalog on WhatsApp!',
                    itemName: 'Featured Espresso Blend',
                    itemPrice: '\$16.50',
                  ),
                ),
                const SizedBox(width: 6),
                ActionChip(
                  avatar: const Icon(Icons.check_circle_outline, size: 14, color: Colors.blue),
                  label: const Text('Confirm Order', style: TextStyle(fontSize: 11)),
                  backgroundColor: Colors.blue.shade50,
                  onPressed: () => _sendMessage('Your order is confirmed! We will notify you when it ships.'),
                ),
              ],
            ),
          ),
          // Input bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: const Color(0xFFF0F0F0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.sentiment_satisfied_alt, color: Colors.grey),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.grey),
                  onPressed: _showAttachmentMenu,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Message',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (val) => _sendMessage(val),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFF00A884),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: () => _sendMessage(_textController.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: msg.isMe ? const Color(0xFFE7FFDB) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(msg.isMe ? 12 : 0),
            bottomRight: Radius.circular(msg.isMe ? 0 : 12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (msg.catalogItemName != null) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A884).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.local_cafe, color: Color(0xFF00A884)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg.catalogItemName!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            msg.catalogItemPrice ?? '',
                            style: const TextStyle(
                              color: Color(0xFF00A884),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ],
            Text(
              msg.text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  msg.time,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
                if (msg.isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.done_all,
                    size: 14,
                    color: msg.isRead ? const Color(0xFF34B7F1) : Colors.grey,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
