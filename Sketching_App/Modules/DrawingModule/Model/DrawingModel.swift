//
//  DrawingModel.swift
//  Sketching_App
//
//  Created by Esraa on 15/06/2022.
//

import UIKit
import PencilKit

struct DrawingModel {
    var id: UUID 
    var drawing: PKDrawing
    var name: String
    var date: Date
    var thumbnail: UIImage

}
