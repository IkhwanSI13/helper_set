import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

class MyDropdown<T> extends StatefulWidget {
  const MyDropdown({
    Key? key,
    required this.itemBuilder,
    this.initialValue,
    this.onSelected,
    this.onCanceled,
    this.colorText,
    this.colorBackground,
    required this.child,
  }) : super(key: key);

  final PopupMenuItemBuilder<T> itemBuilder;
  final T? initialValue;
  final PopupMenuItemSelected<T>? onSelected;
  final PopupMenuCanceled? onCanceled;
  final Widget child;
  final Color? colorText;
  final Color? colorBackground;

  @override
  _MyDropdownState<T> createState() => _MyDropdownState<T>();
}

class _MyDropdownState<T> extends State<MyDropdown<T>>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _rotation = Tween<double>(begin: 0.0, end: 180.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Curves.elasticOut,
          reverseCurve: Curves.easeInExpo),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // return ElevatedButton(
        //   onPressed: _showPopup,
        //   style: ButtonStyle(
        //       padding: MaterialStateProperty.all(
        //           EdgeInsets.symmetric(horizontal: 12.0, vertical: 12)),
        //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //       elevation: MaterialStateProperty.all(0.0),
        //       textStyle: MaterialStateProperty.all(
        //           TextStyle(color: widget.colorText ?? Colors.black)),
        //       backgroundColor: MaterialStateProperty.all(
        //           widget.colorBackground ?? Color(0xffF6F7FB))),
        return ElevatedButton(
          onPressed: _showPopup,
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              backgroundColor: widget.colorBackground ?? Color(0xffF6F7FB),
              shadowColor: Colors.greenAccent,
              elevation: 0,
              textStyle: TextStyle(color: widget.colorText ?? Colors.black)),
          child: AnimatedSize(
            duration: _controller.duration! ~/ 2,
            curve: Curves.fastOutSlowIn,
            child: Row(
              key: Key(widget.initialValue?.toString() ?? ''),
              mainAxisSize: constraints.hasTightWidth
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: widget.child,
                ),
                const SizedBox(width: 8.0),
                AnimatedBuilder(
                  animation: _rotation,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.rotate(
                      angle: radians(_rotation.value),
                      child: child,
                    );
                  },
                  child: Icon(Icons.keyboard_arrow_up, size: 24.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPopup() {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    final Rect position = Rect.fromPoints(
      button.localToGlobal(Offset.zero, ancestor: overlay),
      button.localToGlobal(button.size.bottomRight(Offset.zero),
          ancestor: overlay),
    );
    final buttonColor = Theme.of(context).primaryColor;
    final route = _PopupMenuRoute<T>(
      initialValue: widget.initialValue,
      items: widget.itemBuilder(context),
      position: position,
      shadow:
          BoxShadow(color: buttonColor, blurRadius: 6.0, spreadRadius: -2.0),
    );
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      return Navigator.of(context, rootNavigator: true)
          .push<T>(route)
          .then((T? result) {
        if (!mounted) {
          return;
        }
        if (result == null) {
          widget.onCanceled?.call();
        } else {
          widget.onSelected?.call(result);
        }
        _controller.reverse();
      });
    });
  }
}

class _PopupMenuRoute<T> extends PopupRoute<T> {
  _PopupMenuRoute({
    this.initialValue,
    required this.items,
    required this.position,
    this.shadow = const BoxShadow(
        color: Colors.black26, blurRadius: 6.0, spreadRadius: -2.0),
  });

  final List<PopupMenuEntry<T>> items;
  final T? initialValue;
  final Rect position;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  final BoxShadow shadow;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondary, Widget child) {
    final opacity =
        CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn);
    final top = Tween<double>(begin: position.top, end: position.bottom)
        .animate(opacity);
    return FadeTransition(
      opacity: opacity,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: <Widget>[
              Positioned(
                top: top.value,
                left: position.left,
                width: position.width,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: position.width,
                    maxWidth: position.width,
                    minHeight: 0.0,
                    maxHeight: constraints.maxHeight - position.bottom,
                  ),
                  child: child,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    ///pop up position
    return _PopupPanel(
      items: items,
      padding: EdgeInsets.only(top: 4.0),
      shadow: shadow,
    );
  }
}

