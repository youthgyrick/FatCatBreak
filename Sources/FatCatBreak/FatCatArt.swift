#if os(macOS)
import AppKit

enum FatCatScene: CaseIterable {
    case walk
    case nap
    case sign
    case drink
    case neck
    case divination

    var title: String {
        switch self {
        case .walk: return "休息一下，看看远处"
        case .nap: return "和胖猫一起打个盹"
        case .sign: return "胖猫举牌提醒你"
        case .drink: return "喝口水，放松一下"
        case .neck: return "转转脖子，松一松"
        case .divination: return "胖猫帮你起一卦"
        }
    }

    var subtitle: String {
        switch self {
        case .walk: return "胖猫正在巡逻"
        case .nap: return "胖猫已经趴好"
        case .sign: return "现在离开屏幕"
        case .drink: return "胖猫也在补水"
        case .neck: return "跟胖猫慢慢活动"
        case .divination: return "铜钱一落，灵感就来"
        }
    }
}

enum FatCatArt {
    static let canvasSize = NSSize(width: 360, height: 260)

    static func draw(in rect: NSRect, phase: TimeInterval, scene: FatCatScene, showsStage: Bool) {
        let scale = min(rect.width / canvasSize.width, rect.height / canvasSize.height)
        let drawSize = NSSize(width: canvasSize.width * scale, height: canvasSize.height * scale)
        let origin = NSPoint(
            x: rect.minX + (rect.width - drawSize.width) / 2,
            y: rect.minY + (rect.height - drawSize.height) / 2
        )

        NSGraphicsContext.saveGraphicsState()
        let transform = NSAffineTransform()
        transform.translateX(by: origin.x, yBy: origin.y)
        transform.scale(by: scale)
        transform.concat()

        if showsStage { drawStage() }
        drawScene(scene, phase: phase)
        NSGraphicsContext.restoreGraphicsState()
    }

    private static func drawScene(_ scene: FatCatScene, phase: TimeInterval) {
        switch scene {
        case .walk:
            drawCat(phase: phase, pose: .walk)
        case .nap:
            drawMoon(phase: phase)
            drawSleepingCat(phase: phase)
            drawSleepText(phase: phase)
        case .sign:
            drawSparkles(phase: phase)
            drawCat(phase: phase, pose: .sign)
            drawSign(phase: phase)
        case .drink:
            drawCat(phase: phase, pose: .drink)
            drawCup(phase: phase)
        case .neck:
            drawSparkles(phase: phase)
            drawCat(phase: phase, pose: .neck)
            drawNeckCue(phase: phase)
        case .divination:
            drawSparkles(phase: phase)
            drawDivinationSet(phase: phase)
            drawCat(phase: phase, pose: .divination)
            drawDivinationText(phase: phase)
        }
    }

    private enum Pose { case walk, sign, drink, neck, nap, divination }

    private static func drawStage() {
        let shadow = NSBezierPath(ovalIn: NSRect(x: 78, y: 11, width: 210, height: 26))
        NSColor(calibratedWhite: 0, alpha: 0.08).setFill()
        shadow.fill()
    }

