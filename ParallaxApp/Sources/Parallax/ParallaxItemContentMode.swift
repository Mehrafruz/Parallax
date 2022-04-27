//
//  ParallaxItemContentMode.swift
//  ParallaxApp
//
//  Created by Mehrafruz on 17.04.2022.

import Foundation

public enum ParallaxItemContentMode: Int, CaseIterable {
    
    /**
     контент заполняет свободное пространство растягиваясь и сжимаясь
     */
    case fill = 0
    
    /**
     контент выравнен относительно верха, при сжатии обрезается снизу
     */
    case top
    
    /**
     контент выравнен по верху, его высота растягивается, а при сжатии обрезается снизу
     */
    case topFill
    
    /**
     контент выравнен по центру при растягивании, а при сжатии обрезается сверху и снизу
     */
    case center
    
    /**
     контент заполняет свободное пространство при растягивании, а при сжатии обрезается сверху и снизу
     */
    case centerFill
    
    /**
     контент выравнен относительно низа, при сжатии обрезается сверху
     */
    case bottom
    
    /**
     контент выравнен относительно низа, его высота растягивается, а при сжатии обрезается сверху
     */
    case bottomFill
    
}

extension ParallaxItemContentMode {
    
    static var fillingModes: [ParallaxItemContentMode] {
        [.fill, .topFill, .centerFill, .bottomFill]
    }
    
    static var notFillingModes: [ParallaxItemContentMode] {
        [.top, .center, .bottom]
    }
    
}
