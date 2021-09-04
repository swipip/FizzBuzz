//
//  ViewController.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 31/08/2021.
//

import UIKit
import Combine

class FormController: UIViewController {
    weak var coordinator: FormCoordinatorDelegate?
    
    // MARK: UI elements 􀯱
    let collectionInset: CGFloat = 10
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero ,collectionViewLayout: layout)
        collection.registerNib(ofType: FormCell.self)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.contentInsetAdjustmentBehavior = .never
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    private lazy var refreshButton: UIButton = {
        let button = UIButton.barButton()
        button.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)
        return button
    }()
    // MARK: Data Management 􀤃
    var viewModel = FormControllerViewModel()
    // MARK: View life cycle 􀐰
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        viewModel.delegate = self
        addCollectionView()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: refreshButton)
    }
    // MARK: Navigation 􀋒
    func presentGameController() {
        if viewModel.checkFormIsValid() {
            coordinator?.play(viewModel.form)
        }
    }
    func scrollToItem(_ indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    // MARK: Animations 􀢅
    func animateCellWrong(at indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        } completion: { _ in
            if let cell = self.collectionView.cellForItem(at: indexPath) as? FormCell {
                cell.animateWrong()
            }
        }
    }
    // MARK: Interactions 􀛹
    @objc private func resetButtonPressed() {
        viewModel.resetForm()
        scrollToItem(IndexPath(item: 0, section: 0))
    }
    // MARK: UI construction 􀤋
    private func addCollectionView() {
        let childView: UIView = collectionView
        let mView: UIView = view
        
        view.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        childView.leadingAnchor.constraint(equalTo: mView.leadingAnchor, constant: 0).isActive = true
        childView.topAnchor.constraint(equalTo: mView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        childView.bottomAnchor.constraint(equalTo: mView.safeAreaLayoutGuide.bottomAnchor,constant: 0).isActive = true
        childView.trailingAnchor.constraint(equalTo: mView.trailingAnchor,constant: 0).isActive = true
    }

}
extension FormController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.instructions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dqReusableCell(ofType: FormCell.self, for: indexPath)
        cell.setInstruction(viewModel.instructions[indexPath.item])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.frame.width,
            height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FormCell {
            cell.textField.resignFirstResponder()
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            (cell as? FormCell)?.textField.resignFirstResponder()
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? FormCell {
            cell.setInstruction(viewModel.instructions[indexPath.item])
        }
    }
}
extension FormController: FormCellDelegate {
    func formCell(didUpdateTextField instruction: FormInstruction?, isValueValid: Bool) {
        
        guard isValueValid else {return}
        guard let instruction = instruction else {return}
        
        viewModel.updateForm(instruction)
        viewModel.updateInstruction(instruction)
        
    }
    
    func didPressNextButton(cell: FormCell) {
        if let type = cell.instruction?.buttonType {
            switch type {
            case .next:
                if let indexPath = collectionView.indexPath(for: cell) {
                    scrollToItem(indexPath.next())
                }
            case .go:
                presentGameController()
                break
            }
        }
    }
}
extension FormController: FormControllerViewModelDelegate {
    func formControllerViewModel(didFindMissingValueAtIndex index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        animateCellWrong(at: indexPath)
    }
}
