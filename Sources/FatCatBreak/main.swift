#if os(macOS)
import AppKit

let application = NSApplication.shared
let delegate = AppDelegate()
application.delegate = delegate
application.setActivationPolicy(.regular)
application.run()
#else
import Foundation
fputs("FatCatBreak is a macOS application. Build and run it on macOS 13 or newer.\n", stderr)
#endif
