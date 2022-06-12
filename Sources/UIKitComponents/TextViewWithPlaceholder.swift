//
//  TextViewWithPlaceholder.swift
//  
//
//  Created by Yusaku Nishi on 2022/06/12.
//

import UIKit
import Combine

open class TextViewWithPlaceholder: UITextView {
    
    open var placeholder: String? {
        get { placeholderTextView.text }
        set { placeholderTextView.text = newValue }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let placeholderTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .placeholderText
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    // MARK: - Initializers
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setUpViews()
        setUpSubscriptions()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUpViews()
        setUpSubscriptions()
    }
    
    private func setUpViews() {
        // Subviews
        addSubview(placeholderTextView)
        
        // Layout
        NSLayoutConstraint.activate([
            placeholderTextView.topAnchor.constraint(equalTo: topAnchor),
            placeholderTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeholderTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeholderTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            placeholderTextView.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor),
            placeholderTextView.heightAnchor.constraint(equalTo: frameLayoutGuide.heightAnchor),
        ])
    }
    
    private func setUpSubscriptions() {
        NotificationCenter.default.publisher(for: Self.textDidChangeNotification, object: self)
            .map { [weak self] _ in self?.text }
            .merge(with: publisher(for: \.text)) // When the text is programmatically modified
            .replaceNil(with: "")
            .map { !$0.isEmpty }
            .assign(to: \.placeholderTextView.isHidden, on: self)
            .store(in: &cancellables)
        
        publisher(for: \.font)
            .assign(to: \.font, on: placeholderTextView)
            .store(in: &cancellables)
        
        publisher(for: \.textAlignment)
            .assign(to: \.textAlignment, on: placeholderTextView)
            .store(in: &cancellables)
        
        publisher(for: \.adjustsFontForContentSizeCategory)
            .assign(to: \.adjustsFontForContentSizeCategory, on: placeholderTextView)
            .store(in: &cancellables)
        
        publisher(for: \.contentInset)
            .assign(to: \.contentInset, on: placeholderTextView)
            .store(in: &cancellables)
        
        publisher(for: \.textContainerInset)
            .assign(to: \.textContainerInset, on: placeholderTextView)
            .store(in: &cancellables)
        
        textContainer.publisher(for: \.lineFragmentPadding)
            .assign(to: \.lineFragmentPadding, on: placeholderTextView.textContainer)
            .store(in: &cancellables)
    }
}