final class AdDetailInteractor {
    
    weak var presenter: AdDetailInteractorOutputProtocol?
    
    //MARK: Private properties
    private(set) var ad: AdModel
    
    init(ad: AdModel) {
        self.ad = ad
    }
}
 
// MARK: - AdDetail Interactor Input Protocol conformance
extension AdDetailInteractor: AdDetailInteractorInputProtocol {
}
