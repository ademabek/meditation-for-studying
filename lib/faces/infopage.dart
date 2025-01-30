import 'package:flutter/material.dart';

class informationPage extends StatefulWidget {
  final String initialSearchQuery;

  informationPage({required this.initialSearchQuery});

  @override
  _informationPageState createState() => _informationPageState();
}

class _informationPageState extends State<informationPage> {
  final List<Map<String, String>> _sessions = [
    {"title": "Rain Radio", "description": "Sleep aid - 500 mins"},
    {"title": "Night Sound", "description": "Sleep aid - 60 mins"},
    {"title": "Ocean Time", "description": "Sleep aid - 45 mins"},
    {"title": "Desert Campfire", "description": "Relaxation - 30 mins"},
    {"title": "Compass Gardens", "description": "Meditation - 20 mins"},
    {"title": "Downriver", "description": "Sleep sound - 45 mins"},
  ];

  String _searchQuery = "";
  List<Map<String, String>> _filteredSessions = [];

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.initialSearchQuery;
    _filterSessions(_searchQuery);
  }

  void _filterSessions(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredSessions = _sessions.where((session) {
        return session['title']!.toLowerCase().contains(_searchQuery) ||
            session['description']!.toLowerCase().contains(_searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: TextField(
          onChanged: _filterSessions,
          controller: TextEditingController(text: _searchQuery),
          decoration: InputDecoration(
            hintText: "Search sessions...",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.white),
            filled: true,
            fillColor: Colors.deepPurple[300],
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_searchQuery.isEmpty)
                Text(
                  "Popular Sessions",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredSessions.isEmpty
                      ? _sessions.length
                      : _filteredSessions.length,
                  itemBuilder: (context, index) {
                    final session = _filteredSessions.isEmpty
                        ? _sessions[index]
                        : _filteredSessions[index];
                    return _buildSessionCard(
                      title: session['title']!,
                      description: session['description']!,
                      onTap: () {
                        _showSessionDetails(session);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionCard({
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.music_note, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.deepPurple),
            ],
          ),
        ),
      ),
    );
  }

  void _showSessionDetails(Map<String, String> session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(session['title']!),
        content: Text(session['description']!),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }
}
