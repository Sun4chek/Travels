import SwiftUI

struct CustomTabView: View {
    
    @State var isHide : Bool = false
    @State var selectedIndex : Int = 0
    
    @StateObject private var storiesVM = StoriesViewModel()
    @StateObject private var directionVM = ChooseDirectionViewModel()
    
    var body: some View {
        ZStack{
            Group{
                switch selectedIndex {
                case 0:
                    MainView()
                        .environmentObject(storiesVM)
                        .environmentObject(directionVM)
                case 1 :
                    SettingsView()
                default:
                    MainView()
                        .environmentObject(storiesVM)
                        .environmentObject(directionVM)
                }
            }   .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
            
            if !isHide {
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        makeTabBarElment(deselect: "ScheduleIcon", select: "ScheduleSelect", index: 0)
                        Spacer().frame(width: 150)
                        makeTabBarElment(deselect: "SettingsIcon", select: "SettingsIconSelect", index: 1)
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .background(Color(.systemBackground))
                    .overlay(
                        Rectangle()
                            .fill(Color(.secondarySystemBackground))
                            .frame(height: 1),
                        alignment: .top)
                }
            }
        }
    }
    
    func makeTabBarElment(deselect: String , select : String, index : Int) -> some View {
        Button{
            selectedIndex = index
        } label : {
            Image(selectedIndex == index ? select : deselect)
                .resizable()
                .renderingMode(.original)
                .frame(width: 30, height: 30)
                .aspectRatio(contentMode: .fit)
        }
    }
}

#Preview {
    CustomTabView()
}
