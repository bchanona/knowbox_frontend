import 'package:flutter/material.dart';
import 'package:knowbox/features/auth/presentation/providers/auth_provider.dart';
import 'package:knowbox/features/files/domain/entities/file_entity.dart';
import 'package:knowbox/features/files/presentation/providers/files_provider.dart';
import 'package:knowbox/features/files/presentation/widgets/file_card.dart';
import 'package:knowbox/features/files/presentation/widgets/file_dialog.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadFiles();
    });
  }

  int? _getUserId() {
    final user = context.read<AuthProvider>().state.user;
    return int.tryParse(user?.id ?? '');
  }

  void _loadFiles() {
    final userId = _getUserId();
    if (userId != null) {
      context.read<FilesProvider>().loadFiles(userId);
    }
  }

  Future<void> _showAddDialog() async {
    final userId = _getUserId();
    if (userId == null) return;

    final result = await showFileDialog(context);
    if (result == null || !mounted) return;

    await context.read<FilesProvider>().createFile(
          title: result['title']!,
          description: result['description']?.isNotEmpty == true ? result['description'] : null,
          url: result['url']!,
          userId: userId,
        );

    if (mounted) _showFileFeedback();
  }

  Future<void> _showEditDialog(FileEntity file) async {
    final userId = _getUserId();
    if (userId == null) return;

    final result = await showFileDialog(
      context,
      initialTitle: file.title,
      initialDescription: file.description,
      initialUrl: file.url,
    );
    if (result == null || !mounted) return;

    await context.read<FilesProvider>().updateFile(
          id: file.id,
          title: result['title'],
          description: result['description']?.isNotEmpty == true ? result['description'] : null,
          url: result['url'],
          userId: userId,
        );

    if (mounted) _showFileFeedback();
  }

  Future<void> _confirmDelete(FileEntity file) async {
    final userId = _getUserId();
    if (userId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Delete File',
          style: TextStyle(fontFamily: 'Playfair Display', fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete "${file.title}"?',
          style: const TextStyle(fontFamily: 'Lato'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Lato', color: Theme.of(context).colorScheme.primary),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Delete', style: TextStyle(fontFamily: 'Lato')),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await context.read<FilesProvider>().deleteFile(file.id, userId);
    if (mounted) _showFileFeedback();
  }

  void _showFileFeedback() {
    final provider = context.read<FilesProvider>();
    if (provider.state.status == FilesStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.state.errorMessage ?? 'Operation failed'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Operation completed successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();
    final filesProvider = context.watch<FilesProvider>();
    final user = authProvider.state.user;
    final userId = _getUserId();
    final isLoading = filesProvider.state.status == FilesStatus.loading;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'KnowBox',
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 34,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        color: theme.colorScheme.onSurfaceVariant,
                        onPressed: () {
                          authProvider.resetState();
                          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome, ${user?.fullname ?? 'User'}!',
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Files',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: userId == null || isLoading ? null : _showAddDialog,
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text(
                          'Add File',
                          style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.w600),
                        ),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildFilesList(filesProvider, userId),
                  ),
                ],
              ),
            ),
            if (isLoading)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  color: theme.colorScheme.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilesList(FilesProvider provider, int? userId) {
    if (provider.state.status == FilesStatus.loading && provider.state.files.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.state.status == FilesStatus.error && provider.state.files.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            Text(
              provider.state.errorMessage ?? 'Something went wrong',
              style: const TextStyle(fontFamily: 'Lato'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: () {
                if (userId != null) provider.loadFiles(userId);
              },
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text('Retry', style: TextStyle(fontFamily: 'Lato')),
            ),
          ],
        ),
      );
    }

    if (provider.state.files.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.folder_open, size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text(
              'No files yet',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "Add File" to get started',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (userId != null) await provider.loadFiles(userId);
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: provider.state.files.length,
        itemBuilder: (context, index) {
          final file = provider.state.files[index];
          return FileCard(
            file: file,
            onEdit: () => _showEditDialog(file),
            onDelete: () => _confirmDelete(file),
          );
        },
      ),
    );
  }
}
