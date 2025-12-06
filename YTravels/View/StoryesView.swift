import SwiftUI

struct StoryesView: View {
    @ObservedObject var story: Storyes
    var onTap: (() -> Void)?
    
    var body: some View {
        HStack {
            Button{
                onTap?() 
            } label: {
                if !story.isWatched {
                    ZStack(alignment: .bottomLeading){
                        Image(story.image)
                            .resizable()
                            .frame(width: 92, height: 140)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke( Color.blue, lineWidth: 4)
                                    .padding(1)
                            )
                        Text(story.text)
                            .font(.custom("SFProText-Regular", size: 12))
                            .lineLimit(3)
                            .frame(width: 76, alignment: .leading)// ← максимум 3 строки
                            .truncationMode(.tail)
                            .multilineTextAlignment(.leading)
                            .tint(Color.white)
                            .padding([.leading, .bottom], 8)
                    }
                } else {
                    ZStack(alignment: .bottomLeading){
                        Image(story.image)
                            .resizable()
                            .frame(width: 92, height: 140)
                            .cornerRadius(16)
                        Text(story.text)
                            .font(.custom("SFProText-Regular", size: 12))
                            .frame(width: 76, alignment: .leading)
                            .lineLimit(3)
                            .truncationMode(.tail)
                            .multilineTextAlignment(.leading)
                            .tint(Color.white)
                            .padding([.leading, .bottom], 8)
                    }.overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.4))
                    )
                }
            }
        }
    }
    func doing() {
        
    }
}
