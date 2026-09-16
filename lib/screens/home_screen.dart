import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/screens/business_profile_screen.dart';
import 'package:whatsapp_clone/screens/chat_detail_screen.dart';
import 'package:whatsapp_clone/screens/onboarding_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _activeFilter = 'All';
  String _businessName = 'Green Leaf Specialty Coffee';
  String _businessCategory = 'Restaurant & Cafe';

  final List<Map<String, dynamic>> _catalogItems = [
    {
      'title': 'Artisan Espresso Blend',
      'price': '\$16.50',
      'desc': 'Notes of dark chocolate, toasted hazelnut, and caramel.',
      'icon': Icons.coffee,
    },
    {
      'title': 'Single Origin Colombia',
      'price': '\$18.00',
      'desc': 'Fruity brightness with hints of cherry and sweet panela.',
      'icon': Icons.local_cafe,
    },
    {
      'title': 'Organic Almond Croissant',
      'price': '\$5.25',
      'desc': 'Twice-baked buttery pastry loaded with rich almond cream.',
      'icon': Icons.bakery_dining,
    },
  ];

  final List<Map<String, dynamic>> _chats = [
    {
      'name': 'Sarah Miller',
      'lastMessage': 'Can you confirm delivery for the 5 bags of Espresso?',
      'time': '10:45 AM',
      'unread': 2,
      'isRead': false,
      'label': 'New Order',
      'labelColor': Color(0xFFE53935),
      'isGroup': false,
    },
    {
      'name': 'Urban Bistro - Chef Marco',
      'lastMessage': 'Payment of \$450 sent via bank transfer. Please check.',
      'time': '9:30 AM',
      'unread': 0,
      'isRead': true,
      'label': 'Pending Payment',
      'labelColor': Color(0xFFFB8C00),
      'isGroup': false,
    },
    {
      'name': 'Downtown Cafe Wholesale',
      'lastMessage': 'Invoice received, thank you for the prompt dispatch!',
      'time': 'Yesterday',
      'unread': 0,
      'isRead': true,
      'label': 'Paid',
      'labelColor': Color(0xFF43A047),
      'isGroup': false,
    },
    {
      'name': 'David Chen',
      'lastMessage': 'What are your holiday operating hours?',
      'time': 'Yesterday',
      'unread': 0,
      'isRead': true,
      'label': 'New Customer',
      'labelColor': Color(0xFF1E88E5),
      'isGroup': false,
    },
    {
      'name': 'Roasters & Baristas Group',
      'lastMessage': 'Alex: The new green bean shipment has arrived at port.',
      'time': '9/14/26',
      'unread': 5,
      'isRead': false,
      'label': null,
      'labelColor': null,
      'isGroup': true,
    },
    {
      'name': 'Emma Watson',
      'lastMessage': 'Loved the sample roasts! We would like to order weekly.',
      'time': '9/12/26',
      'unread': 0,
      'isRead': true,
      'label': 'Order Complete',
      'labelColor': Color(0xFF7CB342),
      'isGroup': false,
    },
  ];

  final List<Map<String, dynamic>> _calls = [
    {
      'name': 'Sarah Miller',
      'time': 'Today, 10:30 AM',
      'isVideo': false,
      'isIncoming': true,
      'isMissed': false,
    },
    {
      'name': 'Urban Bistro - Chef Marco',
      'time': 'Yesterday, 4:15 PM',
      'isVideo': true,
      'isIncoming': false,
      'isMissed': false,
    },
    {
      'name': 'Unknown Customer (+1 555-0192)',
      'time': 'September 14, 2:10 PM',
      'isVideo': false,
      'isIncoming': true,
      'isMissed': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Default to Chats tab (index 1)
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    _loadBusinessInfo();
  }

  void _loadBusinessInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _businessName =
          prefs.getString('business_name') ?? 'Green Leaf Specialty Coffee';
      _businessCategory =
          prefs.getString('business_category') ?? 'Restaurant & Cafe';
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
      );
    }
  }

  void _addNewChat() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'New Customer Chat',
          style: TextStyle(color: Color(0xFF075E54), fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Customer Name',
                prefixIcon: Icon(Icons.person, color: Color(0xFF00A884)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone, color: Color(0xFF00A884)),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A884),
            ),
            onPressed: () {
              final name = nameCtrl.text.trim();
              if (name.isNotEmpty) {
                setState(() {
                  _chats.insert(0, {
                    'name': name,
                    'lastMessage': 'Chat started',
                    'time': 'Just now',
                    'unread': 0,
                    'isRead': true,
                    'label': 'New Customer',
                    'labelColor': const Color(0xFF1E88E5),
                    'isGroup': false,
                  });
                });
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatDetailScreen(
                      name: name,
                      avatarUrl: '',
                      initialMessage: 'Hello! Welcome to $_businessName.',
                      label: 'New Customer',
                      labelColor: const Color(0xFF1E88E5),
                    ),
                  ),
                );
              }
            },
            child: const Text('Start Chat', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _addNewCatalogItem() {
    final titleCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add Item to Catalog',
          style: TextStyle(color: Color(0xFF075E54), fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  hintText: 'e.g. Cold Brew Bottle (500ml)',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceCtrl,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: '\$5.50',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Freshly steeped for 18 hours...',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A884),
            ),
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                setState(() {
                  _catalogItems.add({
                    'title': titleCtrl.text.trim(),
                    'price': priceCtrl.text.trim().startsWith('\$')
                        ? priceCtrl.text.trim()
                        : '\$${priceCtrl.text.trim()}',
                    'desc': descCtrl.text.trim(),
                    'icon': Icons.store,
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Item added to business catalog!'),
                    backgroundColor: Color(0xFF00A884),
                  ),
                );
              }
            },
            child: const Text('Add Item', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search chats, tools, orders...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (_) => setState(() {}),
              )
            : const Text(
                'WhatsApp Business',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                }
                _isSearching = !_isSearching;
              });
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'tools', child: Text('Business tools')),
              const PopupMenuItem(value: 'profile', child: Text('Edit profile')),
              const PopupMenuItem(value: 'new_broadcast', child: Text('New broadcast')),
              const PopupMenuItem(value: 'labels', child: Text('Labels')),
              const PopupMenuItem(value: 'linked', child: Text('Linked devices')),
              const PopupMenuItem(value: 'starred', child: Text('Starred messages')),
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Log out', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (val) async {
              if (val == 'tools') {
                _tabController.animateTo(0);
              } else if (val == 'profile') {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BusinessProfileScreen()),
                );
                if (updated == true) _loadBusinessInfo();
              } else if (val == 'logout') {
                _logout();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening $val...')),
                );
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3.5,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(icon: Icon(Icons.storefront, size: 20)),
            Tab(text: 'CHATS'),
            Tab(text: 'UPDATES'),
            Tab(text: 'CALLS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBusinessToolsTab(),
          _buildChatsTab(),
          _buildUpdatesTab(),
          _buildCallsTab(),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget? _buildFab() {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        if (_tabController.index == 1) {
          // Chats Tab FAB
          return FloatingActionButton(
            backgroundColor: const Color(0xFF00A884),
            onPressed: _addNewChat,
            tooltip: 'New Customer Chat',
            child: const Icon(Icons.message, color: Colors.white),
          );
        } else if (_tabController.index == 0) {
          // Tools Tab FAB
          return FloatingActionButton.extended(
            backgroundColor: const Color(0xFF00A884),
            onPressed: _addNewCatalogItem,
            icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
            label: const Text('Add Product', style: TextStyle(color: Colors.white)),
          );
        } else if (_tabController.index == 2) {
          // Status Tab FAB
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.small(
                heroTag: 'fab_edit',
                backgroundColor: Colors.grey.shade200,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Status update editor opened')),
                  );
                },
                child: const Icon(Icons.edit, color: Color(0xFF075E54)),
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                heroTag: 'fab_camera',
                backgroundColor: const Color(0xFF00A884),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Camera opened for status')),
                  );
                },
                child: const Icon(Icons.camera_alt, color: Colors.white),
              ),
            ],
          );
        } else {
          // Calls Tab FAB
          return FloatingActionButton(
            backgroundColor: const Color(0xFF00A884),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Select contact to call')),
              );
            },
            child: const Icon(Icons.add_call, color: Colors.white),
          );
        }
      },
    );
  }

  // BUSINESS TOOLS TAB
  Widget _buildBusinessToolsTab() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        // Business Profile Summary Card
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFFE7FFDB),
                child: const Icon(
                  Icons.storefront,
                  color: Color(0xFF00A884),
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _businessName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _businessCategory,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(Icons.verified, size: 14, color: Color(0xFF00A884)),
                        SizedBox(width: 4),
                        Text(
                          'Verified Business',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF00A884),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF075E54)),
                onPressed: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BusinessProfileScreen(),
                    ),
                  );
                  if (updated == true) _loadBusinessInfo();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // CATALOG SECTION
        _buildSectionHeader('Catalog & Products'),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFF3E5F5),
                  child: Icon(Icons.store, color: Colors.purple),
                ),
                title: const Text(
                  'Catalog',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '${_catalogItems.length} products & services displayed',
                ),
                trailing: TextButton.icon(
                  onPressed: _addNewCatalogItem,
                  icon: const Icon(Icons.add, size: 16, color: Color(0xFF00A884)),
                  label: const Text(
                    'Add',
                    style: TextStyle(color: Color(0xFF00A884)),
                  ),
                ),
              ),
              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _catalogItems.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = _catalogItems[index];
                    return Container(
                      width: 160,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: const Color(0xFFE7FFDB),
                                child: Icon(
                                  item['icon'] as IconData,
                                  size: 16,
                                  color: const Color(0xFF00A884),
                                ),
                              ),
                              Text(
                                item['price'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00A884),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['title'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: Text(
                              item['desc'] as String,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // MESSAGING TOOLS SECTION
        _buildSectionHeader('Messaging Tools'),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              _buildToolTile(
                icon: Icons.waving_hand,
                iconColor: Colors.amber.shade800,
                title: 'Greeting message',
                subtitle: 'Welcome new customers automatically',
                trailing: const Icon(Icons.toggle_on, color: Color(0xFF00A884), size: 36),
                onTap: () {
                  _showGreetingDialog();
                },
              ),
              const Divider(height: 1, indent: 68),
              _buildToolTile(
                icon: Icons.nightlight_round,
                iconColor: Colors.indigo,
                title: 'Away message',
                subtitle: 'Reply automatically when you are away',
                trailing: const Icon(Icons.toggle_on, color: Color(0xFF00A884), size: 36),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Away message schedule: Outside business hours')),
                  );
                },
              ),
              const Divider(height: 1, indent: 68),
              _buildToolTile(
                icon: Icons.flash_on,
                iconColor: Colors.orange,
                title: 'Quick replies',
                subtitle: 'Reuse frequent answers (/thanks, /hours)',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('4 quick replies active')),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // CUSTOMER MANAGEMENT
        _buildSectionHeader('Organize & Grow'),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              _buildToolTile(
                icon: Icons.label,
                iconColor: Colors.teal,
                title: 'Labels',
                subtitle: 'Organize chats (New order, Paid, Pending)',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showLabelsDialog();
                },
              ),
              const Divider(height: 1, indent: 68),
              _buildToolTile(
                icon: Icons.link,
                iconColor: Colors.blue,
                title: 'Short link',
                subtitle: 'https://wa.me/message/GREENLEAF',
                trailing: const Icon(Icons.copy, size: 20, color: Color(0xFF00A884)),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Short link copied to clipboard!'),
                      backgroundColor: Color(0xFF00A884),
                    ),
                  );
                },
              ),
              const Divider(height: 1, indent: 68),
              _buildToolTile(
                icon: Icons.campaign,
                iconColor: Colors.pink,
                title: 'Advertise on Facebook & Instagram',
                subtitle: 'Create ads that lead directly to your WhatsApp',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ads Manager opened')),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildToolTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.12),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _showGreetingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Greeting Message'),
        content: const Text(
          'Automated message sent to customers when they message you for the first time or after 14 days of no activity:\n\n'
          '"Thank you for contacting Green Leaf Specialty Coffee! How can we assist you today?"',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLabelsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Customer Labels'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLabelItem('New customer', const Color(0xFF1E88E5), 3),
            _buildLabelItem('New order', const Color(0xFFE53935), 2),
            _buildLabelItem('Pending payment', const Color(0xFFFB8C00), 1),
            _buildLabelItem('Paid', const Color(0xFF43A047), 4),
            _buildLabelItem('Order complete', const Color(0xFF7CB342), 6),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelItem(String name, Color color, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.label, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 14))),
          Text('$count chats', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  // CHATS TAB
  Widget _buildChatsTab() {
    final query = _searchController.text.toLowerCase();
    final filtered = _chats.where((chat) {
      final nameMatches = chat['name'].toString().toLowerCase().contains(query);
      final msgMatches = chat['lastMessage'].toString().toLowerCase().contains(query);
      if (!nameMatches && !msgMatches) return false;

      if (_activeFilter == 'Unread') {
        return (chat['unread'] as int) > 0;
      } else if (_activeFilter == 'Groups') {
        return chat['isGroup'] == true;
      }
      return true;
    }).toList();

    return Column(
      children: [
        // Filter pills
        Container(
          height: 44,
          color: Colors.white,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            children: [
              _buildFilterChip('All'),
              _buildFilterChip('Unread'),
              _buildFilterChip('Favorites'),
              _buildFilterChip('Groups'),
            ],
          ),
        ),
        const Divider(height: 1),
        // Chat List
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    'No conversations found',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                )
              : ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    indent: 74,
                    color: Colors.grey.shade200,
                  ),
                  itemBuilder: (context, index) {
                    final chat = filtered[index];
                    final unread = chat['unread'] as int;
                    final isGroup = chat['isGroup'] as bool;
                    final label = chat['label'] as String?;
                    final labelColor = chat['labelColor'] as Color?;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: isGroup
                                ? const Color(0xFFE0F2F1)
                                : const Color(0xFFECEFF1),
                            child: Icon(
                              isGroup ? Icons.group : Icons.person,
                              color: isGroup
                                  ? const Color(0xFF00A884)
                                  : Colors.grey.shade700,
                              size: 28,
                            ),
                          ),
                          if (labelColor != null)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: labelColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            chat['time'],
                            style: TextStyle(
                              fontSize: 12,
                              color: unread > 0
                                  ? const Color(0xFF00A884)
                                  : Colors.grey.shade600,
                              fontWeight: unread > 0 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              if (chat['isRead'] == true) ...[
                                const Icon(
                                  Icons.done_all,
                                  size: 16,
                                  color: Color(0xFF34B7F1),
                                ),
                                const SizedBox(width: 4),
                              ],
                              Expanded(
                                child: Text(
                                  chat['lastMessage'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: unread > 0
                                        ? Colors.black87
                                        : Colors.grey.shade600,
                                    fontWeight: unread > 0
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (unread > 0)
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF00A884),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '$unread',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (label != null) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: (labelColor ?? Colors.grey).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: labelColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          chat['unread'] = 0;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailScreen(
                              name: chat['name'],
                              avatarUrl: '',
                              initialMessage: chat['lastMessage'],
                              label: label,
                              labelColor: labelColor,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _activeFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF075E54) : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
        backgroundColor: Colors.grey.shade100,
        selectedColor: const Color(0xFFE7FFDB),
        checkmarkColor: const Color(0xFF00A884),
        onSelected: (_) {
          setState(() {
            _activeFilter = label;
          });
        },
      ),
    );
  }

  // UPDATES (STATUS) TAB
  Widget _buildUpdatesTab() {
    return ListView(
      children: [
        ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFFE7FFDB),
                child: const Icon(Icons.storefront, color: Color(0xFF00A884)),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Color(0xFF00A884),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          title: const Text('My Status', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text('Tap to add business status update'),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Add status photo or announcement')),
            );
          },
        ),
        _buildSectionHeader('Recent updates from business partners'),
        _buildStatusItem('Artisan Bakery Co.', '15 minutes ago', true),
        _buildStatusItem('Organic Dairy Farm', 'Today, 8:40 AM', true),
        _buildStatusItem('Packaging Supplies Ltd.', 'Yesterday, 6:15 PM', false),
      ],
    );
  }

  Widget _buildStatusItem(String name, String time, bool isRecent) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isRecent ? const Color(0xFF00A884) : Colors.grey.shade400,
            width: 2.2,
          ),
        ),
        child: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.grey.shade200,
          child: Text(
            name[0],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF075E54),
            ),
          ),
        ),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(time, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('$name - Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF075E54),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '"New harvest Ethiopian beans available for wholesale orders this week!"',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Reply'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A884),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Close', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  // CALLS TAB
  Widget _buildCallsTab() {
    return ListView.separated(
      itemCount: _calls.length,
      separatorBuilder: (_, __) => Divider(height: 1, indent: 70, color: Colors.grey.shade200),
      itemBuilder: (context, index) {
        final call = _calls[index];
        final isMissed = call['isMissed'] as bool;
        final isIncoming = call['isIncoming'] as bool;
        final isVideo = call['isVideo'] as bool;

        return ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade200,
            child: Text(
              call['name'][0],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF075E54),
              ),
            ),
          ),
          title: Text(
            call['name'],
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isMissed ? Colors.red.shade700 : Colors.black87,
            ),
          ),
          subtitle: Row(
            children: [
              Icon(
                isIncoming ? Icons.call_received : Icons.call_made,
                size: 14,
                color: isMissed ? Colors.red : const Color(0xFF00A884),
              ),
              const SizedBox(width: 4),
              Text(
                call['time'],
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              isVideo ? Icons.videocam : Icons.call,
              color: const Color(0xFF075E54),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling ${call['name']}...')),
              );
            },
          ),
        );
      },
    );
  }
}
