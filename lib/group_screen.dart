import 'package:flutter/material.dart';
import 'menu_items.dart';

class GroupScreen extends StatefulWidget {
  final String groupName;
  final List<MenuItem> menuList;

  GroupScreen({required this.groupName, required this.menuList});

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  List<MenuItem> selectedItems = [];
  double totalAmount = 0;
  int numberOfPeopleInGroup1 = 3;
  int numberOfPeopleInGroup2 = 5;
  int numberOfPeopleInGroup3 = 7;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedItems = List.of(widget.menuList);
    updateTotalAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu for ${widget.groupName} Group"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.menuList.length,
              itemBuilder: (context, index) {
                MenuItem menuItem = widget.menuList[index];
                bool isSelected = selectedItems.contains(menuItem);

                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          '${menuItem.name} - \$${menuItem.price.toStringAsFixed(2)}'),
                      IconButton(
                        icon: isSelected
                            ? Icon(Icons.remove_shopping_cart)
                            : Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          setState(() {
                            if (isSelected) {
                              selectedItems.remove(menuItem);
                            } else {
                              selectedItems.add(menuItem);
                            }
                            updateTotalAmount();
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total: \$${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              splitBill();
            },
            child: Text('Generate The Invoice'),
          ),
        ],
      ),
    );
  }

  void updateTotalAmount() {
    double multiplier = getQuantityMultiplier();
    totalAmount = selectedItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    setState(() {
      totalAmount = totalAmount * multiplier;
    });
  }

  double getQuantityMultiplier() {
    switch (widget.groupName) {
      case 'Group1':
        return 3;
      case 'Group2':
        return 5;
      case 'Group3':
        return 7;
      default:
        return 1;
    }
  }

  void splitBill() {
    if (selectedItems.isNotEmpty) {
      updateTotalAmount();

      double taxRate = 0.1;
      double taxAmount = totalAmount * taxRate;

      if (widget.groupName == 'Group1') {
        double individualShare =
            (totalAmount + taxAmount) / numberOfPeopleInGroup1;
        displayTransactionDetails(individualShare, 0, totalAmount, taxAmount);
      } else if (widget.groupName == 'Group2') {
        double discountRate = 0.1;
        double surchargeRate = 0.012;

        double discountAmount = totalAmount * discountRate;
        double discountedTotal = totalAmount - discountAmount;
        double surcharge = discountedTotal * surchargeRate;
        double finalAmount = discountedTotal + surcharge + taxAmount;

        displayTransactionDetails(
            finalAmount, discountAmount, totalAmount, taxAmount);
      } else if (widget.groupName == 'Group3') {
        double initialTab = 50;
        double discountAmount = 25;
        double discountedTotal = (initialTab + discountAmount);

        double finalAmount = totalAmount - discountedTotal;
        double individualShare = (finalAmount) / numberOfPeopleInGroup3;

        displayTransactionDetails(
            individualShare, discountAmount, discountedTotal, taxAmount);
      }
    }
  }

  void displayTransactionDetails(double paidAmount, double returnedAmount,
      double remainingAmount, double taxAmount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Transaction Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.groupName == 'Group1')
                Text('Individuals Pay: \$${paidAmount.toStringAsFixed(2)}')
              else
                Text('Pay: \$${paidAmount.toStringAsFixed(2)}'),
              SizedBox(height: 8),
              Text('Returned: \$${returnedAmount.toStringAsFixed(2)}'),
              SizedBox(height: 8),
              Text('Remaining: \$${remainingAmount.toStringAsFixed(2)}'),
              SizedBox(height: 8),
              Text('Tax: \$${taxAmount.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
