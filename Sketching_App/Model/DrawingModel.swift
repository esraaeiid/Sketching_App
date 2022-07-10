//
//  DrawingModel.swift
//  Sketching_App
//
//  Created by Esraa on 15/06/2022.
//

import UIKit
import PencilKit

struct DrawingModel {
    var id: UUID = .init()
    var drawing: PKDrawing?
    var name: String?
    var date: Date?
    var thumbnail: UIImage?
    var selectedDrawingStep: PKStroke?
    var undoedDrawings: [PKStroke]?
    

    /// Helper Initializer to assign savedDrawing from disk to drawingCanvas datasource
    init (savedDrawingModel: DrawingDataModel) {
        self.id = savedDrawingModel.id ?? .init()
        self.drawing = try? PKDrawing(data: savedDrawingModel.drawing ?? Data())
        self.name = savedDrawingModel.name
        self.date = savedDrawingModel.date
        self.thumbnail = UIImage(data: savedDrawingModel.thumbnail ?? Data())
    }


    /// Default Initializer
    init(){}


    
    /// Helper Initializer to assign new values to struct
    init(drawing: PKDrawing? = nil,
         name: String? = nil,
         date: Date? = nil,
         thumbnail: UIImage? = nil,
         selectedDrawingStep: PKStroke? = nil ,
         undoedDrawings: [PKStroke]? = []){

        self.drawing = drawing
        self.name = name
        self.date = date
        self.thumbnail = thumbnail
        self.selectedDrawingStep = selectedDrawingStep
        self.undoedDrawings = undoedDrawings
    }

}
