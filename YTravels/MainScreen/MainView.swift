import SwiftUI

struct MainView: View {
    @EnvironmentObject private var storiesVM: StoriesViewModel
    @EnvironmentObject private var directionVM: ChooseDirectionViewModel
    
    @StateObject private var vm = MainViewModel()  // Собственный VM для этого экрана
    
    var body: some View {
        NavigationStack {
            VStack {
                // Stories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(storiesVM.stories) { story in
                            StoryesView(story: story) {
                                vm.selectedStory = story  // Просто устанавливаем — View отреагирует
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 140)
                .padding(.bottom, 24)
                
                ChooseDirectionView()
                    .padding(.bottom, 20)
                
                // Кнопка "Найти"
                if directionVM.isBothDirectionsSelected {
                    Button {
                        vm.searchButtonTapped()  // Логика в VM
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.blue)
                                .frame(height: 60)
                                .frame(width: 150)
                            
                            Text("Найти")
                                .font(.custom("SFProText-Bold", size: 17))
                                .foregroundColor(.white)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.top, 24)
        }
        // Презентация сторис — реагирует на selectedStory из VM
        .fullScreenCover(item: $vm.selectedStory) { story in
            StoryFullScreenView(
                story: story,
                stories: storiesVM.stories,
                isShown: .constant(true),  // Если нужно управлять закрытием — добавь в VM
                initialIndex: storiesVM.stories.firstIndex(of: story) ?? 0
            )
        }
        // Презентация поиска — реагирует на shouldPresentSearch
        .fullScreenCover(isPresented: $vm.shouldPresentSearch) {
            CroosView(
                fromCode: directionVM.fromStationCode,
                toCode: directionVM.toStationCode,
                routeTitle: directionVM.allRoad()
            )
        }
    }
}

#Preview {
    MainView()
        .environmentObject(StoriesViewModel())       // Замени на свои моковые VM
        .environmentObject(ChooseDirectionViewModel())
}
