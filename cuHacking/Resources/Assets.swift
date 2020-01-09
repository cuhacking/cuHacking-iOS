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
    internal static let backdrop1 = ColorAsset(name: "Backdrop-1")
    internal static let backdrop = ColorAsset(name: "Backdrop")
    internal static let background = ColorAsset(name: "Background")
    internal static let blue1 = ColorAsset(name: "Blue1")
    internal static let blue2 = ColorAsset(name: "Blue2")
    internal static let blue3 = ColorAsset(name: "Blue3")
    internal static let blue4 = ColorAsset(name: "Blue4")
    internal static let blue5 = ColorAsset(name: "Blue5")
    internal static let blue6 = ColorAsset(name: "Blue6")
    internal static let blueEvent = ColorAsset(name: "BlueEvent")
    internal static let darkGray = ColorAsset(name: "DarkGray")
    internal static let elevator = ColorAsset(name: "Elevator")
    internal static let gray = ColorAsset(name: "Gray")
    internal static let greenEvent = ColorAsset(name: "GreenEvent")
    internal static let hallway = ColorAsset(name: "Hallway")
    internal static let line = ColorAsset(name: "Line")
    internal static let primary = ColorAsset(name: "Primary")
    internal static let primaryText = ColorAsset(name: "PrimaryText")
    internal static let purple = ColorAsset(name: "Purple")
    internal static let purpleEvent = ColorAsset(name: "PurpleEvent")
    internal static let redEvent = ColorAsset(name: "RedEvent")
    internal static let room = ColorAsset(name: "Room")
    internal static let secondarySurface = ColorAsset(name: "SecondarySurface")
    internal static let secondayText = ColorAsset(name: "SecondayText")
    internal static let stairs = ColorAsset(name: "Stairs")
    internal static let subtitle = ColorAsset(name: "Subtitle")
    internal static let surface = ColorAsset(name: "Surface")
    internal static let title = ColorAsset(name: "Title")
    internal static let washroom = ColorAsset(name: "Washroom")
  }
  internal enum Images {
    internal static let failure = ImageAsset(name: "Failure")
    internal static let foodIcon = ImageAsset(name: "FoodIcon")
    internal static let grad = ImageAsset(name: "Grad")
    internal static let homeIcon = ImageAsset(name: "HomeIcon")
    internal static let mail = ImageAsset(name: "Mail")
    internal static let bus = ImageAsset(name: "Bus")
    internal static let elevators = ImageAsset(name: "Elevators")
    internal static let food = ImageAsset(name: "Food")
    internal static let information = ImageAsset(name: "Information")
    internal static let parking = ImageAsset(name: "Parking")
    internal static let stairs = ImageAsset(name: "Stairs")
    internal static let stairsA1 = ImageAsset(name: "StairsA1")
    internal static let stairsA2 = ImageAsset(name: "StairsA2")
    internal static let stairsA3 = ImageAsset(name: "StairsA3")
    internal static let stairsB1 = ImageAsset(name: "StairsB1")
    internal static let stairsB2 = ImageAsset(name: "StairsB2")
    internal static let stairsB3 = ImageAsset(name: "StairsB3")
    internal static let stairsC1 = ImageAsset(name: "StairsC1")
    internal static let stairsC2 = ImageAsset(name: "StairsC2")
    internal static let stairsC3 = ImageAsset(name: "StairsC3")
    internal static let stairsD1 = ImageAsset(name: "StairsD1")
    internal static let stairsD2 = ImageAsset(name: "StairsD2")
    internal static let stairsD3 = ImageAsset(name: "StairsD3")
    internal static let stairsE1 = ImageAsset(name: "StairsE1")
    internal static let stairsE2 = ImageAsset(name: "StairsE2")
    internal static let stairsE3 = ImageAsset(name: "StairsE3")
    internal static let stairsF1 = ImageAsset(name: "StairsF1")
    internal static let stairsF2 = ImageAsset(name: "StairsF2")
    internal static let stairsF3 = ImageAsset(name: "StairsF3")
    internal static let stairsG1 = ImageAsset(name: "StairsG1")
    internal static let stairsG2 = ImageAsset(name: "StairsG2")
    internal static let stairsG3 = ImageAsset(name: "StairsG3")
    internal static let stairsH1 = ImageAsset(name: "StairsH1")
    internal static let stairsH2 = ImageAsset(name: "StairsH2")
    internal static let stairsH3 = ImageAsset(name: "StairsH3")
    internal static let train = ImageAsset(name: "Train")
    internal static let washroomFemale = ImageAsset(name: "WashroomFemale")
    internal static let washroomMale = ImageAsset(name: "WashroomMale")
    internal static let washroomNeutral = ImageAsset(name: "WashroomNeutral")
    internal static let waterFountain2 = ImageAsset(name: "Water Fountain 2")
    internal static let waterFountain = ImageAsset(name: "Water Fountain")
    internal static let mapIcon = ImageAsset(name: "MapIcon")
    internal static let mapPinPoint = ImageAsset(name: "MapPinPoint")
    internal static let profileIcon = ImageAsset(name: "ProfileIcon")
    internal static let qr = ImageAsset(name: "QR")
    internal static let qrIcon = ImageAsset(name: "QRIcon")
    internal static let scheduleIcon = ImageAsset(name: "ScheduleIcon")
    internal static let settingsIcon = ImageAsset(name: "SettingsIcon")
    internal static let success = ImageAsset(name: "Success")
    internal static let add = ImageAsset(name: "add")
    internal static let blueQR = ImageAsset(name: "blueQR")
    internal static let cuHackingLogo = ImageAsset(name: "cuHackingLogo")
    internal static let elevator = ImageAsset(name: "elevator")
    internal static let greenQR = ImageAsset(name: "greenQR")
    internal static let info = ImageAsset(name: "info")
    internal static let pinkQR = ImageAsset(name: "pinkQR")
    internal static let redQR = ImageAsset(name: "redQR")
    internal static let sampleQR = ImageAsset(name: "sampleQR")
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
