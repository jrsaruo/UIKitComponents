//
//  TextViewWithPlaceholderSampleView.swift
//  UIKitComponentsDemo
//
//  Created by Yusaku Nishi on 2023/02/16.
//

import UIKit
import AceLayout
import UIKitComponents

final class TextViewWithPlaceholderSampleView: UIView {
    
    private let textView: TextViewWithPlaceholder = {
        let textView = TextViewWithPlaceholder()
        textView.placeholder = "Some Placeholder"
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
    }()
    
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
        
        // Subviews
        addSubview(textView)
        
        // Layout
        textView.autoLayout { item in
            item.top.equalToSuperview()
            item.leadingTrailing.equalToSuperview()
            item.bottom.equal(to: keyboardLayoutGuide.topAnchor)
        }
    }
}
