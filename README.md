# URL Cleaner

A Flutter package that removes specified keywords and everything after them from URLs. Perfect for removing tracking parameters, cleaning affiliate links, or sanitizing URLs before sharing. All URLs are normalized to end with a trailing slash.

## Features

✨ **Configurable Keywords** - Maintain a dynamic list of keywords to remove

🔍 **Case-Insensitive Matching** - Matches keywords regardless of letter case

🛡️ **Graceful Error Handling** - Returns original URL if invalid or keywords not found

✅ **URL Validation** - Validates URL format before processing

🎯 **First Match Removal** - Removes the first occurring keyword and everything after it

🔧 **Runtime Configuration** - Add, remove, or update keywords at any time

📌 **Trailing Slash Normalization** - All output URLs end with "/" for consistency

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  url_cleaner: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Usage

```dart
import 'package:url_cleaner/url_cleaner.dart';

// Create a cleaner with initial keywords
final cleaner = UrlCleaner(keywords: ['?xmt', '?utm_source']);

// Clean a URL
final cleaned = cleaner.cleanUrl('xxx.com/?xmt=111');
print(cleaned); // Output: xxx.com/
```

### Case-Insensitive Matching

```dart
final cleaner = UrlCleaner(keywords: ['?xmt']);

// Works with any case
cleaner.cleanUrl('xxx.com/?XMT=111');  // Returns: xxx.com/
cleaner.cleanUrl('xxx.com/?xmt=111');  // Returns: xxx.com/
cleaner.cleanUrl('xxx.com/?XmT=111');  // Returns: xxx.com/
```

### Adding Keywords Dynamically

```dart
// Start with an empty cleaner
final cleaner = UrlCleaner();

// Add keywords as needed
cleaner.addKeyword('?utm_source');
cleaner.addKeyword('?fbclid');
cleaner.addKeyword('?gclid');

// Remove tracking parameters from URLs
final url = 'https://example.com/article?utm_source=twitter&utm_medium=social';
final cleaned = cleaner.cleanUrl(url);
print(cleaned); // Output: https://example.com/article
```

### Managing Keywords

```dart
final cleaner = UrlCleaner(keywords: ['?xmt']);

// Add a keyword
cleaner.addKeyword('?utm_source');

// Remove a keyword
cleaner.removeKeyword('?xmt');

// Set multiple keywords at once
cleaner.setKeywords(['?fbclid', '?gclid', '?msclkid']);

// Get current keywords
final keywords = cleaner.getKeywords();
print(keywords); // ['?fbclid', '?gclid', '?msclkid']

// Check if keyword exists
if (cleaner.hasKeyword('?fbclid')) {
  print('Keyword exists');
}

// Clear all keywords
cleaner.clearKeywords();
```

### Real-World Example: Remove Common Tracking Parameters

```dart
// Create a cleaner for common tracking parameters
final cleaner = UrlCleaner(keywords: [
  '?utm_source',   // Google Analytics
  '?utm_medium',
  '?utm_campaign',
  '?fbclid',       // Facebook Click ID
  '?gclid',        // Google Click ID
  '?msclkid',      // Microsoft Click ID
  '?ref',          // Generic referrer
  '/ref=',         // Amazon tracking
]);

// Clean various URLs
final urls = [
  'https://example.com/article?utm_source=twitter',
  'https://store.com/product?fbclid=IwAR123456789',
  'https://amazon.com/item/B08N5WRWNW/ref=sr_1_1',
];

for (final url in urls) {
  print(cleaner.cleanUrl(url));
}
// Output:
// https://example.com/article/
// https://store.com/product/
// https://amazon.com/item/B08N5WRWNW/
```

## Edge Cases

### URL Not Found
If no keywords are found, the original URL is returned with a trailing slash added if needed:

```dart
final cleaner = UrlCleaner(keywords: ['?xmt']);
cleaner.cleanUrl('xxx.com/?other=111'); // Returns: xxx.com/?other=111/
```

### Invalid URL
If the URL is invalid, it's returned with a trailing slash added:

```dart
final cleaner = UrlCleaner(keywords: ['?xmt']);
cleaner.cleanUrl('not a valid url'); // Returns: not a valid url/
```

### Multiple Keywords in URL
Only the first occurring keyword is removed, and the result ends with a trailing slash:

```dart
final cleaner = UrlCleaner(keywords: ['?xmt', '?utm_source']);
cleaner.cleanUrl('xxx.com/?xmt=111&utm_source=google'); // Returns: xxx.com/
```

## API Reference

### Constructor
- `UrlCleaner({List<String>? keywords})` - Creates a cleaner with optional initial keywords

### Methods
- `String cleanUrl(String url)` - Cleans a URL by removing keywords
- `void addKeyword(String keyword)` - Adds a keyword to the list
- `void removeKeyword(String keyword)` - Removes a keyword from the list
- `void clearKeywords()` - Removes all keywords
- `void setKeywords(List<String> keywords)` - Replaces all keywords with a new list
- `List<String> getKeywords()` - Returns a copy of the keywords list
- `bool hasKeyword(String keyword)` - Checks if a keyword exists

## Additional information

This package is designed to be lightweight and efficient. It uses Dart's built-in `Uri` class for validation and performs case-insensitive string matching to ensure reliable URL cleaning. All output URLs are normalized with a trailing slash for consistency.

For issues or feature requests, please file them in the issue tracker.
