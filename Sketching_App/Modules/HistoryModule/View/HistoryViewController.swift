//
//  HistoryViewController.swift
//  Sketching_App
//
//  Created by Esraa on 14/06/2022.
//

import UIKit

class HistoryViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var historyCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    var drawings: [DrawingModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        setupCollectionView()
    }


    /// helper method to setup collectionView
    ///
    func setupCollectionView(){
        historyCollectionView.delegate = self
        historyCollectionView.dataSource = self
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        historyCollectionView.collectionViewLayout = layout

        historyCollectionView.register(HistoryCell.nib(),
                                       forCellWithReuseIdentifier: HistoryCell.identifier)
    }
    


}

//MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 32, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCell.identifier, for: indexPath) as? HistoryCell else {

            assertionFailure("couldn't load HistoryCollectionViewCell")
            return UICollectionViewCell()
        }
        cell.drawingInfo = drawings[indexPath.row]
        cell.configure()
        cell.delegate = self

        return cell
    }




}

//MARK: - DrawingDeletion
extension HistoryViewController: DrawingDeletion {
    func deleteDrawing(with id: UUID) {
        //delete from colletion view datasource
        // delete from database
    }
}
