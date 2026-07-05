import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../providers/character_provider.dart';
import '../widgets/character_card.dart';
import '../widgets/empty_state.dart';
import 'character_detail_screen.dart';
import 'character_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CharacterFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: Consumer<CharacterProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            color: AppColors.wine700,
            onRefresh: provider.refreshFromApi,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _HeroHeader(provider: provider)),
                if (provider.isLoading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.wine700),
                    ),
                  )
                else if (provider.characters.isEmpty)
                  SliverFillRemaining(
                    child: provider.errorMessage != null
                        ? EmptyState(
                            icon: Icons.wifi_off_outlined,
                            message: provider.errorMessage!,
                            onRetry: provider.init,
                          )
                        : const EmptyState(),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.74,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final character = provider.characters[index];
                          return CharacterCard(
                            character: character,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CharacterDetailScreen(character: character),
                              ),
                            ),
                          );
                        },
                        childCount: provider.characters.length,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final CharacterProvider provider;

  const _HeroHeader({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 56),
          decoration: const BoxDecoration(
            gradient: AppColors.heroGradient,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -30,
                top: -40,
                child: _decorativeCircle(120, 0.08),
              ),
              Positioned(
                left: -20,
                bottom: -30,
                child: _decorativeCircle(80, 0.10),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Multiverso',
                        style: AppTheme.displayFont(fontSize: 30, color: Colors.white),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.14),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Explora personajes de todas las dimensiones',
                    style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.85)),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: -46,
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.wine900.withOpacity(0.14),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: provider.updateSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Buscar personaje',
                    prefixIcon: const Icon(Icons.search, color: AppColors.wine500),
                    filled: true,
                    fillColor: AppColors.wine50,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _FilterChip(
                        label: 'Todos',
                        selected: provider.statusFilter == StatusFilter.all,
                        onTap: () => provider.updateStatusFilter(StatusFilter.all),
                      ),
                      _FilterChip(
                        label: 'Vivo',
                        selected: provider.statusFilter == StatusFilter.alive,
                        onTap: () => provider.updateStatusFilter(StatusFilter.alive),
                      ),
                      _FilterChip(
                        label: 'Muerto',
                        selected: provider.statusFilter == StatusFilter.dead,
                        onTap: () => provider.updateStatusFilter(StatusFilter.dead),
                      ),
                      _FilterChip(
                        label: 'Desconocido',
                        selected: provider.statusFilter == StatusFilter.unknown,
                        onTap: () => provider.updateStatusFilter(StatusFilter.unknown),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
        ),
        const SizedBox(height: 46),
      ],
    );
  }

  Widget _decorativeCircle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: selected ? AppColors.buttonGradient : null,
            color: selected ? null : AppColors.wine50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
