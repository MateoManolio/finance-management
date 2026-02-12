import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wise_wallet/app/controllers/profile_controller.dart';
import 'package:wise_wallet/app/domain/entity/tag.dart';

class TagManagementPage extends GetView<ProfileController> {
  const TagManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('manage_tags_title'.tr),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTagForm(context),
        icon: const Icon(Icons.add_rounded),
        label: Text('new_tag'.tr),
      ),
      body: Obx(() {
        if (controller.isLoadingTags.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.tags.isEmpty) {
          return Center(child: Text('no_tags'.tr));
        }

        return ReorderableListView.builder(
          padding:
              const EdgeInsets.only(bottom: 100, left: 16, right: 16, top: 16),
          itemCount: controller.tags.length,
          itemBuilder: (context, index) {
            final tag = controller.tags[index];
            return _TagTile(
              key: ValueKey(tag.id ?? index),
              tag: tag,
              onDelete: () => _showDeleteConfirmation(context, tag),
              onEdit: () => _showTagForm(context, tag: tag),
            );
          },
          onReorder: controller.reorderTags,
        );
      }),
    );
  }

  void _showTagForm(BuildContext context, {Tag? tag}) {
    final nameController = TextEditingController(text: tag?.tag);
    final selectedColor = (tag?.color ?? Colors.blue).obs;

    Get.dialog(
      AlertDialog(
        title: Text(tag == null ? 'new_tag'.tr : 'edit_tag'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'name_label'.tr),
            ),
            const SizedBox(height: 16),
            Text('color_label'.tr),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Colors.red,
                  Colors.green,
                  Colors.blue,
                  Colors.yellow,
                  Colors.purple,
                  Colors.orange,
                  Colors.teal,
                  Colors.pink,
                  Colors.indigo,
                  Colors.brown,
                  Colors.blueGrey,
                  Colors.cyan
                ]
                    .map((color) => GestureDetector(
                          onTap: () => selectedColor.value = color,
                          child: Obx(() => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: selectedColor.value == color
                                      ? Border.all(
                                          color: Colors.white, width: 2)
                                      : null,
                                ),
                              )),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final newTag = Tag(
                  id: tag?.id,
                  tag: nameController.text,
                  color: selectedColor.value,
                  displayOrder: tag?.displayOrder ?? controller.tags.length,
                );

                if (tag == null) {
                  controller.addTag(newTag);
                } else {
                  controller.editTag(newTag);
                }
              }
            },
            child: Text('save_label'.tr),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Tag tag) {
    Get.defaultDialog(
      title: 'delete_tag_title'.tr,
      middleText: 'delete_tag_confirm'.trParams({'name': tag.tag}),
      textConfirm: 'delete'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (tag.id != null) {
          controller.deleteTag(tag.id!);
        }
        Get.back();
      },
    );
  }
}

class _TagTile extends StatelessWidget {
  final Tag tag;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _TagTile({
    super.key,
    required this.tag,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: tag.color,
            shape: BoxShape.circle,
          ),
        ),
        title: Text(
          tag.tag,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: onEdit,
              color: theme.colorScheme.primary,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
              onPressed: onDelete,
              color: theme.colorScheme.error,
            ),
            const Icon(Icons.drag_handle_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}
