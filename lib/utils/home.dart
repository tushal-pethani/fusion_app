import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sidebar.dart';
import 'gesture_sidebar.dart';
import 'bottom_bar.dart';
import '../screens/Examination/examination_dashboard.dart';
import 'notification_detail_screen.dart';
import '../main.dart';  // Import main.dart for ExitConfirmationWrapper

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  
  // Filter variables
  String? _selectedModule;
  String? _selectedDateFilter;
  bool _showFilters = false;

  // Date filter options
  final List<String> _dateFilterOptions = [
    'All',
    'Today',
    'Yesterday',
    'This Week',
    'This Month',
    'This Year',
  ];

  // Example announcement data across various modules
  final List<Map<String, dynamic>> _announcements = [
    {
      'title': 'End Semester Examination Schedule',
      'module': 'Examination',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'content': 'The End Semester Examination for all courses will commence from 15th May, 2023. Detailed schedule has been uploaded on the examination portal. Students are requested to check their respective schedules.',
      'author': 'Examination Controller',
      'priority': 'High',
      'isUnread': true,
    },
    {
      'title': 'Library Membership Renewal',
      'module': 'Library',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'content': 'All students and faculty members are requested to renew their library membership for the academic year 2023-2024. The renewal process starts from 1st April and ends on 15th April.',
      'author': 'Chief Librarian',
      'priority': 'Medium',
      'isUnread': true,
    },
    {
      'title': 'Hostel Maintenance Notice',
      'module': 'Hostel',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'content': 'Maintenance work will be carried out in Hostel Blocks A and B from 10th April to 15th April. Students are requested to cooperate with the maintenance staff.',
      'author': 'Hostel Warden',
      'priority': 'Medium',
      'isUnread': false,
    },
    {
      'title': 'Campus Placement Drive',
      'module': 'Placement',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'content': 'A campus placement drive for final year students will be conducted by Tech Solutions Inc. on 20th April. Eligible students should register on the placement portal by 15th April.',
      'author': 'Placement Officer',
      'priority': 'High',
      'isUnread': true,
    },
    {
      'title': 'Research Grant Applications',
      'module': 'Research',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'content': 'Applications are invited for research grants under the Institute Innovation Scheme. Last date for submission is 30th April. Detailed guidelines are available on the research portal.',
      'author': 'Research Dean',
      'priority': 'Medium',
      'isUnread': false,
    },
    {
      'title': 'New Course Introduction',
      'module': 'Academic',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'content': 'A new elective course on "Artificial Intelligence for Healthcare" will be offered from the next semester. Interested students can pre-register on the academic portal.',
      'author': 'Academic Dean',
      'priority': 'Low',
      'isUnread': false,
    },
    {
      'title': 'Faculty Development Program',
      'module': 'HR',
      'date': DateTime.now().subtract(const Duration(days: 4)),
      'content': 'A Faculty Development Program on "Effective Teaching Methodologies" will be conducted from 5th to 10th May. Faculty members are encouraged to participate.',
      'author': 'HR Manager',
      'priority': 'Medium',
      'isUnread': true,
    },
    {
      'title': 'Annual Cultural Fest',
      'module': 'Event',
      'date': DateTime.now().subtract(const Duration(days: 12)),
      'content': 'The Annual Cultural Fest "Fusion 2023" will be held from 25th to 27th April. Student coordinators are requested to attend the planning meeting on 15th April.',
      'author': 'Cultural Secretary',
      'priority': 'High',
      'isUnread': false,
    },
    {
      'title': 'Budget Proposal Submission',
      'module': 'Finance',
      'date': DateTime.now().subtract(const Duration(days: 15)),
      'content': 'All departments are requested to submit their budget proposals for the financial year 2023-2024 by 20th April. The template for submission is available on the finance portal.',
      'author': 'Finance Officer',
      'priority': 'Medium',
      'isUnread': false,
    },
    {
      'title': 'Patent Filing Workshop',
      'module': 'Patent',
      'date': DateTime.now().subtract(const Duration(days: 8)),
      'content': 'A workshop on "Patent Filing Process and Guidelines" will be conducted on 18th April. Faculty members and research scholars are encouraged to attend.',
      'author': 'Patent Cell Coordinator',
      'priority': 'Low',
      'isUnread': true,
    },
  ];

  // Example notifications data
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Assignment Graded',
      'module': 'Academic',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'content': 'Your assignment for CS301 has been graded. You scored 85/100.',
      'priority': 'Medium',
      'isUnread': true,
    },
    {
      'title': 'Library Book Due',
      'module': 'Library',
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'content': 'Reminder: The book "Data Structures and Algorithms" is due for return tomorrow.',
      'priority': 'High',
      'isUnread': true,
    },
    {
      'title': 'Hostel Fee Payment',
      'module': 'Finance',
      'date': DateTime.now().subtract(const Duration(hours: 8)),
      'content': 'Your hostel fee payment for the current semester has been received and processed.',
      'priority': 'Low',
      'isUnread': false,
    },
    {
      'title': 'New Course Material',
      'module': 'Academic',
      'date': DateTime.now().subtract(const Duration(hours: 10)),
      'content': 'New course material for CS401 has been uploaded to the learning management system.',
      'priority': 'Medium',
      'isUnread': true,
    },
    {
      'title': 'Meeting Schedule',
      'module': 'Research',
      'date': DateTime.now().subtract(const Duration(hours: 12)),
      'content': 'Research group meeting scheduled for tomorrow at 3 PM in Conference Room 2.',
      'priority': 'High',
      'isUnread': true,
    },
    {
      'title': 'Document Approved',
      'module': 'File Tracking',
      'date': DateTime.now().subtract(const Duration(hours: 15)),
      'content': 'Your leave application has been approved by the department head.',
      'priority': 'Medium',
      'isUnread': false,
    },
    {
      'title': 'Event Registration',
      'module': 'Event',
      'date': DateTime.now().subtract(const Duration(hours: 20)),
      'content': 'Your registration for the workshop on "AI in Healthcare" has been confirmed.',
      'priority': 'Low',
      'isUnread': true,
    },
    {
      'title': 'Grade Submission Reminder',
      'module': 'Examination',
      'date': DateTime.now().subtract(const Duration(hours: 22)),
      'content': 'Reminder: Submission of grades for the mid-semester examination is due by the end of this week.',
      'priority': 'High',
      'isUnread': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedDateFilter = 'All'; // Default date filter
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchController.clear();
      }
    });
  }

  // Get all unique modules for filter
  List<String> _getUniqueModules() {
    final Set<String> modules = {};
    
    for (final notification in _notifications) {
      modules.add(notification['module'] as String);
    }
    
    for (final announcement in _announcements) {
      modules.add(announcement['module'] as String);
    }
    
    final List<String> modulesList = modules.toList();
    modulesList.sort(); // Sort alphabetically
    return ['All'] + modulesList; // Add 'All' as the first option
  }

  List<Map<String, dynamic>> _getFilteredAnnouncements() {
    List<Map<String, dynamic>> filtered = _announcements;

    // Apply text search filter if search is active
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((announcement) =>
          announcement['title'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          announcement['content'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          announcement['module'].toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    }
    
    // Apply module filter
    if (_selectedModule != null && _selectedModule != 'All') {
      filtered = filtered.where((announcement) => 
          announcement['module'] == _selectedModule).toList();
    }
    
    // Apply date filter
    if (_selectedDateFilter != null && _selectedDateFilter != 'All') {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      filtered = filtered.where((announcement) {
        final date = announcement['date'] as DateTime;
        
        switch (_selectedDateFilter) {
          case 'Today':
            final announcementDate = DateTime(date.year, date.month, date.day);
            return announcementDate.isAtSameMomentAs(today);
          case 'Yesterday':
            final yesterday = today.subtract(const Duration(days: 1));
            final announcementDate = DateTime(date.year, date.month, date.day);
            return announcementDate.isAtSameMomentAs(yesterday);
          case 'This Week':
            final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
            return date.isAfter(startOfWeek.subtract(const Duration(days: 1)));
          case 'This Month':
            return date.month == today.month && date.year == today.year;
          case 'This Year':
            return date.year == today.year;
          default:
            return true;
        }
      }).toList();
    }
    
    return filtered;
  }

  List<Map<String, dynamic>> _getFilteredNotifications() {
    List<Map<String, dynamic>> filtered = _notifications;

    // Apply text search filter if search is active
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((notification) =>
          notification['title'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          notification['content'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          notification['module'].toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    }
    
    // Apply module filter
    if (_selectedModule != null && _selectedModule != 'All') {
      filtered = filtered.where((notification) => 
          notification['module'] == _selectedModule).toList();
    }
    
    // Apply date filter
    if (_selectedDateFilter != null && _selectedDateFilter != 'All') {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      filtered = filtered.where((notification) {
        final date = notification['date'] as DateTime;
        
        switch (_selectedDateFilter) {
          case 'Today':
            final notificationDate = DateTime(date.year, date.month, date.day);
            return notificationDate.isAtSameMomentAs(today);
          case 'Yesterday':
            final yesterday = today.subtract(const Duration(days: 1));
            final notificationDate = DateTime(date.year, date.month, date.day);
            return notificationDate.isAtSameMomentAs(yesterday);
          case 'This Week':
            final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
            return date.isAfter(startOfWeek.subtract(const Duration(days: 1)));
          case 'This Month':
            return date.month == today.month && date.year == today.year;
          case 'This Year':
            return date.year == today.year;
          default:
            return true;
        }
      }).toList();
    }
    
    return filtered;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${DateFormat('h:mm a').format(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${DateFormat('h:mm a').format(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureSidebar(
      scaffoldKey: _scaffoldKey,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: _isSearchVisible
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {});
                  },
                )
              : const Text(
                  'Home',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
          backgroundColor: Colors.blue.shade700,
          elevation: 2,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(_isSearchVisible ? Icons.close : Icons.search, color: Colors.white),
              onPressed: _toggleSearch,
            ),
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExitConfirmationWrapper(child: HomeScreen()),
                  ),
                );
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(_showFilters ? 100 : 48),
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: const [
                    Tab(text: 'Notifications'),
                    Tab(text: 'Announcements'),
                  ],
                ),
                if (_showFilters) _buildFilterOptions(),
              ],
            ),
          ),
        ),
        drawer: Sidebar(
          onItemSelected: (index) {
            if (index == 0) {
              // Already on Home screen
              Navigator.pop(context);
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ExaminationDashboard()),
              );
            }
          },
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildNotificationsTab(),
            _buildAnnouncementsTab(),
          ],
        ),
        bottomNavigationBar: const BottomBar(currentIndex: 0),
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Module filter
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.blue.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        hint: Row(
                          children: [
                            Icon(Icons.category_outlined, color: Colors.blue.shade700, size: 16),
                            const SizedBox(width: 8),
                            Text('Select Module', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        value: _selectedModule,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
                        style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w500),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedModule = newValue;
                          });
                        },
                        items: _getUniqueModules()
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  
                  // Date filter
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.blue.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        hint: Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.blue.shade700, size: 16),
                            const SizedBox(width: 8),
                            Text('Select Date Range', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        value: _selectedDateFilter,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
                        style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w500),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedDateFilter = newValue;
                          });
                        },
                        items: _dateFilterOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Reset filters button (minimal version)
          TextButton(
            onPressed: () {
              setState(() {
                _selectedModule = 'All';
                _selectedDateFilter = 'All';
              });
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Reset',
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab() {
    final filteredNotifications = _getFilteredNotifications();
    
    if (filteredNotifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredNotifications.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        final isUnread = notification['isUnread'] as bool;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 5),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                setState(() {
                  notification['isUnread'] = false;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationDetailScreen(notification: notification)
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with module tag and time
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                      child: Row(
                        children: [
                          // Module tag pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.indigo.shade100, width: 0.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getModuleTypeIcon(notification['module']),
                                  size: 12,
                                  color: Colors.indigo.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  notification['module'],
                                  style: TextStyle(
                                    color: Colors.indigo.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Time indicator
                          Text(
                            _formatDate(notification['date']),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          if (isUnread)
                            Container(
                              margin: const EdgeInsets.only(left: 6),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade600,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    // Content section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon
                          Container(
                            width: 45,
                            height: 45,
                            margin: const EdgeInsets.only(top: 2, right: 16),
                            decoration: BoxDecoration(
                              color: isUnread 
                                ? Colors.blue.shade50
                                : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Icon(
                                _getModuleTypeIcon(notification['module']),
                                color: isUnread
                                  ? Colors.blue.shade700
                                  : Colors.grey.shade600,
                                size: 24,
                              ),
                            ),
                          ),
                          
                          // Title and content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification['title'],
                                  style: TextStyle(
                                    fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.grey.shade900,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  notification['content'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnnouncementsTab() {
    final filteredAnnouncements = _getFilteredAnnouncements();
    
    if (filteredAnnouncements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.campaign_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No announcements found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredAnnouncements.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        final announcement = filteredAnnouncements[index];
        final isUnread = announcement['isUnread'] as bool;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 5),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: Colors.transparent,
              ),
            ),
            child: ExpansionTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              tilePadding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              childrenPadding: EdgeInsets.zero,
              
              // Header section
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Module and time row
                  Row(
                    children: [
                      // Module tag pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.indigo.shade100, width: 0.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getModuleTypeIcon(announcement['module']),
                              size: 12,
                              color: Colors.indigo.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              announcement['module'],
                              style: TextStyle(
                                color: Colors.indigo.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Time indicator
                      Text(
                        _formatDate(announcement['date']),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      if (isUnread)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade600,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Title
                  Text(
                    announcement['title'],
                    style: TextStyle(
                      fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                      fontSize: 17,
                      color: Colors.grey.shade900,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
              
              // Subtitle (author)
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        announcement['author'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              onExpansionChanged: (expanded) {
                if (expanded && announcement['isUnread']) {
                  setState(() {
                    announcement['isUnread'] = false;
                  });
                }
              },
              
              // Trailing icon
              trailing: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              
              // Expansion content
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(
                        announcement['content'],
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade800,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 16),
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
  
  IconData _getModuleTypeIcon(String module) {
    switch (module) {
      case 'Examination':
        return Icons.school;
      case 'Library':
        return Icons.local_library;
      case 'Hostel':
        return Icons.apartment;
      case 'Placement':
        return Icons.work;
      case 'Research':
        return Icons.science;
      case 'Academic':
        return Icons.book;
      case 'HR':
        return Icons.people;
      case 'Event':
        return Icons.event;
      case 'Finance':
        return Icons.account_balance;
      case 'Patent':
        return Icons.brightness_7;
      case 'File Tracking':
        return Icons.file_copy;
      default:
        return Icons.notifications;
    }
  }
}