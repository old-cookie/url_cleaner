# URL Cleaner Example

## Quick Start Example

```dart
import 'package:url_cleaner/url_cleaner.dart';

void main() {
  print('=== URL Cleaner Demo ===\n');

  // Initialize cleaner with common tracking parameters
  final cleaner = UrlCleaner(keywords: [
    '?utm_source',
    '?fbclid',
    '?gclid',
    '/ref=',
  ]);

  print('1. Basic Cleaning:');
  print(cleaner.cleanUrl('https://example.com/article?utm_source=twitter'));
  print('');

  print('2. Adding a new keyword:');
  cleaner.addKeyword('?msclkid');
  print('Keywords: ${cleaner.getKeywords()}');
  print('');

  print('3. Cleaning multiple URLs:');
  final urls = [
    'https://shop.com/product?fbclid=abc123',
    'https://blog.com/post?gclid=xyz789',
    'https://amazon.com/item/B08N5W/ref=sr_1_1',
  ];
  
  for (final url in urls) {
    print('  ${cleaner.cleanUrl(url)}');
  }
  print('');

  print('4. Case-insensitive matching:');
  print(cleaner.cleanUrl('https://site.com?FBCLID=test'));
  print('');

  print('5. No keyword found (trailing slash added):');
  print(cleaner.cleanUrl('https://clean-url.com/page'));
  
  print('\n=== Demo Complete ===');
}
```

## Expected Output

```
=== URL Cleaner Demo ===

1. Basic Cleaning:
https://example.com/article/

2. Adding a new keyword:
Keywords: [?utm_source, ?fbclid, ?gclid, /ref=, ?msclkid]

3. Cleaning multiple URLs:
  https://shop.com/product/
  https://blog.com/post/
  https://amazon.com/item/B08N5W/

4. Case-insensitive matching:
https://site.com/

5. No keyword found (trailing slash added):
https://clean-url.com/page/

=== Demo Complete ===
```
