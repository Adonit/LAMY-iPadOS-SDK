//
//  CanvasView.swift
//
//

import UIKit

let π = CGFloat.pi

class CanvasView: UIImageView {
    // Parameters
    private let defaultLineWidth: CGFloat = 6
    private let forceSensitivity: CGFloat = 20.0
    private let tiltThreshold = π / 6 // 30º
    private let minLineWidth: CGFloat = 5

    private var drawingImage: UIImage?

    private var drawColor: UIColor = .black
    private var pencilTexture: UIColor = .init(patternImage: UIImage(named: "PencilTexture")!)

    private var eraserColor: UIColor {
        return backgroundColor ?? UIColor.white
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()

        drawingImage?.draw(in: bounds)

        var touches = [UITouch]()

        if let coalescedTouches = event?.coalescedTouches(for: touch) {
            touches = coalescedTouches
        } else {
            touches.append(touch)
        }
        for touch in touches {
            drawStroke(context: context, touch: touch)
        }

        drawingImage = UIGraphicsGetImageFromCurrentImageContext()
        if let predictedTouches = event?.predictedTouches(for: touch) {
            for touch in predictedTouches {
                drawStroke(context: context, touch: touch)
            }
        }

        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    override func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
        image = drawingImage
    }

    override func touchesCancelled(_: Set<UITouch>, with _: UIEvent?) {
        image = drawingImage
    }

    private func drawStroke(context: CGContext!, touch: UITouch) {
        if !LamyStylusManager.sharedInstance().isStylusConnected {
            let previousLocation = touch.previousLocation(in: self)
            let location = touch.location(in: self)

            var lineWidth: CGFloat
            if touch.type == .pencil {
                if touch.altitudeAngle < tiltThreshold {
                    lineWidth = lineWidthForShading(context: context, touch: touch)
                } else {
                    lineWidth = lineWidthForDrawing(context: context, touch: touch)
                }
                pencilTexture.setStroke()
            } else {
                lineWidth = touch.majorRadius / 2
                eraserColor.setStroke()
            }

            context.setLineWidth(lineWidth)
            context.setLineCap(.round)

            context.move(to: CGPoint(x: previousLocation.x, y: previousLocation.y))
            context.addLine(to: CGPoint(x: location.x, y: location.y))

            context.strokePath()
        }
    }

    private func drawStroke(context: CGContext!, touch: LamyStroke) {
        let previousLocation = touch.previousLocation(in: self)
        let location = touch.location(in: self)

        var lineWidth: CGFloat
        if touch.pressure != 0 {
            if touch.altitudeAngle < tiltThreshold {
                lineWidth = lineWidthForShading(context: context, touch: touch)
            } else {
                lineWidth = lineWidthForDrawing(context: context, touch: touch)
            }
            pencilTexture.setStroke()
        } else {
            lineWidth = 10
            eraserColor.setStroke()
        }

        context.setLineWidth(lineWidth)
        context.setLineCap(.round)

        context.move(to: CGPoint(x: previousLocation.x, y: previousLocation.y))
        context.addLine(to: CGPoint(x: location.x, y: location.y))

        context.strokePath()
    }

    private func lineWidthForShading(context: CGContext!, touch: UITouch) -> CGFloat {
        let previousLocation = touch.previousLocation(in: self)
        let location = touch.location(in: self)

        let vector1 = touch.azimuthUnitVector(in: self)

        let vector2 = CGPoint(x: location.x - previousLocation.x, y: location.y - previousLocation.y)

        var angle = abs(atan2(vector2.y, vector2.x) - atan2(vector1.dy, vector1.dx))

        if angle > π {
            angle = 2 * π - angle
        }
        if angle > π / 2 {
            angle = π - angle
        }

        let minAngle: CGFloat = 0
        let maxAngle = π / 2
        let normalizedAngle = (angle - minAngle) / (maxAngle - minAngle)

        let maxLineWidth: CGFloat = 60
        var lineWidth = maxLineWidth * normalizedAngle


        let minAltitudeAngle: CGFloat = 0.25
        let maxAltitudeAngle = tiltThreshold

        let altitudeAngle = touch.altitudeAngle < minAltitudeAngle
            ? minAltitudeAngle : touch.altitudeAngle

        let normalizedAltitude = 1 - ((altitudeAngle - minAltitudeAngle)
            / (maxAltitudeAngle - minAltitudeAngle))
        lineWidth = lineWidth * normalizedAltitude + minLineWidth

        let minForce: CGFloat = 0.0
        let maxForce: CGFloat = 5

        let normalizedAlpha = (touch.force - minForce) / (maxForce - minForce)

        context!.setAlpha(normalizedAlpha)

        return lineWidth
    }

