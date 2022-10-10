
import UIKit
import Combine

final class AdsListView: UIViewController {
    
    enum Constant {
        static let minimumCellWidth: CGFloat = 150
        static let estimatedCellHeight: CGFloat = 200
        static let gridSpacing = NSCollectionLayoutSpacing.fixed(10)
        static let interCellGroupSpacing: CGFloat = 25
    }
    
    var presenter: AdsListPresenterProtocol?
    
    @Published private var viewModel: AdsListViewModel?
    private var cancellable = Set<AnyCancellable>()
    private var collectionView: UICollectionView!
    private var rows: [AdRow] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private var bestCellWidth: CGFloat {
        let gridWidth = UIScreen.main.bounds.width - Constant.gridSpacing.spacing
        let cellNumber  = Int(gridWidth) / Int(Constant.minimumCellWidth)
        let avaiblableSpace = gridWidth.truncatingRemainder(dividingBy: Constant.minimumCellWidth)
        return Constant.minimumCellWidth + (avaiblableSpace / CGFloat(cellNumber))
    }
    
    private var layout: UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(bestCellWidth),
            heightDimension: .estimated(Constant.estimatedCellHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: Constant.gridSpacing,
            top: nil,
            trailing: Constant.gridSpacing,
            bottom: nil
        )
        group.interItemSpacing = Constant.gridSpacing
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constant.interCellGroupSpacing

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    override func loadView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.view = collectionView
    }
    
    // MARK: View Life Cycle Methods
	override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        presenter?.handle(viewEvent: .viewDidLoad)
    }
    
    private func prepareCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.register(AdCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
}

// MARK: - AdsList View protocol conformance
extension AdsListView: AdsListViewProtocol {
    func bind(viewModel: AdsListViewModel) {
        self.viewModel = viewModel
        title = viewModel.title
        self.viewModel?
            .$rows.sink(receiveValue: { [weak self] rows in
                self?.rows = rows
            })
            .store(in: &cancellable)
    }
    func startLoading() {}
    func stopLoading() {}
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
