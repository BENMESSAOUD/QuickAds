import Darwin

final class AdsListInteractor {
    
    weak var presenter: AdsListInteractorOutputProtocol?
    private let networkService: NetworkServiceProtocol
    private var adsList: [ClassifiedAd] = []
    private var adsCategories: [Category] = []
    private var filter: AdsFilter
    
    init(networkService: NetworkServiceProtocol, filter: AdsFilter?) {
        self.networkService = networkService
        self.filter = filter ?? .init(categories: [])
    }
    
    private func createErrorMessage(_ error: NetworkError) -> String {
        switch error {
        case .wrongURLFormat:
            return "Une erreur technqiue est survenue. Veuillez contacter le support."
        case .badJSONFormat:
            return "Structure de contenu est inconnue. Veillez réessyer ultérieurement."
        case .badRequest:
            return "Une erreur technqiue est survenue. Veillez réessyer ultérieurement."
        case .requestNotFound:
            return "Ce service est temporairement indisponible. Veillez réessyer ultérieurement."
        case .serverError:
            return "Ce service est temporairement indisponible. Veillez réessyer ultérieurement."
        case .statusCodeNotHandled:
            return "Une erreur technqiue est survenue. Veillez réessyer ultérieurement."
        case .unknown:
            return "Une erreur inconnue est survenue. Veillez réessyer ultérieurement."
        }
    }
    
    private func filtreAds(by categories: [Int64]) -> [ClassifiedAd] {
        if categories.isEmpty {
            return adsList
        }
        return adsList.filter({ categories.contains($0.category_id) })
    }
    
    private func sortUrgentAds(list: [ClassifiedAd]) -> [ClassifiedAd] {
        list.sorted(by: {
            if $0.is_urgent == $1.is_urgent {
                return $0.creation_date > $1.creation_date
            }
            return $0.is_urgent == true && $1.is_urgent == false
        })
    }
    
    private func loadAllAds() {
        Task {
            do {
                
                let result = try await networkService.fetchAds()
                switch result {
                case let .success(adsList):
                    self.adsList = self.sortUrgentAds(list: adsList)
                    
                    self.applyFilter()
                    
                case let .failure(error):
                    let message = createErrorMessage(error)
                    presenter?.loadAdsDidFail(message: message)
                }
            } catch {
                let message = createErrorMessage(.unknown)
                presenter?.loadAdsDidFail(message: message)
            }
        }
    }
    
    private func loadAllCategories() {
        Task {
            do {
                let result = try await networkService.fetchAdsCategories()
                switch result {
                case let .success(categories):
                    self.adsCategories = categories
                    self.applyFilter()
                    
                case .failure(_):
                    presenter?.loadCategoriesDidFail()
                }
            } catch {
                presenter?.loadCategoriesDidFail()
            }
        }
    }
    
    private func applyFilter() {
        let filtredList = filtreAds(by: filter.categories)
        presenter?.updateContent(filtredList, categories: adsCategories)
    }
    
    
}
 
// MARK: - AdsList Interactor Input Protocol conformance
extension AdsListInteractor: AdsListInteractorInputProtocol {
    
    func loadAll() {
        loadAllCategories()
        loadAllAds()
    }
    
    func getCategoryName(id: Int64) -> String? {
        adsCategories.first(where: { $0.id == id })?.name
    }
    
    func getSelectedCategoriesFilter() -> [Int64] {
        filter.categories
    }
    
    func addCategoryFilter(id: Int64) {
        if filter.categories.contains(id) { return }
        filter.categories.append(id)
        applyFilter()
    }
    
    func removeCategoryFilter(id: Int64) {
        filter.categories.removeAll(where: { $0 == id })
        applyFilter()
    }

}
