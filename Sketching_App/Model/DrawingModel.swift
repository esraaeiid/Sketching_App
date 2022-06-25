//
//  DrawingModel.swift
//  Sketching_App
//
//  Created by Esraa on 15/06/2022.
//

import UIKit
import PencilKit

struct DrawingModel {
    var id: UUID?
    var drawing: PKDrawing?
    var name: String?
    var date: Date?
    var thumbnail: UIImage?
    var selectedDrawingStep: PKStroke?
    var undoedDrawings: [PKStroke]?
    

    /// Helper Initializer to assign savedDrawing from disk to drawingCanvas datasource
    init (savedDrawingModel: DrawingDataModel) {
        self.id = savedDrawingModel.id!
        self.drawing = try? PKDrawing(data: savedDrawingModel.drawing ?? Data())
        self.name = savedDrawingModel.name
        self.date = savedDrawingModel.date
        self.thumbnail = UIImage(data: savedDrawingModel.thumbnail ?? Data())
    }


    /// Default Initializer
    init(){}

}
