import SwiftUI

extension CurrencyInputField {
    class ViewModel: ObservableObject {
        @Published var multiplier: Double
        let currency: NorgesBank.Currency
        let formatter: NumberFormatter

        @Published var textField: String = ""
        @Published var errorMessage: String? = nil

        init(multiplier: Double, currency: NorgesBank.Currency, formatter: NumberFormatter = .currencyTextField) {
            self.multiplier = multiplier
            self.currency = currency
            self.formatter = formatter
            if let formattedValue = validateInitial(multiplier: multiplier){
                self.textField = formattedValue
            }
        }

        private func validateInitial(multiplier value: Double) -> String? {
            guard let formattedMultiplier = formatter.string(from: NSDecimalNumber(value: value)) else {
                return nil
            }
            return removePrefix(in: formattedMultiplier, prefix: formatter.groupingSeparator)
        }

        func validateTyped(input: String) {
            guard let decimalSeperator = formatter.decimalSeparator,
                  formatter.generatesDecimalNumbers == true
            else {
                assertionFailure("❌ expected to find a decimal seperator in the NumberFormatter.")
                errorMessage = "❌ formatter does not have a decimal seperator."
                return
            }

            let sanitizedInput = sanitizeCurrencyInput(
                input: input,
                decimalSeparator: decimalSeperator,
                groupingSeparator: formatter.usesGroupingSeparator ? formatter.groupingSeparator : nil,
                maximumFractionDigits: formatter.maximumFractionDigits,
                maximumIntegerDigits: formatter.maximumIntegerDigits
            )

            if let formattedNumber = formatter.number(from: sanitizedInput) {
                multiplier = formattedNumber.doubleValue

                // ⚠️ numbers like '100,' the comma will be formatted away,
                // we need some exceptions for decimal seperator
                // do we need anything for the thousand seperator
                guard
                    var formatted = formatter.string(from: NSDecimalNumber(value: formattedNumber.doubleValue))
                else {
                    // ⚠️ could not be formatted?, can I return only here?
                    assertionFailure("❌ could not be formatted?")
                    return
                }

                formatted = removePrefix(in: formatted, prefix: formatter.groupingSeparator)

                switch abs(multiplier) {
                case 0:
                    textField = sanitizedInput
                default:
                    if sanitizedInput.contains(decimalSeperator) {
                        if doesLastCharacterBelongToSet(input: sanitizedInput, characterSet: "123456789") {
                            textField = formatted
                        } else {
                            textField = sanitizedInput
                        }
                    } else {
                        textField = formatted
                    }
                }

            } else {
                print("❌ NOT A NUMBER")
                textField = sanitizedInput
                multiplier = .nan
            }
        }

        private func sanitizeCurrencyInput(
            input: String,
            decimalSeparator: String,
            groupingSeparator: String?,
            maximumFractionDigits: Int,
            maximumIntegerDigits: Int
        ) -> String {
            var validCharacters = "0123456789\(decimalSeparator)"

            if let groupingSeparator = groupingSeparator {
                validCharacters.append(groupingSeparator)
            }

             var sanitizedInput = input.filter { validCharacters.contains($0) }

            // ⚠️ remove prefixing of grouping seperator
            sanitizedInput = removePrefix(in: sanitizedInput, prefix: groupingSeparator)

            // ⚠️ Add leading zero if missing
            sanitizedInput = addLeadingZero(in: sanitizedInput, decimalSeparator: decimalSeparator)

            // ⚠️ only one decimal seperator
            sanitizedInput = removeDuplicates(of: decimalSeparator, in: sanitizedInput)

            // ⚠️ only maximum integer digits
            sanitizedInput = removeToManyIntegerDigits(
                in: sanitizedInput,
                decimalSeparator: decimalSeparator,
                groupingSeparator: groupingSeparator,
                maximumIntegerDigits: maximumIntegerDigits
            )

            // ⚠️ only maximum fraction digits
            sanitizedInput = removeToManyDecimalDigits(
                in: sanitizedInput,
                decimalSeparator: decimalSeparator,
                maximumFractionDigits: maximumFractionDigits
            )

            // Max string length
            // sanitizedInput = String(sanitizedInput.prefix(maximumIntegerDigits))

            return sanitizedInput
        }

