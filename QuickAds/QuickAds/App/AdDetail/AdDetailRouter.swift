import UIKit

enum AdDetailModule {

    /// AdDetail module configuration
    struct Configuration {
        /* Add here module configuration properties. */
        let classifiedAd: ClassifiedAd
    }
}

final class AdDetailRouter {
    typealias View = AdDetailView & AdDetailViewProtocol
    
    // MARK: Private properties
    private var view: View?
    private let configuration: AdDetailModule.Configuration

    /// Initializes the AdDetail module instance.
    /// - Parameters:
    ///   - configuration: The module's configuration.
    init(configuration: AdDetailModule.Configuration) {
        self.configuration = configuration
    }
    
    /// Create and return a new AdDetail module
    func makeInitial() -> UIViewController {
        let adDetailView = AdDetailView()
       
        let interactor = AdDetailInteractor(classifiedAd: configuration.classifiedAd)
        let presenter = AdDetailPresenter(
            view: adDetailView,
            interactor: interactor,
            router: self
        )
        adDetailView.presenter = presenter
        self.view = adDetailView
        return adDetailView
    }
}

// MARK: - AdDetail router protocol conformance
extension AdDetailRouter: AdDetailRouterProtocol {
    func close(animated: Bool) {
        view?.navigationController?.popViewController(animated: true)
    }
}
