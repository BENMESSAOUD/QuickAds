import UIKit

enum AdsListModule {

    /// AdsList module configuration
    struct Configuration {
        /* Add here module configuration properties. */
        let initialFilter: AdsFilter?
    }
    
    /// AdsList module dependencies
    struct Dependencies {
        let networkService: NetworkServiceProtocol
    }
    
    /// Enumeration of wireframes to which the module can navigate.
    enum Wireframe {
        /* Add here all module's kind to which this router can navigate according to the context. */
        case adsDetails(_ ad: AdModel)
        case alert(title: String, message: String)
    }
}

final class AdsListRouter {
    typealias View = AdsListView & AdsListViewProtocol
    
    // MARK: Private properties
    private var view: View?
    private let configuration: AdsListModule.Configuration
    private let dependencies: AdsListModule.Dependencies
    
    /// Initializes the AdsList module instance.
    /// - Parameters:
    ///   - configuration: The module's configuration.
    ///   - dependencies: The module's dependencies.
    init(
        configuration: AdsListModule.Configuration,
        dependencies: AdsListModule.Dependencies
    ) {
        self.configuration = configuration
        self.dependencies = dependencies
    }
    
    /// Create and return a new AdsList module
    func makeInitial() -> UIViewController {
        let adsListView = AdsListView()
        let interactor = AdsListInteractor(networkService: dependencies.networkService, filter: configuration.initialFilter)
        let presenter = AdsListPresenter(
            view: adsListView,
            interactor: interactor,
            router: self
        )
        adsListView.presenter = presenter
        self.view = adsListView
        return adsListView
    }
}

// MARK: - AdsList router protocol conformance
extension AdsListRouter: AdsListRouterProtocol {
    func navigate(to module: AdsListModule.Wireframe) {
        switch module {
        case let .adsDetails(ad):
            let adDetailModule = AdDetailRouter(configuration: .init(ad: ad))
            let viewController = adDetailModule.makeInitial()
            view?.navigationController?.pushViewController(viewController, animated: true)

        case .alert(title: let title, message: let message):
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            view?.present(alertController, animated: true)
        }
    }
}
