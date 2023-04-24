import SwiftUI

extension NorgesBank {
    public struct Currency: Codable {
        let code: String
        let name: String
        let symbol: String

          //norges bank supports this currencies
        static let AUD: Self = .init(code: "AUD", name: "Australian dollar", symbol: "$")
        static let BDT: Self = .init(code: "BDT", name: "Bangladeshi taka", symbol: "৳")
        static let BYN: Self = .init(code: "BYN", name: "Belarusian new rouble", symbol: "p.")
        static let BYR: Self = .init(code: "BYR", name: "Belarusian Ruble", symbol: "Br")
        static let BRL: Self = .init(code: "BRL", name: "Brazilian real", symbol: "R$")
        static let BGN: Self = .init(code: "BGN", name: "Bulgarian lev", symbol: "лв")
        static let CAD: Self = .init(code: "CAD", name: "Canadian dollar", symbol: "$")
        static let CNY: Self = .init(code: "CNY", name: "Chinese yuan", symbol: "¥")
        static let HRK: Self = .init(code: "HRK", name: "Croatian kuna", symbol: "kn")
        static let CZK: Self = .init(code: "CZK", name: "Czech koruna", symbol: "Kč")
        static let DKK: Self = .init(code: "DKK", name: "Danish krone", symbol: "kr.")
        static let EUR: Self = .init(code: "EUR", name: "Euro", symbol: "€")
        static let HKD: Self = .init(code: "HKD", name: "Hong Kong dollar", symbol: "HK$")
        static let HUF: Self = .init(code: "HUF", name: "Hungarian forint", symbol: "Ft")
        static let ISK: Self = .init(code: "ISK", name: "Icelandic krona", symbol: "kr")
        static let INR: Self = .init(code: "INR", name: "Indian rupee", symbol: "₹")
        static let IDR: Self = .init(code: "IDR", name: "Indonesian rupiah", symbol: "Rp")
        static let ILS: Self = .init(code: "ILS", name: "Israeli new shekel", symbol: "₪")
        static let JPY: Self = .init(code: "JPY", name: "Japanese yen", symbol: "¥")
        static let LTL: Self = .init(code: "LTL", name: "Lithuanian litas", symbol: "Lt")
        static let MYR: Self = .init(code: "MYR", name: "Malaysian ringgit", symbol: "RM")
        static let MXN: Self = .init(code: "MXN", name: "Mexican peso", symbol: "$")
        static let MMK: Self = .init(code: "MMK", name: "Myanmar kyat", symbol: "K")
        static let RON: Self = .init(code: "RON", name: "New Romanian leu", symbol: "lei")
        static let TWD: Self = .init(code: "TWD", name: "New Taiwan dollar", symbol: "NT$")
        static let NOK: Self = .init(code: "NOK", name: "Norwegian krone", symbol: "kr")
        static let NZD: Self = .init(code: "NZD", name: "New Zealand dollar", symbol: "$")
        static let PKR: Self = .init(code: "PKR", name: "Pakistani rupee", symbol: "₨")
        static let PHP: Self = .init(code: "PHP", name: "Philippine peso", symbol: "₱")
        static let PLN: Self = .init(code: "PLN", name: "Polish zloty", symbol: "zł")
        static let GBP: Self = .init(code: "GBP", name: "Pound sterling", symbol: "£")
        static let RUB: Self = .init(code: "RUB", name: "Russian rouble", symbol: "₽")
        static let SGD: Self = .init(code: "SGD", name: "Singapore dollar", symbol: "$")
        static let ZAR: Self = .init(code: "ZAR", name: "South African rand", symbol: "R")
        static let KRW: Self = .init(code: "KRW", name: "South Korean won", symbol: "₩")
        static let SEK: Self = .init(code: "SEK", name: "Swedish krona", symbol: "kr")
        static let CHF: Self = .init(code: "CHF", name: "Swiss franc", symbol: "CHF")
        static let THB: Self = .init(code: "THB", name: "Thai baht", symbol: "฿")
        static let TRY: Self = .init(code: "TRY", name: "Turkish lira", symbol: "TL")
        static let VND: Self = .init(code: "VND", name: "Vietnamese dong", symbol: "₫")
        static let USD: Self = .init(code: "USD", name: "US dollar", symbol: "$")

        static let TWI: Self = .init(code: "TWI", name: "Trade-weighted krone exchange rate", symbol: "")
        static let I44: Self = .init(code: "I44", name: "Import-weighted krone exchange rate", symbol: "")
        static let XDR: Self = .init(code: "XDR", name: "IMF, special drawing rights", symbol: "")
    }
}

extension NorgesBank.Currency: Identifiable, Hashable {
    public var id: String { code }
}

extension NorgesBank.Currency {
    var flag: Image {
        Image("Flag_of_\(self.code)", bundle: Bundle.main)
    }
}
extension NorgesBank.Currency: CaseIterable, CustomStringConvertible {
    public static var allCases: [NorgesBank.Currency] {
        return Self.allCurrencies
    }

    public var description: String {
        self.code
    }
}



extension NorgesBank.Currency {
    static var allCurrencies: [NorgesBank.Currency] {
        [
            .AUD,
            .BDT,
            .BYN,
            .BYR,
            .BRL,
            .BGN,
            .CAD,
            .CNY,
            .HRK,
            .CZK,
            .DKK,
            .EUR,
            .HKD,
            .HUF,
            .ISK,
            .INR,
            .IDR,
            .ILS,
            .JPY,
            .LTL,
            .MYR,
            .MXN,
            .MMK,
            .RON,
            .TWD,
            .NOK,
            .NZD,
            .PKR,
            .PHP,
            .PLN,
            .GBP,
            .RUB,
            .SGD,
            .ZAR,
            .KRW,
            .SEK,
            .CHF,
            .THB,
            .TRY,
            .VND,
            .USD,
            .I44,
            .XDR,
            .TWI,

        ]
    }
}

extension NorgesBank.Currency {
    static func map(_ value: String) -> Self? {
        allCurrencies.first(where: { $0.code == value.uppercased() })
    }
}
