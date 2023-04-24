import Foundation

extension NumberFormatter {

    /// A shared `NumberFormatter` instance for formatting currency values without the currency symbol.
    /// Automatically uses the appropriate grouping separator and decimal separator based on the locale.
    ///
    /// Examples (assuming the locale is set to "en_US"):
    /// 1000.12 => 1,000.12
    /// 50.5 => 50.5
    /// 3500 => 3,500
    ///
    /// Examples (assuming the locale is set to "de_DE"):
    /// 1000.12 => 1.000,12
    /// 50.5 => 50,5
    /// 3500 => 3.500
    static var currencyText: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.roundingMode = .halfUp
        formatter.numberStyle = .currency

        // By default, generatesDecimalNumbers is set to false, and number(from:) returns an NSNumber.
        // If you set generatesDecimalNumbers to true, number(from:) will return an NSDecimalNumber.
        formatter.generatesDecimalNumbers = true

        formatter.alwaysShowsDecimalSeparator = false

        // The notANumberSymbol property of NumberFormatter specifies the string that the formatter should use
        // to represent "Not a Number" (NaN) values when formatting a number as a string
        // For example, if you want to format a NaN value and display a custom string instead of the default "NaN" representation,
        //        formatter.notANumberSymbol = "N/A"


        // The zeroSymbol property of NumberFormatter specifies the string that the formatter should use to
        // represent zero values when formatting a number as a string. In other words, it determines the output
        // string when a zero value is encountered during formatting.

        // For example, if you want to format a zero value and display a custom string instead of the default "0"
        // representation, you can set the zeroSymbol property like this:
        //        formatter.zeroSymbol = "Zero"

        // removes the NOK, SEK etc infront of the value
        formatter.currencySymbol = ""

        // The isLenient property of NumberFormatter is a boolean that determines whether the formatter should accept
        // input that contains some ambiguous or non-standard characters.
        // When isLenient is set to true, the formatter is more permissive with the input it receives and tries to
        // interpret it in the best possible way.
        // When isLenient is set to false, the formatter is more strict and only accepts input that adheres to the
        // specified format.
        formatter.isLenient = true

        // For Example. if true, the number 1000 would be formatted as "1 000"
        // The space is in fact the grouping seperator and could be "." and "," etc
        formatter.usesGroupingSeparator = true


        // The minmum number of digits after the decimal separator.
        // For example, if set to 2, the number 3.1 will be formatted as "3.10".
        // default 0
        formatter.minimumFractionDigits = 0

        // The maximum number of digits after the decimal separator.
        // For example, if set to 2, the number 3.1234 will be formatted as "3.12".
        // default 0,
        formatter.maximumFractionDigits = 2

        // The minimum number of significant digits displayed.
        // For example, if set to 4, the number 0.01234 will be formatted as "0.0123".
        //        formatter.minimumSignificantDigits

        // The maximum number of significant digits displayed.
        // For example, if set to 3, the number 123.45 will be formatted as "123".
        //         formatter.maximumSignificantDigits

        // The minimum number of digits before the decimal separator.
        // If the number of integer digits is less than the specified value, it will be padded with zeros.
        // For example, if set to 3, the number 45.67 will be formatted as "045.67".
        formatter.minimumIntegerDigits = 1

        // The maximum number of digits before the decimal separator.
        // If the number of integer digits is greater than the specified value,
        // the formatter will not format the number.
        // For example, if set to 3, the number 1234.56 will not be formatted.
        //        formatter.maximumIntegerDigits

        return formatter
    }()
}
