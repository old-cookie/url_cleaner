/// A URL cleaner that removes specified keywords and everything after them from URLs.
///
/// The cleaner supports case-insensitive keyword matching and maintains a configurable
/// list of keywords that can be modified at runtime. All output URLs are normalized to
/// end with a trailing slash (/).
///
/// Example:
/// ```dart
/// final cleaner = UrlCleaner(keywords: ['?xmt', '?utm_source']);
/// final cleaned = cleaner.cleanUrl('xxx.com/?xmt=111'); // Returns: 'xxx.com/'
/// ```
class UrlCleaner {
  /// Internal list of keywords to remove from URLs
  final List<String> _keywords;

  /// Creates a UrlCleaner with an optional initial list of keywords.
  ///
  /// [keywords] - Initial list of keywords to remove from URLs. Defaults to empty list.
  UrlCleaner({List<String>? keywords}) : _keywords = keywords ?? [];

  /// Cleans a URL by removing the first occurrence of any keyword and everything after it.
  ///
  /// The method performs case-insensitive matching of keywords. If no keywords are found
  /// or the URL is invalid, the original URL is returned with a trailing slash added if needed.
  /// All output URLs are guaranteed to end with a trailing slash (/).
  ///
  /// [url] - The URL string to clean
  ///
  /// Returns the cleaned URL string with a trailing slash, or the original URL with a trailing
  /// slash if no keywords match or URL is invalid.
  ///
  /// Example:
  /// ```dart
  /// final cleaner = UrlCleaner(keywords: ['?xmt']);
  /// cleaner.cleanUrl('xxx.com/?xmt=111'); // Returns: 'xxx.com/'
  /// cleaner.cleanUrl('xxx.com/?XMT=111'); // Returns: 'xxx.com/' (case-insensitive)
  /// cleaner.cleanUrl('xxx.com/path'); // Returns: 'xxx.com/path/' (no keywords found, slash added)
  /// ```
  String cleanUrl(String url) {
    // Validate URL format
    final uri = Uri.tryParse(url);
    if (uri == null) {
      // Return original URL if invalid, ensuring it ends with /
      return url.endsWith('/') ? url : '$url/';
    }

    // If no keywords, return original URL
    if (_keywords.isEmpty) {
      return url.endsWith('/') ? url : '$url/';
    }

    // Convert URL to lowercase for case-insensitive comparison
    final urlLower = url.toLowerCase();

    // Find the earliest occurrence of any keyword
    int earliestIndex = -1;

    for (final keyword in _keywords) {
      final keywordLower = keyword.toLowerCase();
      final index = urlLower.indexOf(keywordLower);

      // If keyword found and it's earlier than current earliest
      if (index != -1 && (earliestIndex == -1 || index < earliestIndex)) {
        earliestIndex = index;
      }
    }

    // If no keyword found, return original URL
    if (earliestIndex == -1) {
      return url.endsWith('/') ? url : '$url/';
    }

    // Return URL up to the keyword, ensuring it ends with /
    final result = url.substring(0, earliestIndex);
    return result.endsWith('/') ? result : '$result/';
  }

  /// Adds a keyword to the list of keywords to remove.
  ///
  /// [keyword] - The keyword to add
  ///
  /// Example:
  /// ```dart
  /// final cleaner = UrlCleaner();
  /// cleaner.addKeyword('?xmt');
  /// cleaner.addKeyword('?utm_source');
  /// ```
  void addKeyword(String keyword) {
    if (!_keywords.contains(keyword)) {
      _keywords.add(keyword);
    }
  }

  /// Removes a keyword from the list of keywords.
  ///
  /// [keyword] - The keyword to remove
  ///
  /// Example:
  /// ```dart
  /// cleaner.removeKeyword('?xmt');
  /// ```
  void removeKeyword(String keyword) {
    _keywords.remove(keyword);
  }

  /// Clears all keywords from the list.
  ///
  /// Example:
  /// ```dart
  /// cleaner.clearKeywords();
  /// ```
  void clearKeywords() {
    _keywords.clear();
  }

  /// Sets the keywords list to a new list, replacing all existing keywords.
  ///
  /// [keywords] - The new list of keywords
  ///
  /// Example:
  /// ```dart
  /// cleaner.setKeywords(['?xmt', '?utm_source', '?fbclid']);
  /// ```
  void setKeywords(List<String> keywords) {
    _keywords.clear();
    _keywords.addAll(keywords);
  }

  /// Returns a copy of the current keywords list.
  ///
  /// Returns a new list containing all current keywords.
  ///
  /// Example:
  /// ```dart
  /// final keywords = cleaner.getKeywords();
  /// print(keywords); // ['?xmt', '?utm_source']
  /// ```
  List<String> getKeywords() {
    return List<String>.from(_keywords);
  }

  /// Checks if a keyword exists in the list.
  ///
  /// [keyword] - The keyword to check
  ///
  /// Returns true if the keyword exists, false otherwise.
  ///
  /// Example:
  /// ```dart
  /// if (cleaner.hasKeyword('?xmt')) {
  ///   print('Keyword exists');
  /// }
  /// ```
  bool hasKeyword(String keyword) {
    return _keywords.contains(keyword);
  }
}
