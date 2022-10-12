import Foundation

/// Enmeration of possuble view events and user action the presenter could handle.
enum AdDetailPresenterUnit {
    enum Event {
        /// Handle view did load event.
        case viewDidLoad
    }
}

final class AdDetailPresenter {
    
    //MARK: Private properties
    weak private var view: AdDetailViewProtocol?
    private var interactor: AdDetailInteractorInputProtocol
    private let router: AdDetailRouterProtocol
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM YYYY à HH:mm"
        return formatter
    }()
    
    //MARK: Life cycle
    init(
        view: AdDetailViewProtocol?,
        interactor: AdDetailInteractorInputProtocol,
        router: AdDetailRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.interactor.presenter = self
    }
}

//MARK: - AdDetail presenter protocol conformance
extension AdDetailPresenter: AdDetailPresenterProtocol {
    
    @MainActor func handle(viewEvent: AdDetailPresenterUnit.Event) {
        switch viewEvent {
        case .viewDidLoad:
            let ad = interactor.ad
            let viewModel = AdDetailViewModel(
                imageURL: ad.imagesUrl?.thumb,
                title: ad.title,
                description: ad.description,
                category: ad.categoryName,
                price: "\(ad.price) €",
                date: dateFormatter.string(from: ad.date),
                isUrgent: ad.isUrgent,
                isPro: ad.isPro
            )
            view?.bind(viewModel: viewModel)
        }
    }
}

//MARK: - AdDetail Interactor output protocol conformance
extension AdDetailPresenter: AdDetailInteractorOutputProtocol {}
