/*
 * ---------------------------
 * File : text_size.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */


enum TextSize {
  xxSmall(size: 10.0),
  xSmall(size: 12.0),
  small(size: 14.0),
  medium(size: 16.0),
  large(size: 18.0),
  xLarge(size: 20.0),
  xxLarge(size: 22.0),
  xxlLarge(size: 26.0),
  uLarge(size: 32.0);

  const TextSize({
    required this.size,
  });

  final double size;
}
