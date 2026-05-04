//import UIKit
//import CoreVideo
//
//extension UIImage {
//
//    func resize(to targetSize: CGSize) -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
//        draw(in: CGRect(origin: .zero, size: targetSize))
//        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return resizedImage
//    }
//
//    func toPixelBuffer(width: Int = 224, height: Int = 224) -> CVPixelBuffer? {
//        let attrs: [CFString: Any] = [
//            kCVPixelBufferCGImageCompatibilityKey: true,
//            kCVPixelBufferCGBitmapContextCompatibilityKey: true
//        ]
//
//        var pixelBuffer: CVPixelBuffer?
//        let status = CVPixelBufferCreate(
//            kCFAllocatorDefault,
//            width,
//            height,
//            kCVPixelFormatType_32BGRA,
//            attrs as CFDictionary,
//            &pixelBuffer
//        )
//
//        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
//            return nil
//        }
//
//        CVPixelBufferLockBaseAddress(buffer, [])
//        defer { CVPixelBufferUnlockBaseAddress(buffer, []) }
//
//        guard let context = CGContext(
//            data: CVPixelBufferGetBaseAddress(buffer),
//            width: width,
//            height: height,
//            bitsPerComponent: 8,
//            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
//            space: CGColorSpaceCreateDeviceRGB(),
//            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
//        ) else {
//            return nil
//        }
//
//        guard let cgImage = self.cgImage else { return nil }
//        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
//        return buffer
//    }
//}
import UIKit
import CoreVideo
import CoreML

extension UIImage {

    func normalizedOrientation() -> UIImage {
        if imageOrientation == .up { return self }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return normalizedImage ?? self
    }

    func resize(to targetSize: CGSize) -> UIImage? {
        let fixedImage = self.normalizedOrientation()

        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        fixedImage.draw(in: CGRect(origin: .zero, size: targetSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }

 func toPixelBuffer(width: Int = 224, height: Int = 224) -> CVPixelBuffer? {
        let attrs: [CFString: Any] = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true
        ]

        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32ARGB,
            attrs as CFDictionary,
            &pixelBuffer
        )

        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(buffer, [])
        defer { CVPixelBufferUnlockBaseAddress(buffer, []) }

        guard let context = CGContext(
            data: CVPixelBufferGetBaseAddress(buffer),
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else {
            return nil
        }

        guard let cgImage = self.normalizedOrientation().cgImage else {
            return nil
        }

        context.clear(CGRect(x: 0, y: 0, width: width, height: height))
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        return buffer
    }
}
