import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/cell.dart';
import '../providers/game_provider.dart';

class CellWidget extends StatefulWidget {
  final Cell cell;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const CellWidget({
    super.key,
    required this.cell,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<CellWidget> createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    if (widget.cell.isOpened) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CellWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cell.isOpened && !oldWidget.cell.isOpened) {
      _controller.forward();
    } else if (!widget.cell.isOpened && oldWidget.cell.isOpened) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!widget.cell.isOpened && !widget.cell.isFlagged) {
          if (context.read<GameProvider>().isHapticEnabled) {
            HapticFeedback.lightImpact();
          }
          widget.onTap();
        }
      },
      onLongPress: () {
        if (!widget.cell.isOpened) {
          if (context.read<GameProvider>().isHapticEnabled) {
            HapticFeedback.mediumImpact();
          }
          widget.onLongPress();
        }
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _getCellColor(),
          borderRadius: BorderRadius.circular(4),
          boxShadow: widget.cell.isOpened
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 1,
                    offset: const Offset(1, 1),
                  ),
                ],
        ),
        child: Center(
          child: _buildCellContent(),
        ),
      ),
    );
  }

  Color _getCellColor() {
    if (widget.cell.isOpened) {
      if (widget.cell.isMine) return Colors.red.shade400;
      return Colors.grey.shade300;
    }
    return Colors.blueGrey.shade400;
  }

  Widget _buildCellContent() {
    // 1. If flagged and not opened, show flag (No scale transition based on _controller)
    if (widget.cell.isFlagged && !widget.cell.isOpened) {
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 150),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: const Icon(Icons.flag, color: Colors.red, size: 16),
          );
        },
      );
    }

    // 2. If not opened (and not flagged), show nothing
    if (!widget.cell.isOpened) return const SizedBox();

    // 3. If opened, use the scale animation for numbers/mines
    return ScaleTransition(
      scale: _scaleAnimation,
      child: _getOpenedContent(),
    );
  }

  Widget _getOpenedContent() {
    if (widget.cell.isMine) {
      return const Icon(Icons.brightness_7, color: Colors.black, size: 18);
    }
    
    if (widget.cell.nearbyMines > 0) {
      return Text(
        '${widget.cell.nearbyMines}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: _getMineCountColor(widget.cell.nearbyMines),
        ),
      );
    }
    return const SizedBox();
  }

  Color _getMineCountColor(int count) {
    switch (count) {
      case 1: return Colors.blue.shade800;
      case 2: return Colors.green.shade800;
      case 3: return Colors.red.shade800;
      case 4: return Colors.purple.shade800;
      case 5: return Colors.orange.shade900;
      case 6: return Colors.teal.shade800;
      case 7: return Colors.black;
      case 8: return Colors.grey.shade800;
      default: return Colors.black;
    }
  }
}
