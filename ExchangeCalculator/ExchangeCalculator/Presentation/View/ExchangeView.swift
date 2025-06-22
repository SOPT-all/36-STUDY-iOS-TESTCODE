import UIKit
import Then
import SnapKit

final class ExchangeView: UIView {
    
    let inputTextField = UITextField()
    let checkButton = UIButton()
    private let inputStackView = UIStackView()
    let exchangeTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        inputTextField.do {
            $0.placeholder = "정수로 달러를 입력하세요"
            $0.textAlignment = .center
            $0.layer.cornerRadius = 4
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.clear.cgColor
        }
        
        checkButton.do {
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .systemGray
            $0.layer.cornerRadius = 4
            $0.isEnabled = false
        }
        
        inputStackView.do {
            $0.axis = .horizontal
            $0.spacing = 30
            $0.layer.cornerRadius = 4
        }
        
        exchangeTextField.do {
            $0.textAlignment = .center
            $0.textColor = .black
            $0.layer.cornerRadius = 4
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    private func setUI() {
        inputStackView.addSubviews(inputTextField, checkButton)
        addSubviews(inputStackView, exchangeTextField)
    }
    
    private func setLayout() {
        inputStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(300)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(60)
        }
        
        inputTextField.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalTo(210)
            $0.height.equalTo(60)
        }
        
        checkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(60)
        }
        
        exchangeTextField.snp.makeConstraints {
            $0.top.equalTo(inputStackView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(60)
        }
    }
}
