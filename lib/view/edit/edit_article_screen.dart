import 'package:flutter/material.dart';
import 'package:wartaapps/models/news_model.dart';
import 'package:wartaapps/services/news_service.dart';

class EditArticlePage extends StatefulWidget {
  const EditArticlePage({super.key});

  @override
  State<EditArticlePage> createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {
  final NewsService _newsService = NewsService();
  final _formKey = GlobalKey<FormState>();
  late News _originalArticle;
  bool _isLoading = false;
  bool _isPublished = false;
  bool _initialized = false;

  late TextEditingController _titleController;
  late TextEditingController _summaryController;
  late TextEditingController _contentController;
  late TextEditingController _categoryController;
  late TextEditingController _tagsController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _summaryController = TextEditingController();
    _contentController = TextEditingController();
    _categoryController = TextEditingController();
    _tagsController = TextEditingController();
    _imageUrlController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)!.settings.arguments as News;
      _originalArticle = args;
      _isPublished = _originalArticle.isPublished;

      _titleController.text = _originalArticle.title;
      _summaryController.text = _originalArticle.summary ?? '';
      _contentController.text = _originalArticle.content ?? '';
      _categoryController.text = _originalArticle.category ?? '';
      _tagsController.text = _originalArticle.tags.join(', ');
      _imageUrlController.text = _originalArticle.featuredImageUrl ?? '';

      _initialized = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    _tagsController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedArticle = UpdateNewsRequest(
        title: _titleController.text,
        summary: _summaryController.text,
        content: _contentController.text,
        featuredImageUrl:
            _imageUrlController.text.isNotEmpty
                ? _imageUrlController.text
                : null,
        category: _categoryController.text,
        tags: _tagsController.text.split(',').map((e) => e.trim()).toList(),
        isPublished: _isPublished,
      );

      await _newsService.updateNews(_originalArticle.id, updatedArticle);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Article updated successfully'),
            backgroundColor: Colors.green[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update article: ${e.toString()}'),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF2B4D8C)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edit Article',
          style: TextStyle(
            color: Color(0xFF2B4D8C),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2B4D8C)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Color(0xFF2B4D8C)),
            onPressed: _isLoading ? null : _submitForm,
            tooltip: 'Save changes',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  title: const Text(
                    'Publish Article',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  value: _isPublished,
                  activeColor: const Color(0xFF2B4D8C),
                  onChanged:
                      _isLoading
                          ? null
                          : (value) => setState(() => _isPublished = value),
                ),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2B4D8C)),
                  ),
                ),
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _summaryController,
                decoration: InputDecoration(
                  labelText: 'Summary',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2B4D8C)),
                  ),
                ),
                maxLines: 3,
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a summary';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2B4D8C)),
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _tagsController,
                decoration: InputDecoration(
                  labelText: 'Tags (comma separated)',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2B4D8C)),
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Featured Image URL',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2B4D8C)),
                  ),
                ),
                keyboardType: TextInputType.url,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              if (_imageUrlController.text.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Image Preview',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[100],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _imageUrlController.text,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      size: 40,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Invalid image URL',
                                      style: TextStyle(color: Colors.grey[500]),
                                    ),
                                  ],
                                ),
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2B4D8C)),
                  ),
                ),
                maxLines: 10,
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B4D8C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _submitForm,
                  child:
                      _isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
