import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum WeatherCondition { sunny, cloudy, rainy, stormy }

class StudioLocation {
  final String name;
  final String area;
  final double latitude;
  final double longitude;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final int uvIndex;
  final WeatherCondition condition;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  const StudioLocation({
    required this.name,
    required this.area,
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.uvIndex,
    required this.condition,
    required this.hourly,
    required this.daily,
  });

  StudioLocation copyWith({
    double? temperature,
    int? humidity,
    double? windSpeed,
    int? uvIndex,
    WeatherCondition? condition,
    List<HourlyForecast>? hourly,
    List<DailyForecast>? daily,
  }) {
    return StudioLocation(
      name: name,
      area: area,
      latitude: latitude,
      longitude: longitude,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      uvIndex: uvIndex ?? this.uvIndex,
      condition: condition ?? this.condition,
      hourly: hourly ?? this.hourly,
      daily: daily ?? this.daily,
    );
  }
}

class HourlyForecast {
  final String time;
  final double temp;
  final WeatherCondition condition;
  const HourlyForecast(this.time, this.temp, this.condition);
}

class DailyForecast {
  final String day;
  final double high;
  final double low;
  final WeatherCondition condition;
  const DailyForecast(this.day, this.high, this.low, this.condition);
}

class CuacaScreen extends StatefulWidget {
  const CuacaScreen({super.key});

  @override
  State<CuacaScreen> createState() => _CuacaScreenState();
}

