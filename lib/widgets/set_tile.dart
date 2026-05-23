import 'package:flutter/material.dart';

class SetTile extends StatelessWidget {
  final int setNumber;
  final bool completed;
  final VoidCallback onTap;

  const SetTile({
    super.key,
    required this.setNumber,
    required this.completed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 250,
        ),

        margin:
            const EdgeInsets.only(
          right: 10,
          bottom: 10,
        ),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),

        decoration: BoxDecoration(
          color: completed
              ? const Color(
                  0xFF2563EB)
              : const Color(
                  0xFF334155),

          borderRadius:
              BorderRadius.circular(
                  16),
        ),

        child: Row(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            Icon(
              completed
                  ? Icons.check
                  : Icons.fitness_center,

              color: Colors.white,
              size: 18,
            ),

            const SizedBox(width: 8),

            Text(
              'Set $setNumber',

              style: const TextStyle(
                color: Colors.white,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}