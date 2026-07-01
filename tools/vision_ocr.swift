import AppKit
import Foundation
import Vision

guard CommandLine.arguments.count >= 2 else {
    fputs("usage: vision_ocr <image> [x y width height]\n", stderr)
    exit(2)
}

let imagePath = CommandLine.arguments[1]
guard let nsImage = NSImage(contentsOfFile: imagePath),
      let tiff = nsImage.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiff),
      let cgImage = bitmap.cgImage else {
    fputs("failed to load image\n", stderr)
    exit(1)
}

var requestOptions: [VNImageOption: Any] = [:]
let handlerImage: CGImage

if CommandLine.arguments.count == 6,
   let x = Int(CommandLine.arguments[2]),
   let y = Int(CommandLine.arguments[3]),
   let w = Int(CommandLine.arguments[4]),
   let h = Int(CommandLine.arguments[5]),
   let cropped = cgImage.cropping(to: CGRect(x: x, y: y, width: w, height: h)) {
    handlerImage = cropped
} else {
    handlerImage = cgImage
}

let request = VNRecognizeTextRequest()
request.recognitionLevel = .accurate
request.usesLanguageCorrection = true
let preferredLanguages = ["zh-Hans", "zh-Hant", "en-US"]
if let supported = try? request.supportedRecognitionLanguages() {
    let usable = preferredLanguages.filter { supported.contains($0) }
    if !usable.isEmpty {
        request.recognitionLanguages = usable
    }
}

let handler = VNImageRequestHandler(cgImage: handlerImage, options: requestOptions)
do {
    try handler.perform([request])
} catch {
    fputs("recognition failed: \(error)\n", stderr)
    exit(1)
}

let observations = (request.results ?? []).sorted {
    if abs($0.boundingBox.minY - $1.boundingBox.minY) > 0.01 {
        return $0.boundingBox.minY > $1.boundingBox.minY
    }
    return $0.boundingBox.minX < $1.boundingBox.minX
}

for observation in observations {
    if let candidate = observation.topCandidates(1).first {
        print(candidate.string)
    }
}
