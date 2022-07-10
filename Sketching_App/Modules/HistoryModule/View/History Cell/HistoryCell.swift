//
//  HistoryCell.swift
//  Sketching_App
//
//  Created by Esraa on 16/06/2022.
//

import UIKit

protocol DrawingDeletion: AnyObject {
    func deleteDrawing(with id: UUID)
}

extension HistoryCell {
    struct CellConfigurator<Model>{
        let nameKeyPath: KeyPath<Model, String?>
        let dateKeyPath: KeyPath<Model, Date?>
        let imageKeyPath: KeyPath<Model, UIImage?>
        let idKeyPath: KeyPath<Model, UUID>


        func configure(_ cell: HistoryCell, for model: Model){
            cell.nameForDrawingLabel.text = model[keyPath: nameKeyPath]
            cell.drawingCreationDateLabel.text = "\(model[keyPath: dateKeyPath] ?? .init())"
            cell.drawingImageView.image = model[keyPath: imageKeyPath]
        }

        func modelID(_ cell: HistoryCell, for model: Model){
            cell.modelID = model[keyPath: idKeyPath]
        }
    }
}

class HistoryCell: UICollectionViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var nameForDrawingLabel: UILabel!
    @IBOutlet weak var drawingCreationDateLabel: UILabel!
    @IBOutlet weak var drawingImageView: UIImageView!

    weak var delegate: DrawingDeletion?
    var modelID: UUID = .init()

    static let identifier = "HistoryCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func nib() -> UINib {
        return UINib(nibName: "HistoryCell", bundle: nil)
    }

    
    @IBAction func deleteDrawingButton(_ sender: UIButton) {
            delegate?.deleteDrawing(with: modelID)
    }


}
