import UIKit


//MARK: - View
/// Add here your methods for communication PRESENTER -> VIEW
protocol AdDetailViewProtocol: AnyObject {
    var presenter: AdDetailPresenterProtocol?  { get set }
    
    /// Binds view with a given view Model
    /// - Parameter viewModel: The view model to bind.
    @MainActor func bind(viewModel: AdDetailViewModel)
}

//MARK: - Router
/// Add here your methods for communication PRESENTER -> ROUTER
protocol AdDetailRouterProtocol {
    /// Closes the current module.
    /// - Parameter animated: Determines wether the closing action should be animated.
    func close(animated: Bool)
}

//MARK: - Presenter
/// Add here your methods for communication VIEW -> PRESENTER
protocol AdDetailPresenterProtocol {
    /// Handles incoming view events.
    func handle(viewEvent: AdDetailPresenterUnit.Event)
}

//MARK: - Interactor
/// Add here your methods for communication PRESENTER -> INTERACTOR
protocol AdDetailInteractorInputProtocol {
    var presenter: AdDetailInteractorOutputProtocol?  { get set }
    
    /// Gets the ad object
    var ad: AdModel { get }
}

// Add here your methods for communication INTERACTOR -> PRESENTER
protocol AdDetailInteractorOutputProtocol: AnyObject {}
