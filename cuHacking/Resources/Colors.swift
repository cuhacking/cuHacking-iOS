// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias AssetColorTypeAlias = NSColor
  internal typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias AssetColorTypeAlias = UIColor
  internal typealias AssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Colors {
    internal static let black = ColorAsset(name: "Black")
    internal static let blue1 = ColorAsset(name: "Blue1")
    internal static let blue2 = ColorAsset(name: "Blue2")
    internal static let blue3 = ColorAsset(name: "Blue3")
    internal static let blue4 = ColorAsset(name: "Blue4")
    internal static let blue5 = ColorAsset(name: "Blue5")
    internal static let blue6 = ColorAsset(name: "Blue6")
    internal static let darkGray = ColorAsset(name: "DarkGray")
    internal static let gray = ColorAsset(name: "Gray")
    internal static let purple = ColorAsset(name: "Purple")
    internal static let white = ColorAsset(name: "White")
  }
  internal enum Images {
    internal static let cuHackingLogoLight = ImageAsset(name: "CUHackingLogo_Light")
    internal static let grad = ImageAsset(name: "Grad")
    internal static let homeIcon = ImageAsset(name: "HomeIcon")
    internal static let mail = ImageAsset(name: "Mail")
    internal static let mapIcon = ImageAsset(name: "MapIcon")
    internal static let profileIcon = ImageAsset(name: "ProfileIcon")
    internal static let qr = ImageAsset(name: "QR")
    internal static let qrIcon = ImageAsset(name: "QRIcon")
    internal static let scheduleIcon = ImageAsset(name: "ScheduleIcon")
    internal static let settingsIcon = ImageAsset(name: "SettingsIcon")
    internal static let add = ImageAsset(name: "add")
    internal static let blueQR = ImageAsset(name: "blueQR")
    internal static let elevator = ImageAsset(name: "elevator")
    internal static let greenQR = ImageAsset(name: "greenQR")
    internal static let pinkQR = ImageAsset(name: "pinkQR")
    internal static let redQR = ImageAsset(name: "redQR")
    internal static let stairs = ImageAsset(name: "stairs")
    internal static let washroom = ImageAsset(name: "washroom")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  internal var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

internal extension AssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct DataAsset {
  internal fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(OSX)
  @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
  internal var data: NSDataAsset {
    return NSDataAsset(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(OSX)
@available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
internal extension NSDataAsset {
  convenience init!(asset: DataAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(OSX)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  internal var image: AssetImageTypeAlias {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = AssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = AssetImageTypeAlias(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal extension AssetImageTypeAlias {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {}
