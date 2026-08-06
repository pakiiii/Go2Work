import 'package:flutter/material.dart';

class PublishRideScreen extends StatefulWidget {
  const PublishRideScreen({super.key});

  @override
  State<PublishRideScreen> createState() => _PublishRideScreenState();
}

class _PublishRideScreenState extends State<PublishRideScreen> {
  final _formKey = GlobalKey<FormState>();

  final _startController = TextEditingController();
  final _destinationController = TextEditingController();
  final _priceController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  int _availableSeats = 1;
  bool _isRecurring = false;

  final List<bool> _selectedDays = List<bool>.filled(7, false);

  static const List<String> _dayLabels = [
    'Pon',
    'Uto',
    'Sri',
    'Čet',
    'Pet',
    'Sub',
    'Ned',
  ];

  @override
  void dispose() {
    _startController.dispose();
    _destinationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _selectedTime = selectedTime;
      });
    }
  }

  void _decreaseSeats() {
    if (_availableSeats <= 1) {
      return;
    }

    setState(() {
      _availableSeats--;
    });
  }

  void _increaseSeats() {
    if (_availableSeats >= 8) {
      return;
    }

    setState(() {
      _availableSeats++;
    });
  }

  void _publishRide() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Odaberi vrijeme polaska.'),
        ),
      );
      return;
    }

    if (!_isRecurring && _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Odaberi datum vožnje.'),
        ),
      );
      return;
    }

    if (_isRecurring && !_selectedDays.contains(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Odaberi barem jedan dan ponavljanja.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Vožnja je spremna za objavu: '
          '${_startController.text} → '
          '${_destinationController.text}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Objavi vožnju',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ponudi slobodna mjesta putnicima koji idu u istom smjeru.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              TextFormField(
                controller: _startController,
                decoration: const InputDecoration(
                  labelText: 'Polazište',
                  hintText: 'Primjer: Sesvete',
                  prefixIcon: Icon(Icons.trip_origin),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Unesi polazište.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _destinationController,
                decoration: const InputDecoration(
                  labelText: 'Odredište',
                  hintText: 'Primjer: Radnička cesta',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Unesi odredište.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Ponavljajuća vožnja',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  'Primjer: svaki radni dan u isto vrijeme',
                ),
                value: _isRecurring,
                onChanged: (value) {
                  setState(() {
                    _isRecurring = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              if (!_isRecurring)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _selectDate,
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                    ),
                    label: Text(
                      _selectedDate == null
                          ? 'Odaberi datum'
                          : '${_selectedDate!.day}.'
                              '${_selectedDate!.month}.'
                              '${_selectedDate!.year}.',
                    ),
                  ),
                ),
              if (_isRecurring) ...[
                const Text(
                  'Odaberi dane',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    _dayLabels.length,
                    (index) {
                      return FilterChip(
                        label: Text(_dayLabels[index]),
                        selected: _selectedDays[index],
                        onSelected: (selected) {
                          setState(() {
                            _selectedDays[index] = selected;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _selectTime,
                  icon: const Icon(Icons.schedule),
                  label: Text(
                    _selectedTime == null
                        ? 'Odaberi vrijeme'
                        : _selectedTime!.format(context),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Slobodna mjesta',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Koliko putnika možeš povesti?',
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _decreaseSeats,
                      icon: const Icon(
                        Icons.remove_circle_outline,
                      ),
                    ),
                    Text(
                      '$_availableSeats',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: _increaseSeats,
                      icon: const Icon(
                        Icons.add_circle_outline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Cijena po putniku',
                  hintText: 'Primjer: 2.50',
                  prefixIcon: Icon(Icons.euro),
                  suffixText: 'EUR',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Unesi cijenu.';
                  }

                  final normalizedValue = value.replaceAll(',', '.');
                  final price = double.tryParse(normalizedValue);

                  if (price == null || price < 0) {
                    return 'Unesi ispravnu cijenu.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.auto_awesome_outlined),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Nakon objave Go2Work će ti predložiti putnike '
                        'čija ruta i vrijeme najbolje odgovaraju tvojoj vožnji.',
                        style: TextStyle(
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton.icon(
                  onPressed: _publishRide,
                  icon: const Icon(Icons.add_road),
                  label: const Text(
                    'Objavi vožnju',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}