import 'package:flutter/material.dart';
import 'package:theatre_app/constants.dart';

class CustomButtonsTheme {
  static ThemeData lightTheme = ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        // Цвет кнопки
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return colorButtonWhiteOff;
            }
            return colorButtonWhite;
          },
        ),
        // Текст кнопки
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (Set<MaterialState> states) {
          return const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          );
        }),
        // Цвет текста
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return Colors.white;
          },
        ),
        // Тень кнопки
        elevation: MaterialStateProperty.resolveWith<double>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return 0;
            }
            return 4;
          },
        ),
        // Скругление кнопки
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        // Размеры кнопки
        minimumSize: MaterialStateProperty.resolveWith<Size>(
          (Set<MaterialState> states) {
            return const Size(180, 42);
          },
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey;
            }
            return const Color(0xFF5aa1f4);
          },
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (Set<MaterialState> states) {
            return const TextStyle(
              color: Color(0xFF5aa1f4),
              fontSize: 15.0,
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF5aa1f4),
              decorationThickness: 1.6,
            );
          },
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 1.25),
        // Толстая белая граница
        borderRadius:
            BorderRadius.circular(12.0), // Скругление границ текстового поля
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1.25),
        // Цвет границы при фокусе
        borderRadius: BorderRadius.circular(12.0),
      ),
      hintStyle: const TextStyle(color: Colors.grey),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors
                  .grey[800]!; // Цвет кнопки, когда она отключена в темной теме
            }
            return colorButtonWhite; // Использование вашего цвета кнопки
          },
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (Set<MaterialState> states) {
          return const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          );
        }),
        elevation: MaterialStateProperty.resolveWith<double>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return 0; // Высота тени для отключенной кнопки в темной теме
            }
            return 4; // Высота тени для кнопки в обычном состоянии в темной теме
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Скругление кнопки
          ),
        ),
        minimumSize: MaterialStateProperty.resolveWith<Size>(
          (Set<MaterialState> states) {
            return const Size(120, 40); // Минимальные размеры кнопки
          },
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey[
                  800]!; // Цвет текста кнопки, когда она отключена в темной теме
            }
            return colorButtonWhite; // Использование вашего цвета текста кнопки
          },
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (Set<MaterialState> states) {
            return const TextStyle(
              fontSize: 16, // Размер текста
              fontWeight: FontWeight.bold, // Жирность текста
            );
          },
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(8.0), // Скругление границ текстового поля
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue),
        // Цвет границы при фокусе
        borderRadius: BorderRadius.circular(8.0),
      ),
      // Другие свойства для текстовых полей...
    ),
  );
}