        private func doesLastCharacterBelongToSet(input: String, characterSet: String) -> Bool {
            if let lastCharacter = input.last, characterSet.contains(lastCharacter) {
                return true
            }
            return false
        }

        private func addLeadingZero(in string: String, decimalSeparator: String) -> String {
            if let firstCharacter = string.first, decimalSeparator.contains(firstCharacter) {
                return "0\(string)"
            }
            return string
        }

        private func splitAndJoin(_ input: String, every n: Int, groupingSeparator: String?) -> String {
            guard let groupingSeparator = groupingSeparator, input.count > n else {
                return input
            }

            let reversedInput = String(input.reversed())
            var chunks: [String] = []

            var currentIndex = reversedInput.startIndex
            while currentIndex < reversedInput.endIndex {
                let remainingDistance = reversedInput.distance(from: currentIndex, to: reversedInput.endIndex)
                let offset = min(n, remainingDistance)
                let endIndex = reversedInput.index(currentIndex, offsetBy: offset)
                let chunk = String(reversedInput[currentIndex..<endIndex])
                chunks.append(chunk)
                currentIndex = endIndex
            }

            let joinedChunks = chunks.joined(separator: groupingSeparator)
            return String(joinedChunks.reversed())
        }

        private func removeDuplicates(of string: String, in inputString: String) -> String {
            guard inputString.contains(string) else { return inputString }
            var result = inputString
            let firstRange = result.range(of: string, options: [.caseInsensitive, .diacriticInsensitive])!
            let prefix = result[..<firstRange.upperBound]
            let suffix = result[firstRange.upperBound...].replacingOccurrences(of: string, with: "")
            result = prefix + suffix
            return result
        }

        private func removeToManyDecimalDigits(in string: String, decimalSeparator: String, maximumFractionDigits: Int) -> String {
            let components = string.split(separator: Character(decimalSeparator))
            if components.count == 2 {
                if components[1].count > maximumFractionDigits {
                    return "\(components[0])\(decimalSeparator)\(components[1].prefix(maximumFractionDigits))"
                }
            }
            return string
        }

        private func removeToManyIntegerDigits(in string: String, decimalSeparator: String, groupingSeparator: String?, maximumIntegerDigits: Int) -> String {
            var components = string.split(separator: Character(decimalSeparator)).map(String.init)

            if components.count >= 1 {
                var integerPart = components[0]
                if let groupingSeparator = groupingSeparator {
                    integerPart = integerPart.replacingOccurrences(of: groupingSeparator, with: "")
                }

                if integerPart.count > maximumIntegerDigits {
                    integerPart = String(integerPart.prefix(maximumIntegerDigits))
                }

                integerPart = splitAndJoin(integerPart, every: 3, groupingSeparator: groupingSeparator)

                if components.count > 1 {
                    components[0] = integerPart
                    return  components.joined(separator: decimalSeparator)
                } else {
                    return string.contains(decimalSeparator) ? integerPart.appending(decimalSeparator) : integerPart
                }

            } else {

                let newString = splitAndJoin(string, every: 3, groupingSeparator: groupingSeparator)
                return string.contains(decimalSeparator) ? newString.appending(decimalSeparator) : newString
            }
        }

        private func removePrefix(in string: String, prefix: String?) -> String {
            guard let prefix = prefix, string.hasPrefix(prefix) else {
                return string
            }
            return String(string.dropFirst(prefix.count))
        }

        private func countDecimalDigits(number: String, decimalSeperator: String) -> Int {
            let components = number.split(separator: Character(decimalSeperator))

            if components.count == 2 {
                return components[1].count
            } else {
                return 0
            }
        }
    }
}
