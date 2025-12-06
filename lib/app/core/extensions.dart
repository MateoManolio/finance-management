import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:wise_wallet/app/data/models/expense_dao.dart';
import 'package:wise_wallet/app/data/models/tag_dao.dart';
import 'package:wise_wallet/app/data/models/category_dao.dart';
import 'package:wise_wallet/app/domain/entity/expense.dart';
import 'package:wise_wallet/app/domain/entity/tag.dart';
import 'package:wise_wallet/app/domain/entity/category.dart';

extension ToDomain on ExpenseDao {
  Expense toDomain() {
    final categoryDao = category.target;
    if (categoryDao == null) {
      throw Exception('Expense must have a category');
    }

    return Expense(
      value: value,
      note: note,
      time: time,
      tags: tags.toDomain(),
      category: categoryDao.toDomain(),
    );
  }
}

extension ToDaoExpense on Expense {
  ExpenseDao toModel() {
    final expense = ExpenseDao(
      value: value,
      note: note,
      time: time,
    );

    // Asignar categoría
    expense.category.target = category.toModel();

    // Asignar tags
    for (final tag in tags) {
      expense.tags.add(tag.toModel());
    }
    return expense;
  }
}

extension ToDaoCategory on Category {
  CategoryDao toModel() {
    return CategoryDao(
      name: name,
      iconCodePoint: icon.codePoint,
      group: group,
      color: color?.value,
    );
  }
}

extension ToDomainCategory on CategoryDao {
  Category toDomain() {
    return Category(
      name: name,
      icon: IconData(iconCodePoint, fontFamily: 'MaterialIcons'),
      group: group,
      color: color != null ? Color(color!) : null,
    );
  }
}

extension ToDaoTag on Tag {
  TagDao toModel() {
    return TagDao(
      tag: tag,
      color: color.toARGB32(),
    );
  }
}

extension ToDomainTagList on ToMany<TagDao> {
  List<Tag> toDomain() {
    var tagList = <Tag>[];
    for (final tagDao in this) {
      tagList.add(tagDao.toDomain());
    }
    return tagList;
  }
}

extension ToDomainTag on TagDao {
  Tag toDomain() {
    return Tag(
      tag: tag,
      color: Color(color),
    );
  }
}
