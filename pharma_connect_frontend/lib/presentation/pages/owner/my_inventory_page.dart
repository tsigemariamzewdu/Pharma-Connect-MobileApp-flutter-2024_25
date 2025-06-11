import 'package:flutter/material.dart';
import 'package:pharma_connect_flutter/domain/entities/inventory/inventory_item.dart';
import 'package:pharma_connect_flutter/domain/repositories/inventory_repository.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/local/session_manager.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/remote/inventory_api.dart';
import 'package:pharma_connect_flutter/infrastructure/repositories/inventory_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:pharma_connect_flutter/presentation/pages/owner/edit_inventory_item_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/application/notifiers/inventory_notifier.dart';

class MyInventoryPage extends ConsumerStatefulWidget {
  const MyInventoryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyInventoryPage> createState() => _MyInventoryPageState();
}

class _MyInventoryPageState extends ConsumerState<MyInventoryPage> {
  String _searchQuery = '';

  List<InventoryItem> _applySearch(String query, List<InventoryItem> items) {
    if (query.isEmpty) return items;
    final lower = query.toLowerCase();
    return items
        .where((item) => item.medicineName.toLowerCase().contains(lower))
        .toList();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  Future<void> _onDeleteItem(String pharmacyId, InventoryItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content:
            Text('Are you sure you want to delete \\${item.medicineName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await ref
            .read(inventoryProvider(pharmacyId).notifier)
            .deleteInventoryItem(item.id);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: \\${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onEditItem(InventoryItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditInventoryItemScreen(item: item),
      ),
    ).then((result) {
      if (result == true) {
        setState(() {}); // Triggers a rebuild to refresh inventory
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionManager = ref.watch(sessionManagerProvider);
    final pharmacyId = sessionManager.getPharmacyId();
    if (pharmacyId == null) {
      return const Scaffold(
        body:
            Center(child: Text('Please complete your pharmacy profile first.')),
      );
    }
    final inventoryState = ref.watch(inventoryProvider(pharmacyId));
    final notifier = ref.read(inventoryProvider(pharmacyId).notifier);
    List<InventoryItem> filteredItems = [];
    bool isLoading = false;
    String? error;
    inventoryState.when(
      loading: () {
        isLoading = true;
      },
      error: (err, _) {
        error = err.toString();
      },
      data: (items) {
        filteredItems = _applySearch(_searchQuery, items);
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.loadInventory(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search medicines in inventory',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : (error != null && error!.contains('404'))
                    ? const Center(child: Text('No medicine in inventory'))
                    : (error != null && filteredItems.isEmpty)
                        ? const Center(child: Text('No medicine in inventory'))
                        : (error != null)
                            ? Center(
                                child: Text(error!,
                                    style: const TextStyle(color: Colors.red)),
                              )
                            : filteredItems.isEmpty
                                ? const Center(
                                    child: Text('No medicine in inventory'))
                                : RefreshIndicator(
                                    onRefresh: () => notifier.loadInventory(),
                                    child: ListView.builder(
                                      padding: const EdgeInsets.all(16),
                                      itemCount: filteredItems.length,
                                      itemBuilder: (context, index) {
                                        final item = filteredItems[index];
                                        return Card(
                                          elevation: 4,
                                          margin:
                                              const EdgeInsets.only(bottom: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        if (item.category !=
                                                                null &&
                                                            item.category!
                                                                .isNotEmpty)
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 8),
                                                            child: Chip(
                                                              label: Text(item
                                                                  .category!),
                                                              backgroundColor: Theme
                                                                      .of(
                                                                          context)
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.1),
                                                            ),
                                                          ),
                                                        Text(
                                                          item.medicineName,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    PopupMenuButton<String>(
                                                      onSelected: (value) {
                                                        if (value == 'edit') {
                                                          _onEditItem(item);
                                                        } else if (value ==
                                                            'delete') {
                                                          _onDeleteItem(
                                                              pharmacyId, item);
                                                        }
                                                      },
                                                      itemBuilder: (context) =>
                                                          [
                                                        const PopupMenuItem(
                                                          value: 'edit',
                                                          child: Text('Edit'),
                                                        ),
                                                        const PopupMenuItem(
                                                          value: 'delete',
                                                          child: Text('Delete'),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                if (item.price > 0)
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.attach_money,
                                                          size: 16),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        'Price: \\${item.price.toStringAsFixed(2)}',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.inventory_2,
                                                        size: 16),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      'Quantity: \\${item.quantity}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.calendar_today,
                                                        size: 16),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      'Expiry Date: \\${DateFormat('MMM dd, yyyy').format(item.expiryDate)}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
          ),
        ],
      ),
    );
  }
}
