import AckeeSnapshots

public let defaultSnapshotDevice: SnapshotDevice = .iPhone13ProMax

private let iPhoneDevices: [SnapshotDevice] = [
    .iPhone8,
    defaultSnapshotDevice
]

public let AssertSnapshot: SnapshotTest = .init(
    devices: iPhoneDevices,
    record: false,
    displayScale: 1,
    contentSizes: [.extraExtraExtraLarge, .large, .small],
    colorSchemes: [.dark]
)