    private static func drawCat(phase: TimeInterval, pose: Pose) {
        let outline = NSColor.black
        let fur = NSColor(calibratedRed: 1.0, green: 0.60, blue: 0.02, alpha: 1)
        let furDeep = NSColor(calibratedRed: 0.92, green: 0.46, blue: 0.0, alpha: 1)
        let cream = NSColor(calibratedRed: 1.0, green: 0.89, blue: 0.47, alpha: 1)

        let sceneBob: CGFloat
        let legSwing: CGFloat
        let tailWave: CGFloat
        let headTilt: CGFloat
        let headOffsetY: CGFloat
        let bodyRotation: CGFloat

        switch pose {
        case .walk:
            sceneBob = CGFloat(sin(phase * 6.5)) * 3
            legSwing = CGFloat(sin(phase * 8.5)) * 7
            tailWave = CGFloat(sin(phase * 4.5)) * 4
            headTilt = 0
            headOffsetY = 0
            bodyRotation = 0
        case .sign:
            sceneBob = CGFloat(sin(phase * 4.2)) * 4
            legSwing = CGFloat(sin(phase * 3.4)) * 2
            tailWave = CGFloat(sin(phase * 3.2)) * 2
            headTilt = -4
            headOffsetY = 1
            bodyRotation = 0
        case .drink:
            sceneBob = CGFloat(sin(phase * 4.1)) * 2
            legSwing = CGFloat(sin(phase * 2.8)) * 1.2
            tailWave = CGFloat(sin(phase * 3.1)) * 2
            headTilt = 8 * max(0, sin(phase * 2.4))
            headOffsetY = -6 * max(0, sin(phase * 2.4))
            bodyRotation = 0
        case .neck:
            sceneBob = CGFloat(sin(phase * 4.0)) * 2
            legSwing = 0
            tailWave = CGFloat(sin(phase * 2.2)) * 2
            headTilt = CGFloat(sin(phase * 2.8)) * 16
            headOffsetY = 0
            bodyRotation = 0
        case .nap:
            sceneBob = 0
            legSwing = 0
            tailWave = CGFloat(sin(phase * 1.7)) * 1.5
            headTilt = 10
            headOffsetY = -9
            bodyRotation = -6
        case .divination:
            sceneBob = CGFloat(sin(phase * 3.0)) * 2
            legSwing = CGFloat(sin(phase * 2.2)) * 1.2
            tailWave = CGFloat(sin(phase * 2.5)) * 2.6
            headTilt = CGFloat(sin(phase * 1.8)) * 3
            headOffsetY = 0
            bodyRotation = 0
        }

        NSGraphicsContext.saveGraphicsState()
        let root = NSAffineTransform()
        root.translateX(by: 0, yBy: sceneBob)
        root.concat()

        drawTail(outline: outline, fur: fur, wave: tailWave)

        if pose != .nap {
            drawLeg(x: 104 + legSwing * 0.30, y: 22, height: 66, color: fur, outline: outline)
            drawLeg(x: 164 - legSwing * 0.22, y: 20, height: 62, color: fur, outline: outline)
            drawLeg(x: 242 + legSwing * 0.18, y: 19, height: 72, color: fur, outline: outline)
        } else {
            drawPaws(color: fur, outline: outline)
        }

        NSGraphicsContext.saveGraphicsState()
        let bodyTransform = NSAffineTransform()
        bodyTransform.translateX(by: 170, yBy: 122)
        bodyTransform.rotate(byDegrees: bodyRotation)
        bodyTransform.translateX(by: -170, yBy: -122)
        bodyTransform.concat()

        let bodyOuter = NSBezierPath(ovalIn: NSRect(x: 58, y: 54, width: 226, height: 142))
        outline.setFill()
        bodyOuter.fill()
        let bodyInner = NSBezierPath(ovalIn: NSRect(x: 66, y: 62, width: 210, height: 126))
        NSGradient(starting: fur, ending: furDeep)?.draw(in: bodyInner, angle: -18)

        let belly = NSBezierPath(ovalIn: NSRect(x: 128, y: 76, width: 112, height: 82))
        cream.setFill()
        belly.fill()
        NSGraphicsContext.restoreGraphicsState()

        drawHead(outline: outline, fur: fur, furDeep: furDeep, angle: headTilt, yOffset: headOffsetY, sleeping: pose == .nap)
        drawFace(outline: outline, angle: headTilt, yOffset: headOffsetY, sleeping: pose == .nap)
        NSGraphicsContext.restoreGraphicsState()
    }

    private static func drawSleepingCat(phase: TimeInterval) {
        drawCat(phase: phase, pose: .nap)
    }

    private static func drawTail(outline: NSColor, fur: NSColor, wave: CGFloat) {
        let outer = NSBezierPath()
        outer.move(to: NSPoint(x: 55, y: 91))
        outer.curve(
            to: NSPoint(x: 26, y: 172 + wave),
            controlPoint1: NSPoint(x: 15, y: 100 + wave),
            controlPoint2: NSPoint(x: 9, y: 153 + wave)
        )
        outer.lineWidth = 26
        outer.lineCapStyle = .round
        outline.setStroke()
        outer.stroke()

        let inner = NSBezierPath()
        inner.move(to: NSPoint(x: 56, y: 95))
        inner.curve(
            to: NSPoint(x: 44, y: 149 + wave),
            controlPoint1: NSPoint(x: 33, y: 105 + wave),
            controlPoint2: NSPoint(x: 31, y: 135 + wave)
        )
        inner.lineWidth = 13
        inner.lineCapStyle = .round
        fur.setStroke()
        inner.stroke()
    }

