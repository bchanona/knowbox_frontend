import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Etiqueta (Label) externa arriba del input
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Lato',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        // Campo de entrada estructurado
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(fontFamily: 'Lato', fontSize: 16),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.black38,
              fontFamily: 'Lato',
            ),
            // Fondo gris claro redondeado como en la imagen
            filled: true,
            fillColor: theme.colorScheme.surfaceContainer, // Usando color de contenedor de tu MaterialTheme
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none, // Sin bordes duros de línea
            ),
          ),
        ),
      ],
    );
  }
}