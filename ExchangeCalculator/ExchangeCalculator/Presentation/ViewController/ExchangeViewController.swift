import UIKit

final class ExchangeViewController: UIViewController {
    
    private let exchangeView = ExchangeView()
    private var exchangeViewModel = ExchangeViewModel()
    
    override func loadView() {
        view = exchangeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setDelegate()
        setTargets()
        bindData()
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
    
    private func bindData() {
        exchangeViewModel.onKRWCalculated = { [weak self] resultText in
            DispatchQueue.main.async {
                self?.exchangeView.exchangeTextField.text = resultText
            }
        }
        
        exchangeViewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.exchangeView.exchangeTextField.text = errorMessage
            }
        }
    }
    
    @objc
    private func checkButtonDidTap() {
        Task {
            guard let text = exchangeView.inputTextField.text,
                  let usd = Int(text) else {
                exchangeView.exchangeTextField.text = "숫자를 입력해주세요"
                return
            }
            
            exchangeViewModel.fetchAndCalculateKRW(forUSD: usd)
        }
    }
    
    @objc
    private func inputTextFieldDidChange() {
        guard let text = exchangeView.inputTextField.text, !text.isEmpty else {
            return
        }
        exchangeView.checkButton.do {
            $0.backgroundColor = .systemBlue
            $0.isEnabled = true
        }
    }
}

extension ExchangeViewController: UITextFieldDelegate {}
