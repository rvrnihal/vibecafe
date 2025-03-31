import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final List<Map<String, String>> paymentOptions = [
    {'method': 'Credit Card', 'icon': 'images/credit_card.png'},
    {'method': 'Debit Card', 'icon': 'images/debit_card.png'},
    {'method': 'UPI', 'icon': 'images/upi.png'},
    {'method': 'Net Banking', 'icon': 'images/net_banking.png'},
    {'method': 'Cash on Delivery', 'icon': 'images/cash_on_delivery.png'},
  ];//payment methods

  final List<String> banks = ['HDFC Bank', 'ICICI Bank', 'SBI', 'Axis Bank', 'Kotak Bank'];//netbanking 

  String? selectedPaymentMethod;
  String? selectedBank;

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderNameController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List<Map<String, String>>?;
    final items = args ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
         backgroundColor: const Color.fromARGB(230, 142, 173, 69),
      ),//appbar
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (items.isNotEmpty)
                      Column(
                        children: items.map((item) => ListTile(
                              leading: Image.asset(
                                item['image'] ?? '',
                                width: 50,
                                height: 50,
                                errorBuilder: (_, __, ___) => const Icon(Icons.image),
                              ),
                              title: Text(item['text'] ?? 'Unknown Item'),
                            )).toList(),
                      )//details of food item
                    else
                      const Text('No items in cart', style: TextStyle(fontSize: 18, color: Colors.red)),

                    const Divider(),
                    const SizedBox(height: 10),
                    _buildAddressField(),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Select Payment Method',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),//Select Payment Method

                    ...paymentOptions.map((option) => RadioListTile<String>(
                          value: option['method']!,
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              selectedPaymentMethod = value;
                            });
                          },
                          title: Row(
                            children: [
                              Image.asset(
                                option['icon']!,
                                width: 30,
                                height: 30,
                                errorBuilder: (_, __, ___) => const Icon(Icons.payment),
                              ),
                              const SizedBox(width: 10),
                              Text(option['method']!),
                            ],
                          ),
                        )),
                    
                    if (selectedPaymentMethod == 'Credit Card' || selectedPaymentMethod == 'Debit Card')
                      _buildCardDetailsForm(),

                    if (selectedPaymentMethod == 'UPI')
                      _buildUpiIdField(),

                    if (selectedPaymentMethod == 'Net Banking')
                      _buildNetBankingDropdown(),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _canProceedToPayment() ? _processPayment : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: const Text('Complete Payment', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // address input field
  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: const InputDecoration(labelText: 'Delivery Address', border: OutlineInputBorder()),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Enter your delivery address';
        return null;
      },
    );
  }

  // card details form
  Widget _buildCardDetailsForm() {
    return Column(
      children: [
        TextFormField(
          controller: _cardNumberController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Card Number'),
          validator: (value) {
            if (value == null || value.length < 16) return 'Enter a valid card number';
            return null;
          },
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryDateController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter expiry date';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _cvvController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'CVV'),
                validator: (value) {
                  if (value == null || value.length != 3) return 'Enter valid CVV';
                  return null;
                },
              ),
            ),
          ],
        ),
        TextFormField(
          controller: _cardHolderNameController,
          decoration: const InputDecoration(labelText: 'Card Holder Name'),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Enter card holder name';
            return null;
          },
        ),
      ],
    );
  }

  // UPI ID input field
  Widget _buildUpiIdField() {
    return TextFormField(
      controller: _upiIdController,
      decoration: const InputDecoration(labelText: 'Enter UPI ID'),
      validator: (value) {
        if (value == null || !value.contains('@')) return 'Enter a valid UPI ID';
        return null;
      },
    );
  }

  // Net Banking dropdown
  Widget _buildNetBankingDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Select Bank'),
      value: selectedBank,
      items: banks.map((bank) => DropdownMenuItem(value: bank, child: Text(bank))).toList(),
      onChanged: (value) {
        setState(() {
          selectedBank = value;
        });
      },
      validator: (value) {
        if (value == null) return 'Please select a bank';
        return null;
      },
    );
  }

  /// check payment can be completed
  bool _canProceedToPayment() {
    if (selectedPaymentMethod == null || _addressController.text.isEmpty) return false;

    if (selectedPaymentMethod == 'Credit Card' || selectedPaymentMethod == 'Debit Card') {
      return _formKey.currentState?.validate() ?? false;
    }

    if (selectedPaymentMethod == 'UPI') {
      return _upiIdController.text.contains('@');
    }

    if (selectedPaymentMethod == 'Net Banking') {
      return selectedBank != null;
    }

    return true;
  }

  //Processes the payment
  void _processPayment() {
    if (!_canProceedToPayment()) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Successful'),
        content: Text('Your order has been placed successfully using $selectedPaymentMethod!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
