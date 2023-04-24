import Foundation

extension NorgesBank {
    public struct CodeValue: Hashable {
        // multiple use casees
        // examples: SerieFrequence:B for buisnesss, Local: AUG for Australien dollar, sp for Spot
        var code: String
        var value: String
    }
}
