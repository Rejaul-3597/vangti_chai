import 'dart:math';

import 'package:flutter/material.dart';

import 'sizes.dart';

// Taka notes, largest first.
const List<int> kNotes = [500, 100, 50, 20, 10, 5, 2, 1];

// Longest amount that can be typed (keeps the numbers safe and readable).
const int kMaxDigits = 9;

const String kClearLabel = 'CLEAR';

void main() => runApp(const VangtiChaiApp());

class VangtiChaiApp extends StatelessWidget {
  const VangtiChaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VangtiChai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const VangtiChaiScreen(),
    );
  }
}

/// One key on the keypad. [flex] lets CLEAR be wider than a digit.
class _Key {
  const _Key(this.label, [this.flex = 1]);
  final String label;
  final int flex;
}

// Portrait keypad: 3 columns.
const List<List<_Key>> _portraitKeys = [
  [_Key('1'), _Key('2'), _Key('3')],
  [_Key('4'), _Key('5'), _Key('6')],
  [_Key('7'), _Key('8'), _Key('9')],
  [_Key('0'), _Key(kClearLabel, 2)],
];

// Landscape keypad: 4 columns.
const List<List<_Key>> _landscapeKeys = [
  [_Key('1'), _Key('2'), _Key('3'), _Key('4')],
  [_Key('5'), _Key('6'), _Key('7'), _Key('8')],
  [_Key('9'), _Key('0'), _Key(kClearLabel, 2)],
];

class VangtiChaiScreen extends StatefulWidget {
  const VangtiChaiScreen({super.key});

  @override
  State<VangtiChaiScreen> createState() => _VangtiChaiScreenState();
}

class _VangtiChaiScreenState extends State<VangtiChaiScreen> {
  // The state lives here. Flutter keeps this State object when the phone
  // rotates, so the amount and change list survive a rotation.
  String _amount = '';

  void _onDigit(String digit) {
    setState(() {
      if (_amount == '0') {
        _amount = digit;
      } else if (_amount.length < kMaxDigits) {
        _amount += digit;
      }
    });
  }

  void _onClear() => setState(() => _amount = '');

  /// Greedy change: how many of each note, in the order of [kNotes].
  List<int> _changeFor(int amount) {
    var rest = amount;
    final counts = <int>[];
    for (final note in kNotes) {
      counts.add(rest ~/ note);
      rest %= note;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes.of(context);
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final counts = _changeFor(_amount.isEmpty ? 0 : int.parse(_amount));
    final bodyMaxHeight =
        isLandscape ? sizes.landscapeBodyHeight : sizes.portraitBodyHeight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('VangtiChai'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(sizes.pagePadding),
          child: Column(
            children: [
              Text(
                'Taka: $_amount',
                style: TextStyle(fontSize: sizes.amountFont),
              ),
              SizedBox(height: sizes.sectionGap),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final height = min(constraints.maxHeight, bodyMaxHeight);
                    return Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: height,
                        child: isLandscape
                            ? _buildLandscape(sizes, counts)
                            : _buildPortrait(sizes, counts),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Portrait: one note column on the left, 3-column keypad on the right.
  Widget _buildPortrait(AppSizes sizes, List<int> counts) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _NotesColumn(
            indices: const [0, 1, 2, 3, 4, 5, 6, 7],
            counts: counts,
            sizes: sizes,
          ),
        ),
        Expanded(
          flex: 3,
          child: _Keypad(
            rows: _portraitKeys,
            sizes: sizes,
            onDigit: _onDigit,
            onClear: _onClear,
          ),
        ),
      ],
    );
  }

  // Landscape: two note columns on the left, 4-column keypad on the right.
  Widget _buildLandscape(AppSizes sizes, List<int> counts) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _NotesColumn(
                  indices: const [0, 1, 2, 3],
                  counts: counts,
                  sizes: sizes,
                ),
              ),
              Expanded(
                child: _NotesColumn(
                  indices: const [4, 5, 6, 7],
                  counts: counts,
                  sizes: sizes,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _Keypad(
            rows: _landscapeKeys,
            sizes: sizes,
            onDigit: _onDigit,
            onClear: _onClear,
          ),
        ),
      ],
    );
  }
}

/// A column of "note: count" lines, e.g. "500: 1".
class _NotesColumn extends StatelessWidget {
  const _NotesColumn({
    required this.indices,
    required this.counts,
    required this.sizes,
  });

  final List<int> indices;
  final List<int> counts;
  final AppSizes sizes;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final i in indices)
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '${kNotes[i]}: ${counts[i]}',
              style: TextStyle(fontSize: sizes.noteFont),
            ),
          ),
      ],
    );
  }
}

/// A keypad built from rows of buttons. Every row and key shares the space
/// equally, so it fits any screen size.
class _Keypad extends StatelessWidget {
  const _Keypad({
    required this.rows,
    required this.sizes,
    required this.onDigit,
    required this.onClear,
  });

  final List<List<_Key>> rows;
  final AppSizes sizes;
  final void Function(String digit) onDigit;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final row in rows)
          Expanded(
            child: Row(
              children: [
                for (final key in row)
                  Expanded(
                    flex: key.flex,
                    child: Padding(
                      padding: EdgeInsets.all(sizes.keySpacing),
                      child: SizedBox.expand(
                        child: ElevatedButton(
                          onPressed: key.label == kClearLabel
                              ? onClear
                              : () => onDigit(key.label),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(sizes.keyRadius),
                            ),
                          ),
                          child: Text(
                            key.label,
                            style: TextStyle(fontSize: sizes.keyFont),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
