
import UIKit

final class AdDetailView: UIViewController {
    var presenter: AdDetailPresenterProtocol?
    private let viewFactory = ViewFactory()
    private lazy var mainStackView = UIStackView()
    private lazy var adInformationScrollView = UIScrollView()
    private lazy var adInformationStackView = UIStackView()
    private lazy var imageView = viewFactory.createImage(image: UIImage(named: "noImage"))
    

    // MARK: View Life Cycle Methods
	override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        prepareMainStackView()
        presenter?.handle(viewEvent: .viewDidLoad)
    }
    
    private func prepareMainStackView() {
        mainStackView.distribution = .fill
        mainStackView.alignment = .fill
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        view.addSubview(mainStackView)
        mainStackView.makeConstraintEqualToSuperview()
        mainStackView.addArrangedSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        prepareAdInformationScrollView()
        mainStackView.addArrangedSubview(adInformationScrollView)
    }
    
    private func prepareAdInformationScrollView() {
        adInformationStackView.distribution = .fill
        adInformationStackView.alignment = .leading
        adInformationStackView.axis = .vertical
        adInformationStackView.spacing = 8
        adInformationScrollView.addSubview(adInformationStackView)
        adInformationStackView.makeConstraintsToSuperview(constraints: [
            .topToTop(),
            .centerX()
        ])
        adInformationStackView.widthAnchor.constraint(equalTo: adInformationScrollView.widthAnchor, multiplier: 0.95).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adInformationScrollView.contentSize = adInformationStackView.bounds.size
    }
}

// MARK: - AdDetail View protocol conformance
extension AdDetailView: AdDetailViewProtocol {
    func bind(viewModel: AdDetailViewModel) {
        imageView.asyncImage(url: viewModel.imageURL)
        adInformationStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        addTitle(text: viewModel.title)
        addDateAndPro(date: viewModel.date, isPro: viewModel.isPro)
        addPriceAndUrgent(price: viewModel.price, isUrgent: viewModel.isUrgent)
        addSeparator()
        addDescriptionView(text: viewModel.description)
        addSeparator()
    }
    
    private func addTitle(text: String) {
        let titleLabel = viewFactory.createLabel(size: 18, weight: .bold, color: .black)
        titleLabel.numberOfLines = 0
        titleLabel.text = text
        adInformationStackView.addArrangedSubview(titleLabel)
    }
    
    private func addDescriptionView(text: String) {
        addTitle(text: "Description")
        let textLabel = viewFactory.createLabel(size: 13, weight: .regular, color: .black)
        textLabel.numberOfLines = 0
        textLabel.text = text
        adInformationStackView.addArrangedSubview(textLabel)
    }
    
    private func addDateAndPro(date: String, isPro: Bool) {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 20
        let dateLabel = viewFactory.createLabel(size: 13, weight: .regular, color: .darkGray)
        dateLabel.text = date
        stackView.addArrangedSubview(dateLabel)

        if isPro {
            stackView.addArrangedSubview(createProView())
        }
        
        adInformationStackView.addArrangedSubview(stackView)
    }
    
    private func createProView() -> UIView {
        let proLabel = viewFactory.createLabel(size: 13, weight: .regular, color: .black)
        proLabel.text = "PRO"
        proLabel.textAlignment = .center
        let containerView = RoundedView(color: .black, content: proLabel, padding: 3)
        return containerView
    }
    
    private func addPriceAndUrgent(price: String, isUrgent: Bool) {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 20
        let priceLabel = viewFactory.createLabel(size: 16, weight: .bold, color: .black)
        priceLabel.text = price
        stackView.addArrangedSubview(priceLabel)

        if isUrgent {
            stackView.addArrangedSubview(createIsUrgentView())
        }
        
        adInformationStackView.addArrangedSubview(stackView)
    }

    
    private func createIsUrgentView() -> UIView {
        let urgentLabel = viewFactory.createLabel(size: 13, weight: .regular, color: .red)
        urgentLabel.text = "Urgent"
        urgentLabel.textAlignment = .center
        let containerView = RoundedView(color: .red, content: urgentLabel, padding: 3)
        return containerView
    }

    private func addSeparator() {
        let separator = SeparatorView()
        adInformationStackView.addArrangedSubview(separator)
    }
}
