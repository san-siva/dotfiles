import Foundation
import IOKit.hid

// Watches for Logitech MX Keys Mini (VID: 0x46D, PID: 0xB369) and applies
// a one-way Caps Lock -> Left Ctrl mapping via hidutil on every connect.

private func applyMapping() {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/usr/bin/hidutil")
    task.arguments = [
        "property",
        "--matching", "{\"VendorID\":0x46D,\"ProductID\":0xB369}",
        "--set", "{\"UserKeyMapping\":[{\"HIDKeyboardModifierMappingSrc\":0x700000039,\"HIDKeyboardModifierMappingDst\":0x7000000E0}]}"
    ]
    try? task.run()
    task.waitUntilExit()
}

let manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))

IOHIDManagerSetDeviceMatching(manager, [
    kIOHIDVendorIDKey: 0x046D,
    kIOHIDProductIDKey: 0xB369
] as CFDictionary)

IOHIDManagerRegisterDeviceMatchingCallback(manager, { _, _, _, _ in
    applyMapping()
}, nil)

IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
IOHIDManagerOpen(manager, IOOptionBits(kIOHIDOptionsTypeNone))

// Apply immediately in case the device is already connected at launch
applyMapping()

CFRunLoopRun()
