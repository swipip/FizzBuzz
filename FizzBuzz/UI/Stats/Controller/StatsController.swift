//
//  StatsController.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 31/08/2021.
//

import UIKit

class StatsController: UIViewController {
    weak var coordinator: StatsControllerCoordinatorDelegate?
    
    // MARK: UI elements 􀯱
    var collectionMargin: CGFloat = 10
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = collectionMargin
        layout.sectionHeadersPinToVisibleBounds = true
        layout.sectionInset.top = collectionMargin
        let collection = UICollectionView(frame: .zero ,collectionViewLayout: layout)
        collection.registerHeaderNib(ofType: StatsHeader.self)
        collection.registerNib(ofType: StatCell.self)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.contentInset = .all(collectionMargin)
        collection.contentInset.bottom = 100
        return collection
    }()
    // MARK: Data Management 􀤃
    var viewModel = StatsControllerViewModel()
    
    // MARK: View life cycle 􀐰
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        viewModel.delegate = self
        
        addCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getForms()
    }
    
    // MARK: UI construction 􀤋
    private func addCollectionView() {
        let childView: UIView = collectionView
        let mView: UIView = view
        
        view.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        childView.leadingAnchor.constraint(equalTo: mView.leadingAnchor, constant: 0).isActive = true
        childView.topAnchor.constraint(equalTo: mView.topAnchor, constant: 0).isActive = true
        childView.bottomAnchor.constraint(equalTo: mView.bottomAnchor,constant: 0).isActive = true
        childView.trailingAnchor.constraint(equalTo: mView.trailingAnchor,constant: 0).isActive = true
    }
}
extension StatsController: StatsControllerViewModelDelegate {
    func statsControllerViewModel(didLoadOrdered forms: [(form: Form, hits: Int)]) {
        collectionView.reloadData()
    }
    
    func statsControllerViewModel(didLoadForms forms: [Form]) {
        viewModel.getTopForms()
    }
}
// MARK: CollectionView Delegation
extension StatsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.orderedForms.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dqReusableCell(ofType: StatCell.self, for: indexPath)
        let formRanked = viewModel.orderedForms[indexPath.item]
        cell.setForm(
            formRanked.form,
            hits: formRanked.hits,
            maxHits: viewModel.maxHits)
        return cell
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        return collectionView.dqHeader(
            ofType: StatsHeader.self,
            for: indexPath)
    }
    
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(
            width: collectionView.frame.width - collectionMargin*2,
            height: 80)
    }
    
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(
            width: collectionView.frame.width - collectionMargin*2,
            height: 60)
    }
    
    func collectionView(
        _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? StatCell,
           let form = cell.form {
            coordinator?.play(form)
        }
    }
}
