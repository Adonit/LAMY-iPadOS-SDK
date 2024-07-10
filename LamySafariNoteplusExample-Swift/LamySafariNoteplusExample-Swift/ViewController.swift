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
    var stackView: UIStackView = .init()
    var shortcutButtonA: UIButton = .init()
    var shortcutButtonB: UIButton = .init()

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
            stylusManager.coalescedLamyStrokesEnabled = true
            if AppDelegate.userDefaults.object(forKey: "IsFirstTimeInSketchNote") == nil {
                setupShortcut()
                AppDelegate.userDefaults.setValue(false, forKey: "IsFirstTimeInSketchNote")
            } else {
                addShortcut()
            }
        }
        
        shortcutButtonA.setTitle("Shortcut A", for: .normal)
        shortcutButtonA.setTitleColor(.black, for: .normal)
        shortcutButtonB.setTitle("Shortcut B", for: .normal)
        shortcutButtonB.setTitleColor(.black, for: .normal)
        
        shortcutButtonA.onTap {
            guard let shortcutView = UIStoryboard.instantiateLamyViewController(withIdentifier: LamyViewControllerShortCutButtonAIdentifier) else { return }
            shortcutView.modalPresentationStyle = .popover
            shortcutView.popoverPresentationController?.sourceView = self.shortcutButtonA
            self.navigationController?.present(shortcutView, animated: true)
        }
        
        
        shortcutButtonB.onTap {
            guard let shortcutView = UIStoryboard.instantiateLamyViewController(withIdentifier: LamyViewControllerShortCutButtonBIdentifier) else { return }
            shortcutView.modalPresentationStyle = .popover
            shortcutView.popoverPresentationController?.sourceView = self.shortcutButtonB
            self.navigationController?.present(shortcutView, animated: true)
        }
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(shortcutButtonA)
        stackView.addArrangedSubview(shortcutButtonB)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
        }
        stackView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(connectionChanged), name: Notification.Name(LamyStylusManagerDidChangeConnectionStatus), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupShortcut() {
        let stylusManager = LamyStylusManager.sharedInstance()
        stylusManager?.removeAllShorcuts()
        stylusManager?.addShortcutOption(LamyShortcut(descriptiveText: "None", key: "none", target: self, selector: #selector(none)))
        stylusManager?.addShortcutOptionButton1Default(LamyShortcut(descriptiveText: "Undo", key: "undo", target: self, selector: #selector(undo)))
        stylusManager?.addShortcutOptionButton2Default(LamyShortcut(descriptiveText: "Redo", key: "redo", target: self, selector: #selector(redo)))
        stylusManager?.addShortcutOption(LamyShortcut(descriptiveText: "Erase", key: "erase", target: self, selector: #selector(erase)))
    }

    private func addShortcut() {
        let stylusManager = LamyStylusManager.sharedInstance()
        stylusManager?.removeAllShorcuts()
        stylusManager?.addShortcutOption(LamyShortcut(descriptiveText: "None", key: "none", target: self, selector: #selector(none)))
        stylusManager?.addShortcutOption(LamyShortcut(descriptiveText: "Undo", key: "undo", target: self, selector: #selector(undo)))
        stylusManager?.addShortcutOption(LamyShortcut(descriptiveText: "Redo", key: "redo", target: self, selector: #selector(redo)))
        stylusManager?.addShortcutOption(LamyShortcut(descriptiveText: "Erase", key: "erase", target: self, selector: #selector(erase)))
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

    @objc func undo() {}

    @objc func redo() {}

    @objc func erase() {}

    @objc func none() {}
    
    @objc private func connectionChanged(note: NSNotification) {
        guard let status = note.userInfo?[LamyStylusManagerDidChangeConnectionStatusStatusKey] else {
            return
        }
        if status as! UInt  == LamyConnectionStatus.connected.rawValue {
            self.stackView.isHidden = false
        } else if status as! UInt  == LamyConnectionStatus.disconnected.rawValue {
            self.stackView.isHidden = true
        }
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
