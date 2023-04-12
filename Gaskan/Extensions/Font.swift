//
//  Font.swift
//  Gaskan
//
//  Created by Dzulfikar on 31/03/23.
//

import Foundation
import SwiftUI

extension Font {
    static func sfMonoLight(fontSize: Double) -> Font {
        Font.custom("SFMono-Light", size: fontSize)
    }
    
    static func sfMonoRegular(fontSize: Double) -> Font {
        Font.custom("SFMono-Regular", size: fontSize)
    }
    
    static func sfMonoMedium(fontSize: Double) -> Font {
        Font.custom("SFMono-Medium", size: fontSize)
    }
    
    static func sfMonoSemibold(fontSize: Double) -> Font {
        Font.custom("SFMono-Semibold", size: fontSize)
    }
    
    static func sfMonoBold(fontSize: Double) -> Font {
        Font.custom("SFMono-Bold", size: fontSize)
    }
    
    static func sfProRegular(fontSize: Double) -> Font {
        Font.custom("SFPro-Regular", size: fontSize)
    }
    
    static func sfProSemibold(fontSize: Double) -> Font {
        Font.custom("SFPro-Semibold", size: fontSize)
    }
    
    static func sfProSemiboldItalic(fontSize: Double) -> Font {
        Font.custom("SFPro-SemiboldItalic", size: fontSize)
    }
}
