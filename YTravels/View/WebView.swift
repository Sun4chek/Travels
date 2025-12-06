import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}


struct UserAgreementView: View {
    @Environment(\.dismiss) private var dismiss
    let url = URL(string: "https://yandex.ru/legal/practicum_offer/ru/")!

    var body: some View {
        NavigationStack {
            WebView(url: url)
                .navigationBarTitle("Пользовательское соглашение", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button { dismiss() } label: {
                            Image("BackIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 17, height: 22)
                        }
                        .padding(.leading, 8)
                    }
                }
        }
    }
}
