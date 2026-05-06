import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plant_it_fe/screens/shared/app_theme.dart';

class PrototypeScaffold extends StatelessWidget {
  final Widget child;
  final bool includeBottomSafeArea;

  const PrototypeScaffold({
    super.key,
    required this.child,
    this.includeBottomSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(bottom: includeBottomSafeArea, child: child),
    );
  }
}

class AssetIcon extends StatelessWidget {
  final String name;
  final double size;
  final Color color;

  const AssetIcon({
    super.key,
    required this.name,
    this.size = 24,
    this.color = AppColors.text,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$name.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const AssetIcon(name: 'menu', size: 28),
      padding: EdgeInsets.zero,
      alignment: Alignment.centerLeft,
    );
  }
}

class RoundIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final Color color;
  final double size;

  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color = AppColors.navDark,
    this.size = 42,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
        ),
        child: icon,
      ),
    );
  }
}

class PrototypeBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const PrototypeBottomNav({
    super.key,
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(
            label: '홈',
            icon: 'home',
            selected: index == 0,
            onTap: () => onChanged(0),
          ),
          _NavItem(
            label: '내 식물',
            icon: 'plant',
            selected: index == 1,
            onTap: () => onChanged(1),
          ),
          _NavItem(
            label: '도감',
            icon: 'book',
            selected: index == 2,
            onTap: () => onChanged(2),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final String icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : AppColors.text;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: selected ? 92 : 64,
        height: selected ? 64 : 56,
        decoration: BoxDecoration(
          color: selected ? AppColors.navDark : Colors.transparent,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AssetIcon(name: icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrototypeImage extends StatelessWidget {
  final String asset;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const PrototypeImage({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.asset(
        asset,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}

class CheckerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const CheckerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(26)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CustomPaint(
        painter: _CheckerPainter(),
        child: SizedBox(width: width, height: height),
      ),
    );
  }
}

class _CheckerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cell = 24.0;
    final light = Paint()..color = const Color(0xFFF4F4F4);
    final dark = Paint()..color = const Color(0xFFE1E1E1);
    for (double y = 0; y < size.height; y += cell) {
      for (double x = 0; x < size.width; x += cell) {
        final useDark = ((x / cell).floor() + (y / cell).floor()).isEven;
        canvas.drawRect(
          Rect.fromLTWH(x, y, cell, cell),
          useDark ? dark : light,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class UnderlineTextField extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscureText;
  final Widget? suffixIcon;

  const UnderlineTextField({
    super.key,
    required this.label,
    this.hint = '...',
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffixIcon,
        filled: false,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.line),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.line),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.green, width: 1.4),
        ),
      ),
    );
  }
}

void showPlantSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.navDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
