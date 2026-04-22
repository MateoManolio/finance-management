import 'package:flutter/material.dart';
import 'package:wise_wallet/app/data/models/expense_dao.dart';
import 'package:wise_wallet/app/data/models/category_dao.dart';
import 'package:wise_wallet/app/data/models/tag_dao.dart';
import 'package:wise_wallet/app/domain/entity/expense.dart';
import 'package:wise_wallet/app/domain/entity/category.dart';
import 'package:wise_wallet/app/domain/entity/tag.dart';
import 'package:wise_wallet/app/data/mappers/credit_card_mapper.dart';

/// Mapper for converting between Expense domain model and ExpenseDao data model
/// Following Clean Architecture separation of concerns
class ExpenseMapper {
  /// Converts ExpenseDao to Expense domain model
  static Expense toDomain(ExpenseDao dao) {
    return Expense(
      id: dao.id,
      value: dao.value,
      note: dao.note,
      time: dao.time,
      tags: dao.tags.map((tagDao) => TagMapper.toDomain(tagDao)).toList(),
      category: dao.category.target != null
          ? CategoryMapper.toDomain(dao.category.target!)
          : Category(
              name: 'Sin Categoría',
              icon: Icons.help_outline_rounded,
              color: Colors.grey,
              displayOrder: 999),
      card: dao.card.target != null
          ? CreditCardMapper.toEntity(dao.card.target!)
          : null,
    );
  }

  /// Converts Expense domain model to ExpenseDao
  static ExpenseDao toDao(Expense expense) {
    final dao = ExpenseDao(
      value: expense.value,
      note: expense.note,
      time: expense.time,
    );
    dao.id = expense.id;
    return dao;
  }

  /// Updates an existing ExpenseDao with values from Expense domain model
  /// This is useful for update operations
  static void updateDao(ExpenseDao dao, Expense expense) {
    // Note: ObjectBox doesn't allow updating final fields directly if standard Dao approach
    // But since our Dao fields are final in the class definition (except id, tags, category relations)
    // Actually, ObjectBox entities usually shouldn't have final fields if you want to update them easily
    // via put(), OR you just create a new object with the same ID.
    // However, relation targets are mutable.

    // For relations:
    dao.category.target = CategoryMapper.toDao(expense.category);
    dao.tags.clear();
    dao.tags.addAll(
      expense.tags.map((tag) => TagMapper.toDao(tag)).toList(),
    );
    if (expense.card != null) {
      dao.card.target = CreditCardMapper.toDao(expense.card!);
    } else {
      dao.card.target = null;
    }
  }
}

/// Mapper for converting between Category domain model and CategoryDao data model
class CategoryMapper {
  /// Converts CategoryDao to Category domain model
  static Category toDomain(CategoryDao dao) {
    return Category(
      id: dao.id,
      name: dao.name,
      icon: IconData(dao.iconCodePoint, fontFamily: 'MaterialIcons'),
      group: dao.group,
      color: dao.color != null ? Color(dao.color!) : null,
      parentId: dao.parentId,
      displayOrder: dao.displayOrder,
    );
  }

  /// Converts Category domain model to CategoryDao
  static CategoryDao toDao(Category category) {
    final dao = CategoryDao(
      name: category.name,
      iconCodePoint: category.icon.codePoint,
      group: category.group,
      color: category.color?.value,
      parentId: category.parentId,
      displayOrder: category.displayOrder,
    );
    if (category.id != null) {
      dao.id = category.id!;
    }
    return dao;
  }
}

/// Mapper for converting between Tag domain model and TagDao data model
class TagMapper {
  /// Converts TagDao to Tag domain model
  static Tag toDomain(TagDao dao) {
    return Tag(
      id: dao.id,
      tag: dao.tag,
      color: Color(dao.color),
      displayOrder: dao.displayOrder,
    );
  }

  /// Converts Tag domain model to TagDao
  static TagDao toDao(Tag tag) {
    final dao = TagDao(
      tag: tag.tag,
      color: tag.color.value,
      displayOrder: tag.displayOrder,
    );
    if (tag.id != null) {
      dao.id = tag.id!;
    }
    return dao;
  }
}
