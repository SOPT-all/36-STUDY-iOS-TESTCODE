import UIKit

final class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    
    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setTargets()
    }

    private func setView() {
        view.backgroundColor = .white
    }
    
    private func setTargets() {
        homeView.showExchangeButton.addTarget(
            self,
            action: #selector(showExchangeButtonDidTap),
            for: .touchUpInside
        )
    }
    
    @objc
    private func showExchangeButtonDidTap() {
        let viewController = ExchangeViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

#Preview {
    HomeViewController()
}
