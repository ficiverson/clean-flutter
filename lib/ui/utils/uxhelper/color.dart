class ColorUtils {

  static String getComplementary (String color) {
    switch (color) {
      case 'Red':
        return 'Blue';
      case 'Blue':
        return 'Red';
      case 'Black':
        return 'White';
      case 'White':
        return 'Black';
      default:
        throw new Exception('Unexpected color [$color]');
    }
  }

}