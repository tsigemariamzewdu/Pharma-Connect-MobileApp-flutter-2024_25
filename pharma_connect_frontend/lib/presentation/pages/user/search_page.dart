import 'package:flutter/material.dart';
import 'package:pharma_connect_flutter/presentation/pages/user/pharmacy_detail_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/application/notifiers/cart_notifier.dart';
import 'package:pharma_connect_flutter/application/notifiers/medicine_notifier.dart';
import 'package:pharma_connect_flutter/domain/entities/medicine/medicine.dart';
import 'package:pharma_connect_flutter/domain/entities/cart/cart_item.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  String _query = '';
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() => _query = query);
    if (query.isNotEmpty) {
      ref.read(medicineSearchProvider.notifier).searchMedicines(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(medicineSearchProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Search for Medicine',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            onSubmitted: _onSearch,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      ['All', 'Low to High', 'High to Low'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    // TODO: Implement price filter logic
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  items: ['All', 'Nearby', 'Specific Location']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    // TODO: Implement location filter logic
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_query.isNotEmpty)
            Text(
              'Results for: $_query',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 16),
          Expanded(
            child: Builder(
              builder: (context) {
                return searchState.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text(err.toString())),
                  data: (results) => results.isEmpty && _query.isNotEmpty
                      ? const Center(child: Text('No results found.'))
                      : ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final medicine = results[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: medicine.photo.isNotEmpty
                                          ? Image.network(
                                              medicine.photo,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                  Icons.local_pharmacy,
                                                  size: 32,
                                                  color: Colors.grey),
                                            ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            medicine.pharmacyName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            medicine.address,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PharmacyDetailPage(
                                                              pharmacyId: medicine
                                                                  .pharmacyId),
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                  'See pharmacy detail',
                                                  style: TextStyle(
                                                      color: Colors.deepPurple),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Price: Br ${medicine.price.toStringAsFixed(0)}',
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Quantity: ${medicine.quantity}',
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.add_shopping_cart,
                                              size: 28),
                                          onPressed: () {
                                            final cartItem = CartItem(
                                              pharmacyName:
                                                  medicine.pharmacyName,
                                              inventoryId: medicine.inventoryId,
                                              address: medicine.address,
                                              photo: medicine.photo,
                                              price: medicine.price,
                                              quantity: 1,
                                              latitude: medicine.latitude,
                                              longitude: medicine.longitude,
                                              pharmacyId: medicine.pharmacyId,
                                              medicineId:
                                                  '', // Not available in search result
                                              medicineName: _query,
                                            );
                                            cartNotifier.addItem(cartItem);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
