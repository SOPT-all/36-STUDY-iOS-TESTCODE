import UIKit

final class ExchangeViewController: UIViewController {
    
    private let exchangeView = ExchangeView()
    private let exchangeService = FetchExchangeService()
    private var exchangeViewModel: ExchangeViewModel?
    private var data = ""
    
    override func loadView() {
        view = exchangeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setDelegate()
        setTargets()
    }
    
    private func setView() {
        view.backgroundColor = .white
    }
    
    private func setDelegate() {
        exchangeView.do {
            $0.inputTextField.delegate = self
            $0.exchangeTextField.delegate = self
        }
    }
    
    private func setTargets() {
        exchangeView.do {
            $0.checkButton.addTarget(
                self, action: #selector(checkButtonDidTap), for: .touchUpInside
            )
            $0.inputTextField.addTarget(
                self, action: #selector(inputTextFieldDidChange), for: .editingChanged
            )
        }
    }
    
    @objc
    private func checkButtonDidTap() {
        Task {
            data = try await exchangeService.fetchExchange()
            
            exchangeViewModel = ExchangeViewModel(exchangeModel: ExchangeModel(data: data))
            
            guard let model = exchangeViewModel else {
                return
            }
            
            guard let text = exchangeView.inputTextField.text,
                  let usd = Int(text) else {
                exchangeView.exchangeTextField.text = "숫자를 입력해주세요"
                return
            }
            
            let result = model.calculateKRW(forUSD: usd)
            print(result)
            exchangeView.exchangeTextField.text = "\(result) 원"
        }
    }
    
    @objc
    private func inputTextFieldDidChange() {
        guard let text = exchangeView.inputTextField.text, !text.isEmpty else {
            return
        }
        exchangeView.checkButton.backgroundColor = .systemBlue
        exchangeView.checkButton.isEnabled = true
    }
}

extension ExchangeViewController: UITextFieldDelegate {}
