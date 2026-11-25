import 'package:flutter/material.dart';

class NewsItem {
  final String id;
  final String title;
  final String summary;
  final String fullContent;
  final String source;
  final String date;
  final String category;
  final IconData thumbnailIcon;
  final List<Color> gradientColors;

  const NewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.fullContent,
    required this.source,
    required this.date,
    required this.category,
    required this.thumbnailIcon,
    required this.gradientColors,
  });
}

class BeritaScreen extends StatefulWidget {
  const BeritaScreen({super.key});

  @override
  State<BeritaScreen> createState() => _BeritaScreenState();
}

class _BeritaScreenState extends State<BeritaScreen> {
  String _selectedCategory = 'Semua';
  final List<String> _categories = [
    'Semua',
    'Album Baru',
    'Tips Studio',
    'Teknologi Audio',
    'Review Gear',
  ];

  final List<NewsItem> _news = [
    NewsItem(
      id: '1',
      title: 'Coldplay Rilis Album "Moon Music" – Rekaman Ramah Lingkungan',
      summary:
          'Album terbaru Coldplay menggunakan 100% energi terbarukan dalam proses rekaman, menjadi benchmark baru industri musik dunia.',
      fullContent:
          'Coldplay merilis album ke-10 mereka bertajuk "Moon Music" yang menuai pujian tidak hanya dari sisi musikal, tetapi juga dari sisi lingkungan. Proses rekaman album ini 100% menggunakan energi surya dan angin di studio khusus di London. Chris Martin menyatakan bahwa ini adalah langkah nyata band mereka menuju tur dan produksi musik yang carbon-neutral. Album ini menampilkan kolaborasi dengan berbagai artis global dan merupakan salah satu perilisan paling dinantikan tahun ini.',
      source: 'Rolling Stone',
      date: '10 Nov 2026',
      category: 'Album Baru',
      thumbnailIcon: Icons.album,
      gradientColors: [Color(0xFF1565C0), Color(0xFF7C4DFF)],
    ),
    NewsItem(
      id: '2',
      title: 'Tips Akustik: Cara Mengoptimalkan Ruang Studio Budget',
      summary:
          'Peredam suara DIY dengan panel Rockwool bisa meningkatkan kualitas akustik studio hingga 70% dengan biaya sangat terjangkau.',
      fullContent:
          'Memiliki studio rekaman dengan akustik yang baik tidak selalu membutuhkan biaya besar. Dengan bahan-bahan seperti Rockwool, panel kayu, dan karpet tebal, Anda bisa membangun studio home recording berkualitas profesional. Artikel ini mengupas teknik penempatan bass trap di sudut ruangan, penggunaan diffuser untuk scatter refleksi, dan cara mengukur RT60 (Reverb Time) menggunakan software gratis Room EQ Wizard (REW). Pelajari bagaimana para produser Indonesia sukses membangun mini studio dari kamar kos!',
      source: 'SoundOnSound',
      date: '8 Nov 2026',
      category: 'Tips Studio',
      thumbnailIcon: Icons.speaker,
      gradientColors: [Color(0xFF2E7D32), Color(0xFF00BCD4)],
    ),
    NewsItem(
      id: '3',
      title: 'Neve 1073 Clone Terbaik 2026: Preamp Analog untuk Budget Terbatas',
      summary:
          'Review mendalam 5 preamp analog clone Neve 1073 terbaik di pasaran, dari Warm Audio WA73-EQ hingga Golden Age Project.',
      fullContent:
          'Neve 1073 adalah salah satu preamp mikrofon paling ikonik dalam sejarah rekaman. Namun harganya yang mencapai belasan juta membuat banyak home studio engineer mencari alternatif. Dalam artikel ini, kami merangkum 5 clone terbaik yang tersedia di Indonesia: Warm Audio WA73-EQ (Rp 4.5 juta), Golden Age Project Pre-73 MKIII (Rp 2.8 juta), ART Pro MPA II (Rp 1.5 juta), Behringer ULTRAGAIN PRO MIC2200 (Rp 800rb), dan DIY Neve 1073 PCB (Rp 1.2 juta). Setiap unit diuji langsung di studio Bandung dengan berbagai mikrofon kondenser dan dynamic.',
      source: 'Pitchfork',
      date: '5 Nov 2026',
      category: 'Review Gear',
      thumbnailIcon: Icons.settings_input_component,
      gradientColors: [Color(0xFFE65100), Color(0xFFFFC107)],
    ),
    NewsItem(
      id: '4',
      title: 'AI dalam Produksi Musik: Revolusi atau Ancaman bagi Musisi?',
      summary:
          'Tools AI seperti LANDR, Suno, dan Udio kini bisa menghasilkan musik berkualitas tinggi otomatis – apa dampaknya bagi musisi lokal?',
      fullContent:
          'Kecerdasan buatan telah masuk ke hampir semua aspek produksi musik modern. Dari auto-mastering menggunakan LANDR, hingga generasi musik penuh dengan Suno AI dan Udio yang bisa menghasilkan lagu dengan lirik dan melodi dalam hitungan detik. Pro: demokratisasi produksi musik untuk musisi independen tanpa budget studio besar. Kontra: kekhawatiran hak cipta, penggantian pekerjaan session musician, dan degradasi nilai kreativitas manusia. Para musisi Bandung yang kami wawancarai memiliki pandangan beragam – sebagian melihatnya sebagai alat bantu kreatif, sebagian khawatir akan masa depan profesi mereka.',
      source: 'Billboard',
      date: '3 Nov 2026',
      category: 'Teknologi Audio',
      thumbnailIcon: Icons.smart_toy,
      gradientColors: [Color(0xFF7C4DFF), Color(0xFFE91E63)],
    ),
    NewsItem(
      id: '5',
      title: 'Kendrick Lamar Raih Grammy 7 Kategori – Album "GNX" Mengguncang Dunia',
      summary:
          'GNX menjadi album hip-hop paling berpengaruh 2026 setelah Kendrick Lamar sweep 7 Grammy Awards termasuk Album of the Year.',
      fullContent:
          'Kendrick Lamar membuktikan dominasinya di industri hip-hop global dengan album "GNX" yang meraup 7 penghargaan Grammy sekaligus. Album yang sebagian besar direkam di studio minimalis di Compton ini menampilkan produksi mentah namun puitis dari Sounwave dan Jack Antonoff. Proses rekaman yang otentik, mengandalkan analog gear vintage dan sedikit plugin, menjadi inspirasi bagi banyak produser muda Indonesia. GNX juga menjadi album pertama yang menggabungkan teknik surround sound spatialized audio untuk pengalaman mendengarkan yang imersif.',
      source: 'Rolling Stone',
      date: '1 Nov 2026',
      category: 'Album Baru',
      thumbnailIcon: Icons.emoji_events,
      gradientColors: [Color(0xFFC62828), Color(0xFFFFA000)],
    ),
    NewsItem(
      id: '6',
      title: 'Panduan Lengkap: Setup Home Recording Studio di Bawah 10 Juta',
      summary:
          'Dari interface audio, mikrofon kondenser, DAW hingga monitor speaker – inilah panduan lengkap membangun studio impian dengan budget realistis.',
      fullContent:
          'Mimpi memiliki studio rekaman sendiri kini bukan lagi kemewahan eksklusif. Dengan budget 10 juta rupiah, Anda sudah bisa memiliki setup yang cukup profesional untuk merekam vokal, akustik gitar, dan podcast berkualitas tinggi. Kami merekomendasikan paket berikut: Audio Interface Focusrite Scarlett 2i2 (Rp 1.8jt), Mikrofon Audio-Technica AT2020 (Rp 1.3jt), Monitor Speaker Yamaha HS5 (Rp 2.5jt/pair), Headphone Sony MDR-7506 (Rp 1.2jt), DAW Reaper (Rp 500rb/tahun), Peredam Rockwool DIY (Rp 1.5jt), Kabel dan aksesori (Rp 1.2jt). Total: Rp 10 juta – siap rekaman!',
      source: 'SoundOnSound',
      date: '28 Okt 2026',
      category: 'Tips Studio',
      thumbnailIcon: Icons.home,
      gradientColors: [Color(0xFF00695C), Color(0xFF4CAF50)],
    ),
    NewsItem(
      id: '7',
      title: 'Dolby Atmos for Music: Panduan Mixing 3D untuk Studio Indie',
      summary:
          'Streaming Dolby Atmos di Apple Music dan Tidal mendorong studio-studio indie untuk mulai mempelajari teknik mixing audio spasial 3D.',
      fullContent:
          'Dolby Atmos tidak lagi eksklusif untuk bioskop dan studio major label. Dengan munculnya Dolby Atmos Music di platform streaming seperti Apple Music dan Tidal, kini musisi indie pun dituntut memahami teknik mixing audio 3D (spatialized audio). Artikel ini membahas cara setup monitoring Dolby Atmos menggunakan binaural rendering di headphone (solusi budget), software requirements seperti DAW yang kompatibel (Logic Pro, Pro Tools Ultimate, Nuendo), serta workflow dasar untuk mengkonversi mix stereo ke format Atmos. Beberapa studio di Bandung sudah mulai menawarkan layanan mixing Atmos!',
      source: 'Pitchfork',
      date: '25 Okt 2026',
      category: 'Teknologi Audio',
      thumbnailIcon: Icons.surround_sound,
      gradientColors: [Color(0xFF1A237E), Color(0xFF00BCD4)],
    ),
    NewsItem(
      id: '8',
      title: 'Scene Metal Bandung Bangkit: 5 Band Lokal yang Harus Kamu Dengarkan',
      summary:
          'Kebangkitan scene metal underground Bandung melahirkan gelombang baru band berbakat yang siap menembus pasar internasional.',
      fullContent:
          'Bandung selalu menjadi inkubator musik metal berkualitas tinggi sejak era 90-an. Memasuki 2026, generasi baru band metal muncul membawa semangat segar dengan sound yang lebih modern namun tetap berakar pada tradisi thrash dan death metal lokal. Lima band yang wajib kamu simak: 1) Funeral Inception – blackened death metal dengan lirik bahasa Sunda, 2) Disasterpiece – technical death metal alumni mahasiswa ITB, 3) Void Psalms – post-metal atmospheric yang terpengaruh Isis dan Neurosis, 4) Krakatau Siege – sludge metal dengan elemen gamelan, 5) Iron Paradox – heavy metal melodic bergaya Judas Priest modern. Semua band ini aktif manggung di venue Bandung dan merekam di studio-studio lokal.',
      source: 'Consequence of Sound',
      date: '20 Okt 2026',
      category: 'Album Baru',
      thumbnailIcon: Icons.electric_bolt,
      gradientColors: [Color(0xFF37474F), Color(0xFFE53935)],
    ),
  ];

