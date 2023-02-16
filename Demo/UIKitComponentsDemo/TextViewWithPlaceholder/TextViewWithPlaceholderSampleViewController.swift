//
//  TextViewWithPlaceholderSampleViewController.swift
//  UIKitComponentsDemo
//
//  Created by Yusaku Nishi on 2023/02/16.
//

import UIKit

final class TextViewWithPlaceholderSampleViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = TextViewWithPlaceholderSampleView()
    }
}
