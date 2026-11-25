import 'dart:math';
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Expression evaluator with operator precedence (× ÷ before + −)
// ---------------------------------------------------------------------------

/// Tokenises and evaluates a flat infix expression like "50000 × 2 + 25000".
/// Supports: + − × ÷, integer and decimal operands, negative numbers.
/// Returns null on division-by-zero (caller shows user-friendly error message).
double? _evaluate(String expr) {
  final String clean = expr.replaceAll('=', '').trim();
  if (clean.isEmpty) return 0;

  // Split tokens by whitespace first (our calculator always pads operators with spaces)
  final List<String> rawTokens = clean.split(RegExp(r'\s+'));
  final List<double> nums = [];
  final List<String> ops = [];

  for (final t in rawTokens) {
    if (t == '+' ||
        t == '−' ||
        t == '-' ||
        t == '×' ||
        t == '÷' ||
        t == '*' ||
        t == '/') {
      ops.add(t == '-' ? '−' : (t == '*' ? '×' : (t == '/' ? '÷' : t)));
    } else {
      final double? parsed = double.tryParse(t);
      if (parsed != null) {
        nums.add(parsed);
      }
    }
  }

  // Fallback regex tokenizer if space-split yielded only 1 token (e.g. raw "5+5")
  if (ops.isEmpty && nums.length <= 1) {
    final RegExp tokenRe = RegExp(r'(-?\d+\.?\d*|[+\−×÷\-\*\/])');
    final matches = tokenRe.allMatches(clean).map((m) => m.group(0)!).toList();
    nums.clear();
    ops.clear();
    for (final m in matches) {
      if (m == '+' ||
          m == '−' ||
          m == '-' ||
          m == '×' ||
          m == '÷' ||
          m == '*' ||
          m == '/') {
        ops.add(m == '-' ? '−' : (m == '*' ? '×' : (m == '/' ? '÷' : m)));
      } else {
        final double? parsed = double.tryParse(m);
        if (parsed != null) nums.add(parsed);
      }
    }
  }

  if (nums.isEmpty) return 0;
  if (nums.length == 1) return nums[0];

  // Pass 1: Multiply (×) and Divide (÷) — higher precedence
  int i = 0;
  while (i < ops.length) {
    if (ops[i] == '×' || ops[i] == '÷') {
      if (i + 1 >= nums.length) break;
      final double a = nums[i];
      final double b = nums[i + 1];
      if (ops[i] == '÷') {
        if (b == 0) return null; // Division by zero guard
        nums[i] = a / b;
      } else {
        nums[i] = a * b;
      }
      nums.removeAt(i + 1);
      ops.removeAt(i);
    } else {
      i++;
    }
  }

  // Pass 2: Add (+) and Subtract (−) — left-to-right
  double total = nums[0];
  for (int j = 0; j < ops.length; j++) {
    if (j + 1 >= nums.length) break;
    if (ops[j] == '+') {
      total += nums[j + 1];
    } else {
      total -= nums[j + 1];
    }
  }

  return total;
}

String _fmt(double val) {
  if (val == val.truncateToDouble() && val.abs() < 1e12) {
    return val.toInt().toString();
  }
  String s = val.toStringAsFixed(8);
  s = s.replaceAll(RegExp(r'0+$'), '');
  s = s.replaceAll(RegExp(r'\.$'), '');
  return s;
}

// ---------------------------------------------------------------------------
// Widget
// ---------------------------------------------------------------------------

class KalkulatorScreen extends StatefulWidget {
  const KalkulatorScreen({super.key});

  @override
  State<KalkulatorScreen> createState() => _KalkulatorScreenState();
}

class _KalkulatorScreenState extends State<KalkulatorScreen> {
  // Full expression string displayed on the top line, e.g. "50000 × 2 + 25000"
  String _expr = '';

  // Current number / result on the main display
  String _current = '0';

  // Set to true after '=' so subsequent operations know whether to chain
  bool _justEvaluated = false;

