import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wise_wallet/app/controllers/analysis_controller.dart';
import 'package:wise_wallet/app/domain/entity/expense.dart';
import 'package:intl/intl.dart';

import 'package:flutter_animate/flutter_animate.dart';

class ExpenseSearchDelegate extends SearchDelegate {
  final AnalysisController controller = Get.find<AnalysisController>();

  @override
  String get searchFieldLabel => 'Buscar en todo el historial...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          controller.updateSearchQuery('');
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    controller.updateSearchQuery(query);
    final results = controller.globalFilteredExpenses;

    if (results.isEmpty) {
      return Center(
        child: Text(
          query.isEmpty
              ? 'Escribe algo para buscar'
              : 'No se encontraron resultados en el historial',
          style: const TextStyle(fontSize: 16),
        ).animate().fadeIn(),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final expense = results[index];
        return _buildExpenseTile(context, expense)
            .animate()
            .fadeIn(delay: (50 * index).ms)
            .slideX(begin: 0.1, curve: Curves.easeOutQuad);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    controller.updateSearchQuery(query);
    final results = controller.globalFilteredExpenses;

    if (results.isEmpty && query.isNotEmpty) {
      return const Center(child: Text('Sin coincidencias')).animate().fadeIn();
    }

    return ListView.builder(
      itemCount: results.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final expense = results[index];
        return _buildExpenseTile(context, expense)
            .animate()
            .fadeIn(delay: (30 * index).ms)
            .slideX(begin: 0.05);
      },
    );
  }

  Widget _buildExpenseTile(BuildContext context, Expense expense) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (expense.category.color ?? Colors.blue).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          expense.category.icon,
          color: expense.category.color ?? Colors.blue,
        ),
      ),
      title: Text(expense.note ?? expense.category.name),
      subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(expense.time)),
      trailing: Text(
        '\$${expense.value.toStringAsFixed(2)}',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.error,
        ),
      ),
    );
  }
}
