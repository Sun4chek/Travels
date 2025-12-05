import SwiftUI

struct ErrorView: View {
    @State var text: String = ""
    @State var errorImageName: String = ""
    var body: some View {
        
        ZStack {
            VStack{
                Image(errorImageName)
                    .resizable()
                    .frame(width: 250, height: 250)
                    .padding()
                Text(text)
                    .font(.custom("SFProText-Bold",size: 24))
            }
        }
    }
}

#Preview {
    ErrorView(text: "Нет интернета", errorImageName: "ServerError")
}
