
import UIKit
import Combine

final class AdsListView: UIViewController {
    
    // MARK: - Private class constant.
    private enum Constant {
        static let minimumCellWidth: CGFloat = 150
        static let estimatedCellHeight: CGFloat = 200
        static let gridSpacing = NSCollectionLayoutSpacing.fixed(10)
        static let interCellGroupSpacing: CGFloat = 25
    }
    var presenter: AdsListPresenterProtocol?
    
    // MARK: - UI Properties
    private var collectionView: UICollectionView!
    private lazy var stackView = UIStackView(frame: .zero)
    private lazy var filterView = CategoriesFilterView(frame: .zero)
    
    // MARK: - Private properties
    @Published private var viewModel: AdsListViewModel?
    private var cancellable = Set<AnyCancellable>()
    
    /// The rows to display in the collection view.
    /// Each time the rows did set, the collectionView reloads data.
    private var rows: [AdRow] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Private computed properties
    
    /// Determines the best cell width according to the screen width and the minimum cell width defined in Constant enumeration.
    private var bestCellWidth: CGFloat {
        let cellNumber  = Int(UIScreen.main.bounds.width) / Int(Constant.minimumCellWidth)
        let gridWidth = UIScreen.main.bounds.width - CGFloat((2 + cellNumber - 1))*Constant.gridSpacing.spacing
        let avaiblableSpace = gridWidth.truncatingRemainder(dividingBy: Constant.minimumCellWidth)
        return Constant.minimumCellWidth + (avaiblableSpace / CGFloat(cellNumber))
    }
    
    /// Creates the Collection View layout using `UICollectionViewCompositionalLayout`
    private var layout: UICollectionViewCompositionalLayout {
        // Setup Items
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(bestCellWidth),
            heightDimension: .estimated(Constant.estimatedCellHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
        // setup Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: Constant.gridSpacing,
            top: Constant.gridSpacing,
            trailing: Constant.gridSpacing,
            bottom: nil
        )
        group.interItemSpacing = Constant.gridSpacing
        
        // setup Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constant.interCellGroupSpacing

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    // MARK: View Life Cycle Methods
    override func loadView() {
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        filterView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        filterView.categoriesDelegate = self
        stackView.addArrangedSubview(filterView)
        stackView.addArrangedSubview(collectionView)
        self.view = stackView
    }
    
	override func viewDidLoad() {
        super.viewDidLoad()
        stackView.distribution = .fill
        stackView.axis = .vertical
        filterView.isHidden = true
        filterView.backgroundColor = Colors.secondaryContainer
        prepareCollectionView()
        prepareNavigationBar()
        presenter?.handle(viewEvent: .viewDidLoad)
    }
    
    // MARK: - Private methods
    /// setup the collection view appearence and delegates.
    private func prepareCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = Colors.secondaryContainer
        collectionView.register(AdCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func prepareNavigationBar() {
        let filterButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "slider.horizontal.3"),
            style: .plain,
            target: self,
            action: #selector(toggleFilters)
        )
        navigationItem.rightBarButtonItem = filterButtonItem
        navigationItem.rightBarButtonItem?.tintColor = Colors.primaryBlack
    }
    
    @objc
    private func toggleFilters() {
        filterView.isHidden.toggle()
    }
}

// MARK: - AdsList View protocol conformance
extension AdsListView: AdsListViewProtocol {
    @MainActor func bind(viewModel: AdsListViewModel) {
        self.viewModel = viewModel
        title = viewModel.title
        self.viewModel?
            .$rows.sink(receiveValue: { [weak self] rows in
                self?.rows = rows
            })
            .store(in: &cancellable)
        
        self.viewModel?
            .$categories.sink(receiveValue: { [weak self] rows in
                DispatchQueue.main.async {
                    self?.navigationItem.rightBarButtonItem?.tintColor = rows.filter(\.isSelected).isEmpty ? Colors.primaryBlack : Colors.primaryOrange
                    self?.filterView.configure(rows: rows)
                }
            })
            .store(in: &cancellable)
    }
}

extension AdsListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        rows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? AdCollectionViewCell
        let item = rows[indexPath.item]
        cell?.configure(with: item)
        return cell ?? UICollectionViewCell()
    }
}

extension AdsListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.handle(viewAction: .tableDidSelectItem(at: indexPath.row))
    }
}

extension AdsListView: CategoriesViewDelegate {
    func didSelectCategory(id: Int64) {
        presenter?.handle(viewAction: .didSelectCategoryFilter(id))
    }
    
    func didDeselectCategory(id: Int64) {
        presenter?.handle(viewAction: .didDeselectCategoryFilter(id))
    }
}
