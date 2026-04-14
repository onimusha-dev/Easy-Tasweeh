// import 'package:easy_tasweeh/core/models/dhikr_model.dart';
// import 'package:easy_tasweeh/core/service/dhikr_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class DhikrPicker extends ConsumerWidget {
//   const DhikrPicker({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentDhikr = ref.watch(currentDhikrProvider);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child: Text('DHIKR', style: Theme.of(context).textTheme.labelSmall),
//         ),
//         SizedBox(
//           height: 100,
//           child: ListView.separated(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             scrollDirection: Axis.horizontal,
//             itemCount: dhikrList.length,
//             separatorBuilder: (context, _) => const SizedBox(width: 10),
//             itemBuilder: (context, index) {
//               final item = dhikrList[index];
//               final isSelected = item == currentDhikr;
//               return GestureDetector(
//                 onTap: () => ref.read(currentDhikrProvider.notifier).state = item,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   curve: Curves.easeOut,
//                   width: 130,
//                   decoration: BoxDecoration(
//                     color: isSelected
//                         ? Theme.of(context).colorScheme.primary
//                         : Theme.of(context).colorScheme.surfaceContainerHighest
//                               .withValues(alpha: 0.4),
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       color: isSelected
//                           ? Theme.of(context).colorScheme.primary
//                           : Theme.of(context).colorScheme.outlineVariant,
//                       width: isSelected ? 2 : 1,
//                     ),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         item.transliteration,
//                         style: Theme.of(context).textTheme.labelMedium
//                             ?.copyWith(
//                               color: isSelected
//                                   ? Theme.of(context).colorScheme.onPrimary
//                                   : Theme.of(context).colorScheme.onSurface,
//                             ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         item.arabic,
//                         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           color: isSelected
//                               ? Theme.of(
//                                   context,
//                                 ).colorScheme.onPrimary.withValues(alpha: 0.8)
//                               : Theme.of(context).colorScheme.outline,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         item.translation,
//                         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           color: isSelected
//                               ? Theme.of(
//                                   context,
//                                 ).colorScheme.onPrimary.withValues(alpha: 0.6)
//                               : Theme.of(context).colorScheme.outline,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
