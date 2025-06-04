//
//  CalculatorViewController.swift
//  CurrencyCalculator
//
//  Created by 임재현 on 6/4/25.
//

import UIKit
import SnapKit
import Then

final class CalculatorViewController: UIViewController {
   
    let fromCountryLabel = UILabel()
    let fromAmountTextField = UITextField()
    let fromAmountSuffixLabel = UILabel()
    let exchangeButton = UIButton()
    let toCountryLabel = UILabel()
    let toAmountSuffixLabel = UILabel()
    var toAmountLabels: [UILabel] = []
    var toAmountTopConstraints: [NSLayoutConstraint] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .color
        setupUI()
        setupStyle()
        setupLayout()
        fromAmountTextField.delegate = self
    }
    
    private func setupUI() {
        self.view.addSubview(fromCountryLabel)
        self.view.addSubview(fromAmountTextField)
        self.view.addSubview(fromAmountSuffixLabel)
        self.view.addSubview(exchangeButton)
        self.view.addSubview(toCountryLabel)
        self.view.addSubview(toAmountSuffixLabel)
        
    }
    
    private func setupStyle() {
        fromCountryLabel.do {
            $0.text = "🇰🇷 대한민국"
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 14)
        }
        
        fromAmountTextField.do {
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 36)
            $0.borderStyle = .none
            $0.keyboardType = .numberPad
            $0.textAlignment = .right
            $0.attributedPlaceholder = NSAttributedString(
                string: "0",
                attributes: [
                    .foregroundColor: UIColor.lightGray,
                    .font: UIFont.systemFont(ofSize: 40)
                ]
            )
        }
        
        fromAmountSuffixLabel.do {
            $0.text = " 원"
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 36)
        }
        
        exchangeButton.do {
            $0.setImage(UIImage(systemName: "arrow.left.arrow.right"), for: .normal)
            $0.tintColor = .white
            $0.isEnabled = false
        }
        
        toCountryLabel.do {
            $0.text = "🇺🇸 미국"
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 14)
        }
        
        toAmountSuffixLabel.do {
            $0.text = "달러"
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 36)
        }

    }
    
    private func setupLayout() {
        fromCountryLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        fromAmountTextField.snp.makeConstraints {
            $0.top.equalTo(fromCountryLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(70)
            $0.height.equalTo(45)
        }
        
        fromAmountSuffixLabel.snp.makeConstraints {
            $0.centerY.equalTo(fromAmountTextField.snp.centerY)
            $0.leading.equalTo(fromAmountTextField.snp.trailing).offset(5)
        }
        
        exchangeButton.snp.makeConstraints {
            $0.top.equalTo(fromAmountTextField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        toCountryLabel.snp.makeConstraints {
            $0.top.equalTo(exchangeButton.snp.bottom).offset(17)
            $0.leading.equalToSuperview().offset(20)
        }
        
        toAmountSuffixLabel.snp.makeConstraints {
            $0.top.equalTo(toCountryLabel.snp.bottom).offset(20)
            $0.trailing.equalTo(fromAmountSuffixLabel.snp.trailing)
        }
    }
    
}

extension CalculatorViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? "0"
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if updatedText.count > 13 {
            return false
        }
        
        let allowedCharacters = CharacterSet(charactersIn: "0123456789,").inverted
        let filtered = string.components(separatedBy: allowedCharacters).joined(separator: "")
        if string != filtered {
            return false
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        
        if let number = Double(updatedText.replacingOccurrences(of: ",", with: "")) {
            let formattedNumber = numberFormatter.string(from: NSNumber(value: number)) ?? ""
            textField.text = formattedNumber
            print("formattedNumber\(formattedNumber)")
            
            if let text = textField.text, !text.isEmpty {
                print("계산 시작\(text)")
                updateConversionAmount(text: text)
            }

        } else {
            textField.text = ""
        }
        
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        print("키보드 닫힘")
        
        textField.resignFirstResponder()
        
        return true
        
    }
}

extension CalculatorViewController {
    private func updateConversionAmount(text: String) {
        guard let amount = Double(text.replacingOccurrences(of: ",", with: "")) else {return}
        let rate = 1400.0
        let convertUSD = CurrencyCalculator.shared.convertToUSD(
            amount: amount,
            from: .KRW,
            to: .USD,
            rate: rate)
        let formattedUSD = String(format: "%.2f", convertUSD)
        
        print("USD로 환산된 금액: \(formattedUSD)")
        
        setuptoAmountLabels(with: formattedUSD)
    }
    
    private func setuptoAmountLabels(with text: String) {
        let formattedText = text.formattedWithCommas()
        let digits = Array(formattedText)
        var previousLabel: UILabel? = nil
        
        var totalWidth: CGFloat = 0
        var labelWidths: [CGFloat] = []

        for label in toAmountLabels {
            label.removeFromSuperview()
        }
        toAmountLabels.removeAll()
        toAmountTopConstraints.removeAll()
        
        for digit in digits {
            let toAmountLabel = createtoAmountLabel(with: String(digit))
            let labelWidth = toAmountLabel.intrinsicContentSize.width
            labelWidths.append(labelWidth)
            totalWidth += labelWidth + 5
        }

        if !labelWidths.isEmpty {
            totalWidth -= 5
        }

        for (_, digit) in digits.enumerated() {
            let toAmountLabel = createtoAmountLabel(with: String(digit))
            view.addSubview(toAmountLabel)
        
            let toAmountTopConstraint = toAmountLabel.topAnchor.constraint(equalTo: toAmountSuffixLabel.topAnchor, constant: -30)
            
            
            
            
            
            toAmountTopConstraints.append(toAmountTopConstraint)
            toAmountLabels.append(toAmountLabel)
            
            var toAmountConstraints = [toAmountTopConstraint]
            
            if let previous = previousLabel {
                toAmountConstraints.append(toAmountLabel.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: 1))
            } else {
                toAmountConstraints.append(toAmountLabel.leadingAnchor.constraint(equalTo: toAmountSuffixLabel.leadingAnchor, constant: -totalWidth + 13))
            }
            
            NSLayoutConstraint.activate(toAmountConstraints)
            previousLabel = toAmountLabel
        }

        if let lastLabel = toAmountLabels.last {
            NSLayoutConstraint.activate([
                lastLabel.trailingAnchor.constraint(equalTo: toAmountSuffixLabel.leadingAnchor, constant: -1)
            ])
        }
        
        animateDigits()
    }
    
    private func createtoAmountLabel(with text: String) -> UILabel {
        let toAmountLabel = UILabel()
        toAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        toAmountLabel.text = text
        toAmountLabel.font = UIFont.systemFont(ofSize: 36)
        toAmountLabel.textColor = .white
        toAmountLabel.alpha = 0.0
        return toAmountLabel
    }
    
    private func animateDigits() {
           DispatchQueue.main.async {
               let reversedLabels = Array(self.toAmountLabels.reversed())
               let reversedTopConstraints = Array(self.toAmountTopConstraints.reversed())
               
               for (index, (label, topConstraint)) in zip(reversedLabels, reversedTopConstraints).enumerated() {
                   let delay = Double(index) * 0.1

                   UIView.animate(withDuration: 0.3, delay: delay, options: .curveEaseInOut, animations: {
                       topConstraint.constant += 30
                       label.alpha = 1.0
                       self.view.layoutIfNeeded()
                   }, completion: nil)
               }
           }
       }
}



extension String {
    func formattedWithCommas() -> String {
        guard let number = Int(self) else { return self }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? self
    }
}
