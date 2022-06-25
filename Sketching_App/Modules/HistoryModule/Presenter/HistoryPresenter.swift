//
//  HistoryPresenter.swift
//  Sketching_App
//
//  Created by Esraa on 16/06/2022.
//

import Foundation


protocol HistoryPresenterProtocol: Presenter {
    func loadDrawings()
    func showSelectedDrawing(_ drawing: DrawingModel)
    func showDrawingCanvas()
    func deleteDrawing(_ id: UUID)
    func searchDrawing(_ text: String)
}


class HistoryPresenter: HistoryPresenterProtocol {

    private var router: Router?
    private var dataBase = CoreDataStorage.instance
    weak var output: PresenterOutput?
    private var drawings: [DrawingModel] = []


    func deleteDrawing(_ id: UUID) {

    }

    func searchDrawing(_ text: String) {
        
    }

    func loadDrawings() {

    }

    func showSelectedDrawing(_ drawing: DrawingModel) {

    }

    func showDrawingCanvas() {

    }

    required init(_ router: Router?, output: PresenterOutput?) {
        self.output = output
        self.router = router
    }

    
}
