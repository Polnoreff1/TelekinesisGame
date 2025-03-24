//
//  PresentableVc.swift
//  ClimbUpGame
//
//  Created by 1234 on 30.06.2023.
//

import Foundation
import SwiftUI


struct PresentableVcWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = PrivacyPolicyViewController
        
        func makeUIViewController(context: Context) -> PrivacyPolicyViewController {
            let vc = PrivacyPolicyViewController()
            return vc
        }
        
        func updateUIViewController(_ uiViewController: PrivacyPolicyViewController, context: Context) {
        }
}