/// Popup panel of list items
class _PopupPanel<T> extends StatelessWidget {
  const _PopupPanel({
    Key? key,
    required this.items,
    this.pointerPosition = 0.9,
    this.pointerSize = 8.0,
    required this.padding,
    this.shadow = const BoxShadow(
        color: Colors.black26, blurRadius: 6.0, spreadRadius: -2.0),
  }) : super(key: key);

  final List<PopupMenuEntry<T>> items;
  final double pointerPosition;
  final double pointerSize;
  final EdgeInsets padding;
  final BoxShadow shadow;

  @override
  Widget build(BuildContext context) {
    final border = _PopupPanelBorder(
      side: BorderSide(color: Colors.grey.shade300, width: 1.0),
      borderRadius: BorderRadius.circular(2.0),
      pointerPosition: pointerPosition,
      pointerSize: pointerSize,
      color: Colors.white,
      shadow: shadow,
    );
    return Padding(
      padding: padding + EdgeInsets.only(top: pointerSize, bottom: pointerSize),
      child: Container(
        decoration: BoxDecoration(border: border),
        child: Material(
          type: MaterialType.transparency,
          child: ListView(
            //asdasd
            primary: false,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: items,
          ),
        ),
      ),
    );
  }
}

/// Custom popup panel border with pointer positioned along the top edge.
class _PopupPanelBorder extends BoxBorder {
  const _PopupPanelBorder({
    this.side = BorderSide.none,
    this.borderRadius = BorderRadius.zero,
    this.pointerPosition = 0.9,
    this.pointerSize = 8.0,
    this.color,
    this.shadow,
  });

  /// The style of this border.
  final BorderSide side;

  @override
  BorderSide get top => side;

  @override
  BorderSide get bottom => side;

  @override
  bool get isUniform => true;

  /// The radii for each corner.
  final BorderRadiusGeometry borderRadius;

  /// The fraction across the top edge the pointer should align to.
  final double pointerPosition;

  /// The size of the pointer in logical pixels.
  final double pointerSize;

  final Color? color;

  final BoxShadow? shadow;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  ShapeBorder scale(double t) {
    return _PopupPanelBorder(
      side: side.scale(t),
      borderRadius: borderRadius * t,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect.deflate(side.width), textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final radius = borderRadius.resolve(textDirection);
    final roundedRect = radius.toRRect(rect);
    final pointerRect = roundedRect.middleRect.inflate(-pointerSize);
    final pointerPos = pointerRect.left +
        (pointerRect.width * pointerPosition.clamp(0.0, 1.0));
    return Path.combine(
      PathOperation.union,
      Path()..addRRect(roundedRect),
      Path()
        ..moveTo(pointerPos, rect.top - pointerSize)
        ..lineTo(pointerPos + pointerSize, rect.top)
        ..lineTo(pointerPos - pointerSize, rect.top)
        ..close(),
    );
  }

  @override
  void paint(Canvas canvas, Rect rect,
      {TextDirection? textDirection,
      BoxShape shape = BoxShape.rectangle,
      BorderRadius? borderRadius}) {
    final path = getOuterPath(rect, textDirection: textDirection);
    if (shadow != null) {
      final scale = 1.0 + shadow!.spreadRadius / 100;
      final center = rect.center;
      final m = Matrix4.translationValues(center.dx, center.dy, 0.0)
        ..scale(scale, scale)
        ..translate(-center.dx, -center.dy);
      canvas.drawPath(path.transform(m.storage), shadow!.toPaint());
    }
    if (color != null) {
      canvas.drawPath(path, Paint()..color = color!);
    }
    if (side.style == BorderStyle.solid) {
      canvas.drawPath(path, side.toPaint());
    }
  }
}
