class StringUtils {
  static String decodeHtml(String htmlString) {
    if (htmlString.isEmpty) return htmlString;
    
    // First, fix the specific issue with &amp;#8211; which is a double-encoded en dash
    String result = htmlString.replaceAll('&amp;#', '&#');
    
    // Then handle other common HTML entities
    final entities = {
      '&amp;': '&',
      '&lt;': '<',
      '&gt;': '>',
      '&quot;': '"',
      '&#39;': "'",
      '&#x27;': "'",
      '&#x2F;': '/',
      '&#8211;': '–',
      '&#8212;': '—',
      '&#8216;': '‘',
      '&#8217;': '’',
      '&#8220;': '“',
      '&#8221;': '”',
      '&#8230;': '…',
    };
    
    entities.forEach((entity, char) {
      result = result.replaceAll(entity, char);
    });
    
    return result;
  }
}