  // True while waiting for operand right after an operator
  bool _awaitingOperand = false;

  bool _hasDecimal = false;

  static const double _btnHeight = 64;
  static const double _btnSpacing = 10;

  static const Color _colorBg = Color(0xFF0D0D1A);
  static const Color _colorBtnDark = Color(0xFF1E1E32);
  static const Color _colorBtnOperator = Color(0xFF7C4DFF);
  static const Color _colorBtnSpecial = Color(0xFF252550);
  static const Color _colorEquals = Color(0xFFFFC107);
  static const Color _colorBtnDanger = Color(0xFFE53935);

  // ── Helpers ───────────────────────────────────────────────────────────────

  String get _display => _current;

  bool get _isError =>
      _current == 'Error' || _current.startsWith('Tidak bisa');

  // ── Input handlers ────────────────────────────────────────────────────────

  void _onDigit(String d) {
    setState(() {
      if (_isError) {
        _current = d == '00' ? '0' : d;
        _hasDecimal = false;
        return;
      }
      if (_awaitingOperand || _justEvaluated) {
        _current = d == '00' ? '0' : d;
        _awaitingOperand = false;
        _justEvaluated = false;
        _hasDecimal = false;
      } else {
        if (_current == '0' && d != '.') {
          _current = d == '00' ? '0' : d;
        } else {
          if (_current.length < 14) _current += d;
        }
      }
    });
  }

  void _onDecimal() {
    setState(() {
      if (_isError) {
        _current = '0.';
        _hasDecimal = true;
        return;
      }
      if (_awaitingOperand || _justEvaluated) {
        _current = '0.';
        _awaitingOperand = false;
        _justEvaluated = false;
        _hasDecimal = true;
        return;
      }
      if (!_hasDecimal) {
        _current += '.';
        _hasDecimal = true;
      }
    });
  }

  void _onOperator(String op) {
    setState(() {
      if (_isError) return;

      // If user pressed '=' previously, continue calculation seamlessly from result
      if (_justEvaluated) {
        _expr = '$_current $op ';
        _awaitingOperand = true;
        _justEvaluated = false;
        _hasDecimal = false;
        return;
      }

      // If user presses two operators consecutively, replace the trailing operator
      if (_awaitingOperand) {
        final String trimmed = _expr.trimRight();
        final int lastSpace = trimmed.lastIndexOf(' ');
        if (lastSpace >= 0) {
          _expr = '${trimmed.substring(0, lastSpace)} $op ';
        } else {
          _expr = '$op ';
        }
        return;
      }

      // Normal case: append current number and operator
      _expr = '$_expr$_current $op ';
      _awaitingOperand = true;
      _hasDecimal = false;
    });
  }

  void _onEquals() {
    setState(() {
      if (_isError) return;
      if (_justEvaluated) return;

      final String full = '$_expr$_current';
      final double? result = _evaluate(full.trim());

      if (result == null) {
        _current = 'Tidak bisa dibagi 0';
        _expr = '$full =';
        _awaitingOperand = false;
        _justEvaluated = false;
        return;
      }

      final String resultStr = _fmt(result);
      _expr = '$full =';
      _current = resultStr;
      _awaitingOperand = false;
      _justEvaluated = true;
      _hasDecimal = resultStr.contains('.');
    });
  }

