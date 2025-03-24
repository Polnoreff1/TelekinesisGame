import Foundation

struct ZPositions {
    static let ui: CGFloat = 50
    static let player: CGFloat = 300
    static let cameraElements: CGFloat = 99
    static let miniGames: CGFloat = 250
    static let underMainTextures: CGFloat = -200
    static let textures: CGFloat = -100
}

struct PhysicsBodies {
    static let player: UInt32 = 0x1 << 1
    static let border: UInt32 = 0x1 << 2
    static let balloon: UInt32 = 0x1 << 3
    static let spikes: UInt32 = 0x1 << 4
    static let playerHand: UInt32 = 0x1 << 5
    static let finishNode: UInt32 = 0x1 << 6
    static let makeBiggerNode: UInt32 = 0x1 << 7
    static let makeSmallerNode: UInt32 = 0x1 << 8
    static let btn: UInt32 = 0x1 << 9
    static let looseNode: UInt32 = 0x1 << 10
}
