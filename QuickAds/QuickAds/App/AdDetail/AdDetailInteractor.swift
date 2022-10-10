

final class AdDetailInteractor {
    
    var presenter: AdDetailInteractorOutputProtocol?
    
    //MARK: Private properties
    private(set) var classifiedAd: ClassifiedAd
    private(set) var categories: [Category]
    
    init(classifiedAd: ClassifiedAd, categories: [Category]) {
        self.classifiedAd = classifiedAd
        self.categories = categories
    }
}
 
// MARK: - AdDetail Interactor Input Protocol conformance
extension AdDetailInteractor: AdDetailInteractorInputProtocol {
}
