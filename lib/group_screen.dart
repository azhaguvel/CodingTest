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
                          // Add or remove item from the cart
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
                  // You can add more details or actions for each menu item
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
        return 3; // Number of members in Group1
      case 'Group2':
        return 5; // Number of members in Group2
      case 'Group3':
        return 7; // Number of members in Group3
      default:
        return 1; // Default multiplier if the group is not recognized
    }
  }

  // void splitBill() {
  //   if (selectedItems.isNotEmpty) {
  //     double totalAmount =
  //         selectedItems.fold(0, (sum, item) => sum + item.price);
  //
  //     double taxRate = 0.1; // 10% tax rate
  //     double quantityMultiplier = getQuantityMultiplier();
  //     totalAmount *= quantityMultiplier;
  //     double taxAmount = totalAmount * taxRate;
  //
  //     if (widget.groupName == 'Group1') {
  //       double individualShare =
  //           (totalAmount + taxAmount) / numberOfPeopleInGroup1;
  //       displayTransactionDetails(individualShare, 0, totalAmount, taxAmount);
  //     } else if (widget.groupName == 'Group2') {
  //       double discountRate = 0.1; // 10% discount rate
  //       double surchargeRate = 0.012; // 1.2% surcharge rate
  //
  //       double discountAmount = totalAmount * discountRate;
  //       double discountedTotal = totalAmount - discountAmount;
  //       double surcharge = discountedTotal * surchargeRate;
  //       double finalAmount = discountedTotal + surcharge + taxAmount;
  //
  //       displayTransactionDetails(
  //           finalAmount, discountAmount, totalAmount, taxAmount);
  //     } else if (widget.groupName == 'Group3') {
  //       double initialTab = 50;
  //       double discountAmount = 25;
  //       double discountedTotal = (initialTab + discountAmount);
  //       print('total amount${totalAmount}');
  //       print('discount amount${discountedTotal}');
  //       print('no of peepole amount${numberOfPeopleInGroup3}');
  //
  //       double finalAmount = totalAmount - discountedTotal;
  //       print('final amount${finalAmount}');
  //       double individualShare = (finalAmount) / numberOfPeopleInGroup3;
  //
  //       displayTransactionDetails(
  //           individualShare, discountAmount, discountedTotal, taxAmount);
  //     }
  //   }
  // }
  void splitBill() {
    if (selectedItems.isNotEmpty) {
      // Update the totalAmount using the selected items
      updateTotalAmount();

      double taxRate = 0.1; // 10% tax rate
      double taxAmount = totalAmount * taxRate;

      if (widget.groupName == 'Group1') {
        double individualShare =
            (totalAmount + taxAmount) / numberOfPeopleInGroup1;
        displayTransactionDetails(individualShare, 0, totalAmount, taxAmount);
      } else if (widget.groupName == 'Group2') {
        double discountRate = 0.1; // 10% discount rate
        double surchargeRate = 0.012; // 1.2% surcharge rate

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

// import 'package:flutter/material.dart';
// import 'menu_items.dart';
//
// // ...
//
// class GroupScreen extends StatefulWidget {
//   final String groupName;
//   final List<MenuItem> menuList;
//
//   GroupScreen({required this.groupName, required this.menuList});
//
//   @override
//   _GroupScreenState createState() => _GroupScreenState();
// }
//
// class _GroupScreenState extends State<GroupScreen> {
//   List<MenuItem> selectedItems = [];
//   double totalAmount = 0;
//   int numberOfPeopleInGroup1 = 3;
//   int numberOfPeopleInGroup2 = 5;
//   int numberOfPeopleInGroup3 = 7;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Menu for ${widget.groupName} Group"),
//
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: widget.menuList.length,
//               itemBuilder: (context, index) {
//                 MenuItem menuItem = widget.menuList[index];
//                 bool isSelected = selectedItems.contains(menuItem);
//
//                 return ListTile(
//                   title: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('${menuItem.name} - \$${menuItem.price.toStringAsFixed(2)}'),
//                       IconButton(
//                         icon: isSelected
//                             ? Icon(Icons.remove_shopping_cart)
//                             : Icon(Icons.add_shopping_cart),
//                         onPressed: () {
//                           // Add or remove item from the cart
//                           setState(() {
//                             if (isSelected) {
//                               selectedItems.remove(menuItem);
//                             } else {
//                               selectedItems.add(menuItem);
//                             }
//                             if(widget.groupName == 'Group1') {
//                               updateTotalAmount(numberOfPeopleInGroup1);
//                             }else if(widget.groupName == 'Group2'){
//                               updateTotalAmount(numberOfPeopleInGroup2);
//                             }else{
//                               updateTotalAmount(numberOfPeopleInGroup3);
//                             }
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                   // You can add more details or actions for each menu item
//                 );
//               },
//             ),
//           ),
//           ElevatedButton(onPressed: (){
//             splitBill();
//           }, child: Text('SplitBill')),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text('Total: \$${totalAmount.toStringAsFixed(2)}'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void updateTotalAmount(int numberOfMembers) {
//     totalAmount = selectedItems.fold(0, (sum, item) => sum + item.price);
//     totalAmount *= numberOfMembers; // Multiply by the number of members in the group
//   }
//   // void splitBill() {
//   //   // Split the total amount among individuals in Group1
//   //   if (widget.groupName == 'Group1' && selectedItems.isNotEmpty) {
//   //     double individualShare = totalAmount / numberOfPeopleInGroup1;
//   //
//   //     showDialog(
//   //       context: context,
//   //       builder: (BuildContext context) {
//   //         return AlertDialog(
//   //           title: Text('Bill Split'),
//   //           content: Column(
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             mainAxisSize: MainAxisSize.min,
//   //             children: [
//   //               Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}'),
//   //               SizedBox(height: 8),
//   //               Text('Individual Share: \$${individualShare.toStringAsFixed(2)} per person'),
//   //             ],
//   //           ),
//   //           actions: [
//   //             TextButton(
//   //               onPressed: () {
//   //                 Navigator.of(context).pop();
//   //               },
//   //               child: Text('OK'),
//   //             ),
//   //           ],
//   //         );
//   //       },
//   //     );
//   //   }
//   //   // Pay the entire bill by credit card with a 10% discount and 1.2% surcharge
//   //   else if (widget.groupName == 'Group2' && selectedItems.isNotEmpty) {
//   //     double discountAmount = totalAmount * 0.1; // 10% discount
//   //     double discountedTotal = totalAmount - discountAmount;
//   //     double surcharge = discountedTotal * 0.012; // 1.2% surcharge
//   //     double finalAmount = discountedTotal + surcharge;
//   //
//   //     showDialog(
//   //       context: context,
//   //       builder: (BuildContext context) {
//   //         return AlertDialog(
//   //           title: Text('Payment Details'),
//   //           content: Column(
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             mainAxisSize: MainAxisSize.min,
//   //             children: [
//   //               Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}'),
//   //               SizedBox(height: 8),
//   //               Text('Discount: \$${discountAmount.toStringAsFixed(2)}'),
//   //               SizedBox(height: 8),
//   //               Text('Surcharge: \$${surcharge.toStringAsFixed(2)}'),
//   //               SizedBox(height: 8),
//   //               Text('Final Amount: \$${finalAmount.toStringAsFixed(2)}'),
//   //             ],
//   //           ),
//   //           actions: [
//   //             TextButton(
//   //               onPressed: () {
//   //                 Navigator.of(context).pop();
//   //               },
//   //               child: Text('OK'),
//   //             ),
//   //           ],
//   //         );
//   //       },
//   //     );
//   //   }
//   //   // Start with a $50 tab, offer a $25 discount, and settle the bill with a split payment
//   //   else if (widget.groupName == 'Group3' && selectedItems.isNotEmpty) {
//   //     double initialTab = 50;
//   //     double discountAmount = 25;
//   //     double discountedTotal = initialTab - discountAmount;
//   //     double individualShare = discountedTotal / 7; // Split among 7 people
//   //
//   //     showDialog(
//   //       context: context,
//   //       builder: (BuildContext context) {
//   //         return AlertDialog(
//   //           title: Text('Bill Settlement'),
//   //           content: Column(
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             mainAxisSize: MainAxisSize.min,
//   //             children: [
//   //               Text('Initial Tab: \$${initialTab.toStringAsFixed(2)}'),
//   //               SizedBox(height: 8),
//   //               Text('Discount: \$${discountAmount.toStringAsFixed(2)}'),
//   //               SizedBox(height: 8),
//   //               Text('Discounted Total: \$${discountedTotal.toStringAsFixed(2)}'),
//   //               SizedBox(height: 8),
//   //               Text('Individual Share: \$${individualShare.toStringAsFixed(2)} per person'),
//   //             ],
//   //           ),
//   //           actions: [
//   //             TextButton(
//   //               onPressed: () {
//   //                 Navigator.of(context).pop();
//   //               },
//   //               child: Text('OK'),
//   //             ),
//   //           ],
//   //         );
//   //       },
//   //     );
//   //   }
//   // }
//
//   void splitBill() {
//     if (selectedItems.isNotEmpty) {
//       // Calculate total amount based on selected items
//       double totalAmount = selectedItems.fold(0, (sum, item) => sum + item.price);
//
//       // Calculate tax (you can adjust the tax rate accordingly)
//       double taxRate = 0.1; // 10% tax rate
//       double taxAmount = totalAmount * taxRate;
//
//       // Handle each group's scenario
//       if (widget.groupName == 'Group1') {
//         // Split the total amount and tax among individuals in Group1
//         double individualShare = (totalAmount + taxAmount) / numberOfPeopleInGroup1;
//         displayTransactionDetails(individualShare, 0, totalAmount, taxAmount);
//       } else if (widget.groupName == 'Group2') {
//         // Pay the entire bill by credit card with a 10% discount and 1.2% surcharge
//         double discountRate = 0.1; // 10% discount rate
//         double surchargeRate = 0.012; // 1.2% surcharge rate
//
//         double discountAmount = totalAmount * discountRate;
//         double discountedTotal = totalAmount - discountAmount;
//         double surcharge = discountedTotal * surchargeRate;
//         double finalAmount = discountedTotal + surcharge + taxAmount;
//
//         displayTransactionDetails(finalAmount, discountAmount, totalAmount, taxAmount);
//       } else if (widget.groupName == 'Group3') {
//         // Start with a $50 tab, offer a $25 discount, and settle the bill with a split payment
//         double initialTab = 50;
//         double discountAmount = 25;
//         double discountedTotal = initialTab - discountAmount;
//         double individualShare = (discountedTotal + taxAmount) / numberOfPeopleInGroup3;
//
//         displayTransactionDetails(individualShare, discountAmount, discountedTotal, taxAmount);
//       }
//     }
//   }
//
//   void displayTransactionDetails(
//       double paidAmount, double returnedAmount, double remainingAmount, double taxAmount) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Transaction Details'),
//           content: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Paid: \$${paidAmount.toStringAsFixed(2)}'),
//               SizedBox(height: 8),
//               Text('Returned: \$${returnedAmount.toStringAsFixed(2)}'),
//               SizedBox(height: 8),
//               Text('Remaining: \$${remainingAmount.toStringAsFixed(2)}'),
//               SizedBox(height: 8),
//               Text('Tax: \$${taxAmount.toStringAsFixed(2)}'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//
//
// }
