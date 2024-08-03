import Foundation
import ProgressHUD

final class PaymentPresenter {
    
    weak var viewController: PaymentViewController?
    
    private var currencies: [CurrencyModel] = [] {
        didSet {
            configViewController()
        }
    }
    
    private let paymentService: PaymentService
    
    init(paymentService: PaymentService = PaymentService()) {
        self.paymentService = paymentService
    }
    
    private func configViewController() {
        viewController?.showIsLoading(false)
        viewController?.setup(currencies: currencies)
    }
    
    func getInfo() {
        viewController?.showIsLoading(true)
        paymentService.loadCurrencies { [weak self] result in
            switch result {
            case .success(let currencies):
                self?.currencies = currencies
            case .failure(let error):
                self?.viewController?.showErrorAlert(title: "Ошибка загрузки данных", completion: { [weak self] in
                    self?.viewController?.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    func payWithCurrency(id: String) {
        viewController?.showIsLoading(true)
        paymentService.payWithCurrency(id: id) { [weak self] result in
            defer {
                self?.viewController?.showIsLoading(false)
            }
            switch result {
            case .success(let order):
                if order.success {
                    self?.viewController?.successPay()
                } else {
                    self?.viewController?.showFailurePayAlert()
                }
            case .failure(_):
                self?.viewController?.showFailurePayAlert()
            }
        }
    }
}
