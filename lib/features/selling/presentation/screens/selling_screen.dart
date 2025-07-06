import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class SellingScreen extends StatefulWidget {
  @override
  _SellingScreenState createState() => _SellingScreenState();
}

class _SellingScreenState extends State<SellingScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Business Information Controllers
  final _businessNameController = TextEditingController();
  final _businessDescriptionController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _businessPhoneController = TextEditingController();
  final _businessEmailController = TextEditingController();
  final _businessWebsiteController = TextEditingController();
  
  // File upload states
  bool _licenseUploaded = false;
  bool _coverPictureUploaded = false;
  bool _faydaUploaded = false;
  
  // Business category
  String selectedCategory = 'Retail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kAccentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kAccentColor.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.store,
                      size: 48,
                      color: kAccentColor,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Join ZareShop as a Vendor',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kTextPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Start selling your products to thousands of customers',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: kTextSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              
              // Business Information Section
              _buildSectionHeader('Business Information', Icons.business),
              SizedBox(height: 16),
              
              // Business Name
              _buildTextField(
                controller: _businessNameController,
                label: 'Business Name',
                hint: 'Enter your business name',
                icon: Icons.store,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter business name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Business Category
              Text(
                'Business Category',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kTextPrimaryColor,
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: kBorderColor),
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Select business category',
                    icon: Icon(Icons.category, color: kTextLightColor),
                  ),
                  items: [
                    'Retail',
                    'Electronics',
                    'Fashion',
                    'Home & Garden',
                    'Automotive',
                    'Health & Beauty',
                    'Sports & Leisure',
                    'Books & Media',
                    'Food & Beverage',
                    'Services',
                    'Other',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(height: 16),
              
              // Business Description
              _buildTextField(
                controller: _businessDescriptionController,
                label: 'Business Description',
                hint: 'Describe your business and what you sell...',
                icon: Icons.description,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter business description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Business Address
              _buildTextField(
                controller: _businessAddressController,
                label: 'Business Address',
                hint: 'Enter your business address',
                icon: Icons.location_on,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter business address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Contact Information Section
              _buildSectionHeader('Contact Information', Icons.contact_phone),
              SizedBox(height: 16),
              
              // Business Phone
              _buildTextField(
                controller: _businessPhoneController,
                label: 'Business Phone',
                hint: 'Enter business phone number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter business phone';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Business Email
              _buildTextField(
                controller: _businessEmailController,
                label: 'Business Email',
                hint: 'Enter business email address',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter business email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Business Website (Optional)
              _buildTextField(
                controller: _businessWebsiteController,
                label: 'Business Website (Optional)',
                hint: 'Enter your website URL',
                icon: Icons.language,
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: 24),
              
              // Required Documents Section
              _buildSectionHeader('Required Documents', Icons.folder_special),
              SizedBox(height: 8),
              Text(
                'Please upload the following documents to complete your vendor registration',
                style: TextStyle(
                  fontSize: 14,
                  color: kTextSecondaryColor,
                ),
              ),
              SizedBox(height: 16),
              
              // License Upload
              _buildFileUploadCard(
                title: 'Business License',
                subtitle: 'Upload your business license or permit',
                icon: Icons.description,
                isUploaded: _licenseUploaded,
                onTap: () {
                  setState(() {
                    _licenseUploaded = !_licenseUploaded;
                  });
                },
              ),
              SizedBox(height: 12),
              
              // Cover Picture Upload
              _buildFileUploadCard(
                title: 'Business Cover Picture',
                subtitle: 'Upload a cover image for your business',
                icon: Icons.image,
                isUploaded: _coverPictureUploaded,
                onTap: () {
                  setState(() {
                    _coverPictureUploaded = !_coverPictureUploaded;
                  });
                },
              ),
              SizedBox(height: 12),
              
              // Fayda Upload
              _buildFileUploadCard(
                title: 'Fayda Image',
                subtitle: 'Upload your Fayda business image',
                icon: Icons.photo_library,
                isUploaded: _faydaUploaded,
                onTap: () {
                  setState(() {
                    _faydaUploaded = !_faydaUploaded;
                  });
                },
              ),
              SizedBox(height: 32),
              
              // Terms and Conditions
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: kBorderColor),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: kAccentColor,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'By submitting this form, you agree to our vendor terms and conditions. Your application will be reviewed within 2-3 business days.',
                        style: TextStyle(
                          fontSize: 12,
                          color: kTextSecondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && 
                        _licenseUploaded && _coverPictureUploaded && _faydaUploaded) {
                      // Handle vendor registration
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Vendor registration submitted successfully!'),
                          backgroundColor: kAccentColor,
                        ),
                      );
                    } else if (!_licenseUploaded || !_coverPictureUploaded || !_faydaUploaded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please upload all required documents'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Submit Vendor Application',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: kAccentColor,
          size: 24,
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kTextPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kTextPrimaryColor,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: kTextLightColor),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: kBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: kBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: kAccentColor),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildFileUploadCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isUploaded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUploaded ? kAccentColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isUploaded ? kAccentColor : kBorderColor,
            width: isUploaded ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isUploaded ? kAccentColor : Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                isUploaded ? Icons.check : icon,
                color: isUploaded ? Colors.white : kTextLightColor,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kTextPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: kTextSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isUploaded ? Icons.check_circle : Icons.upload_file,
              color: isUploaded ? kAccentColor : kTextLightColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessDescriptionController.dispose();
    _businessAddressController.dispose();
    _businessPhoneController.dispose();
    _businessEmailController.dispose();
    _businessWebsiteController.dispose();
    super.dispose();
  }
}
