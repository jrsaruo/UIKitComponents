//
//  TextViewWithPlaceholder.swift
//  
//
//  Created by Yusaku Nishi on 2022/06/12.
//

import UIKit
import Combine

/// A scrollable, multiline text region with a placeholder.
open class TextViewWithPlaceholder: UITextView {
    
    /// The string that displays when there is no other text in the text view.
    ///
    /// This value is `nil` by default. The placeholder string is drawn using a system-defined color.
    open var placeholder: String? {
        get { placeholderTextView.text }
        set { placeholderTextView.text = newValue }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let placeholderTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.textColor = .placeholderText
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    private lazy var placeholderTopBottomToSafeAreaConstraints: [NSLayoutConstraint] = [
        placeholderTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
        placeholderTextView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor)
    ]
    
    private lazy var placeholderTopBottomToFrameConstraints: [NSLayoutConstraint] = [
        placeholderTextView.topAnchor.constraint(equalTo: frameLayoutGuide.topAnchor),
        placeholderTextView.bottomAnchor.constraint(lessThanOrEqualTo: frameLayoutGuide.bottomAnchor)
    ]
    
    // MARK: - Initializers
    
    /// Creates a new text view with the specified text container.
    /// - Parameters:
    ///   - frame: The frame rectangle of the text view.
    ///   - textContainer: The text container to use for the receiver (can be `nil`).
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setUpViews()
        setUpSubscriptions()
    }
    
    /// Creates a text view from data in an unarchiver.
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
            placeholderTextView.leadingAnchor.constraint(equalTo: frameLayoutGuide.leadingAnchor),
            placeholderTextView.trailingAnchor.constraint(equalTo: frameLayoutGuide.trailingAnchor)
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
        
        publisher(for: \.contentInsetAdjustmentBehavior)
            .sink(receiveValue: { [weak self] contentInsetAdjustmentBehavior in
                guard let self = self else { return }
                switch contentInsetAdjustmentBehavior {
                case .automatic, .always:
                    NSLayoutConstraint.deactivate(self.placeholderTopBottomToFrameConstraints)
                    NSLayoutConstraint.activate(self.placeholderTopBottomToSafeAreaConstraints)
                case .scrollableAxes, .never:
                    NSLayoutConstraint.deactivate(self.placeholderTopBottomToSafeAreaConstraints)
                    NSLayoutConstraint.activate(self.placeholderTopBottomToFrameConstraints)
                @unknown default:
                    assertionFailure("Unknown behavior: \(contentInsetAdjustmentBehavior)")
                    NSLayoutConstraint.deactivate(self.placeholderTopBottomToFrameConstraints)
                    NSLayoutConstraint.activate(self.placeholderTopBottomToSafeAreaConstraints)
                }
            })
            .store(in: &cancellables)
    }
}
