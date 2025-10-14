using System.Text;

namespace vivuvn_api.Helpers
{
    public class TextHelper
    {
        /// <summary>
        /// Normalizes Vietnamese text by removing diacritics, converting to lowercase, 
        /// and standardizing whitespace for search and comparison purposes
        /// </summary>
        /// <param name="text">The Vietnamese text to normalize</param>
        /// <param name="preserveCase">Whether to preserve the original case (default: false)</param>
        /// <returns>Normalized text suitable for search operations</returns>
        public static string NormalizeVietnameseText(string? text, bool preserveCase = false)
        {
            if (string.IsNullOrWhiteSpace(text))
                return string.Empty;

            // Step 1: Remove Vietnamese diacritics
            var normalizedString = RemoveVietnameseDiacritics(text);

            // Step 2: Convert to lowercase if not preserving case
            if (!preserveCase)
                normalizedString = normalizedString.ToLowerInvariant();

            // Step 3: Normalize whitespace
            normalizedString = NormalizeWhitespace(normalizedString);

            // Step 4: Remove special characters (optional - keep only letters, numbers, and spaces)
            normalizedString = RemoveSpecialCharacters(normalizedString);

            return normalizedString.Trim();
        }

        /// <summary>
        /// Removes Vietnamese diacritics from text while preserving the base characters
        /// </summary>
        /// <param name="text">Text containing Vietnamese characters</param>
        /// <returns>Text with diacritics removed</returns>
        private static string RemoveVietnameseDiacritics(string text)
        {
            if (string.IsNullOrEmpty(text))
                return text;

            // Vietnamese character mapping
            var vietnameseChars = new Dictionary<char, char>
            {
                // Lowercase vowels with diacritics
                {'à', 'a'}, {'á', 'a'}, {'ạ', 'a'}, {'ả', 'a'}, {'ã', 'a'},
                {'â', 'a'}, {'ầ', 'a'}, {'ấ', 'a'}, {'ậ', 'a'}, {'ẩ', 'a'}, {'ẫ', 'a'},
                {'ă', 'a'}, {'ằ', 'a'}, {'ắ', 'a'}, {'ặ', 'a'}, {'ẳ', 'a'}, {'ẵ', 'a'},

                {'è', 'e'}, {'é', 'e'}, {'ẹ', 'e'}, {'ẻ', 'e'}, {'ẽ', 'e'},
                {'ê', 'e'}, {'ề', 'e'}, {'ế', 'e'}, {'ệ', 'e'}, {'ể', 'e'}, {'ễ', 'e'},

                {'ì', 'i'}, {'í', 'i'}, {'ị', 'i'}, {'ỉ', 'i'}, {'ĩ', 'i'},

                {'ò', 'o'}, {'ó', 'o'}, {'ọ', 'o'}, {'ỏ', 'o'}, {'õ', 'o'},
                {'ô', 'o'}, {'ồ', 'o'}, {'ố', 'o'}, {'ộ', 'o'}, {'ổ', 'o'}, {'ỗ', 'o'},
                {'ơ', 'o'}, {'ờ', 'o'}, {'ớ', 'o'}, {'ợ', 'o'}, {'ở', 'o'}, {'ỡ', 'o'},

                {'ù', 'u'}, {'ú', 'u'}, {'ụ', 'u'}, {'ủ', 'u'}, {'ũ', 'u'},
                {'ư', 'u'}, {'ừ', 'u'}, {'ứ', 'u'}, {'ự', 'u'}, {'ử', 'u'}, {'ữ', 'u'},

                {'ỳ', 'y'}, {'ý', 'y'}, {'ỵ', 'y'}, {'ỷ', 'y'}, {'ỹ', 'y'},

                {'đ', 'd'},
                
                // Uppercase vowels with diacritics
                {'À', 'A'}, {'Á', 'A'}, {'Ạ', 'A'}, {'Ả', 'A'}, {'Ã', 'A'},
                {'Â', 'A'}, {'Ầ', 'A'}, {'Ấ', 'A'}, {'Ậ', 'A'}, {'Ẩ', 'A'}, {'Ẫ', 'A'},
                {'Ă', 'A'}, {'Ằ', 'A'}, {'Ắ', 'A'}, {'Ặ', 'A'}, {'Ẳ', 'A'}, {'Ẵ', 'A'},

                {'È', 'E'}, {'É', 'E'}, {'Ẹ', 'E'}, {'Ẻ', 'E'}, {'Ẽ', 'E'},
                {'Ê', 'E'}, {'Ề', 'E'}, {'Ế', 'E'}, {'Ệ', 'E'}, {'Ể', 'E'}, {'Ễ', 'E'},

                {'Ì', 'I'}, {'Í', 'I'}, {'Ị', 'I'}, {'Ỉ', 'I'}, {'Ĩ', 'I'},

                {'Ò', 'O'}, {'Ó', 'O'}, {'Ọ', 'O'}, {'Ỏ', 'O'}, {'Õ', 'O'},
                {'Ô', 'O'}, {'Ồ', 'O'}, {'Ố', 'O'}, {'Ộ', 'O'}, {'Ổ', 'O'}, {'Ỗ', 'O'},
                {'Ơ', 'O'}, {'Ờ', 'O'}, {'Ớ', 'O'}, {'Ợ', 'O'}, {'Ở', 'O'}, {'Ỡ', 'O'},

                {'Ù', 'U'}, {'Ú', 'U'}, {'Ụ', 'U'}, {'Ủ', 'U'}, {'Ũ', 'U'},
                {'Ư', 'U'}, {'Ừ', 'U'}, {'Ứ', 'U'}, {'Ự', 'U'}, {'Ử', 'U'}, {'Ữ', 'U'},

                {'Ỳ', 'Y'}, {'Ý', 'Y'}, {'Ỵ', 'Y'}, {'Ỷ', 'Y'}, {'Ỹ', 'Y'},

                {'Đ', 'D'}
            };

            var result = new StringBuilder(text.Length);

            foreach (char c in text)
            {
                if (vietnameseChars.TryGetValue(c, out char replacement))
                {
                    result.Append(replacement);
                }
                else
                {
                    result.Append(c);
                }
            }

            return result.ToString();
        }

