import 'dart:ui';

import 'package:objectbox/objectbox.dart';
import 'package:wise_wallet/app/data/models/expense_dao.dart';
import 'package:wise_wallet/app/data/models/tag_dao.dart';
import 'package:wise_wallet/app/domain/expense.dart';
import 'package:wise_wallet/app/domain/tag.dart';

extension ToDomain on ExpenseDao {
  Expense toDomain() {
    //final expenseTags = tags;
    return Expense(
      value: value,
      note: note,
      time: time,
      tags: tags.toDomain(),
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
    for (final tag in tags) {
      expense.tags.add(tag.toModel());
    }
    return expense;
  }
}

extension ToDaoTag on Tag {
  TagDao toModel() {
    return TagDao(
      tag: tag,
      color: '${color.red}-${color.green}-${color.blue}',
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
    final colorList = color.split('-');
    return Tag(
      tag: tag,
      color: Color.fromRGBO(
        int.parse(colorList[0]),
        int.parse(colorList[1]),
        int.parse(colorList[2]),
        1,
      ),
    );
  }
}
