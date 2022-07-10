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
    @IBOutlet weak var drawingOptionsTopConstraint: NSLayoutConstraint!
    
    //editDrawing StackView
    @IBOutlet weak var editDrawingTopConstraint: NSLayoutConstraint!
    
    //finalizeDrawing StackView
    @IBOutlet weak var finazlizeDrawingTopConstraint: NSLayoutConstraint!

    
    private var dataSourceManager: DrawingManagerProtocol?
    private var presenter: DrawingPresenterProtocol?

  
    var isPenSelected = false
    var undoedStrokes:  [PKStroke] = []



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


        self.editDrawingTopConstraint.constant = -10
        self.finazlizeDrawingTopConstraint.constant = -10

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


    //MARK: - Drawing Options View Actions

    //drawingOptions StackView Actions
    @IBAction func finalizeDrawingButtonAction(_ sender: UIButton) {

        animateView(viewToTop: drawingOptionsTopConstraint, viewToBottom: finazlizeDrawingTopConstraint)
        
    }

    @IBAction func editDrawingButtonAction(_ sender: UIButton) {
        animateView(viewToTop: drawingOptionsTopConstraint, viewToBottom: editDrawingTopConstraint)

    }

    @IBAction func uploadImageButtonAction(_ sender: UIButton) {

    }

    @IBAction func expandDrawingButtonAction(_ sender: UIButton) {

    }

    @IBAction func startDrawingButtonAction(_ sender: UIButton) {

        self.isPenSelected = !isPenSelected
        handlePenButtonSelection()
    }

    //MARK: - Finalize Drawing View Actions

    @IBAction func saveDrawingButtonAction(_ sender: UIButton) {

        /// show alert for to add name


        /// save to local
        let drawing = DrawingModel(name: "TEST", date: .init())
        presenter?.saveDrawing(m: drawing)


        ///  show loading view


        /// clear canvas view
    }


    @IBAction func closeFinalizeDrawingViewButtonAction(_ sender: UIButton) {
        animateView(viewToTop: finazlizeDrawingTopConstraint, viewToBottom: drawingOptionsTopConstraint)

    }

    //MARK: - Edit Drawing View Actions

    @IBAction func selectLineButtonAction(_ sender: UIButton) {


    }

    @IBAction func deleteDrawingButtonAction(_ sender: UIButton) {


    }

    @IBAction func undoButtonAction(_ sender: UIButton) {


    }

    @IBAction func redoButtonAction(_ sender: UIButton) {


    }

    @IBAction func closeEditDrawingViewButtonAction(_ sender: UIButton) {
        animateView(viewToTop: editDrawingTopConstraint, viewToBottom: drawingOptionsTopConstraint)

    }



    /// Helper function to animate top views
    /// - Parameters:
    ///   - viewToTop: view that should animate to top of the screen
    ///   - viewToBottom: view that should animate to bottom of the screen
    func animateView(viewToTop:NSLayoutConstraint!, viewToBottom: NSLayoutConstraint!){

        viewToTop.constant = -10

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
        } completion: { _  in
            viewToBottom.constant = 100
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
                self.dataSourceManager?.toolPicker.setVisible(true, forFirstResponder: self.canvasView)
            }

        } else {
            UIView.animate(withDuration: 0, delay: 0.2, options: .curveEaseInOut) {
                 self.dataSourceManager?.toolPicker.setVisible(false, forFirstResponder: self.canvasView)
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
