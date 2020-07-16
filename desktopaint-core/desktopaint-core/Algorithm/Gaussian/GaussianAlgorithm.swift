//
//  GaussianAlgorithm.swift
//  Desktopaint-core
//
//  Created by Nghia Tran on 5/28/18.
//  Copyright © 2018 com.art.Desktopaint.core. All rights reserved.
//

import Foundation
import CoreImage

struct GaussianAlgorithm: GenerationAlgorithm {

    func process(data: DataGenerationType) -> NSImage {

        let scaleImage = scalePerfectImage(data: data)
        let enchancedImage = applyAutoEnchancement(scaleImage)
        let backgroundImage = generateGaussianBackground(enchancedImage, width: data.screenSize.width)
        let DesktopaintImage = drawDesktopaint(image: enchancedImage, backgroundImage: backgroundImage, size: data.screenSize)
        return DesktopaintImage
    }
}

// MARK: - Private
extension GaussianAlgorithm {

    fileprivate func scalePerfectImage(data: DataGenerationType) -> NSImage {
        return data.originalImage.scale(with: .fillHeight(data.scaleHeight))
    }

    fileprivate func applyAutoEnchancement(_ image: NSImage) -> NSImage {
        return image.autoEnchance()
    }

    fileprivate func generateGaussianBackground(_ image: NSImage, width: CGFloat) -> NSImage {
        let backgroundImage = image.scale(with: .fillWidth(width))
        return GaussianEffect.imageByApplyingLightEffect(to: backgroundImage)!
    }

    fileprivate func drawDesktopaint(image: NSImage, backgroundImage: NSImage, size: CGSize) -> NSImage {

        let final = NSImage(size: size)
        final.lockFocus()

        // Background
        let backgroundOrigin = CGPoint(x: 0, y: (size.height - backgroundImage.pointSize.height) / 2)
        let backgroundRect = CGRect(origin: backgroundOrigin, size: backgroundImage.pointSize)
        backgroundImage.draw(in: backgroundRect)

        // Prepare
        let imageOrigin = NSPoint(x: (size.width - image.pointSize.width) / 2,
                                  y: (size.height - image.pointSize.height) / 2)
        let imageRect = CGRect(origin: imageOrigin, size: image.pointSize)

        // Shadow
        let ctx = NSGraphicsContext.current!.cgContext
        ctx.saveGState()
        ctx.setShadow(offset: CGSize.zero, blur: 50.0, color: NSColor(white: 0.0, alpha: 0.4).cgColor)
        ctx.fill(imageRect)
        ctx.restoreGState()

        // Image
        image.draw(in: imageRect)

        // Release
        final.unlockFocus()

        // Get image
        let data = final.tiffRepresentation!
        let newImage = NSImage(data: data)!
        return newImage
    }
}
