import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

// ---------------------------------------------------------------------------
// Theme helpers
// ---------------------------------------------------------------------------

final _darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFFFC107),   // Amber
    secondary: Color(0xFF7C4DFF), // Deep Purple / Indigo
    surface: Color(0xFF1A1A2E),
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    tertiary: Color(0xFF00BCD4),  // Cyan accent
  ),
  scaffoldBackgroundColor: const Color(0xFF0D0D1A),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1A1A2E),
    foregroundColor: Color(0xFFFFC107),
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    color: const Color(0xFF1E1E32),
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1A1A2E),
    selectedItemColor: Color(0xFFFFC107),
    unselectedItemColor: Color(0xFF6B7280),
    type: BottomNavigationBarType.fixed,
    elevation: 10,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF252540),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF3D3D6B)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF3D3D6B)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFFFC107), width: 2),
    ),
    labelStyle: const TextStyle(color: Color(0xFF9CA3AF)),
    hintStyle: const TextStyle(color: Color(0xFF6B7280)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFC107),
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    ),
  ),
);

// ---------------------------------------------------------------------------
// Root widget
// ---------------------------------------------------------------------------

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoundHub Studio',
      debugShowCheckedModeBanner: false,
      theme: _darkTheme,
      // On web: wrap every route inside the phone-frame widget.
      // On native (Android/iOS): pass the child through unchanged.
      builder: (context, child) {
        if (kIsWeb) {
          return _PhoneFrameShell(child: child ?? const SizedBox.shrink());
        }
        return child ?? const SizedBox.shrink();
      },
      home: const SplashScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// Custom phone-frame wrapper — web only
// ---------------------------------------------------------------------------

/// Renders the app content inside a simulated smartphone bezel.
///
/// • Max content area : 412 × 892 dp (≈ Pixel 6 logical size)
/// • Corner radius    : 36 px
/// • Border           : dark, 3 px thick, slight shadow
/// • Notch / status   : thin dark pill at the top of the screen
///
/// Only activated when [kIsWeb] is true (see [MyApp.builder]).
class _PhoneFrameShell extends StatelessWidget {
  const _PhoneFrameShell({required this.child});

  final Widget child;

  static const double _maxW = 412;
  static const double _maxH = 892;
  static const double _radius = 36;
  static const double _borderW = 3;
  static const double _bezelV = 12; // top/bottom padding inside frame
  static const double _bezelH = 0;  // left/right padding inside frame
  static const double _notchH = 24; // notch bar height
  static const double _notchW = 100; // notch pill width
  static const double _shadowSpread = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Scale down proportionally when viewport is smaller than max size.
            final double availH = constraints.maxHeight;
            final double availW = constraints.maxWidth;

            // Total frame height = content + bezel top/bottom
            const double frameH = _maxH + _bezelV * 2 + _borderW * 2;
            const double frameW = _maxW + _bezelH * 2 + _borderW * 2;

            final double scaleH = availH < frameH ? availH / frameH : 1.0;
            final double scaleW = availW < frameW ? availW / frameW : 1.0;
            final double scale = scaleH < scaleW ? scaleH : scaleW;

            return Transform.scale(
              scale: scale,
              child: SizedBox(
                width: frameW,
                height: frameH,
                child: _buildFrame(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFrame() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(_radius + _borderW),
        border: Border.all(
          color: const Color(0xFF2E2E2E),
          width: _borderW,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x88000000),
            blurRadius: 40,
            spreadRadius: _shadowSpread,
          ),
          BoxShadow(
            color: Color(0x33FFC107),
            blurRadius: 60,
            spreadRadius: 2,
          ),
        ],
      ),
      // Clip content to rounded screen shape
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: SizedBox(
          width: _maxW + _bezelH * 2,
          height: _maxH + _bezelV * 2,
          child: Column(
            children: [
              // ── Status bar / notch area ─────────────────────────────────
              _buildStatusBar(),

              // ── App content ─────────────────────────────────────────────
              Expanded(child: child),

              // ── Home indicator ───────────────────────────────────────────
              _buildHomeIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      width: double.infinity,
      height: _notchH + _bezelV,
      color: const Color(0xFF0D0D1A),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Notch pill
          Positioned(
            top: _bezelV / 2,
            child: Container(
              width: _notchW,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Camera dot
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2A2A2A),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Speaker slit
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right-side status icons
          Positioned(
            right: 16,
            bottom: 2,
            child: Row(
              children: [
                _statusIcon(Icons.signal_cellular_alt, 10),
                const SizedBox(width: 3),
                _statusIcon(Icons.wifi, 10),
                const SizedBox(width: 3),
                _statusIcon(Icons.battery_full, 11),
              ],
            ),
          ),
          // Clock (static)
          const Positioned(
            left: 16,
            bottom: 2,
            child: Text(
              '21:00',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeIndicator() {
    return Container(
      width: double.infinity,
      height: _bezelV + 4,
      color: const Color(0xFF0D0D1A),
      child: Center(
        child: Container(
          width: 120,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF3D3D6B),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _statusIcon(IconData icon, double size) {
    return Icon(icon, color: Colors.white, size: size);
  }
}
