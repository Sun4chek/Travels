import Foundation


final class Storyes: ObservableObject, Identifiable, Equatable {
    let id = UUID()
    let image: String
    let fullSizeImage: String
    let text: String
    let discription: String
    
    @Published var isWatched: Bool = false
    
    init(image: String, text: String, isWatched: Bool = false, discription: String = "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text", fullSizeImage: String ) {
        self.image = image
        self.text = text
        self.isWatched = isWatched
        self.discription = discription
        self.fullSizeImage = fullSizeImage
    }
    
  
    static func == (lhs: Storyes, rhs: Storyes) -> Bool {
        lhs.id == rhs.id
    }
}

class StoriesViewModel: ObservableObject {
    @Published var stories: [Storyes] = [
        Storyes(image: "StoriesPreview1", text: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text", fullSizeImage: "FullStoryImage1"),
        Storyes(image: "StoriesPreview2", text: "Text Text Text Text Text Text Text Text Text Text", fullSizeImage: "FullStoryImage2"),
        Storyes(image: "StoriesPreview3", text: "Text Text Text Text Text Text Text Text Text Text", isWatched: true, fullSizeImage: "FullStoryImage3"),
        Storyes(image: "StoriesPreview4", text: "Text Text Text Text Text Text Text Text Text Text", fullSizeImage: "FullStoryImage4"),
        Storyes(image: "StoriesPreview1", text: "Text Text Text Text Text Text Text Text Text Text", fullSizeImage: "FullStoryImage1"),
        Storyes(image: "StoriesPreview2", text: "Text Text Text Text Text Text Text Text Text Text", fullSizeImage: "FullStoryImage2"),
        Storyes(image: "StoriesPreview3", text: "Text Text Text Text Text Text Text Text Text Text", fullSizeImage: "FullStoryImage3")
    ]
}

