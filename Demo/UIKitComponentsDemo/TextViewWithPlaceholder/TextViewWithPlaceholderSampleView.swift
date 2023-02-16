//
//  TextViewWithPlaceholderSampleView.swift
//  UIKitComponentsDemo
//
//  Created by Yusaku Nishi on 2023/02/16.
//

import UIKit

final class TextViewWithPlaceholderSampleView: UIView {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
    
    private func setUpViews() {
        backgroundColor = .systemBackground
    }
}
