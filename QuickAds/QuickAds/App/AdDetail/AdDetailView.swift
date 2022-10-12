
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
        view.backgroundColor = Colors.mainContainer
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
        adInformationStackView.alignment = .fill
        adInformationStackView.axis = .vertical
        adInformationStackView.spacing = 8
        adInformationStackView.backgroundColor = Colors.secondaryContainer
        adInformationScrollView.backgroundColor = Colors.secondaryContainer
        adInformationScrollView.addSubview(adInformationStackView)
        adInformationStackView.makeConstraintsToSuperview(constraints: [
            .top(),
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
    @MainActor func bind(viewModel: AdDetailViewModel) {
        imageView.asyncImage(url: viewModel.imageURL)
        adInformationStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        addSeparator()
        addTitle(text: viewModel.title)
        addCategoryAndPro(text: viewModel.category, isPro: viewModel.isPro)
        addDate(date: viewModel.date)
        addPriceAndUrgent(price: viewModel.price, isUrgent: viewModel.isUrgent)
        addSeparator()
        addDescriptionView(text: viewModel.description)
        addSeparator()
    }
    
    private func addTitle(text: String) {
        let titleLabel = viewFactory.createLabel(size: 18, weight: .bold, color: Colors.primaryBlack)
        titleLabel.numberOfLines = 0
        titleLabel.text = text
        adInformationStackView.addArrangedSubview(titleLabel)
    }
    
    private func addCategoryAndPro(text: String, isPro: Bool) {
        let contentView = UIView()
        let categoryLabel = viewFactory.createLabel(size: 13, weight: .regular, color: Colors.primaryBlack)
        categoryLabel.text = text
        contentView.addSubview(categoryLabel)
        categoryLabel.makeConstraintsToSuperview(constraints: [
            .top(),
            .leading(),
            .centerY()
        ])
        if isPro {
            let proView = createProView()
            contentView.addSubview(proView)
            proView.makeConstraints(constraints: [.horizontal(.equals(10))], view: categoryLabel)
            proView.makeConstraintsToSuperview(constraints: [.top(), .centerY()])
        }
        
        adInformationStackView.addArrangedSubview(contentView)

    }
    
    private func addDescriptionView(text: String) {
        addTitle(text: "Description")
        let textLabel = viewFactory.createLabel(size: 13, weight: .regular, color: Colors.primaryBlack)
        textLabel.numberOfLines = 0
        textLabel.text = text
        adInformationStackView.addArrangedSubview(textLabel)
    }
    
    private func addDate(date: String) {
        let dateLabel = viewFactory.createLabel(size: 13, weight: .regular, color: Colors.primaryGray)
        dateLabel.text = date
        
        adInformationStackView.addArrangedSubview(dateLabel)
    }
    
    private func createProView() -> UIView {
        let proLabel = viewFactory.createLabel(size: 13, weight: .regular, color: Colors.primaryBlack)
        proLabel.text = "PRO"
        proLabel.textAlignment = .center
        let roundedContainerView = viewFactory.createRoundedContainerView(content: proLabel)
        return roundedContainerView
    }
    
    private func addPriceAndUrgent(price: String, isUrgent: Bool) {
        let contentView = UIView()
        let priceLabel = viewFactory.createLabel(size: 16, weight: .bold, color: Colors.primaryOrange)
        priceLabel.text = price
        contentView.addSubview(priceLabel)
        priceLabel.makeConstraintsToSuperview(constraints: [
            .top(),
            .leading(),
            .centerY()
        ])
        
        if isUrgent {
            let urgentView = createIsUrgentView()
            contentView.addSubview(urgentView)
            urgentView.makeConstraints(constraints: [.horizontal(.equals(10))], view: priceLabel)
            urgentView.makeConstraintsToSuperview(constraints: [.top(), .centerY()])
            
        }
        
        adInformationStackView.addArrangedSubview(contentView)
    }

    
    private func createIsUrgentView() -> UIView {
        let urgentLabel = viewFactory.createLabel(size: 13, weight: .regular, color: .red)
        urgentLabel.text = "Urgent"
        urgentLabel.textAlignment = .center
        let containerView =  viewFactory.createRoundedContainerView(content: urgentLabel, borderColor: .red)
        return containerView
    }

    private func addSeparator() {
        let separator = viewFactory.createSeparatorView()
        adInformationStackView.addArrangedSubview(separator)
    }
}
