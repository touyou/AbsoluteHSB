//
//  Color.swift
//  AbsoluteHSB
//
//  Created by 藤井陽介 on 2019/03/23.
//

import Foundation

internal struct HSBColor {

    // white and alpha
    var white: CGFloat?

    // RGB
    var red: CGFloat?
    var green: CGFloat?
    var blue: CGFloat?

    // displayP3
    var displayP3Red: CGFloat?

    var alpha: CGFloat?

    var hue: CGFloat {

        get {
            // RGB
            if let _r = red,
                let _g = green,
                let _b = blue {

                return getHue(red: _r, green: _g, blue: _b)
            }

            // grayscale
            if let _ = white {

                return 0.0
            }

            // P3 Colorspace
            if #available(OSX 10.11.2, *) {
                if let _r = displayP3Red,
                    let _g = green,
                    let _b = blue {


                    let sRGB = convertP3RGB(red: _r, green: _g, blue: _b, alpha: alpha ?? 1.0)
                    return getHue(red: sRGB.red, green: sRGB.green, blue: sRGB.blue)
                }
            }

            // TODO: implement for other initializer
            return 0.0
        }
    }

    var saturation: CGFloat {

        get {
            // RGB
            if let _r = red,
                let _g = green,
                let _b = blue {

                return getSaturation(red: _r, green: _g, blue: _b)
            }

            // grayscale
            if let _ = white {

                return 0.0
            }

            // P3 Colorspace
            if #available(OSX 10.11.2, *) {
                if let _r = displayP3Red,
                    let _g = green,
                    let _b = blue {


                    let sRGB = convertP3RGB(red: _r, green: _g, blue: _b, alpha: alpha ?? 1.0)
                    return getSaturation(red: sRGB.red, green: sRGB.green, blue: sRGB.blue)
                }
            }

            // TODO: implement for other initializer
            return 0.0
        }
    }

    var brightness: CGFloat {

        get {
            // RGB
            if let _r = red,
                let _g = green,
                let _b = blue {

                return getBrightness(red: _r, green: _g, blue: _b)
            }

            // grayscale
            if let _white = white {

                return _white
            }

            // P3 Colorspace
            if #available(OSX 10.11.2, *) {
                if let _r = displayP3Red,
                    let _g = green,
                    let _b = blue {


                    let sRGB = convertP3RGB(red: _r, green: _g, blue: _b, alpha: alpha ?? 1.0)
                    return getBrightness(red: sRGB.red, green: sRGB.green, blue: sRGB.blue)
                }
            }

            // TODO: implement for other initializer
            return 0.0
        }
    }

    private func getHue(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat {

        let r = red * 255
        let g = green * 255
        let b = blue * 255

        if r == g && g == b {

            return 0.0
        }
        if r >= g && r >= b {

            let value = 60 * ((g - b) / (r - min(g, b)))
            return (value < 0 ? value + 360 : value) / 360.0
        }
        if g >= r && g >= b {

            let value = 60 * ((b - r) / (g - min(r, b))) + 120
            return (value < 0 ? value + 360 : value) / 360.0
        }
        if b >= r && b >= g {

            let value = 60 * ((r - g) / (b - min(r, g))) + 240
            return (value < 0 ? value + 360 : value) / 360.0
        }

        return 0.0
    }

    private func getSaturation(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat {

        let maxValue = max(red, max(green, blue))
        let minValue = min(red, min(green, blue))
        return (maxValue - minValue) / maxValue
    }

    private func getBrightness(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat {

        return max(red, max(green, blue))
    }

    @available(OSX 10.11.2, *)
    private func convertP3RGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {

        let componets = [red, green, blue, alpha]
        let color = CGColor(colorSpace: CGColorSpace(name: CGColorSpace.displayP3)!, components: componets)
        let sRGB = color?.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: CGColorRenderingIntent.defaultIntent, options: nil)

        let sRed = sRGB?.components?[0] ?? 0.0
        let sGreen = sRGB?.components?[1] ?? 0.0
        let sBlue = sRGB?.components?[2] ?? 0.0
        let sAlpha = sRGB?.components?[3] ?? 1.0

        return (red: sRed, green: sGreen, blue: sBlue, alpha: sAlpha)
    }
}
