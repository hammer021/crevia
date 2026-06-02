import 'package:flutter/material.dart';

class TypableText extends AnimatedWidget {
  final String text;
  final TextStyle? style;

  TypableText({
    Key? key,
    required Animation<double> animation,
    required this.text,
    this.style,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    int totalLettersCount = text.length;
    int currentLettersCount = (totalLettersCount * animation.value).round();
    return Text(
      text.substring(0, currentLettersCount),
      style: style,
    );
  }
}

class TypeableTextFormField extends StatefulWidget {
  final String finalText;
  final InputDecoration? decoration;
  final Animation<double> animation;

  const TypeableTextFormField({
    Key? key,
    required this.animation,
    required this.finalText,
    this.decoration,
  }) : super(key: key);

  @override
  State<TypeableTextFormField> createState() => TypeableTextFormFieldState();
}

class TypeableTextFormFieldState extends State<TypeableTextFormField> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.animation.addListener(() {
      int totalLettersCount = widget.finalText.length;
      int currentLettersCount =
          (totalLettersCount * widget.animation.value).round();
      if (mounted) {
        setState(() {
          controller.text = widget.finalText.substring(0, currentLettersCount);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: widget.decoration,
      controller: controller,
    );
  }
}
