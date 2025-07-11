import 'package:flutter/material.dart';

class AddImageButton extends StatelessWidget {
  final bool isImageContain;
  final void Function() onAddImagePressed;
  final void Function() onRemoveImagePressed;

  const AddImageButton({
    super.key,
    required this.isImageContain,
    required this.onAddImagePressed,
    required this.onRemoveImagePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if(isImageContain) _buildAddOrRemoveButton("ลบรูปภาพ", const Color(0xFFFE8989), () => onRemoveImagePressed(),),
        const SizedBox(width: 8),
        _buildAddOrRemoveButton("เพิ่มรูปภาพ", const Color(0xFF444444),() => onAddImagePressed(),),
        const SizedBox(width: 12,),
      ],
    );
  }

  Widget _buildAddOrRemoveButton(
      String text,
      Color color,
      void Function() onTap,
      ) {
    return OutlinedButton(
      onPressed: () => onTap(),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        side: BorderSide(width: 2, color: color),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 20,
          fontFamily: 'Mitr',
          fontWeight: FontWeight.bold,
          height: 0,
        ),
      ),
    );
  }
}
