import UIKit
import Then
import SnapKit

final class HomeView: UIView {
    
    private let americaImageView = UIImageView()
    let showExchangeButton = UIButton()
    
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
        americaImageView.do {
            $0.image = .america
            $0.contentMode = .scaleToFill
            $0.layer.cornerRadius = 4
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        showExchangeButton.do {
            $0.setTitle("환율 보러가기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .systemBlue
            $0.layer.cornerRadius = 3
        }
    }
    
    private func setUI() {
        addSubviews(americaImageView, showExchangeButton)
    }
    
    private func setLayout() {
        americaImageView.snp.makeConstraints {
            //$0.top.equalToSuperview().inset(50)
            $0.center.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(180)
        }
        
        showExchangeButton.snp.makeConstraints {
            $0.top.equalTo(americaImageView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(60)
        }
    }
}
