import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'placement_dashboard.dart';
import '../../utils/sidebar.dart';
import '../../utils/gesture_sidebar.dart';
import '../../utils/bottom_bar.dart';
import 'dart:math' as math;

class UploadOfferLetterScreen extends StatefulWidget {
  const UploadOfferLetterScreen({super.key});

  @override
  State<UploadOfferLetterScreen> createState() => _UploadOfferLetterScreenState();
}

class _UploadOfferLetterScreenState extends State<UploadOfferLetterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _packageController = TextEditingController();
  final TextEditingController _joiningDateController = TextEditingController();
  final TextEditingController _offerLetterController = TextEditingController();
  
  PlatformFile? _selectedOfferLetter;
  bool _isLoading = false;
  DateTime? _selectedJoiningDate;
  
  // List to store uploaded offer letters with their verification status
  final List<Map<String, dynamic>> _uploadedOfferLetters = [
    {
      'id': '1',
      'companyName': 'Google',
      'jobTitle': 'Software Engineer',
      'package': '₹38 LPA',
      'joiningDate': '01/08/2024',
      'uploadDate': '15/05/2024',
      'status': 'Verified',
      'statusColor': Colors.green,
      'fileName': 'Google_Offer_Letter.pdf',
      'fileSize': '2.3 MB',
    },
    {
      'id': '2',
      'companyName': 'Microsoft',
      'jobTitle': 'Product Manager',
      'package': '₹32 LPA',
      'joiningDate': '15/07/2024',
      'uploadDate': '10/04/2024',
      'status': 'In Progress',
      'statusColor': Colors.orange,
      'fileName': 'Microsoft_Offer_Letter.pdf',
      'fileSize': '1.8 MB',
    },
    {
      'id': '3',
      'companyName': 'TCS',
      'jobTitle': 'System Engineer',
      'package': '₹7.5 LPA',
      'joiningDate': '20/07/2024',
      'uploadDate': '25/03/2024',
      'status': 'Rejected',
      'statusColor': Colors.red,
      'fileName': 'TCS_Offer_Letter.pdf',
      'fileSize': '1.2 MB',
      'rejectReason': 'Invalid offer letter format. Please upload the official letter with company letterhead.',
    },
  ];
  
  @override
  void dispose() {
    _companyNameController.dispose();
    _jobTitleController.dispose();
    _packageController.dispose();
    _joiningDateController.dispose();
    _offerLetterController.dispose();
    super.dispose();
  }
  
  Future<void> _selectJoiningDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedJoiningDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedJoiningDate) {
      setState(() {
        _selectedJoiningDate = picked;
        _joiningDateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
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
  
  Future<void> _selectOfferLetter() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );
      
      setState(() {
        _isLoading = false;
      });
      
      if (result != null) {
        setState(() {
          _selectedOfferLetter = result.files.first;
          _offerLetterController.text = _selectedOfferLetter!.name;
        });
        
        _showSnackBar('Offer Letter selected: ${_selectedOfferLetter!.name}');
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
  
  void _validateAndSubmit() {
    // Validate all fields
    if (_companyNameController.text.isEmpty) {
      _showSnackBar('Please enter company name', isError: true);
      return;
    }
    
    if (_jobTitleController.text.isEmpty) {
      _showSnackBar('Please enter job title', isError: true);
      return;
    }
    
    if (_packageController.text.isEmpty) {
      _showSnackBar('Please enter package details', isError: true);
      return;
    }
    
    if (_joiningDateController.text.isEmpty) {
      _showSnackBar('Please select joining date', isError: true);
      return;
    }
    
    if (_selectedOfferLetter == null) {
      _showSnackBar('Please upload your offer letter', isError: true);
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    // Simulate API call to upload offer letter
    Future.delayed(const Duration(seconds: 2), () {
      // Generate a random ID for the new upload
      String newId = (math.Random().nextInt(1000) + 4).toString();
      
      // Get current date for upload date
      final now = DateTime.now();
      final uploadDate = "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";
      
      // Add new offer letter to the list
      _uploadedOfferLetters.insert(0, {
        'id': newId,
        'companyName': _companyNameController.text,
        'jobTitle': _jobTitleController.text,
        'package': _packageController.text,
        'joiningDate': _joiningDateController.text,
        'uploadDate': uploadDate,
        'status': 'Pending',
        'statusColor': Colors.blue,
        'fileName': _selectedOfferLetter!.name,
        'fileSize': _formatFileSize(_selectedOfferLetter!.size),
      });
      
      setState(() {
        _isLoading = false;
        // Clear form fields
        _companyNameController.clear();
        _jobTitleController.clear();
        _packageController.clear();
        _joiningDateController.clear();
        _offerLetterController.clear();
        _selectedOfferLetter = null;
        _selectedJoiningDate = null;
      });
      
      _showUploadSuccess();
    });
  }
  
  void _showUploadSuccess() {
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
              const Text('Offer Letter Uploaded'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your offer letter has been successfully uploaded. The placement cell will verify it shortly.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 12),
              Text(
                'You will be notified once the verification is complete.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  
  void _showDetailsDialog(Map<String, dynamic> offerLetter) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Offer Letter Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Company', offerLetter['companyName']),
                _buildDetailRow('Position', offerLetter['jobTitle']),
                _buildDetailRow('Package', offerLetter['package']),
                _buildDetailRow('Joining Date', offerLetter['joiningDate']),
                _buildDetailRow('Upload Date', offerLetter['uploadDate']),
                _buildDetailRow('Status', offerLetter['status']),
                _buildDetailRow('File', offerLetter['fileName']),
                if (offerLetter['status'] == 'Rejected' && offerLetter.containsKey('rejectReason'))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Rejection Reason:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(offerLetter['rejectReason']),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            if (offerLetter['status'] == 'Rejected')
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Pre-fill form with rejected offer data for resubmission
                  setState(() {
                    _companyNameController.text = offerLetter['companyName'];
                    _jobTitleController.text = offerLetter['jobTitle'];
                    _packageController.text = offerLetter['package'];
                    _joiningDateController.text = offerLetter['joiningDate'];
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                ),
                child: const Text('Resubmit'),
              ),
          ],
        );
      },
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
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
            'Upload Offer Letter',
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
            if (index == 39) {
              // Already on Upload Offer Letter screen
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
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Upload section header
                    Text(
                      'Upload New Offer Letter',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Submit your offer letter from on-campus placement',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Upload form
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Company name field
                            _buildFormField(
                              label: 'Company Name*',
                              controller: _companyNameController,
                              hint: 'Enter company name',
                            ),
                            const SizedBox(height: 16),
                            
                            // Job title field
                            _buildFormField(
                              label: 'Job Title*',
                              controller: _jobTitleController,
                              hint: 'Enter job title/position',
                            ),
                            const SizedBox(height: 16),
                            
                            // Package field
                            _buildFormField(
                              label: 'Package Offered*',
                              controller: _packageController,
                              hint: 'E.g., ₹10 LPA',
                            ),
                            const SizedBox(height: 16),
                            
                            // Joining date field
                            _buildFormField(
                              label: 'Joining Date*',
                              controller: _joiningDateController,
                              hint: 'Select joining date',
                              readOnly: true,
                              onTap: () => _selectJoiningDate(context),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () => _selectJoiningDate(context),
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Offer letter upload field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Offer Letter*',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: _selectOfferLetter,
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
                                              _offerLetterController.text.isEmpty
                                                  ? 'No file chosen'
                                                  : _offerLetterController.text,
                                              style: TextStyle(
                                                color: _offerLetterController.text.isEmpty
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
                                            onPressed: _selectOfferLetter,
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
                                        'Accepts PDF or image files (.jpg, .png)',
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
                            
                            // Show selected file details if any
                            if (_offerLetterController.text.isNotEmpty &&
                                _selectedOfferLetter != null)
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
                                              _selectedOfferLetter!.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              _formatFileSize(_selectedOfferLetter!.size),
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
                                            _offerLetterController.text = '';
                                            _selectedOfferLetter = null;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            
                            const SizedBox(height: 24),
                            
                            // Submit button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
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
                                child: const Text('Submit Offer Letter'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Previously uploaded offer letters
                    Text(
                      'Your Uploaded Offer Letters',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Track verification status of your offer letters',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // List of uploaded offer letters
                    ..._uploadedOfferLetters.map((offerLetter) => Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () => _showDetailsDialog(offerLetter),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Company info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          offerLetter['companyName'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          offerLetter['jobTitle'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Status badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: offerLetter['statusColor'].withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: offerLetter['statusColor'],
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _getStatusIcon(offerLetter['status']),
                                          size: 16,
                                          color: offerLetter['statusColor'],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          offerLetter['status'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: offerLetter['statusColor'],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 12),
                              const Divider(height: 1),
                              const SizedBox(height: 12),
                              
                              // Additional details
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        _buildOfferInfoRow(
                                          Icons.monetization_on_outlined,
                                          'Package',
                                          offerLetter['package'],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        _buildOfferInfoRow(
                                          Icons.calendar_today_outlined,
                                          'Joining',
                                          offerLetter['joiningDate'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // File details
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _getFileIcon(offerLetter['fileName']),
                                      color: Colors.blue.shade700,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            offerLetter['fileName'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            'Uploaded on ${offerLetter['uploadDate']} • ${offerLetter['fileSize']}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: IconButton(
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.all(4),
                                        icon: Icon(
                                          Icons.visibility,
                                          color: Colors.blue.shade700,
                                          size: 18,
                                        ),
                                        onPressed: () {},
                                        tooltip: 'View Document',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Rejection reason if status is rejected
                              if (offerLetter['status'] == 'Rejected' && offerLetter.containsKey('rejectReason'))
                                Container(
                                  margin: const EdgeInsets.only(top: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.red.shade200),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            color: Colors.red.shade700,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Rejection Reason:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        offerLetter['rejectReason'],
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.red.shade800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    )).toList(),
                  ],
                ),
              ),
            ),
            
            // Loading indicator
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
  
  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
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
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
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
  
  Widget _buildOfferInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 16,
            color: Colors.blue.shade700,
          ),
        ),
        const SizedBox(width: 8),
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
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Verified':
        return Icons.verified;
      case 'Rejected':
        return Icons.cancel;
      case 'In Progress':
        return Icons.pending;
      case 'Pending':
        return Icons.hourglass_empty;
      default:
        return Icons.info;
    }
  }
  
  IconData _getFileIcon(String fileName) {
    if (fileName.toLowerCase().endsWith('.pdf')) {
      return Icons.picture_as_pdf;
    } else if (fileName.toLowerCase().endsWith('.jpg') || 
              fileName.toLowerCase().endsWith('.jpeg') || 
              fileName.toLowerCase().endsWith('.png')) {
      return Icons.image;
    } else {
      return Icons.insert_drive_file;
    }
  }
}
