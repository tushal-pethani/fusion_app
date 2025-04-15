
import 'package:flutter/material.dart';
import 'placement_dashboard.dart';
import '../../utils/sidebar.dart';
import '../../utils/gesture_sidebar.dart';
import '../../utils/bottom_bar.dart';

class ViewApplicationsScreen extends StatefulWidget {
  const ViewApplicationsScreen({super.key});

  @override
  State<ViewApplicationsScreen> createState() => _ViewApplicationsScreenState();
}

class _ViewApplicationsScreenState extends State<ViewApplicationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  List<Map<String, dynamic>> _applications = [];

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    // Simulate API loading
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _applications = [
        {
          'id': 'APP10034',
          'company': 'Google',
          'logo': 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png',
          'position': 'Software Engineer',
          'applied_date': '05 June 2024',
          'status': 'Under Review',
          'package': '₹25-40 LPA',
          'location': 'Bangalore, India',
          'statusColor': Colors.orange,
          'upcoming_event': 'Technical Interview on 20 July 2024',
          'feedback': null,
        },
        {
          'id': 'APP10022',
          'company': 'Microsoft',
          'logo': 'https://cdn.pixabay.com/photo/2013/02/12/09/07/microsoft-80658_1280.png',
          'position': 'Cloud Solutions Architect',
          'applied_date': '28 May 2024',
          'status': 'Interview Scheduled',
          'package': '₹20-35 LPA',
          'location': 'Hyderabad, India',
          'statusColor': Colors.blue,
          'upcoming_event': 'HR Round on 15 July 2024',
          'feedback': null,
        },
        {
          'id': 'APP9977',
          'company': 'Amazon',
          'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Amazon_logo.svg/2560px-Amazon_logo.svg.png',
          'position': 'SDE',
          'applied_date': '15 May 2024',
          'status': 'Rejected',
          'package': '₹22-38 LPA',
          'location': 'Gurgaon, India',
          'statusColor': Colors.red,
          'upcoming_event': null,
          'feedback': 'We found candidates with better matching skills for this role.',
        },
        {
          'id': 'APP9856',
          'company': 'Infosys',
          'logo': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1LxhLVV4iKcwxIULHCEXL60CHBF_sROlnxw&s',
          'position': 'Systems Engineer',
          'applied_date': '10 May 2024',
          'status': 'Selected',
          'package': '₹6-12 LPA',
          'location': 'Pune, India',
          'statusColor': Colors.green,
          'upcoming_event': 'Offer Acceptance Deadline: 20 July 2024',
          'feedback': 'Congratulations! You have been selected for the position.',
        },
        {
          'id': 'APP9814',
          'company': 'TCS',
          'logo': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgdN5uaq0RMWIAydcXeyqdkm4dtErZs3sw0w&s',
          'position': 'Assistant System Engineer',
          'applied_date': '02 May 2024',
          'status': 'Shortlisted',
          'package': '₹7-15 LPA',
          'location': 'Chennai, India',
          'statusColor': Colors.purple,
          'upcoming_event': 'Technical Test on 18 July 2024',
          'feedback': null,
        },
      ];
      _isLoading = false;
    });
  }

  void _showApplicationDetails(Map<String, dynamic> application) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildApplicationDetails(application),
    );
  }

  Widget _buildApplicationDetails(Map<String, dynamic> application) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(16),
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
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          'Application Details',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 48), // For balance
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Application ID and date
                    _buildDetailRow(
                      'Application ID',
                      application['id'],
                      icon: Icons.confirmation_number,
                    ),
                    _buildDetailRow(
                      'Applied On',
                      application['applied_date'],
                      icon: Icons.calendar_today,
                    ),
                    
                    const Divider(height: 32),
                    
                    // Company and position info
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            application['logo'],
                            height: 60,
                            width: 60,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 60,
                              width: 60,
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
                                application['company'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                application['position'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                application['location'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const Divider(height: 32),
                    
                    // Application status
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: application['statusColor'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: application['statusColor'].withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: application['statusColor'].withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getStatusIcon(application['status']),
                                  color: application['statusColor'],
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Current Status',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    application['status'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: application['statusColor'],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          
                          if (application['upcoming_event'] != null) ...[
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(Icons.event_note, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    application['upcoming_event'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    if (application['feedback'] != null) ...[
                      const SizedBox(height: 24),
                      const Text(
                        'Feedback',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          application['feedback'],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                    const Text(
                      'Job Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'Package',
                      application['package'],
                      icon: Icons.monetization_on,
                    ),
                    const SizedBox(height: 24),
                    
                    // Actions based on application status
                    if (application['status'] == 'Interview Scheduled' || 
                        application['status'] == 'Shortlisted') ...[
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showSnackBar('Interview details sent to your email.');
                        },
                        icon: const Icon(Icons.calendar_month),
                        label: const Text('View Interview Details'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ] else if (application['status'] == 'Selected') ...[
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showSnackBar('Offer letter downloaded successfully.');
                        },
                        icon: const Icon(Icons.file_download),
                        label: const Text('Download Offer Letter'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 16),
                    if (application['status'] != 'Rejected' && 
                        application['status'] != 'Selected') ...[
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showWithdrawConfirmation(application);
                        },
                        icon: const Icon(Icons.close),
                        label: const Text('Withdraw Application'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red.shade700,
                          side: BorderSide(color: Colors.red.shade700),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _showWithdrawConfirmation(Map<String, dynamic> application) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Withdraw Application'),
          content: Text(
            'Are you sure you want to withdraw your application for ${application['position']} at ${application['company']}? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  application['status'] = 'Withdrawn';
                  application['statusColor'] = Colors.grey;
                  application['upcoming_event'] = null;
                });
                _showSnackBar('Application withdrawn successfully.');
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red.shade700,
              ),
              child: const Text('WITHDRAW'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: Colors.grey.shade700),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Under Review':
        return Icons.hourglass_top;
      case 'Interview Scheduled':
        return Icons.event_available;
      case 'Shortlisted':
        return Icons.star;
      case 'Selected':
        return Icons.check_circle;
      case 'Rejected':
        return Icons.cancel;
      case 'Withdrawn':
        return Icons.remove_circle;
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Under Review':
        return Colors.orange;
      case 'Interview Scheduled':
        return Colors.blue;
      case 'Shortlisted':
        return Colors.purple;
      case 'Selected':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Withdrawn':
        return Colors.grey;
      default:
        return Colors.blue.shade700;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }

  String _getStatusMessage(String status, String? upcomingEvent) {
    switch (status) {
      case 'Under Review':
        return 'Your application is being reviewed by the recruiter.';
      case 'Interview Scheduled':
        return upcomingEvent ?? 'Your interview has been scheduled.';
      case 'Shortlisted':
        return upcomingEvent ?? 'You have been shortlisted for next round.';
      case 'Selected':
        return 'Congratulations! You have been selected.';
      case 'Rejected':
        return 'Unfortunately, your application was not selected.';
      case 'Withdrawn':
        return 'You have withdrawn this application.';
      default:
        return 'Application status is being updated.';
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
            'My Applications',
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
            if (index == 42) {
              // Already on View Applications screen
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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Track Your Job Applications',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Monitor the status of your applications to different companies',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Status filter chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('All (${_applications.length})'),
                          _buildFilterChip('Under Review (1)'),
                          _buildFilterChip('Shortlisted (1)'),
                          _buildFilterChip('Interview (1)'),
                          _buildFilterChip('Selected (1)'),
                          _buildFilterChip('Rejected (1)'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Expanded(
                      child: _applications.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.work_off,
                                    size: 80,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No applications found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'You haven\'t applied to any jobs yet',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const PlacementDashboard(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.work),
                                    label: const Text('View Available Jobs'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade700,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: _applications.length,
                              itemBuilder: (context, index) {
                                final application = _applications[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: InkWell(
                                    onTap: () => _showApplicationDetails(application),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image.network(
                                                  application['logo'],
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
                                                      application['company'],
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      application['position'],
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: application['statusColor'].withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: application['statusColor'].withOpacity(0.5),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      _getStatusIcon(application['status']),
                                                      size: 14,
                                                      color: application['statusColor'],
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      application['status'],
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                        color: application['statusColor'],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Applied on: ${application['applied_date']}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  'ID: ${application['id']}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          const Divider(),
                                          
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              _getStatusMessage(
                                                application['status'],
                                                application['upcoming_event'],
                                              ),
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                          
                                          const SizedBox(height: 12),
                                          
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ElevatedButton.icon(
                                                onPressed: () => _showApplicationDetails(application),
                                                icon: const Icon(Icons.visibility, size: 18),
                                                label: const Text('View Details'),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue.shade700,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                              ),
                                              
                                              if (application['status'] != 'Rejected' && 
                                                  application['status'] != 'Selected' &&
                                                  application['status'] != 'Withdrawn')
                                                TextButton.icon(
                                                  onPressed: () => _showWithdrawConfirmation(application),
                                                  icon: const Icon(Icons.close, size: 18),
                                                  label: const Text('Withdraw'),
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: Colors.red.shade700,
                                                  ),
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
              ),
        bottomNavigationBar: const BottomBar(currentIndex: 2),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = label.startsWith('All');
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        showCheckmark: false,
        backgroundColor: Colors.grey.shade100,
        selectedColor: Colors.blue.shade100,
        labelStyle: TextStyle(
          color: isSelected ? Colors.blue.shade800 : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.blue.shade800 : Colors.grey.shade300,
          ),
        ),
        onSelected: (bool selected) {
          // Implementation for filtering would go here
        },
      ),
    );
  }
}