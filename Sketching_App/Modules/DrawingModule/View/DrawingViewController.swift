//
//  DrawingViewController.swift
//  Sketching_App
//
//  Created by Esraa on 14/06/2022.
///Users/esraa/Desktop/Sketching_App/Sketching_App.xcodeproj

import UIKit
import PencilKit

class DrawingViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {

    // MARK: - IBOutlets

    //canvasView
    @IBOutlet weak var canvasView: PKCanvasView!

    //drawingOptions StackView
    @IBOutlet weak var drawingOptionsStackView: UIStackView!

    //editDrawing StackView

    //finalizeDrawing StackView



    var drawing = PKDrawing()
    var toolPicker: PKToolPicker!
    let canvasWidth: CGFloat = 768
    var hasModifiedDrawing = false
    var isPenSelected = false


    /// Standard amount of overscroll allowed in the canvas.
    static let canvasOverscrollHeight: CGFloat = 500

    ///
    /// setup canvasView
    ///
    func setupCanvasView(){
        canvasView.delegate = self
        canvasView.drawing = drawing
        canvasView.alwaysBounceVertical = false
        canvasView.drawingPolicy = .anyInput


        // Setup toolPicker
        toolPicker = PKToolPicker()
        //Sets the visibility for the tool picker
        toolPicker.setVisible(false, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        toolPicker.addObserver(self)


        updateLayout(for: toolPicker)
        canvasView.becomeFirstResponder()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCanvasView()
    }

    // When the view is resized, adjust the canvas scale so that it is zoomed to the default `canvasWidth`.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let canvasScale = canvasView.bounds.width / canvasWidth
        canvasView.minimumZoomScale = canvasScale
        canvasView.maximumZoomScale = canvasScale
        canvasView.zoomScale = canvasScale

        // Scroll to the top.
        updateContentSizeForDrawing()
        canvasView.contentOffset = CGPoint(x: 0, y: -canvasView.adjustedContentInset.top)
    }


    //MARK: - Actions

    //drawingOptions StackView Actions
    @IBAction func finalizeDrawingButtonAction(_ sender: UIButton) {
        print("1")
    }

    @IBAction func editDrawingButtonAction(_ sender: UIButton) {
        print("2")
    }

    @IBAction func uploadImageButtonAction(_ sender: UIButton) {
        print("3")
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
    /// Helper method to set a suitable content size for the canvas view.
    ///
    func updateContentSizeForDrawing() {
        // Update the content size to match the drawing.
        let drawing = canvasView.drawing
        let contentHeight: CGFloat

        // Adjust the content size to always be bigger than the drawing height.
        if !drawing.bounds.isNull {
            contentHeight = max(canvasView.bounds.height, (drawing.bounds.maxY + DrawingViewController.canvasOverscrollHeight) * canvasView.zoomScale)
        } else {
            contentHeight = canvasView.bounds.height
        }
        canvasView.contentSize = CGSize(width: canvasWidth * canvasView.zoomScale, height: contentHeight)

    }


    ///
    /// Handle showing and hiding of the toolPicker
    ///
    func handlePenButtonSelection(){
        if isPenSelected{
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                self.tabBarController?.tabBar.layer.zPosition = -1

            } completion: { _  in
                self.toolPicker.setVisible(true, forFirstResponder: self.canvasView)
            }

        } else {
            UIView.animate(withDuration: 0, delay: 0.2, options: .curveEaseInOut) {
                self.toolPicker.setVisible(false, forFirstResponder: self.canvasView)

            } completion: { _  in
                self.tabBarController?.tabBar.layer.zPosition = 0
            }
        }
    }


    //MARK: - PKCanvasViewDelegate Methods

    /// Tells the delegate that the contents of the current drawing changed.
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        hasModifiedDrawing = true
        updateContentSizeForDrawing()
    }


    //MARK: - PKToolPickerObserver Methods

    /// Tells the observer that area obscured by the tool picker changed.
    func toolPickerFramesObscuredDidChange(_ toolPicker: PKToolPicker) {
        updateLayout(for: toolPicker)
    }

    /// Tells the observer that the user showed or hide the tool picker.
    func toolPickerVisibilityDidChange(_ toolPicker: PKToolPicker) {
        updateLayout(for: toolPicker)
    }



}