  List<NewsItem> get _filtered {
    if (_selectedCategory == 'Semua') return _news;
    return _news
        .where((n) => n.category == _selectedCategory)
        .toList();
  }

  void _showDetail(NewsItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E32),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D3D6B),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header image
              Container(
                margin: const EdgeInsets.all(16),
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: item.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(item.thumbnailIcon,
                      size: 64, color: Colors.white.withValues(alpha: 0.9)),
                ),
              ),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  children: [
                    // Category chip
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: item.gradientColors[0].withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: item.gradientColors[0].withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            item.category,
                            style: TextStyle(
                              color: item.gradientColors[0],
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          item.date,
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Title
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Source
                    Row(
                      children: [
                        const Icon(Icons.newspaper,
                            size: 14, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        Text(
                          item.source,
                          style: const TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFF3D3D6B)),
                    const SizedBox(height: 16),
                    // Full content
                    Text(
                      item.fullContent,
                      style: const TextStyle(
                        color: Color(0xFFCBD5E0),
                        fontSize: 15,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Share / bookmark buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.bookmark_outline,
                                size: 16),
                            label: const Text('Simpan'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFFFC107),
                              side: const BorderSide(
                                  color: Color(0xFFFFC107)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.share, size: 16),
                            label: const Text('Bagikan'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        title: const Text(
          'Berita Musik & Studio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(Icons.newspaper,
                color: Theme.of(context).colorScheme.primary),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: SizedBox(
            height: 46,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: _categories.length,
              itemBuilder: (_, i) {
                final selected = _categories[i] == _selectedCategory;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedCategory = _categories[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFFFC107)
                          : const Color(0xFF1E1E32),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFFFFC107)
                            : const Color(0xFF3D3D6B),
                      ),
                    ),
                    child: Text(
                      _categories[i],
                      style: TextStyle(
                        color: selected ? Colors.black : Colors.white70,
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
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: filtered.length,
        itemBuilder: (_, i) {
          final item = filtered[i];
          return GestureDetector(
            onTap: () => _showDetail(item),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E32),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: item.gradientColors[0].withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: Container(
                      width: 100,
                      height: 110,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: item.gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          item.thumbnailIcon,
                          size: 44,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ),

                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category
                          Text(
                            item.category,
                            style: TextStyle(
                              color: item.gradientColors[0],
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Title
                          Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Summary
                          Text(
                            item.summary,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 11,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Source & Date
                          Row(
                            children: [
                              const Icon(Icons.newspaper,
                                  size: 11, color: Color(0xFF6B7280)),
                              const SizedBox(width: 3),
                              Text(
                                item.source,
                                style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                item.date,
                                style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
