import 'package:flutter_test/flutter_test.dart';
import 'package:url_cleaner/url_cleaner.dart';

void main() {
  group('UrlCleaner Basic Functionality', () {
    test('removes keyword and everything after it', () {
      final cleaner = UrlCleaner(keywords: ['?xmt']);
      expect(cleaner.cleanUrl('xxx.com/?xmt=111'), 'xxx.com/');
    });

    test('returns original URL when keyword not found', () {
      final cleaner = UrlCleaner(keywords: ['?xmt']);
      expect(cleaner.cleanUrl('xxx.com/?other=111'), 'xxx.com/?other=111/');
    });

    test('handles URL without any query parameters', () {
      final cleaner = UrlCleaner(keywords: ['?xmt']);
      expect(cleaner.cleanUrl('xxx.com/path'), 'xxx.com/path/');
    });

    test('handles empty URL', () {
      final cleaner = UrlCleaner(keywords: ['?xmt']);
      expect(cleaner.cleanUrl(''), '/');
    });

    test('returns original URL when keywords list is empty', () {
      final cleaner = UrlCleaner();
      expect(cleaner.cleanUrl('xxx.com/?xmt=111'), 'xxx.com/?xmt=111/');
    });
  });

  group('UrlCleaner Case-Insensitive Matching', () {
    test('matches keyword with different case - uppercase', () {
      final cleaner = UrlCleaner(keywords: ['?xmt']);
      expect(cleaner.cleanUrl('xxx.com/?XMT=111'), 'xxx.com/');
    });

    test('matches keyword with different case - mixed case', () {
      final cleaner = UrlCleaner(keywords: ['?utm_source']);
      expect(cleaner.cleanUrl('xxx.com/?UTM_SOURCE=google'), 'xxx.com/');
    });

    test('matches keyword with lowercase when URL has uppercase', () {
      final cleaner = UrlCleaner(keywords: ['?XMT']);
      expect(cleaner.cleanUrl('xxx.com/?xmt=111'), 'xxx.com/');
    });
  });

  group('UrlCleaner Multiple Keywords', () {
    test('removes first occurrence when multiple keywords present', () {
      final cleaner = UrlCleaner(keywords: ['?xmt', '?utm_source']);
      expect(
        cleaner.cleanUrl('xxx.com/?xmt=111&utm_source=google'),
        'xxx.com/',
      );
    });

    test('removes correct keyword when order differs', () {
      final cleaner = UrlCleaner(keywords: ['?xmt', '?utm_source']);
      expect(
        cleaner.cleanUrl('xxx.com/?utm_source=google&xmt=111'),
        'xxx.com/',
      );
    });

    test('handles multiple keywords with only one present in URL', () {
      final cleaner = UrlCleaner(keywords: ['?xmt', '?utm_source', '?fbclid']);
      expect(cleaner.cleanUrl('xxx.com/?utm_source=google'), 'xxx.com/');
    });

    test('works with many keywords', () {
      final cleaner = UrlCleaner(
        keywords: ['?xmt', '?utm_source', '?fbclid', '?gclid', '?ref'],
      );
      expect(cleaner.cleanUrl('xxx.com/path?ref=twitter'), 'xxx.com/path/');
    });
  });

  group('UrlCleaner URL Validation', () {
    test('handles invalid URL gracefully', () {
      final cleaner = UrlCleaner(keywords: ['?xmt']);
      expect(cleaner.cleanUrl('not a valid url'), 'not a valid url/');
    });

    test('handles URL with special characters', () {
      final cleaner = UrlCleaner(keywords: ['?xmt']);
      expect(
        cleaner.cleanUrl('https://example.com/path?xmt=111&other=value'),
        'https://example.com/path/',
      );
    });

    test('handles URL with fragment', () {
      final cleaner = UrlCleaner(keywords: ['?xmt']);
      expect(
        cleaner.cleanUrl('https://example.com/path?xmt=111#section'),
        'https://example.com/path/',
      );
    });

    test('handles URL with port', () {
      final cleaner = UrlCleaner(keywords: ['?xmt']);
      expect(
        cleaner.cleanUrl('https://example.com:8080/path?xmt=111'),
        'https://example.com:8080/path/',
      );
    });

    test('handles URL with authentication', () {
      final cleaner = UrlCleaner(keywords: ['?xmt']);
      expect(
        cleaner.cleanUrl('https://user:pass@example.com?xmt=111'),
        'https://user:pass@example.com/',
      );
    });
  });

  group('UrlCleaner Keyword Management', () {
    test('addKeyword adds a new keyword', () {
      final cleaner = UrlCleaner();
      cleaner.addKeyword('?xmt');
      expect(cleaner.hasKeyword('?xmt'), true);
      expect(cleaner.cleanUrl('xxx.com/?xmt=111'), 'xxx.com/');
    });

    test('addKeyword does not add duplicate', () {
      final cleaner = UrlCleaner(keywords: ['?xmt']);
      cleaner.addKeyword('?xmt');
      expect(cleaner.getKeywords().length, 1);
    });

    test('removeKeyword removes a keyword', () {
      final cleaner = UrlCleaner(keywords: ['?xmt', '?utm_source']);
      cleaner.removeKeyword('?xmt');
      expect(cleaner.hasKeyword('?xmt'), false);
      expect(cleaner.getKeywords().length, 1);
    });

    test('clearKeywords removes all keywords', () {
      final cleaner = UrlCleaner(keywords: ['?xmt', '?utm_source', '?fbclid']);
      cleaner.clearKeywords();
      expect(cleaner.getKeywords().isEmpty, true);
    });

    test('setKeywords replaces all keywords', () {
      final cleaner = UrlCleaner(keywords: ['?xmt']);
      cleaner.setKeywords(['?utm_source', '?fbclid']);
      expect(cleaner.hasKeyword('?xmt'), false);
      expect(cleaner.hasKeyword('?utm_source'), true);
      expect(cleaner.hasKeyword('?fbclid'), true);
      expect(cleaner.getKeywords().length, 2);
    });

    test('getKeywords returns a copy of the list', () {
      final cleaner = UrlCleaner(keywords: ['?xmt']);
      final keywords = cleaner.getKeywords();
      keywords.add('?utm_source');
      // Original list should not be affected
      expect(cleaner.getKeywords().length, 1);
    });

    test('hasKeyword returns false for non-existent keyword', () {
      final cleaner = UrlCleaner(keywords: ['?xmt']);
      expect(cleaner.hasKeyword('?utm_source'), false);
    });
  });

  group('UrlCleaner Edge Cases', () {
    test('handles keyword at the start of URL', () {
      final cleaner = UrlCleaner(keywords: ['http']);
      expect(cleaner.cleanUrl('https://example.com'), '/');
    });

    test('handles keyword in path', () {
      final cleaner = UrlCleaner(keywords: ['/admin']);
      expect(
        cleaner.cleanUrl('https://example.com/admin/users'),
        'https://example.com/',
      );
    });

    test('handles keyword with special regex characters', () {
      final cleaner = UrlCleaner(keywords: ['?test[123]']);
      expect(cleaner.cleanUrl('xxx.com/?test[123]=value'), 'xxx.com/');
    });

    test('handles very long URL', () {
      final cleaner = UrlCleaner(keywords: ['?xmt']);
      final longUrl = 'https://example.com/${"a" * 1000}?xmt=111';
      expect(cleaner.cleanUrl(longUrl), 'https://example.com/${"a" * 1000}/');
    });

    test('handles URL with multiple question marks', () {
      final cleaner = UrlCleaner(keywords: ['?xmt']);
      expect(
        cleaner.cleanUrl('xxx.com/?param=value?xmt=111'),
        'xxx.com/?param=value/',
      );
    });

    test('handles empty keyword', () {
      final cleaner = UrlCleaner(keywords: ['']);
      // Empty keyword would match at position 0
      expect(cleaner.cleanUrl('xxx.com/?xmt=111'), '/');
    });
  });

  group('UrlCleaner Real-World Examples', () {
    test('removes common tracking parameters', () {
      final cleaner = UrlCleaner(
        keywords: [
          '?utm_source',
          '?fbclid',
          '?gclid',
          '?msclkid',
          '?mc_cid',
          '?ref',
        ],
      );

      expect(
        cleaner.cleanUrl(
          'https://example.com/article?utm_source=twitter&utm_medium=social',
        ),
        'https://example.com/article/',
      );

      expect(
        cleaner.cleanUrl('https://example.com/product?fbclid=IwAR123456789'),
        'https://example.com/product/',
      );

      expect(
        cleaner.cleanUrl('https://example.com/page?ref=newsletter&id=xyz'),
        'https://example.com/page/',
      );
    });

    test('preserves clean URLs', () {
      final cleaner = UrlCleaner(keywords: ['?utm_source', '?fbclid']);
      expect(
        cleaner.cleanUrl('https://example.com/article'),
        'https://example.com/article/',
      );
    });

    test('works with Amazon tracking parameters', () {
      final cleaner = UrlCleaner(keywords: ['/ref=']);
      expect(
        cleaner.cleanUrl('https://amazon.com/product/B08N5WRWNW/ref=sr_1_1'),
        'https://amazon.com/product/B08N5WRWNW/',
      );
    });
  });
}
