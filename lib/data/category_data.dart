import 'package:flutter/material.dart';

const List<Map<String, dynamic>> businessCategories = [
  {"name": "Automotive Service", "icon": Icons.directions_car},
  {"name": "Baby & Children's Clothing", "icon": Icons.child_friendly},
  {"name": "Beauty, Cosmetic & Personal Care", "icon": Icons.face},
  {"name": "Clothing & Apparel", "icon": Icons.checkroom},
  {"name": "Education & School", "icon": Icons.school},
  {"name": "Entertainment & Media", "icon": Icons.movie},
  {"name": "Finance & Insurance", "icon": Icons.account_balance},
  {"name": "Food & Beverage", "icon": Icons.restaurant},
  {"name": "Grocery & Convenience Store", "icon": Icons.local_grocery_store},
  {"name": "Hotel & Lodging", "icon": Icons.hotel},
  {"name": "Medical & Health", "icon": Icons.local_hospital},
  {"name": "Non-profit Organization", "icon": Icons.volunteer_activism},
  {"name": "Professional Services", "icon": Icons.business_center},
  {"name": "Real Estate", "icon": Icons.apartment},
  {"name": "Restaurant & Cafe", "icon": Icons.local_cafe},
  {"name": "Shopping & Retail", "icon": Icons.shopping_bag},
  {"name": "Software & Technology", "icon": Icons.computer},
  {"name": "Travel & Transportation", "icon": Icons.flight},
  {"name": "Other Business", "icon": Icons.storefront},
];

class CategoryPage extends StatefulWidget {
  final String? currentCategory;

  const CategoryPage({Key? key, this.currentCategory}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredCategories = businessCategories;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.currentCategory;
    _searchController.addListener(_filterCategories);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCategories() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = businessCategories;
      } else {
        _filteredCategories = businessCategories
            .where((category) =>
                category["name"].toString().toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text(
          'Business Category',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, _selectedCategory),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFF6F6F6),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search categories...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF00A884)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Color(0xFF00A884), width: 1.5),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select the category that best describes your business',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _filteredCategories.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 54, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(
                          'No categories found',
                          style: TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context, _searchController.text.trim());
                          },
                          icon: const Icon(Icons.add, color: Color(0xFF00A884)),
                          label: Text(
                            'Use "${_searchController.text.trim()}"',
                            style: const TextStyle(color: Color(0xFF00A884)),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: _filteredCategories.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      indent: 68,
                      color: Colors.grey.shade200,
                    ),
                    itemBuilder: (context, index) {
                      final category = _filteredCategories[index];
                      final name = category["name"] as String;
                      final icon = category["icon"] as IconData;
                      final isSelected = _selectedCategory == name;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isSelected
                              ? const Color(0xFFE7FFDB)
                              : Colors.grey.shade100,
                          child: Icon(
                            icon,
                            color: isSelected
                                ? const Color(0xFF00A884)
                                : Colors.grey.shade700,
                            size: 22,
                          ),
                        ),
                        title: Text(
                          name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? const Color(0xFF00A884)
                                : Colors.black87,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle,
                                color: Color(0xFF00A884),
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedCategory = name;
                          });
                          Navigator.pop(context, name);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
