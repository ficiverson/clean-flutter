class PaddingUtils {

  static getMargin(double screenHeight, double pixelRatio) {
    if (pixelRatio == 2.0 || pixelRatio == 4.0) {
      return 20.0;
    } else if (pixelRatio == 3.0) {
      return 20.0;
    } else {
      return 24.0;
    }
  }

}