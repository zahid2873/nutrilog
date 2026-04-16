import 'package:flutter/material.dart';

// ─── PROVIDER HELPER (manual, no provider package needed) ─────────────────────

class ChangeNotifierProvider<T extends ChangeNotifier> extends StatefulWidget {
  final T Function(BuildContext) create;
  final Widget child;
  const ChangeNotifierProvider({super.key, required this.create, required this.child});

  static T of<T extends ChangeNotifier>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedNotifier<T>>()!.notifier;
  }

  @override
  State<ChangeNotifierProvider<T>> createState() =>
      _ChangeNotifierProviderState<T>();
}

class _ChangeNotifierProviderState<T extends ChangeNotifier>
    extends State<ChangeNotifierProvider<T>> {
  late T _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = widget.create(context);
    _notifier.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _notifier.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _InheritedNotifier<T>(notifier: _notifier, child: widget.child);
}

class _InheritedNotifier<T extends ChangeNotifier> extends InheritedWidget {
  final T notifier;
  const _InheritedNotifier({required this.notifier, required super.child});

  @override
  bool updateShouldNotify(_InheritedNotifier<T> old) => true;
}

class Consumer<T extends ChangeNotifier> extends StatelessWidget {
  final Widget Function(BuildContext, T, Widget?) builder;
  const Consumer({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, ChangeNotifierProvider.of<T>(context), null);
  }
}

extension ContextExtension on BuildContext {
  T read<T extends ChangeNotifier>() => ChangeNotifierProvider.of<T>(this);
}
