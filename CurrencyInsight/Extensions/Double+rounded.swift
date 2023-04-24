import Foundation

extension Double {
    /// Scale: Refers to the number of digits after the decimal point in a floating-point or fixed-point number. For example, if you want to round a number to two decimal places, you would use a scale of 2.
    func rounded(scale: Int = 0, mode: NSDecimalNumber.RoundingMode = .plain) -> Double {
        let decimalValue = Decimal(self)
        var result = Decimal()
        var value = decimalValue
        NSDecimalRound(&result, &value, scale, mode)
        return NSDecimalNumber(decimal: result).doubleValue
    }
}

extension Double {
    /// Scale: Refers to the number of digits after the decimal point in a floating-point or fixed-point number. For example, if you want to round a number to two decimal places, you would use a scale of 2.
    func formatted(scale: Int = 0, mode: NSDecimalNumber.RoundingMode = .plain) throws -> String {
        let roundedValue = self.rounded(scale: scale, mode: mode)
        return String(format: "%.\(scale)f", roundedValue)
    }
}