        /// <summary>
        /// Normalizes whitespace by replacing multiple spaces with single spaces
        /// and removing leading/trailing spaces
        /// </summary>
        /// <param name="text">Text to normalize</param>
        /// <returns>Text with normalized whitespace</returns>
        private static string NormalizeWhitespace(string text)
        {
            if (string.IsNullOrEmpty(text))
                return text;

            // Replace multiple whitespace characters with single space
            var normalized = new StringBuilder();
            bool lastWasSpace = false;

            foreach (char c in text)
            {
                if (char.IsWhiteSpace(c))
                {
                    if (!lastWasSpace)
                    {
                        normalized.Append(' ');
                        lastWasSpace = true;
                    }
                }
                else
                {
                    normalized.Append(c);
                    lastWasSpace = false;
                }
            }

            return normalized.ToString();
        }

        /// <summary>
        /// Removes special characters, keeping only letters, numbers, and spaces
        /// </summary>
        /// <param name="text">Text to clean</param>
        /// <returns>Text with special characters removed</returns>
        private static string RemoveSpecialCharacters(string text)
        {
            if (string.IsNullOrEmpty(text))
                return text;

            var result = new StringBuilder();

            foreach (char c in text)
            {
                if (char.IsLetterOrDigit(c) || char.IsWhiteSpace(c))
                {
                    result.Append(c);
                }
            }

            return result.ToString();
        }

        /// <summary>
        /// Checks if two Vietnamese texts are similar after normalization
        /// </summary>
        /// <param name="text1">First text to compare</param>
        /// <param name="text2">Second text to compare</param>
        /// <returns>True if texts are similar after normalization</returns>
        public static bool AreVietnameseTextsSimilar(string? text1, string? text2)
        {
            var normalized1 = NormalizeVietnameseText(text1);
            var normalized2 = NormalizeVietnameseText(text2);

            return string.Equals(normalized1, normalized2, StringComparison.OrdinalIgnoreCase);
        }

        /// <summary>
        /// Converts Vietnamese text to a search-friendly format
        /// </summary>
        /// <param name="text">Vietnamese text to convert</param>
        /// <returns>Search-friendly text without diacritics and special characters</returns>
        public static string ToSearchFriendly(string? text)
        {
            return NormalizeVietnameseText(text, preserveCase: false);
        }
    }
}
