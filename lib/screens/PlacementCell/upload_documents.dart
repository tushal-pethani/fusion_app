import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:math';
import 'placement_dashboard.dart';
import '../../utils/sidebar.dart';
import '../../utils/gesture_sidebar.dart';
import '../../utils/bottom_bar.dart';

class UploadDocumentsScreen extends StatefulWidget {
  const UploadDocumentsScreen({super.key});

  @override
  State<UploadDocumentsScreen> createState() => _UploadDocumentsScreenState();
}

class _UploadDocumentsScreenState extends State<UploadDocumentsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  final TextEditingController _documentNameController = TextEditingController();
  String _selectedDocumentType = 'Marksheet';
  PlatformFile? _selectedFile;

  // Modified mock data for previously uploaded documents - removed 'Verified' status
  final List<Map<String, dynamic>> _uploadedDocuments = [
    {
      'name': 'Semester 5 Marksheet',
      'type': 'Marksheet',
      'date': '10 May 2023',
      'fileSize': '325 KB',
      'fileType': 'PDF',
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
    },
    {
      'name': 'BTech Degree Certificate',
      'type': 'Certificate',
      'date': '15 Mar 2023',
      'fileSize': '2.1 MB',
      'fileType': 'PDF',
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
    },
    {
      'name': 'Fee Receipt Sem 6',
      'type': 'Fee Receipt',
      'date': '28 Feb 2023',
      'fileSize': '180 KB',
      'fileType': 'JPEG',
      'icon': Icons.image,
      'color': Colors.blue,
    },
    {
      'name': 'Internship Completion Certificate',
      'type': 'Certificate',
      'date': '12 Jan 2023',
      'fileSize': '450 KB',
      'fileType': 'PNG',
      'icon': Icons.image,
      'color': Colors.green,
    },
  ];

  final List<String> _documentTypes = [
    'Marksheet',
    'Certificate',
    'Fee Receipt',
    'ID Card',
    'Internship Letter',
    'Passport',
    'Resume',
    'Other',
  ];

  @override
  void dispose() {
    _documentNameController.dispose();
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

  Future<void> _selectFile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      setState(() {
        _isLoading = false;
      });

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;

          // Auto-populate document name based on file name
          String fileName = _selectedFile!.name;
          // Remove file extension
          fileName = fileName.split('.').first;
          // Capitalize each word
          fileName = fileName.split('_').map((word) =>
              word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '').join(' ');

          _documentNameController.text = fileName;
        });

        _showSnackBar('File selected: ${_selectedFile!.name}');
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

  void _uploadDocument() {
    if (_documentNameController.text.isEmpty) {
      _showSnackBar('Please enter a document name', isError: true);
      return;
    }

    if (_selectedFile == null) {
      _showSnackBar('Please select a file to upload', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call with delay
    Future.delayed(const Duration(seconds: 2), () {
      // Create a new document entry without 'status' field
      final newDocument = {
        'name': _documentNameController.text,
        'type': _selectedDocumentType,
        'date': _getCurrentDate(),
        'fileSize': _formatFileSize(_selectedFile!.size),
        'fileType': _getFileType(_selectedFile!.name),
        'icon': _getFileIcon(_selectedFile!.name),
        'color': _getFileColor(_selectedFile!.name),
      };

      setState(() {
        // Add to the beginning of the list
        _uploadedDocuments.insert(0, newDocument);
        _isLoading = false;

        // Reset form
        _documentNameController.clear();
        _selectedFile = null;
      });

      _showSnackBar('Document uploaded successfully!');
    });
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  String _getFileType(String fileName) {
    final extension = fileName.split('.').last.toUpperCase();
    return extension;
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'jpg':
      case 'jpeg':
        return Colors.orange;
      case 'png':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _viewDocumentDetails(Map<String, dynamic> document) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildDocumentDetailsSheet(document),
    );
  }

  Widget _buildDocumentDetailsSheet(Map<String, dynamic> document) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
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
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: document['color'].withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          document['icon'],
                          size: 50,
                          color: document['color'],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        document['name'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildDetailItem('Document Type', document['type']),
                    _buildDetailItem('File Type', document['fileType']),
                    _buildDetailItem('File Size', document['fileSize']),
                    _buildDetailItem('Upload Date', document['date']),
                    const SizedBox(height: 32),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showSnackBar('Downloading document...');
                            },
                            icon: const Icon(Icons.download),
                            label: const Text('Download'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Colors.blue.shade700),
                              foregroundColor: Colors.blue.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showSnackBar('Opening document viewer...');
                            },
                            icon: const Icon(Icons.visibility),
                            label: const Text('View'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Delete button for all documents
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showDeleteConfirmation(document);
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete Document'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
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

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document?'),
        content: Text(
          'Are you sure you want to delete "${document['name']}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _uploadedDocuments.remove(document);
              });
              _showSnackBar('Document deleted successfully');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('DELETE'),
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
            'Upload Documents',
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
            if (index == 38) {
              // Already on Upload Documents screen
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
                    'Document Management',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload and manage your placement documents',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Upload document card
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.upload_file,
                                color: Colors.blue.shade700,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Upload New Document',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),

                          // Document name field
                          TextField(
                            controller: _documentNameController,
                            decoration: InputDecoration(
                              labelText: 'Document Name*',
                              hintText: 'E.g., Semester 6 Marksheet',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.edit_document),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Document type dropdown
                          DropdownButtonFormField<String>(
                            value: _selectedDocumentType,
                            decoration: InputDecoration(
                              labelText: 'Document Type*',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.folder),
                            ),
                            items: _documentTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedDocumentType = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 16),

                          // File picker
                          InkWell(
                            onTap: _selectFile,
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
                                        _selectedFile == null
                                            ? 'No file chosen'
                                            : _selectedFile!.name,
                                        style: TextStyle(
                                          color: _selectedFile == null
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
                                    child: TextButton.icon(
                                      onPressed: _selectFile,
                                      icon: const Icon(Icons.attach_file),
                                      label: const Text('Browse'),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        foregroundColor: Colors.blue.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Show file info if selected
                          if (_selectedFile != null)
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
                                      _getFileIcon(_selectedFile!.name),
                                      color: _getFileColor(_selectedFile!.name),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _selectedFile!.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          Text(
                                            _formatFileSize(_selectedFile!.size),
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
                                          _selectedFile = null;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          const SizedBox(height: 24),

                          // Upload button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _uploadDocument,
                              icon: const Icon(Icons.cloud_upload),
                              label: const Text('Upload Document'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
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
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Previously uploaded documents section
                  Text(
                    'Your Documents',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Expanded(
                    child: _uploadedDocuments.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open,
                                  size: 60,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No documents uploaded yet',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _uploadedDocuments.length,
                            itemBuilder: (context, index) {
                              final document = _uploadedDocuments[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 16,
                                  ),
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: document['color'].withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      document['icon'],
                                      color: document['color'],
                                    ),
                                  ),
                                  title: Text(
                                    document['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${document['type']} • ${document['fileSize']} • Uploaded on ${document['date']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Add delete button directly in the list
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red.shade400,
                                          size: 20,
                                        ),
                                        onPressed: () => _showDeleteConfirmation(document),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Colors.grey.shade700,
                                        ),
                                        onPressed: () => _viewDocumentDetails(document),
                                      ),
                                    ],
                                  ),
                                  onTap: () => _viewDocumentDetails(document),
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
}