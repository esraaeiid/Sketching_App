//
//  DrawingPresenter.swift
//  Sketching_App
//
//  Created by Esraa on 15/06/2022.
//

import Foundation
import PencilKit


enum ViewState {
    case loading
    case finishedWithSuccess(SuccessType)
    case failure(ErrorModel)
}

enum SuccessType {
    case drawingsHistory([DrawingModel])
    case drawingCanvas(DrawingModel)
    case drawingCanvasExpanded(Bool)
}

protocol Presenter {
    init(_ router: Router?, output: PresenterOutput?)
}

protocol PresenterOutput: AnyObject {
    func update(_ viewState: ViewState)
}


protocol DrawingPresenterProtocol: Presenter {
    func showDrawing()
    func saveDrawing(m: DrawingModel)
}


class DrawingPresenter: DrawingPresenterProtocol {
    private var router: Router?
    private var dataBase = CoreDataStorage.instance
    weak var output: PresenterOutput?
    private var drawing: DrawingModel = .init()



    func showDrawing() {
//        if let drawing = drawing {
            //should show selected drawing
            self.output?.update(.finishedWithSuccess(.drawingCanvas(drawing)))
//        } else {
//            self.output?.update(.finishedWithSuccess(.drawingCanvas(drawing ?? .init())))
//        }

    }

    func saveDrawing(m: DrawingModel) {
//        if let drawingModel = drawing {
        
        drawing = m  // update new drawings values
            dataBase.saveDrawing(completionHandler: { isSaved in
                print("Saved?", isSaved)
                print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
            }, model: drawing)
        print("DRAWING", drawing)
//        }
//        else {
//
//            drawing = .init()
//            dataBase.saveDrawing(completionHandler: { isSaved in
//                print("Saved!")
//                print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
//            }, model: drawing)
//        }
    }



    required init(_ router: Router?, output: PresenterOutput?) {
        self.router = router
        self.output = output
    }


}
