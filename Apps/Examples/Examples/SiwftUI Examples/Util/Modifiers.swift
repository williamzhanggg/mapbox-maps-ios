//
//  Modifiers.swift
//  SwiftUIExamples
//
//  Created by Ivan Persidskiy on 1/26/23.
//

import SwiftUI

@available(iOS 14.0, *)
extension View {
    @ViewBuilder
    func safeOverlay<V: View>(alignment: Alignment, content: () -> V) -> some View {
        if #available(iOS 16.0, *) {
            overlay(alignment: alignment, content: content)
        } else {
            overlay(content(), alignment: alignment)
        }
    }

    @ViewBuilder
    func defaultDetents() -> some View {
        if #available(iOS 16, *) {
            presentationDetents([.fraction(0.33), .large])
        }
    }

    @ViewBuilder
    func prominentButton() -> some View {
        if #available(iOS 15, *) {
            buttonStyle(.borderedProminent)
        }
    }
}
