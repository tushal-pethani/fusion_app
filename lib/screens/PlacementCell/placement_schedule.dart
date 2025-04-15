import 'package:flutter/material.dart';
import 'placement_dashboard.dart';
import 'view_jobs.dart'; // Import the ViewJobsScreen class
import '../../utils/sidebar.dart';
import '../../utils/gesture_sidebar.dart';
import '../../utils/bottom_bar.dart';

class PlacementScheduleScreen extends StatefulWidget {
  const PlacementScheduleScreen({super.key});

  @override
  State<PlacementScheduleScreen> createState() => _PlacementScheduleScreenState();
}

class _PlacementScheduleScreenState extends State<PlacementScheduleScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedFilter = 'All';
  List<Map<String, dynamic>> _filteredEvents = [];
  final List<String> _filterOptions = [
    'All',
    'Today',
    'This Week',
    'This Month',
    'Upcoming'
  ];

  // Sample events data
  final List<Map<String, dynamic>> _scheduleEvents = [
    {
      'companyName': 'Google',
      'logo': 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png',
      'role': 'Software Engineer',
      'date': '2024-06-15',
      'time': '10:00 AM',
      'mode': 'Online',
      'location': 'Google Meet',
      'description': 'Technical interview for software engineering roles. Be prepared to solve coding problems and system design questions.',
      'requirements': 'Laptop with working camera and microphone, stable internet connection.',
    },
    {
      'companyName': 'Microsoft',
      'logo': 'https://cdn.pixabay.com/photo/2013/02/12/09/07/microsoft-80658_1280.png',
      'role': 'Product Manager',
      'date': '2024-06-18',
      'time': '02:00 PM',
      'mode': 'Offline',
      'location': 'Campus Auditorium',
      'description': 'Group discussion and personal interview for product management roles.',
      'requirements': 'College ID, resume copies (3), formal attire.',
    },
    {
      'companyName': 'Amazon',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Amazon_logo.svg/2560px-Amazon_logo.svg.png',
      'role': 'Software Development Engineer',
      'date': '2024-06-20',
      'time': '09:30 AM',
      'mode': 'Online',
      'location': 'Amazon Chime',
      'description': 'Multiple rounds of technical interviews for SDE roles.',
      'requirements': 'Laptop with stable internet, whiteboard/paper for problem-solving.',
    },
    {
      'companyName': 'Infosys',
      'logo': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1LxhLVV4iKcwxIULHCEXL60CHBF_sROlnxw&s',
      'role': 'Systems Engineer',
      'date': '2024-06-25',
      'time': '11:00 AM',
      'mode': 'Offline',
      'location': 'Campus Placement Cell',
      'description': 'Aptitude test followed by technical and HR interview.',
      'requirements': 'College ID, resume, formal attire, basic coding knowledge.',
    },
    {
      'companyName': 'TCS',
      'logo': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgdN5uaq0RMWIAydcXeyqdkm4dtErZs3sw0w&s',
      'role': 'Digital Specialist Engineer',
      'date': '2024-07-05',
      'time': '10:00 AM',
      'mode': 'Hybrid',
      'location': 'Online Test + Campus Interview',
      'description': 'Online aptitude and technical assessment followed by in-person interviews for shortlisted candidates.',
      'requirements': 'College ID, laptop for online test, resume copies.',
    },
    {
      'companyName': 'Wipro',
      'logo': 'https://companieslogo.com/img/orig/WIT-5b3c072c.png?t=1648384541',
      'role': 'Project Engineer',
      'date': '2024-07-10',
      'time': '09:00 AM',
      'mode': 'Online',
      'location': 'Wipro Portal',
      'description': 'Online assessment followed by technical and HR interviews.',
      'requirements': 'Updated resume, laptop with stable internet connection.',
    },
    {
      'companyName': 'Accenture',
      'logo': 'https://companieslogo.com/img/orig/ACN-bb9c01e5.png?t=1633439499',
      'role': 'Associate Software Engineer',
      'date': '2024-07-15',
      'time': '11:30 AM',
      'mode': 'Offline',
      'location': 'Campus Conference Hall',
      'description': 'Full day selection process including aptitude, coding test, and interviews.',
      'requirements': 'College ID, resume copies, formal dress code mandatory.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filterEvents(_selectedFilter);
  }

  void _filterEvents(String filter) {
    setState(() {
      _selectedFilter = filter;
      
      if (filter == 'All') {
        _filteredEvents = List.from(_scheduleEvents);
        return;
      }

      // Get current date
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      // Filter events based on selected filter
      _filteredEvents = _scheduleEvents.where((event) {
        final eventDate = DateTime.parse(event['date']);
        
        if (filter == 'Today') {
          return eventDate.year == today.year && 
                 eventDate.month == today.month && 
                 eventDate.day == today.day;
        } 
        else if (filter == 'This Week') {
          // Calculate the end of the week (next 7 days)
          final endOfWeek = today.add(const Duration(days: 7));
          return eventDate.isAfter(today.subtract(const Duration(days: 1))) && 
                 eventDate.isBefore(endOfWeek);
        }
        else if (filter == 'This Month') {
          return eventDate.year == today.year && 
                 eventDate.month == today.month;
        }
        else if (filter == 'Upcoming') {
          return eventDate.isAfter(today.subtract(const Duration(days: 1)));
        }
        
        return true;
      }).toList();
      
      // Sort by date (earliest first)
      _filteredEvents.sort((a, b) {
        final dateA = DateTime.parse(a['date']);
        final dateB = DateTime.parse(b['date']);
        return dateA.compareTo(dateB);
      });
    });
  }

  void _showEventDetails(Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildEventDetailsSheet(event),
    );
  }

  Widget _buildEventDetailsSheet(Map<String, dynamic> event) {
    // Parse the date
    final eventDate = DateTime.parse(event['date']);
    final formattedDate = "${eventDate.day}/${eventDate.month}/${eventDate.year}";
    
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 6,
                width: 60,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Company header with logo
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            event['logo'],
                            height: 50,
                            width: 50,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 50,
                              width: 50,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.business, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event['companyName'],
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                event['role'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Event details section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Event Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(Icons.calendar_today, 'Date', formattedDate),
                          const SizedBox(height: 12),
                          _buildDetailRow(Icons.access_time, 'Time', event['time']),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            event['mode'] == 'Online' 
                              ? Icons.computer
                              : event['mode'] == 'Hybrid'
                                ? Icons.compare_arrows
                                : Icons.location_on,
                            'Mode', 
                            event['mode']
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(Icons.place, 'Location', event['location']),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event['description'],
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade800,
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Requirements
                    const Text(
                      'Requirements',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event['requirements'],
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade800,
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Event added to calendar'),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            icon: Icon(Icons.calendar_month, color: Colors.blue.shade700),
                            label: Text(
                              'Add to Calendar',
                              style: TextStyle(color: Colors.blue.shade700),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Colors.blue.shade700),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Reminder set for this event'),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            icon: const Icon(Icons.notifications_active),
                            label: const Text('Set Reminder'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Close button
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade700),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Format date for display
  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    
    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      return 'Today';
    } else if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureSidebar(
      scaffoldKey: _scaffoldKey,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            'Placement Schedule',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlacementDashboard(),
                ),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.blue),
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
          ],
        ),
        drawer: Sidebar(
          onItemSelected: (index) {
            Navigator.pop(context);
            if (index == 37) {
              // Already on View Placement Schedule screen
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlacementDashboard(),
                ),
              );
            }
          },
        ),
        body: Column(
          children: [
            // Filter chips
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: _filterOptions.map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            _filterEvents(filter);
                          }
                        },
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: Colors.blue.shade100,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.blue.shade800 : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            // Event count
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _filteredEvents.isNotEmpty 
                      ? '${_filteredEvents.length} events found'
                      : 'No events found',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.sort, size: 16, color: Colors.blue.shade700),
                      const SizedBox(width: 4),
                      Text(
                        'Sorted by date',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Event list
            Expanded(
              child: _filteredEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No events found for $_selectedFilter',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try another filter',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = _filteredEvents[index];
                      final date = _formatDate(event['date']);
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () => _showEventDetails(event),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        event['logo'],
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          height: 40,
                                          width: 40,
                                          color: Colors.grey.shade200,
                                          child: const Icon(Icons.business, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event['companyName'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            event['role'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blue.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: event['mode'] == 'Online' 
                                          ? Colors.green.shade50 
                                          : event['mode'] == 'Offline'
                                            ? Colors.orange.shade50
                                            : Colors.purple.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: event['mode'] == 'Online' 
                                            ? Colors.green.shade200 
                                            : event['mode'] == 'Offline'
                                              ? Colors.orange.shade200
                                              : Colors.purple.shade200,
                                        ),
                                      ),
                                      child: Text(
                                        event['mode'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: event['mode'] == 'Online' 
                                            ? Colors.green.shade700 
                                            : event['mode'] == 'Offline'
                                              ? Colors.orange.shade700
                                              : Colors.purple.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(Icons.calendar_today, 
                                              size: 16, color: Colors.grey.shade600),
                                          const SizedBox(width: 4),
                                          Text(
                                            date,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: date == 'Today' 
                                                ? Colors.green.shade700
                                                : date == 'Tomorrow'
                                                  ? Colors.orange.shade700
                                                  : Colors.grey.shade700,
                                              fontWeight: date == 'Today' || date == 'Tomorrow'
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time, 
                                            size: 16, color: Colors.grey.shade600),
                                        const SizedBox(width: 4),
                                        Text(
                                          event['time'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Icon(
                                      event['mode'] == 'Online' 
                                        ? Icons.computer
                                        : event['mode'] == 'Hybrid'
                                          ? Icons.compare_arrows
                                          : Icons.location_on,
                                      size: 16, 
                                      color: Colors.grey.shade600
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        event['location'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade700,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () => _showEventDetails(event),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.blue.shade700,
                                        side: BorderSide(color: Colors.blue.shade700),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      ),
                                      child: const Text('View Details'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
        bottomNavigationBar: const BottomBar(currentIndex: 2),
      ),
    );
  }
}