    private func lineWidthForShading(context: CGContext!, touch: LamyStroke) -> CGFloat {
        let previousLocation = touch.previousLocation(in: self)
        let location = touch.location(in: self)

        let vector1 = touch.azimuthUnitVector(in: self)

        let vector2 = CGPoint(x: location.x - previousLocation.x, y: location.y - previousLocation.y)

        var angle = abs(atan2(vector2.y, vector2.x) - atan2(vector1.dy, vector1.dx))

        if angle > π {
            angle = 2 * π - angle
        }
        if angle > π / 2 {
            angle = π - angle
        }

        let minAngle: CGFloat = 0
        let maxAngle = π / 2
        let normalizedAngle = (angle - minAngle) / (maxAngle - minAngle)

        let maxLineWidth: CGFloat = 60
        var lineWidth = maxLineWidth * normalizedAngle

        let minAltitudeAngle: CGFloat = 0.25
        let maxAltitudeAngle = tiltThreshold

        let altitudeAngle = touch.altitudeAngle < minAltitudeAngle
            ? minAltitudeAngle : touch.altitudeAngle

        let normalizedAltitude = 1 - ((altitudeAngle - minAltitudeAngle)
            / (maxAltitudeAngle - minAltitudeAngle))
        lineWidth = lineWidth * normalizedAltitude + minLineWidth

        // Set alpha of shading using force
        let minForce: CGFloat = 0.0
        let maxForce: CGFloat = 5

        // Normalize between 0 and 1
        let normalizedAlpha = (touch.pressure - minForce) / (maxForce - minForce)

        context!.setAlpha(normalizedAlpha)
        return lineWidth
    }

    private func lineWidthForDrawing(context _: CGContext?, touch: UITouch) -> CGFloat {
        var lineWidth = defaultLineWidth

        if touch.force > 0 { // If finger, touch.force = 0
            lineWidth = touch.force * forceSensitivity
        }

        return lineWidth
    }

    private func lineWidthForDrawing(context _: CGContext?, touch: LamyStroke) -> CGFloat {
        var lineWidth = defaultLineWidth

        if touch.pressure > 0 { // If finger, touch.force = 0
            lineWidth += touch.pressure * forceSensitivity
        }

        return lineWidth
    }

    func clearCanvas(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.alpha = 0
            }, completion: { _ in
                self.alpha = 1
                self.image = nil
                self.drawingImage = nil
            })
        } else {
            image = nil
            drawingImage = nil
        }
    }

    func lamyStylusStrokeBegan(_: LamyStroke) {}

    func lamyStylusStrokeMoved(_ stylusStroke: LamyStroke) {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        drawingImage?.draw(in: bounds)

        var touches = [LamyStroke]()

        if let coalescedTouches = stylusStroke.coalescedLamyStrokes {
            touches = coalescedTouches
        } else {
            touches.append(stylusStroke)
        }
        for touch in touches {
            drawStroke(context: context, touch: touch)
        }

        drawingImage = UIGraphicsGetImageFromCurrentImageContext()
        if let predictedTouches = stylusStroke.predictedLamyStrokes {
            for touch in predictedTouches {
                drawStroke(context: context, touch: touch)
            }
        }

        // Update image
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    func lamyStylusStrokeEnded(_: LamyStroke) {
        image = drawingImage
    }

    func lamyStylusStrokeCancelled(_: LamyStroke) {
        image = drawingImage
    }
    
    func clearCanvas() {
        self.image = nil
        self.drawingImage = nil
    }
}