  void _onPercent() {
    setState(() {
      if (_isError) return;
      final double val = double.tryParse(_current) ?? 0;

      // Case 1: Right after '=' or standalone without operator -> N / 100
      if (_justEvaluated || _expr.isEmpty) {
        _current = _fmt(val / 100.0);
        _expr = '';
        _justEvaluated = false;
        _hasDecimal = _current.contains('.');
        return;
      }

      // Case 2: In the middle of an expression
      final String trimmed = _expr.trimRight();
      if (trimmed.isNotEmpty) {
        final String lastOp = trimmed.substring(trimmed.length - 1);

        // When preceded by '+' or '−': percent of previous subtotal
        // e.g. 500 - 5% -> 5% of 500 = 25 -> expression becomes 500 - 25 = 475
        if (lastOp == '+' || lastOp == '−' || lastOp == '-') {
          final String exprBefore = trimmed.substring(0, trimmed.length - 1).trim();
          if (exprBefore.isNotEmpty) {
            final double? baseVal = _evaluate(exprBefore);
            if (baseVal != null) {
              final double percentVal = baseVal * (val / 100.0);
              _current = _fmt(percentVal);
              _awaitingOperand = false;
              _hasDecimal = _current.contains('.');
              return;
            }
          }
        }
      }

      // Preceded by '×' or '÷' (or fallback) -> N / 100
      _current = _fmt(val / 100.0);
      _awaitingOperand = false;
      _hasDecimal = _current.contains('.');
    });
  }

  void _onSquare() {
    setState(() {
      if (_isError) return;
      final double val = double.tryParse(_current) ?? 0;
      final double result = val * val;

      if (_justEvaluated || _expr.isEmpty) {
        _expr = '(${_fmt(val)})² =';
        _current = _fmt(result);
        _justEvaluated = true;
      } else {
        // Applying x² directly to the operand currently being typed in ongoing expression
        _current = _fmt(result);
      }
      _awaitingOperand = false;
      _hasDecimal = _current.contains('.');
    });
  }

  void _onSqrt() {
    setState(() {
      if (_isError) return;
      final double val = double.tryParse(_current) ?? 0;
      if (val < 0) {
        _current = 'Error';
        _expr = '√(${_fmt(val)}) =';
        _justEvaluated = false;
        _awaitingOperand = false;
        return;
      }
      final double result = sqrt(val);

      if (_justEvaluated || _expr.isEmpty) {
        _expr = '√(${_fmt(val)}) =';
        _current = _fmt(result);
        _justEvaluated = true;
      } else {
        // Applying √x directly to the operand currently being typed in ongoing expression
        _current = _fmt(result);
      }
      _awaitingOperand = false;
      _hasDecimal = _current.contains('.');
    });
  }

  void _onToggleSign() {
    setState(() {
      if (_isError) return;
      final double val = double.tryParse(_current) ?? 0;
      _current = _fmt(-val);
      _hasDecimal = _current.contains('.');
    });
  }

  void _onBackspace() {
    setState(() {
      if (_isError || _justEvaluated) {
        _current = '0';
        _justEvaluated = false;
        _hasDecimal = false;
        return;
      }
      if (_awaitingOperand) return;
      if (_current.length <= 1 ||
          _current == '0' ||
          _current == '-0' ||
          (_current.length == 2 && _current.startsWith('-'))) {
        _current = '0';
        _hasDecimal = false;
      } else {
        if (_current.endsWith('.')) _hasDecimal = false;
        _current = _current.substring(0, _current.length - 1);
        _hasDecimal = _current.contains('.');
      }
    });
  }

  void _onClear() {
    setState(() {
      _expr = '';
      _current = '0';
      _awaitingOperand = false;
      _justEvaluated = false;
      _hasDecimal = false;
    });
  }

  // ── UI Components ─────────────────────────────────────────────────────────

