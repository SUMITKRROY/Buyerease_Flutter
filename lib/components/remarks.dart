import 'package:flutter/material.dart';

class Remarks extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  const Remarks({super.key, this.initialValue, this.onChanged, this.controller});

  @override
  State<Remarks> createState() => _RemarksState();
}

class _RemarksState extends State<Remarks> {
  TextEditingController? _internalController;
  TextEditingController get _controller => widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController(text: widget.initialValue ?? '');
      _internalController!.addListener(_handleChange);
    }
  }

  @override
  void didUpdateWidget(covariant Remarks oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.initialValue != widget.initialValue) {
      _internalController?.text = widget.initialValue ?? '';
    }
  }

  void _handleChange() {
    if (widget.onChanged != null) {
      widget.onChanged!(_controller.text);
    }
  }

  @override
  void dispose() {
    if (_internalController != null) {
      _internalController!.removeListener(_handleChange);
      _internalController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Remark",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: _controller,
          maxLines: 4,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter remarks here...",
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          onChanged: (value) {
            // Already handled by controller listener
          },
        ),
      ],
    );
  }
}
