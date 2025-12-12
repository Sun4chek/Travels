//import SwiftUI
//
//struct StoryView: View {
//    let story: Storyes
//
//    var body: some View {
//        ZStack {
//            // Фон — реальная полноразмерная картинка
//            Image(story.fullSizeImage)
//                .resizable()
//                .scaledToFill()
//                .ignoresSafeArea()
//
//            // Текстовая информация внизу
//            VStack {
//                Spacer()
//                VStack(alignment: .leading, spacing: 10) {
//                    Text(story.text)
//                        .font(.bold34)
//                        .foregroundColor(.white)
//
//                    Text(story.discription)
//                        .font(.regular20)
//                        .foregroundColor(.white)
//                        .lineLimit(3)
//                }
//                .padding(.horizontal, 16)
//                .padding(.bottom, 40)
//            }
//        }
//    }
//}
