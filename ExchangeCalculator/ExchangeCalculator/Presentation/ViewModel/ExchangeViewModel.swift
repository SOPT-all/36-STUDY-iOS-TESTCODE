class ExchangeViewModel {
    
    let exchangeModel: ExchangeModel
    
    init(exchangeModel: ExchangeModel) {
        self.exchangeModel = exchangeModel
    }
    
    func calculateKRW(forUSD: Int) -> Int {
        let krw = convert(data : exchangeModel.data)
        return krw * forUSD
    }
    
    private func convert(data: String) -> Int {
        let newDataString = data.replacingOccurrences(of: ",", with: "")
        guard let converted = Int(newDataString) else {
            return 0
        }
        return converted
    }
}
