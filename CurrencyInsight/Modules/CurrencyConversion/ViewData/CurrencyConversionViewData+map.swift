import Foundation

// https://github.com/sdmx-twg/sdmx-json

extension CurrencyConversionViewData {
    static func map(dto: NorgesBank.ExchangeRatesResponse, configuration: CurrencyConversionConfig) -> Self? {

        var series = [ExchangeRateSerie]()

        guard let dataset = dto.data.dataSets.first else {
            print("response.data.dataSets.first does not exist?, returns")
            return nil
        }

        // take out the one, I think it can only be one
        guard let firstDimensionOservation = dto.data.structure.dimensions.observation.filter({ dimObs in
            dimObs.id == NorgesBank.NbDemensionOservationKey.TIME_PERIOD.rawValue
        }).first else {
            print("")
            return nil
        }

        var index = 0
        for datasetSerie in dataset.series {

            // Key to dimensions series
            let keyPositions = datasetSerie.key.split(separator: ":")

            var _frequncy: NorgesBank.SeriesFrequency?
            var _baseCurrency: NorgesBank.Currency?
            var _quoteCurrency: NorgesBank.Currency? // allways NOK
            var _tenor: NorgesBank.CodeValue? // allways SP - Spot

            for dimensionSerie in dto.data.structure.dimensions.series {
                guard let _keyPos = Int(keyPositions[dimensionSerie.keyPosition]) else {
                    print("String to Int issue with keyPosition?, continues")
                    continue
                }
                let value = dimensionSerie.values[_keyPos]

                switch dimensionSerie.id {
                case NorgesBank.NbDemensionSeriesKey.FREQ.rawValue:
                    _frequncy = .map(value.id)
                case NorgesBank.NbDemensionSeriesKey.BASE_CUR.rawValue:
                    _baseCurrency = .map(value.id)
                    if _baseCurrency == nil {
                        print("mapping baseCurrency faild, value.id: \(value.id) - \(value.name)")
                    }
                case NorgesBank.NbDemensionSeriesKey.QUOTE_CUR.rawValue:
                    _quoteCurrency = .map(value.id)
                case NorgesBank.NbDemensionSeriesKey.TENOR.rawValue:
                    _tenor = NorgesBank.CodeValue(code: value.id, value: value.name)
                default:

                    print("Unknown dimension series - \(dimensionSerie.id)")
                    continue
                }
            }

            // If anything is missing continue
            // if sortOrder is nil, that means that NbBaseCurrency enum value was´nt found
            // Not found because I have not listed it, or Norges Bank has changed their support off the currency
            guard let _frequncy = _frequncy else {
                print("missing frequency")
                continue
            }
            guard let _baseCurrency = _baseCurrency else {
                print("missing baseCurrency, we have -> frequency: \(_frequncy.value), quoteCurrency: \(_quoteCurrency?.code ?? "-"), tenor: \(_tenor?.value ?? "-")")
                continue
            }
            guard let _quoteCurrency = _quoteCurrency else {
                print("missing quoteCurrency")
                continue
            }
            guard let _tenor = _tenor else {
                print("missing tenor")
                continue
            }

            if _tenor.code != "SP" {
                //
                print("Unexpected tenor, got \(_tenor.code) - \(_tenor.value) when expected is SP - Spot")
                continue
            }

            var _decimals: Int?
            var _calculated: Bool?
            var _multiplier: Double?
            var _collected: String?

            dto.data.structure.attributes.series.forEach { attributeSerie in

                switch attributeSerie.id {
                case "DECIMALS":
                    _decimals = Int(attributeSerie.values[datasetSerie.value.attributes[0]].id)
                case "CALCULATED":
                    _calculated = Bool(attributeSerie.values[datasetSerie.value.attributes[1]].id)
                case "UNIT_MULT":
                    _multiplier = Double(attributeSerie.values[datasetSerie.value.attributes[2]].id)
                case "COLLECTION":
                    _collected = String(attributeSerie.values[datasetSerie.value.attributes[3]].id)
                default:
                    print("response.attributsstructure.attributes.series has an id not expected. id: \(attributeSerie.id)")
                }
            }

            guard let _decimals = _decimals else {
                print("missing decimals")
                continue
            }

            guard _calculated != nil else {
                print("missing calculated")
                continue
            }

            guard let _multiplier = _multiplier else {
                print("missing multiplier")
                continue
            }

            guard let _collected = _collected else {
                print("missing collection")
                continue
            }

            let _orginalBaseValue = Double(pow(10, Double(_multiplier)))
            let _baseValue = 1.0

            // Observations
            var _observations = [ExchangeRateObservation]()
            for nbObservation in datasetSerie.value.observations.sorted(by: { $0.key < $1.key }) {
                // key is an index - and points to date part
                let id = nbObservation.key // Int index
                // tror det kun er et item i arrayen
                // value as string
                let orginalValueAsString = nbObservation.value.first ?? "nan"
                let orginalValue = Double(orginalValueAsString) ?? Double.nan
                let oneUnitValue =  orginalValue / _orginalBaseValue
                let valueAsString = (try? oneUnitValue.formatted(scale: _decimals)) ?? "N/A"

                // From date observation
                let nbDateObservation = firstDimensionOservation.values[id]
                let key = nbDateObservation.id
                let start = nbDateObservation.start
                let end = nbDateObservation.end

                // new observation object value and dates in same serie, dates then duplicated - tja
                let observation = ExchangeRateObservation(
                    id: index,
                    value: oneUnitValue,
                    valueAsString: valueAsString,
                    key: key,
                    start: start,
                    end: end
                )

                _observations.append(observation)
            }

            let serie = ExchangeRateSerie(
                id: index,
                frequency: _frequncy,
                baseCurrency: _baseCurrency,
                baseValue: _baseValue,
                quoteCurrency: _quoteCurrency,
                quoteObservations: _observations,
                decimals: _decimals,
                collected: _collected
            )

            series.append(serie)
            index += 1
        }

        return CurrencyConversionViewData(
            baseCurrency: configuration.baseCurrency,
            multiplier: configuration.multiplier,
            series: series,
            meta: .init(prepared:  dto.meta.prepared, message: ""),
            missingSeriesCurrencies: []
        )
    }
}
