import Foundation


final class Storyes: ObservableObject, Identifiable, Equatable {
    let id = UUID()
    let image: String
    let text: String
    
    @Published var isWatched: Bool = false
    
    init(image: String, text: String, isWatched: Bool = false) {
        self.image = image
        self.text = text
        self.isWatched = isWatched
    }
    
  
    static func == (lhs: Storyes, rhs: Storyes) -> Bool {
        lhs.id == rhs.id
    }
}

class StoriesViewModel: ObservableObject {
    @Published var stories: [Storyes] = [
        Storyes(image: "Storyes", text: "Text Text Text Text Text Text Text Text Text"),
        Storyes(image: "Storyes", text: "Рим"),
        Storyes(image: "Storyes", text: "Токио", isWatched: true),
        Storyes(image: "Storyes", text: "Нью-Йорк"),
        Storyes(image: "Storyes", text: "Бали"),
        Storyes(image: "Storyes", text: "Дубай"),
        Storyes(image: "Storyes", text: "Москва")
    ]
}
