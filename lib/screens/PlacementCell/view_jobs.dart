import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'placement_dashboard.dart';
import '../../utils/sidebar.dart';
import '../../utils/gesture_sidebar.dart';
import '../../utils/bottom_bar.dart';

class ViewJobsScreen extends StatefulWidget {
  const ViewJobsScreen({super.key});

  @override
  State<ViewJobsScreen> createState() => _ViewJobsScreenState();
}

class _ViewJobsScreenState extends State<ViewJobsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _resumeController = TextEditingController();
  PlatformFile? _selectedResume;
  bool _isLoading = false;
  String? _selectedCompany;
  String? _selectedPosition;

  final List<Map<String, dynamic>> _companies = [
    {
      'name': 'Google',
      'logo':
          'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png',
      'positions': ['Software Engineer', 'Product Manager', 'Data Scientist'],
      'package': '₹25-40 LPA',
      'location': 'Bangalore, India',
      'deadline': '30 June 2024',
    },
    {
      'name': 'Microsoft',
      'logo':
          'https://cdn.pixabay.com/photo/2013/02/12/09/07/microsoft-80658_1280.png',
      'positions': [
        'Software Engineer',
        'Cloud Solutions Architect',
        'UX Designer'
      ],
      'package': '₹20-35 LPA',
      'location': 'Hyderabad, India',
      'deadline': '15 July 2024',
    },
    {
      'name': 'Amazon',
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Amazon_logo.svg/2560px-Amazon_logo.svg.png',
      'positions': ['SDE', 'Business Analyst', 'Operations Manager'],
      'package': '₹22-38 LPA',
      'location': 'Gurgaon, India',
      'deadline': '10 July 2024',
    },
    {
      'name': 'Infosys',
      'logo':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1LxhLVV4iKcwxIULHCEXL60CHBF_sROlnxw&s',
      'positions': [
        'Systems Engineer',
        'Technology Analyst',
        'Digital Specialist'
      ],
      'package': '₹6-12 LPA',
      'location': 'Pune, India',
      'deadline': '20 July 2024',
    },
    {
      'name': 'TCS',
      'logo':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgdN5uaq0RMWIAydcXeyqdkm4dtErZs3sw0w&s',
      'positions': [
        'Assistant System Engineer',
        'Developer',
        'Business Analyst'
      ],
      'package': '₹7-15 LPA',
      'location': 'Chennai, India',
      'deadline': '25 July 2024',
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _resumeController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _selectResume() async {
    try {
      setState(() {
        _isLoading = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      setState(() {
        _isLoading = false;
      });

      if (result != null) {
        setState(() {
          _selectedResume = result.files.first;
          _resumeController.text = _selectedResume!.name;
        });

        _showSnackBar('Resume selected: ${_selectedResume!.name}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showSnackBar('Error picking file: $e', isError: true);
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      double kb = bytes / 1024;
      return '${kb.toStringAsFixed(1)} KB';
    } else {
      double mb = bytes / (1024 * 1024);
      return '${mb.toStringAsFixed(1)} MB';
    }
  }

  void _showApplicationForm(String companyName, String position) {
    setState(() {
      _selectedCompany = companyName;
      _selectedPosition = position;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildApplicationForm(),
    );
  }

  Widget _buildApplicationForm() {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
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
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            'Apply to $_selectedCompany - $_selectedPosition',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48), // For balance
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildFormField(
                      label: 'Full Name*',
                      controller: _nameController,
                      hint: 'Enter your full name',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Email Address*',
                      controller: _emailController,
                      hint: 'Enter your email address',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Phone Number*',
                      controller: _phoneController,
                      hint: 'Enter your phone number',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Resume/CV*',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: _selectResume,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 16),
                                      child: Text(
                                        _resumeController.text.isEmpty
                                            ? 'No file chosen'
                                            : _resumeController.text,
                                        style: TextStyle(
                                          color: _resumeController.text.isEmpty
                                              ? Colors.grey.shade600
                                              : Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(7.0),
                                        bottomRight: Radius.circular(7.0),
                                      ),
                                    ),
                                    child: TextButton(
                                      onPressed: _selectResume,
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                      ),
                                      child: Text(
                                        'Browse',
                                        style: TextStyle(
                                            color: Colors.blue.shade700),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline,
                                    size: 12, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                Text(
                                  'Accepts .pdf, .doc or .docx files only',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_resumeController.text.isNotEmpty &&
                        _selectedResume != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.description,
                                color: Colors.blue.shade700,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedResume!.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    Text(
                                      _formatFileSize(_selectedResume!.size),
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.close,
                                    color: Colors.red, size: 20),
                                onPressed: () {
                                  setState(() {
                                    _resumeController.text = '';
                                    _selectedResume = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _validateAndSubmit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Submit Application'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
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

  Widget _buildFormField({
    required String label,
    TextEditingController? controller,
    String? hint,
    TextInputType? keyboardType,
    Widget? child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        child ??
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
      ],
    );
  }

  void _validateAndSubmit() {
    if (_nameController.text.isEmpty) {
      _showSnackBar('Please enter your full name', isError: true);
      return;
    }

    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      _showSnackBar('Please enter a valid email address', isError: true);
      return;
    }

    if (_phoneController.text.isEmpty || _phoneController.text.length < 10) {
      _showSnackBar('Please enter a valid phone number', isError: true);
      return;
    }

    if (_selectedResume == null) {
      _showSnackBar('Please upload your resume', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context); // Close form
      _showApplicationSuccess();
    });
  }

  void _showApplicationSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade500),
              const SizedBox(width: 8),
              const Text('Application Submitted'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Company: $_selectedCompany',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Position: $_selectedPosition'),
              const SizedBox(height: 16),
              const Text(
                'Your application has been successfully submitted. The recruiter will contact you shortly.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureSidebar(
      scaffoldKey: _scaffoldKey,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            'Available Jobs',
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
            if (index == 40) {
              // Already on View Jobs screen
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
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latest Placement Opportunities',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Apply to available positions in top companies',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _companies.length,
                      itemBuilder: (context, index) {
                        final company = _companies[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                                        company['logo'],
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          height: 40,
                                          width: 40,
                                          color: Colors.grey.shade200,
                                          child: const Icon(Icons.business,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            company['name'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            company['location'],
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
                                const Divider(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildInfoRow(
                                            Icons.work_outline,
                                            'Package: ${company['package']}',
                                          ),
                                          const SizedBox(height: 8),
                                          _buildInfoRow(
                                            Icons.event,
                                            'Deadline: ${company['deadline']}',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Available Positions:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...List.generate(
                                  (company['positions'] as List).length,
                                  (i) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '• ${company['positions'][i]}',
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => _showApplicationForm(
                                            company['name'],
                                            company['positions'][i],
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.blue.shade700,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('Apply'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
        bottomNavigationBar: const BottomBar(currentIndex: 2),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blue.shade700),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
