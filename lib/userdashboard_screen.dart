import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_service.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _userData = {};
  bool _isNightMode = true; // Local state for theme management

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Toggle theme method
  void _toggleTheme() {
    setState(() {
      _isNightMode = !_isNightMode;
    });
  }

  Future<void> _loadUserData() async {
    final profileService = Provider.of<ProfileService>(context, listen: false);
    final data = await profileService.getProfileData();
    if (data != null) _userData = data;
    setState(() {
      _isLoading = false;
    });
  }

  void _editField(
    String field,
    String label,
    TextInputType inputType, {
    String? initialValue,
    int? min,
    int? max,
  }) {
    final controller = TextEditingController(text: initialValue ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit $label'),
        content: TextFormField(
          controller: controller,
          keyboardType: inputType,
          decoration: InputDecoration(hintText: 'Enter $label'),
          validator: (value) {
            if (value == null || value.isEmpty) return '$label cannot be empty';
            if (inputType == TextInputType.number) {
              final val = double.tryParse(value);
              if (val == null) return 'Invalid number';
              if (min != null && val < min)
                return '$label cannot be less than $min';
              if (max != null && val > max)
                return '$label cannot be more than $max';
            }
            return null;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final value = controller.text;
              _userData[field] = inputType == TextInputType.number
                  ? int.tryParse(value)
                  : value;
              final profileService = Provider.of<ProfileService>(
                context,
                listen: false,
              );
              await profileService.saveProfileData(_userData);
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    String field, {
    TextInputType inputType = TextInputType.text,
    int? min,
    int? max,
    required Map<String, dynamic> theme,
  }) {
    return Card(
      elevation: 3,
      color: theme['cardColor'] as Color,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          label,
          style: TextStyle(color: theme['onCardColor'] as Color),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            color: (theme['onCardColor'] as Color).withOpacity(0.7),
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: theme['accentColor'] as Color),
          onPressed: () => _editField(
            field,
            label,
            inputType,
            initialValue: value,
            min: min,
            max: max,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Day (Blue & White) Theme
    const dayPrimaryColor = Color(0xFF1976D2);
    const dayBackgroundColor = Color(0xFFF5F5F5);
    const dayCardColor = Colors.white;
    const dayOnCardColor = Colors.black;
    const dayAccentColor = Color(0xFF1976D2);

    // Night (Green & Black) Theme
    const nightPrimaryColor = Color(0xFF2E7D32);
    const nightBackgroundColor = Colors.black;
    const nightCardColor = Color(0xFF1E1E1E);
    const nightOnCardColor = Colors.white;
    const nightAccentColor = Color(0xFF4CAF50);

    // Determine current theme colors
    final primaryColor = _isNightMode ? nightPrimaryColor : dayPrimaryColor;
    final backgroundColor = _isNightMode
        ? nightBackgroundColor
        : dayBackgroundColor;
    final currentTheme = _isNightMode
        ? {
            'cardColor': nightCardColor,
            'onCardColor': nightOnCardColor,
            'accentColor': nightAccentColor,
          }
        : {
            'cardColor': dayCardColor,
            'onCardColor': dayOnCardColor,
            'accentColor': dayAccentColor,
          };

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'My Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isNightMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  _buildDetailRow(
                    'Name',
                    _userData['name'] ?? 'Not set',
                    'name',
                    theme: currentTheme,
                  ),
                  _buildDetailRow(
                    'Age',
                    (_userData['age'] ?? 'Not set').toString(),
                    'age',
                    inputType: TextInputType.number,
                    min: 10,
                    max: 100,
                    theme: currentTheme,
                  ),
                  _buildDetailRow(
                    'Gender',
                    _userData['gender'] ?? 'Not set',
                    'gender',
                    theme: currentTheme,
                  ),
                  _buildDetailRow(
                    'Class',
                    _userData['class'] ?? 'Not set',
                    'class',
                    theme: currentTheme,
                  ),
                  _buildDetailRow(
                    'Interests',
                    _userData['interests'] ?? 'Not set',
                    'interests',
                    theme: currentTheme,
                  ),
                  _buildDetailRow(
                    'SSC %',
                    (_userData['sscPercentage'] ?? 'Not set').toString(),
                    'sscPercentage',
                    inputType: TextInputType.number,
                    min: 0,
                    max: 100,
                    theme: currentTheme,
                  ),
                  _buildDetailRow(
                    'HSC/Diploma %',
                    (_userData['hscPercentage'] ?? 'Not set').toString(),
                    'hscPercentage',
                    inputType: TextInputType.number,
                    min: 0,
                    max: 100,
                    theme: currentTheme,
                  ),
                ],
              ),
            ),
    );
  }
}
