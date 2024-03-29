//
//  BrushLibrary.swift
//  LamySafariNoteplusSwiftExample
//
//  Copyright (c) 2015 Adonit. All rights reserved.
//

// This is supposed to be easy to modify, go nuts!

import Foundation

class BrushLibrary: NSObject {
    @objc let pen:Brush
	@objc let pencil:Brush
	@objc let eraser:Brush
	
	@objc let eraserIndex:Int
	@objc var eraserSelected = false
	
	@objc fileprivate(set) var brushes = [Brush]()
	@objc var currentBrushIndex = 0 {
		willSet {
			previousBrushIndex = currentBrushIndex
		}
		didSet {
			assert(currentBrushIndex < brushes.count && currentBrushIndex >= 0, "Current Brush Index out of range!")
			UserDefaults.standard.set(currentBrushIndex, forKey:"currentBrushIndex")
			eraserSelected = currentBrush == eraser
		}
	}
	
	fileprivate(set) var previousBrushIndex = 0
	
	override init() {
        pencil = Brush(minPressureOpacity: 0.8, maxPressureOpacity: 0.95, minOpacity: 0.01, maxOpacity: 1.0, minPressureSize: 1.8, maxPressureSize: 3.8, minSize: 1.8, maxSize: 10.0, selectedIcon: UIImage(named: "pencil-brush-icon-selected")!, unselectedIcon: UIImage(named: "pencil-brush-icon-deselected")!, isEraser: false)
        pen = Brush(minPressureOpacity: 0.8, maxPressureOpacity: 0.95, minOpacity: 0.01, maxOpacity: 1.0, minPressureSize: 5.0, maxPressureSize: 15, minSize: 4.5, maxSize: 75.0, selectedIcon: UIImage(named: "pen-brush-icon-selected")!, unselectedIcon: UIImage(named: "pen-brush-icon-deselected")!, isEraser: false)
        
        eraser = Brush(minPressureOpacity: 0.5, maxPressureOpacity: 0.95, minOpacity: 0.01, maxOpacity: 1.0, minPressureSize: 25.0, maxPressureSize: 60.0, minSize: 2.0, maxSize: 75.0, selectedIcon: UIImage(named: "eraser-brush-icon-selected")!, unselectedIcon: UIImage(named: "eraser-brush-icon-deselected")!, isEraser: true)
        
        brushes += [pencil, pen, eraser]
		
        eraserIndex = brushes.firstIndex(of: eraser)!
        
        currentBrushIndex = UserDefaults.standard.integer(forKey: "currentBrushIndex")
    }
	
	@objc var currentBrush:Brush {
		return brushes[currentBrushIndex]
	}
	
	func revertFromEraser() {
        if currentBrushIndex == brushes.firstIndex(of: eraser) {
            if previousBrushIndex != brushes.firstIndex(of: eraser) {
				currentBrushIndex = previousBrushIndex
			} else {
				currentBrushIndex = 0
			}
		}
	}

}
