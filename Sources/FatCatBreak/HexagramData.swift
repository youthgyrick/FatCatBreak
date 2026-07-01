#if os(macOS)
import Foundation

struct HexagramCatalog {
    let trigramOrder: [String]
    let trigrams: [String: HexagramTrigram]
    let hexagrams: [Hexagram]
    let explanations: [String: HexagramExplanation]

    var sortedHexagrams: [Hexagram] {
        hexagrams.sorted { $0.number < $1.number }
    }

    func hexagram(upper: String, lower: String) -> Hexagram? {
        hexagrams.first {
            $0.upperTrigram.name == upper && $0.lowerTrigram.name == lower
        }
    }

    func hexagram(number: Int) -> Hexagram? {
        hexagrams.first { $0.number == number || $0.id == number }
    }

    func explanation(for hexagram: Hexagram) -> HexagramExplanation? {
        explanations["\(hexagram.number)"] ?? explanations["\(hexagram.id)"]
    }

    static func load() -> HexagramCatalog {
        let hexagramData = loadData(named: "hexagrams", extension: "json")
        let explanationData = loadData(named: "hexagramExplanations", extension: "json")
        let decoder = JSONDecoder()
        let payload = (try? decoder.decode(HexagramPayload.self, from: hexagramData)) ?? HexagramPayload.empty
        let explanations = (try? decoder.decode([String: HexagramExplanation].self, from: explanationData)) ?? [:]
        let source = String(data: hexagramData, encoding: .utf8) ?? ""
        let order = trigramOrder(from: source)
        let catalog = HexagramCatalog(
            trigramOrder: order.isEmpty ? payload.trigrams.keys.sorted() : order,
            trigrams: payload.trigrams,
            hexagrams: payload.hexagrams,
            explanations: explanations
        )
        catalog.logMissingExplanations()
        return catalog
    }

    private func logMissingExplanations() {
        for hexagram in hexagrams.sorted(by: { $0.number < $1.number }) {
            let text = explanation(for: hexagram)?.rawText.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if text.isEmpty {
                NSLog("Warning: missing explanation for hexagram %d %@", hexagram.number, hexagram.name)
            }
        }
    }

    private static func loadData(named name: String, extension ext: String) -> Data {
        if let url = Bundle.main.url(forResource: name, withExtension: ext, subdirectory: "Data"),
           let data = try? Data(contentsOf: url) {
            return data
        }
        let fallback = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            .appendingPathComponent("Resources/Data/\(name).\(ext)")
        return (try? Data(contentsOf: fallback)) ?? Data()
    }

    private static func trigramOrder(from source: String) -> [String] {
        guard let start = source.range(of: "\"trigrams\""),
              let end = source.range(of: "\"hexagrams\"", range: start.upperBound..<source.endIndex) else {
            return []
        }
        let block = String(source[start.upperBound..<end.lowerBound])
        let pattern = #""([^"]+)"\s*:\s*\{"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        let range = NSRange(block.startIndex..<block.endIndex, in: block)
        return regex.matches(in: block, range: range).compactMap { match in
            guard let keyRange = Range(match.range(at: 1), in: block) else { return nil }
            let key = String(block[keyRange])
            return key.count == 1 ? key : nil
        }
    }
}

private struct HexagramPayload: Codable {
    let trigrams: [String: HexagramTrigram]
    let hexagrams: [Hexagram]

    static let empty = HexagramPayload(trigrams: [:], hexagrams: [])
}

struct HexagramTrigram: Codable {
    let element: String
    let symbol: String
    let bitsBottomToTop: String?
    let bitsTopToBottom: String?
    let unicode: String?

    enum CodingKeys: String, CodingKey {
        case element
        case symbol
        case bitsBottomToTop = "bits_bottom_to_top"
        case bitsTopToBottom = "bits_top_to_bottom"
        case unicode
    }
}

struct HexagramTrigramRef: Codable {
    let name: String
    let element: String
    let symbol: String
    let binaryBottomToTop: String?
}

struct Hexagram: Codable {
    let id: Int
    let kingWenNumber: Int?
    let name: String
    let shortName: String
    let unicode: String?
    let binary: String?
    let binaryBottomToTop: String?
    let binaryTopToBottom: String?
    let linesTopToBottom: [String]?
    let upperTrigram: HexagramTrigramRef
    let lowerTrigram: HexagramTrigramRef

    var number: Int { kingWenNumber ?? id }

    var displayLinesTopToBottom: [String] {
        if let linesTopToBottom, linesTopToBottom.count == 6 {
            return linesTopToBottom.map(Self.normalizedLine)
        }
        if let binaryTopToBottom, binaryTopToBottom.count == 6 {
            return binaryTopToBottom.map { $0 == "1" ? "⚊" : "⚋" }
        }
        let bottomToTop = binaryBottomToTop ?? binary ?? ""
        if bottomToTop.count == 6 {
            return bottomToTop.reversed().map { $0 == "1" ? "⚊" : "⚋" }
        }
        return Array(repeating: "⚋", count: 6)
    }

    private static func normalizedLine(_ value: String) -> String {
        if value == "1" || value == "⚊" { return "⚊" }
        return "⚋"
    }
}

struct HexagramExplanation: Codable {
    let name: String
    let shortName: String
    let content: [String: String]
    let rawText: String
}
#endif
