import UIKit


//MARK: - View
/// Add here your methods for communication PRESENTER -> VIEW
protocol AdDetailViewProtocol: AnyObject {
    var presenter: AdDetailPresenterProtocol?  { get set }
    func bind(viewModel: AdDetailViewModel)
}

//MARK: - Router
/// Add here your methods for communication PRESENTER -> ROUTER
protocol AdDetailRouterProtocol {
    func close(animated: Bool)
}

//MARK: - Presenter
/// Add here your methods for communication VIEW -> PRESENTER
protocol AdDetailPresenterProtocol {
    func handle(viewEvent: AdDetailPresenterUnit.Event)
}

//MARK: - Interactor
/// Add here your methods for communication PRESENTER -> INTERACTOR
protocol AdDetailInteractorInputProtocol {
    var presenter: AdDetailInteractorOutputProtocol?  { get set }
    var classifiedAd: ClassifiedAd { get }
}

// Add here your methods for communication INTERACTOR -> PRESENTER
protocol AdDetailInteractorOutputProtocol {
}

//MARK: - DataManager
/// Add here your methods for communication INTERACTOR -> DATA MANAGER
protocol AdDetailDataManagerProtocol {
   
}
