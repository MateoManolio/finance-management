import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wise_wallet/app/controllers/profile_controller.dart';
import 'package:wise_wallet/app/domain/entity/category.dart';
import 'icon_picker_dialog.dart';

class CategoryManagementPage extends GetView<ProfileController> {
  const CategoryManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('manage_categories_title'.tr),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCategoryForm(context),
        icon: const Icon(Icons.add_rounded),
        label: Text('new_category'.tr),
      ),
      body: Obx(() {
        if (controller.isLoadingCategories.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.categories.isEmpty) {
          return Center(child: Text('no_categories'.tr));
        }

        // Filter root categories (no parent)
        final rootCategories =
            controller.categories.where((c) => c.parentId == null).toList();

        return ReorderableListView.builder(
          padding:
              const EdgeInsets.only(bottom: 100, left: 16, right: 16, top: 16),
          itemCount: rootCategories.length,
          itemBuilder: (context, index) {
            final category = rootCategories[index];
            final subcategories = controller.categories
                .where((c) => c.parentId == category.id)
                .toList();

            return Column(
              key: ValueKey(category.id ?? index),
              children: [
                _CategoryTile(
                  category: category,
                  onDelete: () => _showDeleteConfirmation(context, category),
                  onEdit: () => _showCategoryForm(context, category: category),
                ),
                if (subcategories.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Column(
                      children: subcategories
                          .map((sub) => _CategoryTile(
                                category: sub,
                                onDelete: () =>
                                    _showDeleteConfirmation(context, sub),
                                onEdit: () =>
                                    _showCategoryForm(context, category: sub),
                                isSubcategory: true,
                              ))
                          .toList(),
                    ),
                  ),
                const SizedBox(height: 8),
              ],
            );
          },
          onReorder: controller.reorderCategories,
        );
      }),
    );
  }

  void _showCategoryForm(BuildContext context, {Category? category}) {
    final nameController = TextEditingController(text: category?.name);
    final groupController = TextEditingController(text: category?.group);
    final iconData = (category?.icon ?? Icons.category_rounded).obs;
    final selectedColor = (category?.color ?? Colors.blue).obs;
    final parentId = Rx<int?>(category?.parentId);

    Get.dialog(
      AlertDialog(
        title: Text(category == null ? 'new_category'.tr : 'edit_category'.tr),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  final IconData? icon =
                      await Get.dialog<IconData>(const IconPickerDialog());
                  if (icon != null) iconData.value = icon;
                },
                child: Obx(() => Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: selectedColor.value.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: selectedColor.value.withOpacity(0.3)),
                      ),
                      child: Icon(iconData.value,
                          size: 40, color: selectedColor.value),
                    )),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'name_label'.tr),
              ),
              TextField(
                controller: groupController,
                decoration: InputDecoration(labelText: 'note_optional'.tr),
              ),
              const SizedBox(height: 16),
              if (category == null || category.parentId != null)
                Obx(() => DropdownButtonFormField<int?>(
                      initialValue: parentId.value,
                      decoration:
                          InputDecoration(labelText: 'parent_category'.tr),
                      items: [
                        DropdownMenuItem<int?>(
                            value: null, child: Text('none_root'.tr)),
                        ...controller.categories
                            .where((c) =>
                                c.parentId == null && c.id != category?.id)
                            .map((c) => DropdownMenuItem<int?>(
                                  value: c.id,
                                  child: Text(c.name),
                                )),
                      ],
                      onChanged: (val) => parentId.value = val,
                    )),
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
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final newCategory = Category(
                  id: category?.id,
                  name: nameController.text,
                  group: groupController.text.isEmpty
                      ? null
                      : groupController.text,
                  icon: iconData.value,
                  color: selectedColor.value,
                  parentId: parentId.value,
                  displayOrder:
                      category?.displayOrder ?? controller.categories.length,
                );

                if (category == null) {
                  controller.addCategory(newCategory);
                } else {
                  controller.editCategory(newCategory);
                }
                Get.back();
              }
            },
            child: Text('save_label'.tr),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Category category) {
    Get.defaultDialog(
      title: 'delete_category_title'.tr,
      middleText: 'delete_category_confirm'.trParams({'name': category.name}),
      textConfirm: 'delete'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (category.id != null) {
          controller.deleteCategory(category.id!);
        }
        Get.back();
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final Category category;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final bool isSubcategory;

  const _CategoryTile({
    required this.category,
    required this.onDelete,
    required this.onEdit,
    this.isSubcategory = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (category.color ?? theme.colorScheme.primary)
                .withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            category.icon,
            color: category.color ?? theme.colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          category.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: isSubcategory ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: category.group != null ? Text(category.group!) : null,
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
            if (!isSubcategory) const Icon(Icons.drag_handle_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}
