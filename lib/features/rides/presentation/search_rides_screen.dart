import 'package:flutter/material.dart';

class SearchRidesScreen extends StatefulWidget {
  const SearchRidesScreen({super.key});

  @override
  State<SearchRidesScreen> createState() => _SearchRidesScreenState();
}

class _SearchRidesScreenState extends State<SearchRidesScreen> {
  final _formKey = GlobalKey<FormState>();

  final _startController = TextEditingController();
  final _destinationController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _startController.dispose();
    _destinationController.dispose();
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

  void _searchRides() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Odaberi datum i vrijeme polaska.',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tražimo vožnje: '
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
                'Pronađi vožnju',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Unesi svoju rutu i pronađi najbolje vozače u blizini.',
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
                  prefixIcon: Icon(
                    Icons.trip_origin,
                  ),
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
                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                  ),
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
              Row(
                children: [
                  Expanded(
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _selectTime,
                      icon: const Icon(
                        Icons.schedule,
                      ),
                      label: Text(
                        _selectedTime == null
                            ? 'Odaberi vrijeme'
                            : _selectedTime!.format(context),
                      ),
                    ),
                  ),
                ],
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
                    Icon(
                      Icons.auto_awesome_outlined,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Go2Work će usporediti rutu, vrijeme polaska '
                        'i odstupanje vozača kako bi ti predložio '
                        'najbolje vožnje.',
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
                  onPressed: _searchRides,
                  icon: const Icon(
                    Icons.search,
                  ),
                  label: const Text(
                    'Pronađi vožnju',
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