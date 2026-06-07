import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/features/search/presentation/pages/global_search_page.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

/// A lightweight search widget intended for use in app bars.
/// On submit (or when the field gains focus and the user presses enter)
/// it navigates to [GlobalSearchPage] with the current query pre-loaded.
class SearchOverlayWidget extends StatefulWidget {
  const SearchOverlayWidget({super.key});

  @override
  State<SearchOverlayWidget> createState() => _SearchOverlayWidgetState();
}

class _SearchOverlayWidgetState extends State<SearchOverlayWidget> {
  final TextEditingController _controller = TextEditingController();

  void _navigate() {
    final query = _controller.text.trim();
    context.push(
      GlobalSearchPage.routePath,
      extra: query,
    );
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      width: 220,
      child: TextField(
        controller: _controller,
        style: const TextStyle(color: ColorPallete.textPrimary, fontSize: 13),
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => _navigate(),
        onTap: _navigate, // opens the full page on focus
        decoration: InputDecoration(
          hintText: 'Search…',
          hintStyle: TextStyle(color: ColorPallete.textPrimary.withOpacity(0.4), fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: ColorPallete.textSecondary, size: 18),
          filled: true,
          fillColor: ColorPallete.backgroundSecondary,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