  Widget _btnBox({
    required String label,
    required Color bg,
    required VoidCallback onTap,
    Color tc = Colors.white,
    double height = _btnHeight,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: bg.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: tc,
              fontSize: label.length > 2 ? 18 : 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _btnExpanded({
    required String label,
    required Color bg,
    required VoidCallback onTap,
    Color tc = Colors.white,
    int flex = 1,
    double height = _btnHeight,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: _btnBox(
          label: label,
          bg: bg,
          onTap: onTap,
          tc: tc,
          height: height,
        ),
      ),
    );
  }

  Widget _buildRow(List<Widget> buttons) {
    return Padding(
      padding: const EdgeInsets.only(bottom: _btnSpacing),
      child: Row(children: buttons),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorBg,
      appBar: AppBar(
        title: const Text(
          'Kalkulator Studio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.calculate,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Info banner
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E32),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFFFC107).withValues(alpha: 0.3),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 14, color: Color(0xFFFFC107)),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Gunakan untuk estimasi biaya sewa studio × jam × paket',
                    style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11),
                  ),
                ),
              ],
            ),
          ),

          // Display area
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Full continuous expression display
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _expr,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Current operand or calculation result
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _display,
                      style: TextStyle(
                        color: _isError ? Colors.redAccent : Colors.white,
                        fontSize: 54,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Keypad container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A2E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              children: [
                // Row 1: C, ⌫, %, ÷
                _buildRow([
                  _btnExpanded(label: 'C', bg: _colorBtnDanger, onTap: _onClear, tc: Colors.white),
                  _btnExpanded(label: '⌫', bg: _colorBtnSpecial, onTap: _onBackspace, tc: const Color(0xFFFFC107)),
                  _btnExpanded(label: '%', bg: _colorBtnSpecial, onTap: _onPercent, tc: const Color(0xFFFFC107)),
                  _btnExpanded(label: '÷', bg: _colorBtnOperator, onTap: () => _onOperator('÷')),
                ]),

                // Row 2: x², √x, +/−, ×
                _buildRow([
                  _btnExpanded(label: 'x²', bg: _colorBtnSpecial, onTap: _onSquare, tc: const Color(0xFF00BCD4)),
                  _btnExpanded(label: '√x', bg: _colorBtnSpecial, onTap: _onSqrt, tc: const Color(0xFF00BCD4)),
                  _btnExpanded(label: '+/−', bg: _colorBtnSpecial, onTap: _onToggleSign, tc: const Color(0xFFFFC107)),
                  _btnExpanded(label: '×', bg: _colorBtnOperator, onTap: () => _onOperator('×')),
                ]),

                // Row 3: 7, 8, 9, −
                _buildRow([
                  _btnExpanded(label: '7', bg: _colorBtnDark, onTap: () => _onDigit('7')),
                  _btnExpanded(label: '8', bg: _colorBtnDark, onTap: () => _onDigit('8')),
                  _btnExpanded(label: '9', bg: _colorBtnDark, onTap: () => _onDigit('9')),
                  _btnExpanded(label: '−', bg: _colorBtnOperator, onTap: () => _onOperator('−')),
                ]),

                // Row 4: 4, 5, 6, +
                _buildRow([
                  _btnExpanded(label: '4', bg: _colorBtnDark, onTap: () => _onDigit('4')),
                  _btnExpanded(label: '5', bg: _colorBtnDark, onTap: () => _onDigit('5')),
                  _btnExpanded(label: '6', bg: _colorBtnDark, onTap: () => _onDigit('6')),
                  _btnExpanded(label: '+', bg: _colorBtnOperator, onTap: () => _onOperator('+')),
                ]),

                // Rows 5 & 6 combined:
                // Left 3 columns: [1, 2, 3] and [0, 00, .]
                // Right 1 column: Single tall '=' button spanning both rows
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left 3 columns
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _btnExpanded(label: '1', bg: _colorBtnDark, onTap: () => _onDigit('1')),
                              _btnExpanded(label: '2', bg: _colorBtnDark, onTap: () => _onDigit('2')),
                              _btnExpanded(label: '3', bg: _colorBtnDark, onTap: () => _onDigit('3')),
                            ],
                          ),
                          const SizedBox(height: _btnSpacing),
                          Row(
                            children: [
                              _btnExpanded(label: '0', bg: _colorBtnDark, onTap: () => _onDigit('0')),
                              _btnExpanded(label: '00', bg: _colorBtnDark, onTap: () => _onDigit('00')),
                              _btnExpanded(label: '.', bg: _colorBtnDark, onTap: _onDecimal),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Right 1 column: tall '=' button
                    _btnExpanded(
                      label: '=',
                      bg: _colorEquals,
                      onTap: _onEquals,
                      tc: Colors.black,
                      height: _btnHeight * 2 + _btnSpacing,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
