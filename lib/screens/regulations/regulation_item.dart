import 'package:flutter/material.dart';
import 'package:library_management/utils/parameters.dart';

class RegulationItem extends StatefulWidget {
  const RegulationItem({
    super.key,
    required this.content,
    required this.regulation,
  });

  final String content;
  final String regulation;

  @override
  State<RegulationItem> createState() => _RegulationItemState();
}

class _RegulationItemState extends State<RegulationItem> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(
        () => _isHover = true,
      ),
      onHover: (_) => setState(
        () => _isHover = true,
      ),
      onExit: (_) => setState(
        () => _isHover = false,
      ),
      child: Ink(
        decoration: BoxDecoration(
          color: _isHover ? Colors.grey.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          children: [
            SizedBox(
              width: 700,
              child: Text(
                widget.content,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              ThamSoQuyDinh.getThamSo(widget.regulation),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const Spacer(),
            AnimatedSwitcher(
              /* Thời gian hiệu ứng xuất hiện */
              duration: const Duration(milliseconds: 150),
              /* Thời gian hiệu ứng biến mất */
              reverseDuration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: _isHover
                  ? IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_rounded),
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(8),
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
