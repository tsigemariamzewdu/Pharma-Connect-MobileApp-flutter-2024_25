import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/application/notifiers/cart_notifier.dart';
import 'package:pharma_connect_flutter/domain/entities/cart/cart_item.dart';
import 'package:pharma_connect_flutter/presentation/widgets/loading_indicator.dart';
import 'package:pharma_connect_flutter/presentation/widgets/error_dialog.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);
    ref.listen<AsyncValue<List<CartItem>>>(cartProvider, (prev, next) {
      next.whenOrNull(
        error: (err, _) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(message: err.toString()),
          );
        },
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await notifier.clearCart();
            },
          ),
        ],
      ),
      body: cartState.when(
        loading: () => const Center(child: LoadingIndicator()),
        data: (items) => items.isEmpty
            ? const Center(child: Text('Your cart is empty'))
            : CartItemsList(items: items, notifier: notifier),
        error: (err, _) => Center(child: Text(err.toString())),
      ),
    );
  }
}

class CartItemsList extends StatelessWidget {
  const CartItemsList({
    Key? key,
    required this.items,
    required this.notifier,
  }) : super(key: key);

  final List<CartItem> items;
  final CartNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return CartItemTile(item: item, notifier: notifier);
            },
          ),
        ),
        CartSummary(items: items),
      ],
    );
  }
}

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    Key? key,
    required this.item,
    required this.notifier,
  }) : super(key: key);

  final CartItem item;
  final CartNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: item.photo.isNotEmpty
            ? Image.network(
                item.photo,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.medication),
        title: Text(item.medicineName),
        subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                if (item.quantity > 1) {
                  notifier.addItem(
                    item.copyWith(quantity: item.quantity - 1),
                  );
                }
              },
            ),
            Text(item.quantity.toString()),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                notifier.addItem(
                  item.copyWith(quantity: item.quantity + 1),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                notifier.removeItem(item.medicineId);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CartSummary extends StatelessWidget {
  const CartSummary({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<CartItem> items;

  @override
  Widget build(BuildContext context) {
    final total = items.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implement checkout logic if needed
                },
                child: const Text('Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
