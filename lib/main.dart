import 'package:flutter/material.dart';
import 'custom_icons.dart';
import 'content.dart';
import 'theme.dart';
import 'widgets.dart';

void main(){
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enes Dağdelen | Portfolyo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeMode,
      home: ProfilSayfasi(
        isDark: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class ProfilSayfasi extends StatefulWidget{
  final bool isDark;
  final VoidCallback onToggleTheme;

  const ProfilSayfasi({super.key, required this.isDark, required this.onToggleTheme});

  @override
  State<ProfilSayfasi> createState() {
    return _ProfilSayfasiState();
  }
}


class _ProfilSayfasiState extends State<ProfilSayfasi>{
  int likes = 0;
  bool isLiked = false;

  void _changeLike(){
    setState(() {
      if (isLiked){
        likes--;
        isLiked = false;
      }
      else{
        likes++;
        isLiked = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = FadeSlideIn(
      child: _ProfilKarti(likes: likes, isLiked: isLiked, onLike: _changeLike),
    );
    const contact = FadeSlideIn(
      delay: Duration(milliseconds: 300),
      child: _IletisimKarti(),
    );
    const content = PortfolioContent();

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Decorative gradient header behind the cards
            Container(
              height: 280,
              decoration: const BoxDecoration(
                gradient: AppTheme.brandGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
            ),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _UstBar(isDark: widget.isDark, onToggleTheme: widget.onToggleTheme),
                        const SizedBox(height: 24),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth >= 860) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 360,
                                    child: Column(
                                      children: [profile, const SizedBox(height: 20), contact],
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  const Expanded(child: content),
                                ],
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                profile,
                                const SizedBox(height: 20),
                                content,
                                const SizedBox(height: 20),
                                contact,
                              ],
                            );
                          },
                        ),
                        const _Altbilgi(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UstBar extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const _UstBar({required this.isDark, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          const Text(
            '<Enes />',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: isDark ? 'Açık tema' : 'Koyu tema',
            onPressed: onToggleTheme,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              foregroundColor: Colors.white,
            ),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => RotationTransition(
                turns: Tween(begin: 0.75, end: 1.0).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Icon(
                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                key: ValueKey(isDark),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilKarti extends StatelessWidget {
  final int likes;
  final bool isLiked;
  final VoidCallback onLike;

  const _ProfilKarti({required this.likes, required this.isLiked, required this.onLike});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      color: scheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar with a gradient ring
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                gradient: AppTheme.brandGradient,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 56,
                backgroundColor: scheme.surfaceContainerLowest,
                child: const CircleAvatar(
                  radius: 52,
                  backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/162743017?v=4'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Enes Dağdelen',
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            ShaderMask(
              shaderCallback: (bounds) => AppTheme.brandGradient.createShader(bounds),
              child: Text(
                'Flutter Geliştirici',
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on_outlined, size: 16, color: scheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  'Bursa, Türkiye',
                  style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => goLink('https://raw.githubusercontent.com/enesdagci/flutter-portfolio-app/main/assets/cv/enesCv1.pdf'),
                    icon: CustomBrandIcon.resume(size: 20, color: scheme.onPrimary),
                    label: const Text('Özgeçmiş'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => goLink('https://github.com/Enesdagci'),
                    icon: const Icon(Icons.person_add_alt_1_outlined, size: 20),
                    label: const Text('Takip Et'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _BegeniButonu(likes: likes, isLiked: isLiked, onLike: onLike),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                _SosyalButon(
                  tooltip: 'Github',
                  icon: CustomBrandIcon.github(size: 24),
                  url: 'https://github.com/Enesdagci',
                ),
                _SosyalButon(
                  tooltip: 'Linkedin',
                  icon: CustomBrandIcon.linkedin(size: 24),
                  url: 'https://www.linkedin.com/in/enes-dağdelen-27204a2a4',
                ),
                _SosyalButon(
                  tooltip: 'LeetCode',
                  icon: CustomBrandIcon.leetCode(size: 24),
                  url: 'https://leetcode.com/u/Rico_Crasher_16/',
                ),
                _SosyalButon(
                  tooltip: 'E-posta',
                  icon: CustomBrandIcon.eMail(size: 24),
                  url: 'mailto:enesdagci1287@hotmail.com',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BegeniButonu extends StatelessWidget {
  final int likes;
  final bool isLiked;
  final VoidCallback onLike;

  const _BegeniButonu({required this.likes, required this.isLiked, required this.onLike});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const likedColor = Color(0xFFE11D48);

    return Material(
      color: isLiked ? likedColor.withValues(alpha: 0.12) : scheme.surfaceContainerHigh,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onLike,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
                  child: child,
                ),
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(isLiked),
                  color: isLiked ? likedColor : scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Beğeni Sayısı: $likes',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isLiked ? likedColor : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SosyalButon extends StatelessWidget {
  final String tooltip;
  final Widget icon;
  final String url;

  const _SosyalButon({required this.tooltip, required this.icon, required this.url});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // White background keeps the dark brand icons visible in dark mode too.
    return HoverLift(
      scale: 1.12,
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.white,
          shape: CircleBorder(side: BorderSide(color: scheme.outlineVariant)),
          elevation: 2,
          shadowColor: Colors.black26,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => goLink(url),
            child: Padding(padding: const EdgeInsets.all(12), child: icon),
          ),
        ),
      ),
    );
  }
}

class _IletisimKarti extends StatelessWidget {
  const _IletisimKarti();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.contact_mail_outlined,
      title: 'İletişim',
      child: Column(
        children: [
          const _IletisimSatiri(
            icon: Icons.map_outlined,
            title: 'Adres',
            subtitle: 'Bursa, Türkiye',
          ),
          _IletisimSatiri(
            icon: Icons.phone_outlined,
            title: 'Telefon',
            subtitle: '+905423356750',
            onTap: () => goLink('tel:+905423356750'),
          ),
          _IletisimSatiri(
            icon: Icons.email_outlined,
            title: 'E-mail',
            subtitle: 'enesdagci1287@hotmail.com',
            onTap: () => goLink('mailto:enesdagci1287@hotmail.com'),
          ),
        ],
      ),
    );
  }
}

class _IletisimSatiri extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _IletisimSatiri({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: scheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: scheme.onSecondaryContainer),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: scheme.onSurface),
      ),
      trailing: onTap == null ? null : Icon(Icons.arrow_outward, size: 18, color: scheme.onSurfaceVariant),
      onTap: onTap,
    );
  }
}

class _Altbilgi extends StatelessWidget {
  const _Altbilgi();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Text(
        '© ${DateTime.now().year} · Enes Dağdelen ·',
        textAlign: TextAlign.center,
        style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
      ),
    );
  }
}
