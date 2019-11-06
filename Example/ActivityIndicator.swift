//
//  ActivityIndicator.swift
//  Zone5 Example
//
//  Created by Daniel Farrelly on 25/10/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import SwiftUI
import UIKit

/// `UIActivityIndicatorView` isn't represented in SwiftUI at the moment, so we need to wrap it ourselves. This
/// `UIViewRepresentable`-based structure enables us to use it, and binds its animation to a boolean property.
struct ActivityIndicator: UIViewRepresentable {

	/// Flag that indicates if the receiver is animating.
    @Binding var isAnimating: Bool

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
		return UIActivityIndicatorView(style: .medium)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }

}

struct ActivityIndicator_Previews: PreviewProvider {
	@State static var isAnimating = true
    static var previews: some View {
		ActivityIndicator(isAnimating: $isAnimating)
    }
}
