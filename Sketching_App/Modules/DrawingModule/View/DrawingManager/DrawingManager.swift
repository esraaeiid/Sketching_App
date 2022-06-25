//
//  DrawingManager.swift
//  Sketching_App
//
//  Created by Esraa on 17/06/2022.
//

import Foundation
import PencilKit
import UIKit


protocol DrawingManagerProtocol {
    func setup()
    func update(_ model: DrawingModel)
    func setDelegate(_ delegate: DrawingManagerDelegate?)
}

enum DeleteDrawingMode{
    case all
    case selectedStep
}


protocol DrawingManagerDelegate: AnyObject {
    func saveDrawing(_ drawing: DrawingModel)
    func deleteDrawing(_ mode: DeleteDrawingMode)
    func undoDrawing()
    func redoDrawing()
    func expandDrawing()
    func collapseDrawing()
    func rotateDrawing()
    func scaleDrawing()
    func showImagePicker()
    func setupCanvasViewLayout()
}


class DrawingManager: NSObject, DrawingManagerProtocol {

    var view: UIView?
    var canvasView: PKCanvasView?
    var drawingModel: DrawingModel = .init() {
        didSet{
            canvasView?.drawing = drawingModel.drawing ?? PKDrawing()
        }
    }
    var toolPicker: PKToolPicker!
    var hasModifiedDrawing = false
    let canvasWidth: CGFloat = 768

    weak var delegate: DrawingManagerDelegate?
    
    func setup() {
        canvasView?.delegate = self
        canvasView?.alwaysBounceVertical = false
        canvasView?.drawingPolicy = .anyInput


        // Setup toolPicker
        toolPicker = PKToolPicker()
        //Sets the visibility for the tool picker
        if let canvasView = canvasView {
            toolPicker.setVisible(false, forFirstResponder: canvasView)
            toolPicker.addObserver(canvasView)
            toolPicker.addObserver(self)
        }



        updateLayout(for: toolPicker)
        canvasView?.becomeFirstResponder()
    }

    func updateLayout(for toolPicker: PKToolPicker) {
        let obscuredFrame = toolPicker.frameObscured(in: view ?? UIView())

        // If the tool picker is floating over the canvas
        if obscuredFrame.isNull {
            canvasView?.contentInset = .zero
        }

        // Otherwise, the bottom of the canvas should be inset to the top of the
        // tool picker
        else {
            canvasView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view?.bounds.maxY ?? 0 - obscuredFrame.minY, right: 0)
        }

    }


    func update(_ model: DrawingModel) {
        self.drawingModel = model
    }

    func setDelegate(_ delegate: DrawingManagerDelegate?) {
        self.delegate = delegate
    }

    required init(view: UIView?, canvasView: PKCanvasView?) {
        self.view = view
        self.canvasView = canvasView
    }


}

//MARK: - PKCanvasViewDelegate Methods

extension DrawingManager: PKCanvasViewDelegate{
    /// Tells the delegate that the contents of the current drawing changed.
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        hasModifiedDrawing = true
        updateContentSizeForDrawing()
        print("change!!!!!!",  canvasView.drawing.strokes.count)
    }



    ///
    /// Helper method to set a suitable content size for the canvas view.
    ///
    func updateContentSizeForDrawing() {
        // Update the content size to match the drawing.
        let drawing = canvasView?.drawing
        let contentHeight: CGFloat

        // Adjust the content size to always be bigger than the drawing height.
        if !(drawing?.bounds.isNull ?? false) {
            contentHeight = max(canvasView?.bounds.height ?? 0,
                                ((drawing?.bounds.maxY ?? 0) + DrawingViewController.canvasOverscrollHeight) * (canvasView?.zoomScale ?? 0))
        } else {
            contentHeight = canvasView?.bounds.height ?? 0
        }
        canvasView?.contentSize = CGSize(width: canvasWidth * (canvasView?.zoomScale ?? 0) , height: contentHeight)

    }
    
}


//MARK: - PKToolPickerObserver Methods
extension DrawingManager: PKToolPickerObserver{

    /// Tells the observer that area obscured by the tool picker changed.
    func toolPickerFramesObscuredDidChange(_ toolPicker: PKToolPicker) {
        updateLayout(for: toolPicker)
    }

    /// Tells the observer that the user showed or hide the tool picker.
    func toolPickerVisibilityDidChange(_ toolPicker: PKToolPicker) {
        updateLayout(for: toolPicker)
    }

}
