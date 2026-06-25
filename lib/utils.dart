class Utils {
  static String lowerUnicodeTextext(String textToTransform) {
    // Pattern noSymbolRegExp = RegExp(r'[^\w\s]+');
    Pattern noSymbolRegExp = RegExp(
        r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]+',
        unicode: true);
    // Pattern noSymbolRegExp = new RegExp(r'[^\w\s\d]+', unicode: true);
    return textToTransform
        .toLowerCase()
        .replaceAll(noSymbolRegExp, '')
        .replaceAll(new RegExp(r'[ôòÔ]+', unicode: false), 'o')
        .replaceAll(new RegExp(r'[àâäã]+', unicode: true), 'a')
        .replaceAll(new RegExp(r'[éèêë]+', unicode: true), 'e')
        .replaceAll(new RegExp(r'[ïîì]+', unicode: true), 'i')
        .replaceAll(new RegExp(r'[ç]+', unicode: true), 'c')
        .replaceAll(new RegExp(r'\s\s+', unicode: true), ' ');
    // return textToTransform;
  }
}
