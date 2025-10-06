import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../models/user_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<User> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _filteredUsers = _getAllUsersExceptCurrent();
  }

  List<User> _getAllUsersExceptCurrent() {
    final appState = Provider.of<AppState>(context, listen: false);
    final currentUser = appState.currentUser;
    return appState.users.where((user) => user.id != currentUser?.id).toList();
  }

  void _filterUsers(String query) {
    final allUsers = _getAllUsersExceptCurrent();

    if (query.isEmpty) {
      setState(() {
        _filteredUsers = allUsers;
      });
      return;
    }

    final filtered = allUsers.where((user) {
      return user.username.toLowerCase().contains(query.toLowerCase()) ||
          user.bio.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredUsers = filtered;
    });
  }

  Color _getUserColor(String userId) {
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal
    ];
    final index = userId.hashCode % colors.length;
    return colors[index];
  }

  String _getUserAvatar(String username) {
    final emojiMap = {
      'gio': '👨‍💻',
      'piki': '👩‍🎨',
      'dimas': '👨‍💼',
      'calvin': '👨‍✈️'
    };
    final lowercase = username.toLowerCase();
    for (final key in emojiMap.keys) {
      if (lowercase.contains(key)) return emojiMap[key]!;
    }
    return username[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final currentUser = appState.currentUser;

          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search users by name or bio...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterUsers('');
                            },
                          )
                        : null,
                  ),
                  onChanged: _filterUsers,
                ),
              ),

              // Search results or all users
              Expanded(
                child: _filteredUsers.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No users found',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Try a different search term',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = _filteredUsers[index];
                          final isFollowing =
                              currentUser?.followingIds.contains(user.id) ??
                                  false;

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: user.profileImage != null
                                    ? Colors.transparent
                                    : _getUserColor(user.id),
                                backgroundImage: user.profileImage != null
                                    ? NetworkImage(user.profileImage!)
                                    : null,
                                child: user.profileImage == null
                                    ? Text(
                                        _getUserAvatar(user.username),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )
                                    : null,
                              ),
                              title: Text(
                                user.username,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(user.bio),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  if (isFollowing) {
                                    appState.unfollowUser(user.id);
                                  } else {
                                    appState.followUser(user.id);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isFollowing ? Colors.grey : Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child:
                                    Text(isFollowing ? 'Following' : 'Follow'),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
