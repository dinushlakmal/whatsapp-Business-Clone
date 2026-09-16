import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/data/category_data.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({Key? key}) : super(key: key);

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  String _category = 'Restaurant & Cafe';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descController = TextEditingController();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _websiteController = TextEditingController();
    _loadProfile();
  }

  void _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text =
          prefs.getString('business_name') ?? 'Green Leaf Specialty Coffee';
      _descController.text = prefs.getString('business_desc') ??
          'Handcrafted specialty coffee, artisan pastries, and wholesale beans.';
      _addressController.text = prefs.getString('business_address') ??
          '452 Market Street, San Francisco, CA';
      _emailController.text =
          prefs.getString('business_email') ?? 'orders@greenleafcoffee.com';
      _websiteController.text =
          prefs.getString('business_website') ?? 'https://www.greenleafcoffee.com';
      _category = prefs.getString('business_category') ?? 'Restaurant & Cafe';
      _isLoading = false;
    });
  }

  void _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('business_name', _nameController.text.trim());
    await prefs.setString('business_desc', _descController.text.trim());
    await prefs.setString('business_address', _addressController.text.trim());
    await prefs.setString('business_email', _emailController.text.trim());
    await prefs.setString('business_website', _websiteController.text.trim());
    await prefs.setString('business_category', _category);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Business Profile updated successfully!'),
          backgroundColor: Color(0xFF00A884),
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00A884)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text(
          'Edit Business Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            tooltip: 'Save',
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Cover & Avatar
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  color: const Color(0xFF128C7E),
                  child: Center(
                    child: Icon(
                      Icons.storefront,
                      size: 64,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -36,
                  left: 20,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 41,
                          backgroundColor: const Color(0xFFE7FFDB),
                          child: const Icon(
                            Icons.local_cafe,
                            size: 40,
                            color: Color(0xFF00A884),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xFF00A884),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Form Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildCardSection([
                    _buildTextField(
                      controller: _nameController,
                      icon: Icons.store,
                      label: 'Business Name',
                    ),
                    const Divider(height: 1, indent: 48),
                    ListTile(
                      leading: const Icon(Icons.category, color: Color(0xFF00A884)),
                      title: const Text('Category', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      subtitle: Text(_category, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryPage(currentCategory: _category),
                          ),
                        );
                        if (result != null && result is String) {
                          setState(() => _category = result);
                        }
                      },
                    ),
                    const Divider(height: 1, indent: 48),
                    _buildTextField(
                      controller: _descController,
                      icon: Icons.description,
                      label: 'Description',
                      maxLines: 3,
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _buildCardSection([
                    _buildTextField(
                      controller: _addressController,
                      icon: Icons.location_on,
                      label: 'Business Address',
                    ),
                    const Divider(height: 1, indent: 48),
                    ListTile(
                      leading: const Icon(Icons.access_time, color: Color(0xFF00A884)),
                      title: const Text('Business Hours', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      subtitle: const Text('Mon - Fri: 8:00 AM - 6:00 PM\nSat - Sun: 9:00 AM - 4:00 PM'),
                      trailing: const Icon(Icons.edit, size: 18),
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _buildCardSection([
                    _buildTextField(
                      controller: _emailController,
                      icon: Icons.email,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const Divider(height: 1, indent: 48),
                    _buildTextField(
                      controller: _websiteController,
                      icon: Icons.language,
                      label: 'Website',
                      keyboardType: TextInputType.url,
                    ),
                  ]),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A884),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _saveProfile,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Save Business Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSection(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment:
            maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: maxLines > 1 ? 12 : 0),
            child: Icon(icon, color: const Color(0xFF00A884)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
