import Foundation

enum AdDetailPresenterUnit {
    enum Event {
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
    func handle(viewEvent: AdDetailPresenterUnit.Event) {
        switch viewEvent {
        case .viewDidLoad:
            let classifiedAd = interactor.classifiedAd
            let viewModel = AdDetailViewModel(
                imageURL: classifiedAd.images_url?.thumb,
                title: classifiedAd.title,
                description: classifiedAd.description,
                category: "\(classifiedAd.category_id)",
                price: "\(classifiedAd.price) €",
                date: dateFormatter.string(from: classifiedAd.creation_date),
                isUrgent: classifiedAd.is_urgent,
                isPro: classifiedAd.siret?.isEmpty == false
            )
            view?.bind(viewModel: viewModel)
        }
    }
}

//MARK: - AdDetail Interactor output protocol conformance
extension AdDetailPresenter: AdDetailInteractorOutputProtocol {}
