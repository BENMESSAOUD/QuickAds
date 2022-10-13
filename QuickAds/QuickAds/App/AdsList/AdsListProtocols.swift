import UIKit


//MARK: - View
/// Add here your methods for communication PRESENTER -> VIEW
protocol AdsListViewProtocol: AnyObject {
    var presenter: AdsListPresenterProtocol?  { get set }
    func bind(viewModel: AdsListViewModel)
}

//MARK: - Router
/// Add here your methods for communication PRESENTER -> ROUTER
protocol AdsListRouterProtocol {
    func navigate(to module: AdsListModule.Wireframe)
}

//MARK: - Presenter
/// Add here your methods for communication VIEW -> PRESENTER
protocol AdsListPresenterProtocol {
    func handle(viewEvent: AdsListPresenterUnit.Event)
    func handle(viewAction: AdsListPresenterUnit.Action)
}

//MARK: - Interactor
/// Add here your methods for communication PRESENTER -> INTERACTOR
protocol AdsListInteractorInputProtocol {
    var presenter: AdsListInteractorOutputProtocol?  { get set }
    func loadAds()
    func loadCategories()
    func getCategoryName(id: Int64) -> String?
    func getSelectedCategoriesFilter() -> [Int64]
    func addCategoryFilter(id: Int64)
    func removeCategoryFilter(id: Int64)
}

// Add here your methods for communication INTERACTOR -> PRESENTER
protocol AdsListInteractorOutputProtocol: AnyObject {
    func updateContent(_ adsList: [ClassifiedAd], categories: [Category])
    func loadAdsDidFail(message: String)
    func loadCategoriesDidFail()
}

//MARK: - DataManager
/// Add here your methods for communication INTERACTOR -> DATA MANAGER
protocol AdsListDataManagerProtocol {
   
}
