//
//  DrawingViewController.swift
//  Sketching_App
//
//  Created by Esraa on 14/06/2022.


import UIKit
import PencilKit

class DrawingViewController: UIViewController {

    // MARK: - IBOutlets

    //canvasView
    @IBOutlet weak var canvasView: PKCanvasView!

    //drawingOptions StackView
    @IBOutlet weak var drawingOptionsStackView: UIStackView!

    //editDrawing StackView

    //finalizeDrawing StackView


    private var dataSourceManager: DrawingManagerProtocol?
    private var presenter: DrawingPresenterProtocol?

  
    var isPenSelected = false
    var undoedStrokes:  [PKStroke] = []

    private var coreDataStorage = CoreDataStorage.instance



    ///
    /// setup canvasView
    ///
    func setupCanvasView(){
        dataSourceManager?.setup()
        dataSourceManager?.setDelegate(self)
        presenter?.showDrawing()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCanvasView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dataSourceManager?.updateContentSizeForDrawing()
    }


    public func setManager(_ manager: DrawingManagerProtocol?) {
        self.dataSourceManager = manager
    }

    public func setPresenter(_ presenter: DrawingPresenterProtocol?) {
        self.presenter = presenter
    }

    //MARK: - Actions

    //drawingOptions StackView Actions
    @IBAction func finalizeDrawingButtonAction(_ sender: UIButton) {
      
//        if let drawingModel = dataSourceManager.drawingModel {
//            coreDataStorage.saveDrawing(completionHandler: { isSaved in
//                print("Saved!")
//            }, model: drawingModel)
//        } else {
//            drawingModel = .init()
//            coreDataStorage.saveDrawing(completionHandler: { isSaved in
//                print("Saved!")
//            }, model: drawingModel)
//        }

    }

    @IBAction func editDrawingButtonAction(_ sender: UIButton) {

    }

    @IBAction func uploadImageButtonAction(_ sender: UIButton) {

    }

    @IBAction func expandDrawingButtonAction(_ sender: UIButton) {

    }

    @IBAction func startDrawingButtonAction(_ sender: UIButton) {
        /* - hide toolPicker
           - hide drawingOptionsStackView
           - show collapse button  */

        self.isPenSelected = !isPenSelected
        handlePenButtonSelection()

    }



    

    ///
    ///  adjust the canvas view size when the tool picker changes which part
    /// of the canvas view it obscures, if any.
    ///
    func updateLayout(for toolPicker: PKToolPicker) {
        let obscuredFrame = toolPicker.frameObscured(in: view)

        // If the tool picker is floating over the canvas
        if obscuredFrame.isNull {
            canvasView.contentInset = .zero
        }

        // Otherwise, the bottom of the canvas should be inset to the top of the
        // tool picker
        else {
            canvasView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.bounds.maxY - obscuredFrame.minY, right: 0)
        }

    }

    



    ///
    /// Handle showing and hiding of the toolPicker
    ///
    func handlePenButtonSelection(){
        if isPenSelected{
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                self.tabBarController?.tabBar.layer.zPosition = -1

            } completion: { _  in
//                self.toolPicker.setVisible(true, forFirstResponder: self.canvasView)
            }

        } else {
            UIView.animate(withDuration: 0, delay: 0.2, options: .curveEaseInOut) {
//                self.toolPicker.setVisible(false, forFirstResponder: self.canvasView)

            } completion: { _  in
                self.tabBarController?.tabBar.layer.zPosition = 0
            }
        }
    }


    func undoDrawing(){
        for stroke in canvasView.drawing.strokes{
            undoedStrokes.append(stroke)
        }

       _ = canvasView.drawing.strokes.popLast()
    }

    func redoDrawing(){
        for stroke in undoedStrokes {
            canvasView.drawing.strokes.append(stroke)
        }
    }


    func deleteAllDrawing(){

    }

    func deleteSelectedDrawing(){
        //tap gesture should be implemented here!
    }

    func uploadImage(){

    }


}

//MARK: -  DrawingManagerDelegate

extension DrawingViewController: DrawingManagerDelegate {
    func setupCanvasViewLayout() {
        
    }

    func saveDrawing(_ drawing: DrawingModel) {

    }

    func deleteDrawing(_ mode: DeleteDrawingMode) {

    }

    func expandDrawing() {

    }

    func collapseDrawing() {

    }

    func rotateDrawing() {

    }

    func scaleDrawing() {

    }

    func showImagePicker() {

    }


}

//MARK: - PresenterOutput

extension DrawingViewController: PresenterOutput {
    
    func update(_ viewState: ViewState) {
        switch viewState {
        case .finishedWithSuccess(let successType):
            switch successType {

            case .drawingCanvas(let drawingModel):
                dataSourceManager?.update(drawingModel)

            case .drawingCanvasExpanded(let bool):
                if bool {
                    //expand
                    break
                } else {
                    //collapse
                    break
                }
            default:
                break
            }
        default:
            break
        }
    }




}
