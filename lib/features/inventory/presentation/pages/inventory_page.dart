import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offs/core/di/injection.dart';
import 'package:offs/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:offs/features/inventory/domain/entities/inventory_item.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<InventoryBloc>()..add(LoadInventory()),
      child: const InventoryView(),
    );
  }
}

class InventoryView extends StatelessWidget {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: InventorySearchDelegate(
                  BlocProvider.of<InventoryBloc>(context),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          if (state.status == InventoryStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == InventoryStatus.failure) {
            return Center(child: Text(state.errorMessage ?? 'Error loading inventory'));
          } else if (state.status == InventoryStatus.success) {
            if (state.items.isEmpty) {
              return const Center(child: Text('No inventory items found'));
            }
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return InventoryItemTile(item: item);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class InventoryItemTile extends StatelessWidget {
  final InventoryItem item;

  const InventoryItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text('SKU: ${item.sku} | Location: ${item.location ?? "N/A"}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              if (item.quantity > 0) {
                context.read<InventoryBloc>().add(
                      UpdateInventoryQuantity(item.id, item.quantity - 1),
                    );
              }
            },
          ),
          Text(
            '${item.quantity}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.read<InventoryBloc>().add(
                    UpdateInventoryQuantity(item.id, item.quantity + 1),
                  );
            },
          ),
        ],
      ),
    );
  }
}

class InventorySearchDelegate extends SearchDelegate {
  final InventoryBloc inventoryBloc;

  InventorySearchDelegate(this.inventoryBloc);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          inventoryBloc.add(LoadInventory());
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
    inventoryBloc.add(SearchInventoryEvent(query));
    return BlocProvider.value(
      value: inventoryBloc,
      child: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          if (state.status == InventoryStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == InventoryStatus.success) {
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return InventoryItemTile(item: item);
              },
            );
          } else if (state.status == InventoryStatus.failure) {
             return Center(child: Text(state.errorMessage ?? 'Error'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
