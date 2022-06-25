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

class HistoryCell: UICollectionViewCell {

    var drawingInfo: DrawingModel?

    // MARK: - IBOutlets

    @IBOutlet weak var nameForDrawingLabel: UILabel!
    @IBOutlet weak var drawingCreationDateLabel: UILabel!
    @IBOutlet weak var drawingImageView: UIImageView!

    weak var delegate: DrawingDeletion?


    static let identifier = "HistoryCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func nib() -> UINib {
        return UINib(nibName: "HistoryCell", bundle: nil)
    }

    func configure(){
        if let drawingInfo = drawingInfo {
            self.nameForDrawingLabel.text = drawingInfo.name
            self.drawingCreationDateLabel.text = "\(drawingInfo.date)"
            self.drawingImageView.image = drawingInfo.thumbnail
        }
    }
    
    @IBAction func deleteDrawingButton(_ sender: UIButton) {
        if let drawingInfo = drawingInfo {
            delegate?.deleteDrawing(with: drawingInfo.id ?? UUID())
        }

    }


}