class _CuacaScreenState extends State<CuacaScreen>
    with TickerProviderStateMixin {
  int _selectedLocation = 0;
  WeatherCondition _selectedCondition = WeatherCondition.sunny;

  // Real-time API state
  bool _isLive = false;
  bool _isLoading = false;
  StudioLocation? _liveLocationData;

  late AnimationController _sunRotationController;
  late AnimationController _cloudController;
  late AnimationController _rainController;
  late AnimationController _lightningController;
  late AnimationController _switchController;
  late Animation<double> _switchAnimation;

  final List<StudioLocation> _locations = [
    StudioLocation(
      name: 'SoundHub Itenas',
      area: 'Bandung Tengah',
      latitude: -6.8976,
      longitude: 107.6366,
      temperature: 23,
      humidity: 72,
      windSpeed: 12,
      uvIndex: 5,
      condition: WeatherCondition.cloudy,
      hourly: [
        HourlyForecast('08:00', 21, WeatherCondition.cloudy),
        HourlyForecast('10:00', 23, WeatherCondition.sunny),
        HourlyForecast('12:00', 25, WeatherCondition.sunny),
        HourlyForecast('14:00', 24, WeatherCondition.cloudy),
        HourlyForecast('16:00', 22, WeatherCondition.rainy),
        HourlyForecast('18:00', 20, WeatherCondition.rainy),
      ],
      daily: [
        DailyForecast('Sen', 25, 19, WeatherCondition.cloudy),
        DailyForecast('Sel', 26, 20, WeatherCondition.sunny),
        DailyForecast('Rab', 22, 18, WeatherCondition.rainy),
        DailyForecast('Kam', 24, 19, WeatherCondition.cloudy),
        DailyForecast('Jum', 21, 17, WeatherCondition.stormy),
        DailyForecast('Sab', 23, 18, WeatherCondition.cloudy),
        DailyForecast('Min', 25, 20, WeatherCondition.sunny),
      ],
    ),
    StudioLocation(
      name: 'SoundHub Dago',
      area: 'Dago, Bandung Utara',
      latitude: -6.8732,
      longitude: 107.6186,
      temperature: 20,
      humidity: 80,
      windSpeed: 15,
      uvIndex: 3,
      condition: WeatherCondition.rainy,
      hourly: [
        HourlyForecast('08:00', 18, WeatherCondition.rainy),
        HourlyForecast('10:00', 20, WeatherCondition.rainy),
        HourlyForecast('12:00', 21, WeatherCondition.cloudy),
        HourlyForecast('14:00', 20, WeatherCondition.rainy),
        HourlyForecast('16:00', 19, WeatherCondition.stormy),
        HourlyForecast('18:00', 17, WeatherCondition.rainy),
      ],
      daily: [
        DailyForecast('Sen', 22, 17, WeatherCondition.rainy),
        DailyForecast('Sel', 23, 18, WeatherCondition.cloudy),
        DailyForecast('Rab', 20, 16, WeatherCondition.rainy),
        DailyForecast('Kam', 22, 17, WeatherCondition.cloudy),
        DailyForecast('Jum', 19, 15, WeatherCondition.stormy),
        DailyForecast('Sab', 21, 16, WeatherCondition.rainy),
        DailyForecast('Min', 23, 18, WeatherCondition.cloudy),
      ],
    ),
    StudioLocation(
      name: 'SoundHub Setiabudi',
      area: 'Setiabudi, Bandung',
      latitude: -6.8617,
      longitude: 107.5936,
      temperature: 24,
      humidity: 68,
      windSpeed: 10,
      uvIndex: 6,
      condition: WeatherCondition.sunny,
      hourly: [
        HourlyForecast('08:00', 22, WeatherCondition.sunny),
        HourlyForecast('10:00', 24, WeatherCondition.sunny),
        HourlyForecast('12:00', 26, WeatherCondition.sunny),
        HourlyForecast('14:00', 25, WeatherCondition.cloudy),
        HourlyForecast('16:00', 23, WeatherCondition.cloudy),
        HourlyForecast('18:00', 21, WeatherCondition.cloudy),
      ],
      daily: [
        DailyForecast('Sen', 27, 21, WeatherCondition.sunny),
        DailyForecast('Sel', 28, 22, WeatherCondition.sunny),
        DailyForecast('Rab', 25, 20, WeatherCondition.cloudy),
        DailyForecast('Kam', 26, 21, WeatherCondition.sunny),
        DailyForecast('Jum', 24, 19, WeatherCondition.rainy),
        DailyForecast('Sab', 25, 20, WeatherCondition.cloudy),
        DailyForecast('Min', 27, 21, WeatherCondition.sunny),
      ],
    ),
    StudioLocation(
      name: 'SoundHub Lembang',
      area: 'Lembang, Bandung Barat',
      latitude: -6.8168,
      longitude: 107.6179,
      temperature: 17,
      humidity: 90,
      windSpeed: 18,
      uvIndex: 2,
      condition: WeatherCondition.stormy,
      hourly: [
        HourlyForecast('08:00', 15, WeatherCondition.stormy),
        HourlyForecast('10:00', 16, WeatherCondition.rainy),
        HourlyForecast('12:00', 17, WeatherCondition.rainy),
        HourlyForecast('14:00', 17, WeatherCondition.cloudy),
        HourlyForecast('16:00', 16, WeatherCondition.rainy),
        HourlyForecast('18:00', 14, WeatherCondition.stormy),
      ],
      daily: [
        DailyForecast('Sen', 18, 13, WeatherCondition.rainy),
        DailyForecast('Sel', 20, 14, WeatherCondition.cloudy),
        DailyForecast('Rab', 17, 12, WeatherCondition.stormy),
        DailyForecast('Kam', 19, 13, WeatherCondition.rainy),
        DailyForecast('Jum', 16, 11, WeatherCondition.stormy),
        DailyForecast('Sab', 18, 13, WeatherCondition.rainy),
        DailyForecast('Min', 21, 15, WeatherCondition.cloudy),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedCondition = _locations[_selectedLocation].condition;

    _sunRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _rainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();

    _lightningController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _switchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _switchAnimation = CurvedAnimation(
      parent: _switchController,
      curve: Curves.easeInOut,
    );
    _switchController.forward();

    // Fetch real-time weather on screen startup
    _fetchRealTimeWeather(_locations[_selectedLocation]);
  }

  @override
  void dispose() {
    _sunRotationController.dispose();
    _cloudController.dispose();
    _rainController.dispose();
    _lightningController.dispose();
    _switchController.dispose();
    super.dispose();
  }

  // ── Open-Meteo API Fetcher ────────────────────────────────────────────────

  WeatherCondition _mapWmoCode(int code) {
    if (code == 0) return WeatherCondition.sunny;
    if (code <= 3 || code == 45 || code == 48) return WeatherCondition.cloudy;
    if (code >= 95) return WeatherCondition.stormy;
    return WeatherCondition.rainy;
  }

  String _formatDayName(DateTime dt) {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return days[dt.weekday - 1];
  }

  Future<void> _fetchRealTimeWeather(StudioLocation baseLoc) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=${baseLoc.latitude}&longitude=${baseLoc.longitude}'
      '&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m'
      '&hourly=temperature_2m,weather_code'
      '&daily=weather_code,temperature_2m_max,temperature_2m_min'
      '&timezone=Asia%2FJakarta',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;

        // Current weather
        final current = data['current'] as Map<String, dynamic>?;
        final double temp = (current?['temperature_2m'] as num?)?.toDouble() ??
            baseLoc.temperature;
        final int humidity =
            (current?['relative_humidity_2m'] as num?)?.toInt() ??
                baseLoc.humidity;
        final double wind = (current?['wind_speed_10m'] as num?)?.toDouble() ??
            baseLoc.windSpeed;
        final int weatherCode =
            (current?['weather_code'] as num?)?.toInt() ?? 0;
        final WeatherCondition condition = _mapWmoCode(weatherCode);

        // Hourly forecast (next 6 intervals)
        List<HourlyForecast> hourlyList = [];
        final hourly = data['hourly'] as Map<String, dynamic>?;
        if (hourly != null) {
          final times = (hourly['time'] as List?)?.cast<String>() ?? [];
          final temps = (hourly['temperature_2m'] as List?) ?? [];
          final codes = (hourly['weather_code'] as List?) ?? [];

          final now = DateTime.now();
          int startIndex = 0;
          for (int i = 0; i < times.length; i++) {
            final dt = DateTime.tryParse(times[i]);
            if (dt != null && dt.isAfter(now.subtract(const Duration(hours: 1)))) {
              startIndex = i;
              break;
            }
          }

          for (int i = startIndex; i < min(startIndex + 6, times.length); i++) {
            final dt = DateTime.tryParse(times[i]);
            final timeStr = dt != null
                ? '${dt.hour.toString().padLeft(2, '0')}:00'
                : '00:00';
            final t = (temps[i] as num?)?.toDouble() ?? 24.0;
            final c = _mapWmoCode((codes[i] as num?)?.toInt() ?? 0);
            hourlyList.add(HourlyForecast(timeStr, t, c));
          }
        }
        if (hourlyList.isEmpty) hourlyList = baseLoc.hourly;

        // Daily forecast (next 7 days)
        List<DailyForecast> dailyList = [];
        final daily = data['daily'] as Map<String, dynamic>?;
        if (daily != null) {
          final times = (daily['time'] as List?)?.cast<String>() ?? [];
          final maxTemps = (daily['temperature_2m_max'] as List?) ?? [];
          final minTemps = (daily['temperature_2m_min'] as List?) ?? [];
          final codes = (daily['weather_code'] as List?) ?? [];

          for (int i = 0; i < min(7, times.length); i++) {
            final dt = DateTime.tryParse(times[i]) ?? DateTime.now().add(Duration(days: i));
            final dayStr = _formatDayName(dt);
            final h = (maxTemps[i] as num?)?.toDouble() ?? 25.0;
            final l = (minTemps[i] as num?)?.toDouble() ?? 19.0;
            final c = _mapWmoCode((codes[i] as num?)?.toInt() ?? 0);
            dailyList.add(DailyForecast(dayStr, h, l, c));
          }
        }
        if (dailyList.isEmpty) dailyList = baseLoc.daily;

        final updated = baseLoc.copyWith(
          temperature: temp,
          humidity: humidity,
          windSpeed: wind,
          condition: condition,
          hourly: hourlyList,
          daily: dailyList,
        );

        if (mounted) {
          _switchController.reset();
          setState(() {
            _liveLocationData = updated;
            _selectedCondition = condition;
            _isLive = true;
            _isLoading = false;
          });
          _switchController.forward();
        }
        return;
      }
    } catch (_) {
      // Offline / network failure -> clean fallback to static data
    }

    if (mounted) {
      _switchController.reset();
      setState(() {
        _isLive = false;
        _isLoading = false;
        _liveLocationData = null;
        _selectedCondition = baseLoc.condition;
      });
      _switchController.forward();
    }
  }

  // ── User Actions ──────────────────────────────────────────────────────────

  void _changeLocation(int idx) {
    _switchController.reset();
    setState(() {
      _selectedLocation = idx;
    });
    _switchController.forward();

    // Trigger auto-fetch for the new studio branch
    _fetchRealTimeWeather(_locations[idx]);
  }

  // ── Visual Helpers ────────────────────────────────────────────────────────

  Color get _bgTop {
    switch (_selectedCondition) {
      case WeatherCondition.sunny:
        return const Color(0xFF1A2A4A);
      case WeatherCondition.cloudy:
        return const Color(0xFF1A1A2E);
      case WeatherCondition.rainy:
        return const Color(0xFF0D1A2E);
      case WeatherCondition.stormy:
        return const Color(0xFF0A0A14);
    }
  }

  Color get _bgBottom {
    switch (_selectedCondition) {
      case WeatherCondition.sunny:
        return const Color(0xFF0D1A30);
      case WeatherCondition.cloudy:
        return const Color(0xFF0D0D1A);
      case WeatherCondition.rainy:
        return const Color(0xFF050F1A);
      case WeatherCondition.stormy:
        return const Color(0xFF050508);
    }
  }

  String get _conditionLabel {
    switch (_selectedCondition) {
      case WeatherCondition.sunny:
        return 'Cerah ☀️';
      case WeatherCondition.cloudy:
        return 'Berawan ⛅';
      case WeatherCondition.rainy:
        return 'Hujan 🌧️';
      case WeatherCondition.stormy:
        return 'Badai ⛈️';
    }
  }

  String _weatherEmoji(WeatherCondition c) {
    switch (c) {
      case WeatherCondition.sunny:
        return '☀️';
      case WeatherCondition.cloudy:
        return '⛅';
      case WeatherCondition.rainy:
        return '🌧️';
      case WeatherCondition.stormy:
        return '⛈️';
    }
  }

  Color _tempColor(double temp) {
    if (temp >= 25) return const Color(0xFFFFC107);
    if (temp >= 20) return const Color(0xFF4CAF50);
    return const Color(0xFF2196F3);
  }

  // ── UI Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Effective location: live data if available, fallback to static template
    final loc = _liveLocationData ?? _locations[_selectedLocation];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header / Location Title Row ──────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Text(
                      'Cuaca Studio',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Live / Offline Status Badge
                    _buildStatusBadge(),
                    const Spacer(),
                    const Icon(Icons.location_on,
                        color: Color(0xFFFFC107), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      loc.area,
                      style: const TextStyle(
                        color: Color(0xFFFFC107),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Refresh Button
                    GestureDetector(
                      onTap: () =>
                          _fetchRealTimeWeather(_locations[_selectedLocation]),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E32).withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFFFFC107),
                                ),
                              )
                            : const Icon(Icons.refresh,
                                color: Colors.white70, size: 16),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Branch Selector Bar ──────────────────────────────────────
              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _locations.length,
                  itemBuilder: (_, i) {
                    final selected = i == _selectedLocation;
                    return GestureDetector(
                      onTap: () => _changeLocation(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFFFFC107)
                              : const Color(0xFF1E1E32).withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFFFFC107)
                                : Colors.white24,
                          ),
                        ),
                        child: Text(
                          _locations[i].name,
                          style: TextStyle(
                            color: selected ? Colors.black : Colors.white,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ── Dynamic Weather Animation (Driven Automatically) ────────
              SizedBox(
                height: 170,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _buildWeatherAnimation(_selectedCondition),
                ),
              ),

              // ── Temperature & Condition Label ────────────────────────────
              FadeTransition(
                opacity: _switchAnimation,
                child: Column(
                  children: [
                    Text(
                      '${loc.temperature.round()}°C',
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _conditionLabel,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFFCBD5E0),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Stats row: Humidity, Wind, UV ────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statChip(Icons.water_drop, '${loc.humidity}%', 'Kelembapan'),
                    _statChip(Icons.air, '${loc.windSpeed.round()} km/h', 'Angin'),
                    _statChip(Icons.wb_sunny, 'UV ${loc.uvIndex}', 'Indeks UV'),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Automatic Condition Status Indicators (Read-Only) ────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _conditionIndicator('☀️', 'Cerah', WeatherCondition.sunny),
                    const SizedBox(width: 8),
                    _conditionIndicator('⛅', 'Berawan', WeatherCondition.cloudy),
                    const SizedBox(width: 8),
                    _conditionIndicator('🌧️', 'Hujan', WeatherCondition.rainy),
                    const SizedBox(width: 8),
                    _conditionIndicator('⛈️', 'Badai', WeatherCondition.stormy),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Hourly Forecast Bar ──────────────────────────────────────
              SizedBox(
                height: 86,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: loc.hourly.length,
                  itemBuilder: (_, i) {
                    final h = loc.hourly[i];
                    return Container(
                      width: 68,
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E32).withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(h.time,
                              style: const TextStyle(
                                  color: Color(0xFF9CA3AF), fontSize: 10)),
                          Text(_weatherEmoji(h.condition),
                              style: const TextStyle(fontSize: 18)),
                          Text('${h.temp.round()}°',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 6),

              // ── 7-Day Forecast Card ──────────────────────────────────────
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E32).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            '7 Hari ke Depan',
                            style: TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _isLive ? 'Open-Meteo Real-Time' : 'Data Lokal (Offline)',
                            style: TextStyle(
                              color: _isLive
                                  ? const Color(0xFF4CAF50)
                                  : const Color(0xFF9CA3AF),
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: ListView.builder(
                          itemCount: loc.daily.length,
                          itemBuilder: (_, i) {
                            final d = loc.daily[i];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 36,
                                    child: Text(
                                      d.day,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Text(_weatherEmoji(d.condition),
                                      style: const TextStyle(fontSize: 16)),
                                  const Spacer(),
                                  Text('${d.low.round()}°',
                                      style: const TextStyle(
                                          color: Color(0xFF9CA3AF),
                                          fontSize: 12)),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 80,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFF7C4DFF),
                                          _tempColor(d.high),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('${d.high.round()}°',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Widgets & Indicators ──────────────────────────────────────────────────

  Widget _buildStatusBadge() {
    if (_isLive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF4CAF50).withValues(alpha: 0.5),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, color: Color(0xFF4CAF50), size: 7),
            SizedBox(width: 4),
            Text(
              'LIVE',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC107).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFC107).withValues(alpha: 0.5),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle_outlined, color: Color(0xFFFFC107), size: 7),
          SizedBox(width: 4),
          Text(
            'OFFLINE',
            style: TextStyle(
              color: Color(0xFFFFC107),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E32).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFFFC107), size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  /// Read-only automatic status indicator box
  /// Highlights automatically when it matches the current real-time condition.
  Widget _conditionIndicator(
      String emoji, String label, WeatherCondition cond) {
    final isCurrent = _selectedCondition == cond;
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isCurrent
              ? const Color(0xFFFFC107).withValues(alpha: 0.18)
              : const Color(0xFF1E1E32).withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCurrent
                ? const Color(0xFFFFC107)
                : Colors.white12,
            width: isCurrent ? 1.5 : 1.0,
          ),
          boxShadow: isCurrent
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFC107).withValues(alpha: 0.25),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isCurrent
                    ? const Color(0xFFFFC107)
                    : const Color(0xFF6B7280),
                fontSize: 11,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Animations ────────────────────────────────────────────────────────────

  Widget _buildWeatherAnimation(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return _buildSunAnimation();
      case WeatherCondition.cloudy:
        return _buildCloudAnimation();
      case WeatherCondition.rainy:
        return _buildRainAnimation();
      case WeatherCondition.stormy:
        return _buildStormAnimation();
    }
  }

  Widget _buildSunAnimation() {
    return SizedBox(
      key: const ValueKey('sunny'),
      child: Center(
        child: AnimatedBuilder(
          animation: _sunRotationController,
          builder: (_, child) {
            return Transform.rotate(
              angle: _sunRotationController.value * 2 * pi,
              child: child,
            );
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFC107),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFC107).withValues(alpha: 0.5),
                  blurRadius: 30,
                  spreadRadius: 15,
                ),
              ],
            ),
            child: const Center(
              child: Text('☀️', style: TextStyle(fontSize: 60)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCloudAnimation() {
    return SizedBox(
      key: const ValueKey('cloudy'),
      child: AnimatedBuilder(
        animation: _cloudController,
        builder: (_, _) {
          final offset = _cloudController.value * 20 - 10;
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.translate(
                offset: Offset(offset * 0.8, 0),
                child: const Text('☁️',
                    style: TextStyle(fontSize: 60, color: Colors.white70)),
              ),
              Transform.translate(
                offset: Offset(-offset, 10),
                child: const Text('⛅',
                    style: TextStyle(fontSize: 70)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRainAnimation() {
    return SizedBox(
      key: const ValueKey('rainy'),
      child: AnimatedBuilder(
        animation: _rainController,
        builder: (_, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              const Positioned(
                top: 10,
                child: Text('🌧️', style: TextStyle(fontSize: 60)),
              ),
              ...List.generate(6, (i) {
                final offset = (_rainController.value + i * 0.15) % 1.0;
                return Positioned(
                  left: 30.0 + i * 20,
                  top: 80 + offset * 60,
                  child: Opacity(
                    opacity: 1.0 - offset,
                    child: Container(
                      width: 2,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF64B5F6),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStormAnimation() {
    return SizedBox(
      key: const ValueKey('stormy'),
      child: AnimatedBuilder(
        animation: _lightningController,
        builder: (_, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              const Text('⛈️', style: TextStyle(fontSize: 70)),
              Positioned(
                right: 50,
                bottom: 10,
                child: Opacity(
                  opacity: _lightningController.value,
                  child: const Text('⚡',
                      style: TextStyle(fontSize: 36)),
                ),
              ),
              Positioned(
                left: 50,
                bottom: 20,
                child: Opacity(
                  opacity: 1 - _lightningController.value,
                  child: const Text('⚡',
                      style: TextStyle(fontSize: 28)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