    private static func drawLeg(x: CGFloat, y: CGFloat, height: CGFloat, color: NSColor, outline: NSColor) {
        let outer = NSBezierPath(roundedRect: NSRect(x: x, y: y, width: 37, height: height), xRadius: 18, yRadius: 18)
        outline.setFill()
        outer.fill()
        let inner = NSBezierPath(roundedRect: NSRect(x: x + 8, y: y + 7, width: 21, height: height - 14), xRadius: 11, yRadius: 11)
        color.setFill()
        inner.fill()
    }

    private static func drawPaws(color: NSColor, outline: NSColor) {
        for paw in [NSRect(x: 116, y: 26, width: 42, height: 28), NSRect(x: 162, y: 22, width: 46, height: 30), NSRect(x: 208, y: 26, width: 42, height: 28)] {
            let outer = NSBezierPath(roundedRect: paw, xRadius: 15, yRadius: 15)
            outline.setFill()
            outer.fill()
            let inner = NSBezierPath(roundedRect: paw.insetBy(dx: 7, dy: 6), xRadius: 10, yRadius: 10)
            color.setFill()
            inner.fill()
        }
    }

    private static func drawHead(outline: NSColor, fur: NSColor, furDeep: NSColor, angle: CGFloat, yOffset: CGFloat, sleeping: Bool) {
        NSGraphicsContext.saveGraphicsState()
        let t = NSAffineTransform()
        t.translateX(by: 281, yBy: 155 + yOffset)
        t.rotate(byDegrees: angle)
        t.translateX(by: -281, yBy: -(155 + yOffset))
        t.concat()

        outline.setFill()
        triangle(NSPoint(x: 240, y: 167 + yOffset), NSPoint(x: 256, y: 250 + yOffset), NSPoint(x: 288, y: 176 + yOffset)).fill()
        triangle(NSPoint(x: 300, y: 176 + yOffset), NSPoint(x: 336, y: 248 + yOffset), NSPoint(x: 344, y: 157 + yOffset)).fill()

        let headOuter = NSBezierPath(ovalIn: NSRect(x: 210, y: 92 + yOffset, width: 142, height: 126))
        headOuter.fill()
        let headInner = NSBezierPath(ovalIn: NSRect(x: 220, y: 102 + yOffset, width: 122, height: 106))
        NSGradient(starting: fur, ending: furDeep)?.draw(in: headInner, angle: -20)

        if sleeping {
            let cheek = NSBezierPath(ovalIn: NSRect(x: 246, y: 108 + yOffset, width: 72, height: 42))
            NSColor(calibratedWhite: 1, alpha: 0.12).setFill()
            cheek.fill()
        }
        NSGraphicsContext.restoreGraphicsState()
    }

    private static func drawFace(outline: NSColor, angle: CGFloat, yOffset: CGFloat, sleeping: Bool) {
        NSGraphicsContext.saveGraphicsState()
        let t = NSAffineTransform()
        t.translateX(by: 281, yBy: 155 + yOffset)
        t.rotate(byDegrees: angle)
        t.translateX(by: -281, yBy: -(155 + yOffset))
        t.concat()

        if sleeping {
            let leftEye = NSBezierPath()
            leftEye.move(to: NSPoint(x: 257, y: 165 + yOffset))
            leftEye.curve(to: NSPoint(x: 273, y: 165 + yOffset), controlPoint1: NSPoint(x: 261, y: 158 + yOffset), controlPoint2: NSPoint(x: 269, y: 158 + yOffset))
            let rightEye = NSBezierPath()
            rightEye.move(to: NSPoint(x: 312, y: 164 + yOffset))
            rightEye.curve(to: NSPoint(x: 328, y: 164 + yOffset), controlPoint1: NSPoint(x: 316, y: 157 + yOffset), controlPoint2: NSPoint(x: 324, y: 157 + yOffset))
            leftEye.lineWidth = 5
            rightEye.lineWidth = 5
            outline.setStroke()
            leftEye.stroke()
            rightEye.stroke()
        } else {
            outline.setFill()
            NSBezierPath(ovalIn: NSRect(x: 259, y: 159 + yOffset, width: 13, height: 25)).fill()
            NSBezierPath(ovalIn: NSRect(x: 314, y: 158 + yOffset, width: 13, height: 25)).fill()
        }

        outline.setFill()
        NSBezierPath(ovalIn: NSRect(x: 287, y: 136 + yOffset, width: 20, height: 15)).fill()

        let whiskers = NSBezierPath()
        whiskers.move(to: NSPoint(x: 284, y: 136 + yOffset)); whiskers.line(to: NSPoint(x: 222, y: 146 + yOffset))
        whiskers.move(to: NSPoint(x: 283, y: 126 + yOffset)); whiskers.line(to: NSPoint(x: 222, y: 116 + yOffset))
        whiskers.move(to: NSPoint(x: 309, y: 136 + yOffset)); whiskers.line(to: NSPoint(x: 361, y: 146 + yOffset))
        whiskers.move(to: NSPoint(x: 309, y: 126 + yOffset)); whiskers.line(to: NSPoint(x: 361, y: 116 + yOffset))
        whiskers.lineWidth = 5
        whiskers.lineCapStyle = .round
        outline.setStroke()
        whiskers.stroke()
        NSGraphicsContext.restoreGraphicsState()
    }

