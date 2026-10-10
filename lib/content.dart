import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'widgets.dart';

class PortfolioContent extends StatefulWidget {
  const PortfolioContent({super.key});

  @override
  State<PortfolioContent> createState() => _PortfolioContentState();
}

class _PortfolioContentState extends State<PortfolioContent> {
  // Loaded once so rebuilds (e.g. the like button) don't reload the JSON.
  late final Future<Map<String, dynamic>> _veri = _veriyiYukle();

  Future<Map<String, dynamic>> _veriyiYukle() async {
    final String response = await rootBundle.loadString('assets/data/data.json');
    return jsonDecode(response);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _veri,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(48),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const SectionCard(
            icon: Icons.error_outline,
            title: 'Hata',
            child: Text('Veri yüklenirken hata oluştu.'),
          );
        }

        final data = snapshot.data!;
        final List deneyimler = data['deneyimler'] ?? [];
        final List yetenekler = data['yetenekler'] ?? [];
        final List projeler = data['projeler'] ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FadeSlideIn(
              delay: const Duration(milliseconds: 150),
              child: SectionCard(
                icon: Icons.person_outline,
                title: 'Hakkımda',
                child: Text(
                  data['hakkimda'] ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeSlideIn(
              delay: const Duration(milliseconds: 300),
              child: SectionCard(
                icon: Icons.auto_awesome_outlined,
                title: 'Yetenekler',
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: yetenekler
                      .map((item) => HoverLift(
                            scale: 1.06,
                            child: Chip(label: Text(item)),
                          ))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeSlideIn(
              delay: const Duration(milliseconds: 450),
              child: SectionCard(
                icon: Icons.work_outline,
                title: 'Deneyimler',
                child: Column(
                  children: [
                    for (var i = 0; i < deneyimler.length; i++)
                      _DeneyimSatiri(
                        item: deneyimler[i],
                        isLast: i == deneyimler.length - 1,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeSlideIn(
              delay: const Duration(milliseconds: 600),
              child: SectionCard(
                icon: Icons.rocket_launch_outlined,
                title: 'Projeler',
                child: _ProjelerBolumu(projeler: projeler),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// One experience entry drawn as a vertical timeline node.
class _DeneyimSatiri extends StatelessWidget {
  final Map item;
  final bool isLast;

  const _DeneyimSatiri({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                const SizedBox(height: 4),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: scheme.primaryContainer, width: 3),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: scheme.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['pozisyon'] ?? '',
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['sirket'] ?? '',
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 13, color: scheme.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Text(
                          item['donem'] ?? '',
                          style: textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item['aciklama'] ?? '',
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Project cards with category filter chips.
class _ProjelerBolumu extends StatefulWidget {
  final List projeler;

  const _ProjelerBolumu({required this.projeler});

  @override
  State<_ProjelerBolumu> createState() => _ProjelerBolumuState();
}

class _ProjelerBolumuState extends State<_ProjelerBolumu> {
  static const String _tumu = 'Tümü';
  String _secili = _tumu;

  @override
  Widget build(BuildContext context) {
    final kategoriler = <String>[
      _tumu,
      ...{for (final p in widget.projeler) p['kategori'] as String},
    ];
    final gorunen = _secili == _tumu
        ? widget.projeler
        : widget.projeler.where((p) => p['kategori'] == _secili).toList();

    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final k in kategoriler)
              ChoiceChip(
                label: Text(k),
                selected: _secili == k,
                showCheckmark: false,
                selectedColor: scheme.primary,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: _secili == k ? scheme.onPrimary : scheme.onSecondaryContainer,
                ),
                onSelected: (_) => setState(() => _secili = k),
              ),
          ],
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 14.0;
            final sutun = constraints.maxWidth >= 520 ? 2 : 1;
            final genislik = (constraints.maxWidth - spacing * (sutun - 1)) / sutun;
            // Rows of equal-height cards
            return Column(
              children: [
                for (var i = 0; i < gorunen.length; i += sutun)
                  Padding(
                    padding: EdgeInsets.only(top: i == 0 ? 0 : spacing),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var j = i; j < i + sutun; j++) ...[
                            if (j > i) const SizedBox(width: spacing),
                            SizedBox(
                              width: genislik,
                              child: j < gorunen.length ? _ProjeKarti(proje: gorunen[j]) : null,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ProjeKarti extends StatelessWidget {
  final Map proje;

  const _ProjeKarti({required this.proje});

  static IconData _kategoriIkonu(String? kategori) {
    switch (kategori) {
      case 'Mobil':
        return Icons.phone_android_outlined;
      case 'Gömülü & Robotik':
        return Icons.memory_outlined;
      case 'Yapay Zeka & Görüntü':
        return Icons.insights_outlined;
      case 'Masaüstü':
        return Icons.desktop_windows_outlined;
      case 'Web':
        return Icons.language_outlined;
      default:
        return Icons.folder_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final List teknolojiler = proje['teknolojiler'] ?? [];
    final bool ekip = proje['ekip'] == true;

    return HoverLift(
      scale: 1.02,
      child: Material(
        color: scheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: proje['link'] == null ? null : () => goLink(proje['link']),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: scheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _kategoriIkonu(proje['kategori']),
                        size: 20,
                        color: scheme.onTertiaryContainer,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        proje['ad'] ?? '',
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    if (proje['link'] != null)
                      Icon(Icons.arrow_outward, size: 18, color: scheme.onSurfaceVariant),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _Etiket(text: proje['kategori'] ?? '', color: scheme.primary),
                    if (ekip) _Etiket(text: 'Ekip projesi', color: scheme.tertiary),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  proje['aciklama'] ?? '',
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final t in teknolojiler)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          t,
                          style: textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Etiket extends StatelessWidget {
  final String text;
  final Color color;

  const _Etiket({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
