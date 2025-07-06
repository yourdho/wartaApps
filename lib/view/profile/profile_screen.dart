import 'package:flutter/material.dart';
import 'package:wartaapps/models/auth_model.dart';
import 'package:wartaapps/services/auth_service.dart';
import 'package:wartaapps/utils/Storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _authController = AuthController();
  late Future<ProfileResponse> _profileFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<ProfileResponse> _loadProfile() async {
    final token = Storage.getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }
    return await _authController.getProfile(token);
  }

  Future<void> _logout() async {
    setState(() => _isLoading = true);
    try {
      await Storage.clearAll();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF2B4D8C),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Color(0xFF2B4D8C)),
            onPressed: _isLoading ? null : _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: FutureBuilder<ProfileResponse>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2B4D8C)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading profile',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B4D8C),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _profileFuture = _loadProfile();
                      });
                    },
                    child: const Text(
                      'Try Again',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No profile data available',
                style: TextStyle(color: Colors.grey[600]),
              ),
            );
          }

          final profile = snapshot.data!.data;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        backgroundImage:
                            profile.avatarUrl != null
                                ? NetworkImage(profile.avatarUrl!)
                                : null,
                        child:
                            profile.avatarUrl == null
                                ? Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey[600],
                                )
                                : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profile.fullName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B4D8C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.email,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      if (profile.bio != null && profile.bio!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            profile.bio!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionCard(
                  title: 'Account Information',
                  children: [
                    _buildProfileItem(
                      icon: Icons.person_outline,
                      label: 'Full Name',
                      value: profile.fullName,
                    ),
                    _buildProfileItem(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: profile.email,
                    ),
                    _buildProfileItem(
                      icon: Icons.calendar_today_outlined,
                      label: 'Member Since',
                      value: _formatDate(profile.createdAt),
                    ),
                    _buildProfileItem(
                      icon: Icons.verified_outlined,
                      label: 'Status',
                      value: profile.isActive ? 'Active' : 'Inactive',
                      valueColor:
                          profile.isActive ? Colors.green : Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Statistics',
                  children: [
                    _buildStatItem(
                      icon: Icons.article_outlined,
                      label: 'Articles Written',
                      value: '24',
                    ),
                    _buildStatItem(
                      icon: Icons.visibility_outlined,
                      label: 'Total Views',
                      value: '1.2K',
                    ),
                    _buildStatItem(
                      icon: Icons.thumb_up_outlined,
                      label: 'Likes Received',
                      value: '356',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.red.shade300),
                      ),
                    ),
                    onPressed: _isLoading ? null : _logout,
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.red,
                              ),
                            )
                            : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.logout),
                                SizedBox(width: 8),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B4D8C),
            ),
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: const Color(0xFF2B4D8C)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: valueColor ?? Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: const Color(0xFF2B4D8C)),
          const SizedBox(width: 16),
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B4D8C),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
