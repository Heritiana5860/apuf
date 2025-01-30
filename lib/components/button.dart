import 'package:app/components/text.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.screenWidth,
    required this.label,
     required GlobalKey formKey,
    this.onTap
  }) : _formKey = formKey;

  final double screenWidth;
  final String label;
  final void Function()? onTap;
    final GlobalKey _formKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red[300],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            vertical: 16,
          ),
          alignment: Alignment.center,
          child: TextWidget(
            label: label,
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// import 'package:app/components/text.dart';
// import 'package:flutter/material.dart';

// class ButtonWidget extends StatelessWidget {
//   final String text;
//   final String? scaffoldMessengerText;
//   final OutlinedBorder? shape;
//   const ButtonWidget({
//     super.key,
//     required GlobalKey formKey,
//     required this.text,
//     this.shape,
//     this.scaffoldMessengerText,
//   }) : _formKey = formKey;
//   final GlobalKey _formKey;
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         if (_formKey.currentState!.validate()) {
//           // Ajoutez ici la logique de connexion
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(scaffoldMessengerText!)),
//           );
//         }
//       },
//       style: ElevatedButton.styleFrom(
//         padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
//         shape: shape,
//         backgroundColor: Colors.red[300],
//       ),
//       child: TextWidget(
//         label: text,
//         color: Colors.white,
//         fontSize: 20,
//       ),
//     );
//   }
// }
