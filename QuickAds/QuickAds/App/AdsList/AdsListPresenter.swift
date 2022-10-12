import Combine
import Foundation

enum AdsListPresenterUnit {
    enum Event {
        case viewDidLoad
    }
    enum Action {
        case tableDidSelectItem(at: Int)
        case didSelectCategoryFilter(_ id: Int64)
        case didDeselectCategoryFilter(_ id: Int64)
    }
}

final class AdsListPresenter {
    
    //MARK: Private properties
    weak private var view: AdsListViewProtocol?
    private var interactor: AdsListInteractorInputProtocol
    private let router: AdsListRouterProtocol
    private let viewModel: AdsListViewModel
    private var displayedList: [ClassifiedAd] = []
    
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
    @MainActor func handle(viewEvent: AdsListPresenterUnit.Event) {
        switch viewEvent {
        case .viewDidLoad:
            interactor.loadAll()
            view?.bind(viewModel: viewModel)
        }
    }
    
    func handle(viewAction: AdsListPresenterUnit.Action) {
        switch viewAction {
        case let .tableDidSelectItem(at: index):
            let classifiedAd = displayedList[index]
            let adModel = AdModel(
                title: classifiedAd.title,
                categoryName: interactor.getCategoryName(id: classifiedAd.category_id) ?? "",
                date: classifiedAd.creation_date,
                description: classifiedAd.description,
                isUrgent: classifiedAd.is_urgent,
                imagesUrl: classifiedAd.images_url,
                price: classifiedAd.price,
                isPro: classifiedAd.siret?.isEmpty == false
            )

            router.navigate(to: .adsDetails(adModel))
            
        case let .didSelectCategoryFilter(id):
            interactor.addCategoryFilter(id: id)
            
        case let .didDeselectCategoryFilter(id):
            interactor.removeCategoryFilter(id: id)
        }
    }
}

//MARK: - AdsList Interactor output protocol conformance
extension AdsListPresenter: AdsListInteractorOutputProtocol {
    
    func updateContent(_ adsList: [ClassifiedAd], categories: [Category]) {
        displayedList = adsList
        let selectedCategories = interactor.getSelectedCategoriesFilter()
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
        viewModel.categories = categories.map{
            CategoriesFilterRow(
                id: $0.id,
                name: $0.name,
                isSelected: selectedCategories.contains($0.id)
            )
        }
        
    }
    
    func loadAdsDidFail(message: String) {
        router.navigate(to: .alert(title: "Opps!", message: message))
    }
    
    func loadCategoriesDidFail() {
        
    }
    
}
