import Foundation

enum Fmt {
    private static let suffixes: [(threshold: Double, suffix: String)] = [
        (1e24, " septillion"),
        (1e21, " sextillion"),
        (1e18, " quintillion"),
        (1e15, " quadrillion"),
        (1e12, " trillion"),
        (1e9,  " billion"),
        (1e6,  "M"),
    ]

    static func number(_ n: Double, decimals: Int = 1) -> String {
        if n < 0 { return "-" + number(-n, decimals: decimals) }
        if n < 1000 {
            return n.truncatingRemainder(dividingBy: 1) == 0
                ? String(Int(n))
                : String(format: "%.\(decimals)f", n)
        }
        if n < 1e6 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: n)) ?? String(Int(n))
        }
        for (threshold, suffix) in suffixes {
            if n >= threshold {
                return String(format: "%.\(decimals)f", n / threshold) + suffix
            }
        }
        return String(format: "%.\(decimals)f", n)
    }

    static func compact(_ n: Double) -> String {
        if n < 1000 { return String(Int(n)) }
        if n < 1e6 { return String(format: "%.1fK", n / 1e3) }
        if n < 1e9 { return String(format: "%.1fM", n / 1e6) }
        if n < 1e12 { return String(format: "%.1fB", n / 1e9) }
        if n < 1e15 { return String(format: "%.1fT", n / 1e12) }
        return String(format: "%.1e", n)
    }

    static func duration(_ seconds: Double) -> String {
        let s = Int(seconds)
        if s < 60 { return "\(s)s" }
        if s < 3600 {
            let m = s / 60
            let rem = s % 60
            return rem > 0 ? "\(m)m \(rem)s" : "\(m)m"
        }
        if s < 86400 {
            let h = s / 3600
            let m = (s % 3600) / 60
            return m > 0 ? "\(h)h \(m)m" : "\(h)h"
        }
        let d = s / 86400
        let h = (s % 86400) / 3600
        return h > 0 ? "\(d)d \(h)h" : "\(d)d"
    }
}