    private static func drawMoon(phase: TimeInterval) {
        let moon = NSBezierPath(ovalIn: NSRect(x: 252, y: 208, width: 48, height: 48))
        NSColor(calibratedRed: 1, green: 0.97, blue: 0.74, alpha: 0.78).setFill()
        moon.fill()
        let cut = NSBezierPath(ovalIn: NSRect(x: 266 + CGFloat(sin(phase * 0.8)) * 2, y: 215, width: 42, height: 42))
        NSColor.white.setFill()
        cut.fill()
    }

    private static func drawSleepText(phase: TimeInterval) {
        let alpha = 0.35 + 0.55 * ((sin(phase * 2.3) + 1) / 2)
        let attrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 26, weight: .bold),
            .foregroundColor: NSColor.white.withAlphaComponent(alpha)
        ]
        ("Z z z" as NSString).draw(at: NSPoint(x: 312, y: 222 + CGFloat(sin(phase * 1.7)) * 6), withAttributes: attrs)
    }

    private static func drawSign(phase: TimeInterval) {
        let bounce = CGFloat(sin(phase * 2.1)) * 4
        let outer = NSBezierPath(roundedRect: NSRect(x: 240, y: 202 + bounce, width: 112, height: 56), xRadius: 18, yRadius: 18)
        NSColor.black.setFill()
        outer.fill()
        let inner = NSBezierPath(roundedRect: NSRect(x: 246, y: 208 + bounce, width: 100, height: 44), xRadius: 14, yRadius: 14)
        NSColor(calibratedRed: 1, green: 0.96, blue: 0.79, alpha: 1).setFill()
        inner.fill()
        let attrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 18, weight: .heavy),
            .foregroundColor: NSColor(calibratedRed: 0.18, green: 0.14, blue: 0.12, alpha: 1)
        ]
        ("休息啦" as NSString).draw(at: NSPoint(x: 266, y: 219 + bounce), withAttributes: attrs)
    }

    private static func drawCup(phase: TimeInterval) {
        let sway = max(0, sin(phase * 2.4))
        let x: CGFloat = 246
        let y: CGFloat = 18
        let cupOuter = NSBezierPath(roundedRect: NSRect(x: x, y: y, width: 58, height: 44), xRadius: 12, yRadius: 12)
        NSColor.black.setFill()
        cupOuter.fill()
        let cupInner = NSBezierPath(roundedRect: NSRect(x: x + 6, y: y + 6, width: 46, height: 32), xRadius: 9, yRadius: 9)
        NSColor(calibratedRed: 0.73, green: 0.92, blue: 1.0, alpha: 1).setFill()
        cupInner.fill()
        let handle = NSBezierPath()
        handle.appendArc(withCenter: NSPoint(x: x + 56, y: y + 22), radius: 12, startAngle: -90, endAngle: 90)
        handle.lineWidth = 6
        NSColor.black.setStroke()
        handle.stroke()

        let water = NSBezierPath(roundedRect: NSRect(x: x + 11, y: y + 25, width: 36, height: 7), xRadius: 4, yRadius: 4)
        NSColor(calibratedRed: 0.35, green: 0.77, blue: 1.0, alpha: 1).setFill()
        water.fill()

        let droplet = NSBezierPath(ovalIn: NSRect(x: x + 36, y: y + 52 - sway * 22, width: 10, height: 15))
        NSColor(calibratedRed: 0.56, green: 0.86, blue: 1.0, alpha: 0.78).setFill()
        droplet.fill()
    }

    private static func drawNeckCue(phase: TimeInterval) {
        let alpha = 0.48 + 0.28 * ((sin(phase * 2.0) + 1) / 2)
        let cue = NSBezierPath()
        cue.move(to: NSPoint(x: 170, y: 196))
        cue.curve(to: NSPoint(x: 246, y: 196), controlPoint1: NSPoint(x: 183, y: 226), controlPoint2: NSPoint(x: 233, y: 226))
        cue.lineWidth = 5
        cue.lineCapStyle = .round
        NSColor(calibratedRed: 1, green: 0.97, blue: 0.74, alpha: alpha).setStroke()
        cue.stroke()
    }

    private static func drawDivinationSet(phase: TimeInterval) {
        let floatingCoinOffset = CGFloat(sin(phase * 3.0)) * 9
        for coinRect in [
            NSRect(x: 124, y: 20 + CGFloat(sin(phase * 2.0)) * 1.5, width: 40, height: 40),
            NSRect(x: 176, y: 96 + floatingCoinOffset, width: 40, height: 40),
            NSRect(x: 228, y: 20 + CGFloat(sin(phase * 2.0 + 1.6)) * 1.5, width: 40, height: 40)
        ] {
            let coin = NSBezierPath(ovalIn: coinRect)
            NSColor(calibratedRed: 0.86, green: 0.66, blue: 0.22, alpha: 1).setFill()
            coin.fill()
            NSColor(calibratedRed: 0.42, green: 0.25, blue: 0.06, alpha: 1).setStroke()
            coin.lineWidth = 4
            coin.stroke()
            let inset = 12.0
            let hole = NSBezierPath(roundedRect: coinRect.insetBy(dx: inset, dy: inset), xRadius: 3, yRadius: 3)
            NSColor(calibratedRed: 0.64, green: 0.12, blue: 0.08, alpha: 1).setFill()
            hole.fill()
        }

        let cloud = NSBezierPath()
        cloud.move(to: NSPoint(x: 182, y: 214))
        cloud.curve(to: NSPoint(x: 208, y: 214), controlPoint1: NSPoint(x: 186, y: 226), controlPoint2: NSPoint(x: 201, y: 226))
        cloud.curve(to: NSPoint(x: 224, y: 205), controlPoint1: NSPoint(x: 215, y: 214), controlPoint2: NSPoint(x: 221, y: 210))
        cloud.curve(to: NSPoint(x: 246, y: 208), controlPoint1: NSPoint(x: 232, y: 196), controlPoint2: NSPoint(x: 241, y: 198))
        cloud.curve(to: NSPoint(x: 260, y: 200), controlPoint1: NSPoint(x: 250, y: 213), controlPoint2: NSPoint(x: 256, y: 209))
        cloud.lineWidth = 4
        NSColor(calibratedRed: 0.95, green: 0.68, blue: 0.16, alpha: 1).setStroke()
        cloud.stroke()
    }

    private static func drawDivinationText(phase: TimeInterval) {
        let bounce = CGFloat(sin(phase * 2.1)) * 4
        let outer = NSBezierPath(roundedRect: NSRect(x: 240, y: 202 + bounce, width: 112, height: 56), xRadius: 18, yRadius: 18)
        NSColor.black.setFill()
        outer.fill()
        let inner = NSBezierPath(roundedRect: NSRect(x: 246, y: 208 + bounce, width: 100, height: 44), xRadius: 14, yRadius: 14)
        NSColor(calibratedRed: 1, green: 0.96, blue: 0.79, alpha: 1).setFill()
        inner.fill()
        let attrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 18, weight: .heavy),
            .foregroundColor: NSColor(calibratedRed: 0.18, green: 0.14, blue: 0.12, alpha: 1)
        ]
        ("来一卦" as NSString).draw(at: NSPoint(x: 266, y: 219 + bounce), withAttributes: attrs)
    }

    private static func drawSparkles(phase: TimeInterval) {
        let stars = [
            NSPoint(x: 118, y: 214),
            NSPoint(x: 282, y: 225),
            NSPoint(x: 222, y: 238)
        ]
        for (index, star) in stars.enumerated() {
            let pulse = 0.35 + 0.65 * ((sin(phase * (2.1 + Double(index) * 0.5) + Double(index)) + 1) / 2)
            let size = 10 + pulse * 8
            let rect = NSRect(x: star.x - size / 2, y: star.y - size / 2, width: size, height: size)
            let path = NSBezierPath(ovalIn: rect)
            NSColor(calibratedRed: 1, green: 0.97, blue: 0.74, alpha: pulse).setFill()
            path.fill()
        }
    }

    private static func triangle(_ a: NSPoint, _ b: NSPoint, _ c: NSPoint) -> NSBezierPath {
        let path = NSBezierPath()
        path.move(to: a)
        path.line(to: b)
        path.line(to: c)
        path.close()
        return path
    }
}
#endif
