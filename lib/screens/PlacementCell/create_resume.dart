
import 'package:flutter/material.dart';
import '../../utils/sidebar.dart' as sidebar;
import '../../utils/gesture_sidebar.dart';
import '../../utils/bottom_bar.dart';

class CreateResumeScreen extends StatefulWidget {
  const CreateResumeScreen({super.key});

  @override
  State<CreateResumeScreen> createState() => _CreateResumeScreenState();
}

class _CreateResumeScreenState extends State<CreateResumeScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  final List<Map<String, dynamic>> _resumeTemplates = [
    {
      'name': 'Professional',
      'image': 'assets/images/resume_template1.png',
      'description': 'A clean, professional template suitable for corporate roles.'
    },
    {
      'name': 'Creative',
      'image': 'assets/images/resume_template2.png',
      'description': 'A modern, creative design for design and artistic roles.'
    },
    {
      'name': 'Academic',
      'image': 'assets/images/resume_template3.png',
      'description': 'Focused on academic achievements, perfect for research positions.'
    },
    {
      'name': 'Technical',
      'image': 'assets/images/resume_template4.png',
      'description': 'Highlights technical skills and projects for IT roles.'
    },
  ];

  final List<Map<String, dynamic>> _savedResumes = [
    {
      'title': 'Software Developer Resume',
      'template': 'Technical',
      'lastUpdated': '2023-05-15',
    },
    {
      'title': 'Research Internship Resume',
      'template': 'Academic',
      'lastUpdated': '2023-04-22',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleNavigation(int index) {
    Navigator.pop(context);
    // Additional navigation logic if needed
  }

  @override
  Widget build(BuildContext context) {
    return GestureSidebar(
      scaffoldKey: _scaffoldKey,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            'Create Resume',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.blue.shade700,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: 'Templates'),
              Tab(text: 'My Resumes'),
            ],
          ),
        ),
        drawer: sidebar.Sidebar(onItemSelected: _handleNavigation),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Build professional resumes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Templates Tab
                  _buildTemplatesTab(),
                  // My Resumes Tab
                  _buildMyResumesTab(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showCreateNewResumeDialog();
          },
          backgroundColor: Colors.blue.shade700,
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: const BottomBar(currentIndex: 2),
      ),
    );
  }

  Widget _buildTemplatesTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: _resumeTemplates.length,
        itemBuilder: (context, index) {
          return _buildTemplateCard(_resumeTemplates[index]);
        },
      ),
    );
  }

  Widget _buildTemplateCard(Map<String, dynamic> template) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showStartNewResumeDialog(template['name']);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.description,
                    size: 60,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    template['description'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyResumesTab() {
    return _savedResumes.isEmpty
        ? const Center(
            child: Text(
              'No resumes created yet',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _savedResumes.length,
            itemBuilder: (context, index) {
              final resume = _savedResumes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(
                      Icons.description,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  title: Text(
                    resume['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Template: ${resume['template']}'),
                      Text('Last updated: ${resume['lastUpdated']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditResumeDialog(resume);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteResumeDialog(resume);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    _showResumeDetailsDialog(resume);
                  },
                ),
              );
            },
          );
  }

  void _showCreateNewResumeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Resume'),
        content: const Text('Choose a template to get started or start from scratch.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _tabController.animateTo(0); // Switch to templates tab
            },
            child: const Text('Select Template'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement starting from scratch logic
              _showStartNewResumeDialog('Blank');
            },
            child: const Text('Start from Scratch'),
          ),
        ],
      ),
    );
  }

  void _showStartNewResumeDialog(String templateName) {
    final TextEditingController resumeTitleController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Resume with $templateName Template'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: resumeTitleController,
              decoration: const InputDecoration(
                labelText: 'Resume Title',
                hintText: 'e.g. Software Developer Resume',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (resumeTitleController.text.isNotEmpty) {
                Navigator.pop(context);
                // Here you would navigate to a resume editor screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Creating resume: ${resumeTitleController.text}'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                
                // Add the new resume to the list (this would connect to backend in real app)
                setState(() {
                  _savedResumes.add({
                    'title': resumeTitleController.text,
                    'template': templateName,
                    'lastUpdated': DateTime.now().toString().substring(0, 10),
                  });
                });
                
                // Switch to My Resumes tab
                _tabController.animateTo(1);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showResumeDetailsDialog(Map<String, dynamic> resume) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(resume['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Template: ${resume['template']}'),
            Text('Last updated: ${resume['lastUpdated']}'),
            const SizedBox(height: 20),
            const Text('Options:'),
            const SizedBox(height: 10),
            _buildActionButton(
              icon: Icons.edit,
              label: 'Edit Resume',
              onTap: () {
                Navigator.pop(context);
                _showEditResumeDialog(resume);
              },
            ),
            const SizedBox(height: 8),
            _buildActionButton(
              icon: Icons.download,
              label: 'Download PDF',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Downloading resume as PDF...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildActionButton(
              icon: Icons.share,
              label: 'Share Resume',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sharing resume...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade700),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditResumeDialog(Map<String, dynamic> resume) {
    final TextEditingController titleController = TextEditingController(text: resume['title']);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Resume'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Resume Title',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                Navigator.pop(context);
                // Update the resume title
                setState(() {
                  resume['title'] = titleController.text;
                  resume['lastUpdated'] = DateTime.now().toString().substring(0, 10);
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Resume updated'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteResumeDialog(Map<String, dynamic> resume) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Resume'),
        content: Text('Are you sure you want to delete "${resume['title']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _savedResumes.remove(resume);
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Resume deleted'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}