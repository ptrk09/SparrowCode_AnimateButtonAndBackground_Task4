import SwiftUI

struct ContentView: View {
    @State var shouldAnimate: Bool = false

    var body: some View {
        AnimatedButton()
            .frame(maxWidth: 70)
            .buttonStyle(BackgroundByPressButtonStyle())
    }
}

extension ContentView {
    @ViewBuilder
    private func AnimatedButton() -> some View {
        Button {
            withAnimation(AnimationFactory.bouncy()) {
                shouldAnimate.toggle()
            } completion: {
                withAnimation(AnimationFactory.linear()) {
                    shouldAnimate.toggle()
                }
            }
        } label: {
            ButtonContent()
        }
    }

    @ViewBuilder
    private func ButtonContent() -> some View {
        GeometryReader { proxy in
            let width = proxy.size.width / 2

            HStack(alignment: .center, spacing: 0) {
                Image(systemName: "play.fill")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: shouldAnimate ? width : .zero)
                    .opacity(shouldAnimate ? 1 : .zero)

                Image(systemName: "play.fill")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width)

                Image(systemName: "play.fill")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: shouldAnimate ? 0.5 : width)
                    .opacity(shouldAnimate ? .zero : 1)
            }
            .frame(maxHeight: .infinity, alignment: .center)
        }
    }
}

private class AnimationFactory {
    static func bouncy() -> Animation {
        .bouncy(duration: 0.4, extraBounce: 0.2)
    }

    static func linear() -> Animation {
        .linear(duration: 0.01)
    }

    static func showBackground(_ duration: TimeInterval) -> Animation {
        .easeOut(duration: duration)
    }

    static func hideBackground(_ duration: TimeInterval) -> Animation {
        .easeOut(duration: duration).delay(duration)
    }
}

struct BackgroundByPressButtonStyle: ButtonStyle {
    private enum Constants {
        enum Animation {
            static let duration: TimeInterval = 0.22
            static let scaleValue: CGFloat = 0.86
        }

        enum Colors {
            static let backgroundColor: Color = .secondary
            static let backgroundActiveOpacity: CGFloat = 0.3
        }
    }

    @State private var shouldShowBackground: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .foregroundColor(Constants.Colors.backgroundColor)
                .opacity(shouldShowBackground ? Constants.Colors.backgroundActiveOpacity : 0)

            configuration.label.padding(12)
        }
        .scaleEffect(shouldShowBackground ? Constants.Animation.scaleValue : 1)
        .animation(
            .easeOut(duration: Constants.Animation.duration),
            value: configuration.isPressed
        )
        .onChange(of: configuration.isPressed) { _, newValue in
            if newValue {
                withAnimation(AnimationFactory.showBackground(Constants.Animation.duration)) {
                    shouldShowBackground = true
                }
            }
            else {
                withAnimation(AnimationFactory.hideBackground(Constants.Animation.duration)) {
                    shouldShowBackground = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
