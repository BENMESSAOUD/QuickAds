import Combine
import Foundation

enum AdsListPresenterUnit {
    enum Event {
        case viewDidLoad
    }
    enum Action {
        case tableDidSelectItem(at: Int)
    }
}

final class AdsListPresenter {
    
    //MARK: Private properties
    weak private var view: AdsListViewProtocol?
    private var interactor: AdsListInteractorInputProtocol
    private let router: AdsListRouterProtocol
    private let viewModel: AdsListViewModel
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM YYYY à HH:mm"
        return formatter
    }()
    
    //MARK: Life cycle
    init(
        view: AdsListViewProtocol?,
        interactor: AdsListInteractorInputProtocol,
        router: AdsListRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        viewModel = .init(title: "Annonces")
        self.interactor.presenter = self
    }

}

//MARK: - AdsList presenter protocol conformance
extension AdsListPresenter: AdsListPresenterProtocol {
    func handle(viewEvent: AdsListPresenterUnit.Event) {
        switch viewEvent {
        case .viewDidLoad:
            interactor.loadAll()
            view?.bind(viewModel: viewModel)
        }
    }
    
    func handle(viewAction: AdsListPresenterUnit.Action) {
        switch viewAction {
        case let .tableDidSelectItem(at: index):
            let ad = interactor.getAd(at: index)
            router.navigate(to: .adsDetails(ad))
        }
    }
}

//MARK: - AdsList Interactor output protocol conformance
extension AdsListPresenter: AdsListInteractorOutputProtocol {
    
    func updateContent(_ adsList: [ClassifiedAd], categories: [Category]) {
        viewModel.rows = adsList.map({ ad in
            AdRow(
                title: ad.title,
                image: ad.images_url?.small,
                price: "\(ad.price) €",
                category: categories.first(where: { $0.id == ad.category_id })?.name,
                date: dateFormatter.string(from: ad.creation_date),
                isUrgent: ad.is_urgent
            )
        })
        viewModel.categories = categories.map(\.name)
        
    }
    
    func loadAdsDidFail(message: String) {
        router.navigate(to: .alert(title: "Opps!", message: message))
    }
    
    func loadCategoriesDidFail() {
        
    }
    
}
