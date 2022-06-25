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
}


class DrawingPresenter: DrawingPresenterProtocol {
    private var router: Router?
    private var dataBase = CoreDataStorage.instance
    weak var output: PresenterOutput?
    private var drawing: DrawingModel?


    func showDrawing() {
        if let drawing = drawing {
            //should show selected drawing
            self.output?.update(.finishedWithSuccess(.drawingCanvas(drawing)))
        } else {
            drawing = .init()
            drawing?.drawing =  PKDrawing()
            self.output?.update(.finishedWithSuccess(.drawingCanvas(drawing ?? .init())))
            print("emptey canvas")
        }

    }



    required init(_ router: Router?, output: PresenterOutput?) {
        self.router = router
        self.output = output
    }


}
