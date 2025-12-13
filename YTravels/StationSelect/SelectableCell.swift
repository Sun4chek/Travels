import SwiftUI

struct SelectableCell: View {
    let title: String
    let hasChevron: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.custom("SFProText-Regular", size: 17))
                    .foregroundColor(.primary)
                Spacer()
                if hasChevron {
                    Image("NextIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 20)
                    
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
