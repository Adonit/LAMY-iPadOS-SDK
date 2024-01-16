//
//  ViewController.swift
//  LamySafariNoteplusExample-Swift
//
//  Created by Mark on 2023/12/29.
//

import Closures
import SnapKit
import UIKit

class ViewController: UIViewController {
    var canvasView: CanvasView = .init()
    var clearButton: UIButton = .init()
    var stylusButton: UIView = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(canvasView)
        canvasView.isUserInteractionEnabled = true
        canvasView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        view.addSubview(clearButton)
        clearButton.setTitle("Clear", for: .normal)
        clearButton.setTitleColor(.black, for: .normal)
        clearButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
            $0.width.equalTo(60)
        }

        clearButton.onTap {
            self.canvasView.clearCanvas()
        }

        if let connectView = UIStoryboard.instantiateInitialLamyViewController() {
            connectView.view.frame = stylusButton.bounds
            stylusButton.backgroundColor = UIColor.clear
            stylusButton.addSubview((connectView.view)!)
            addChild(connectView)
            view.addSubview(stylusButton)
            stylusButton.snp.makeConstraints {
                $0.top.equalTo(clearButton.snp.top)
                $0.right.equalTo(clearButton.snp.left).inset(-20)
                $0.height.width.equalTo(40)
            }
        }
        if let stylusManager = LamyStylusManager.sharedInstance() {
            stylusManager.enable()
            stylusManager.lamyStrokeDelegate = self
//            stylusManager.unconnectedPressure = 1024
            stylusManager.coalescedLamyStrokesEnabled = true
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        canvasView.touchesMoved(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        canvasView.touchesEnded(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        canvasView.touchesCancelled(touches, with: event)
    }
}

extension ViewController: LamyStrokeDelegate {
    func lamyStylusStrokeBegan(_ stylusStroke: LamyStroke) {
        canvasView.lamyStylusStrokeBegan(stylusStroke)
    }

    func lamyStylusStrokeMoved(_ stylusStroke: LamyStroke) {
        canvasView.lamyStylusStrokeMoved(stylusStroke)
    }

    func lamyStylusStrokeEnded(_ stylusStroke: LamyStroke) {
        canvasView.lamyStylusStrokeEnded(stylusStroke)
    }

    func lamyStylusStrokeCancelled(_ stylusStroke: LamyStroke) {
        canvasView.lamyStylusStrokeCancelled(stylusStroke)
    }

    func suggestsToDisableGestures() {}

    func suggestsToEnableGestures() {}
}
