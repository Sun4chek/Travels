//import Foundation
//
//@MainActor
//final class StoriesViewModel: ObservableObject {
//
//    struct StoryUIState: Identifiable, Equatable {
//        let id: UUID
//        let story: Story
//        var isWatched: Bool = false
//
//        static func == (lhs: StoryUIState, rhs: StoryUIState) -> Bool {
//            lhs.id == rhs.id
//        }
//    }
//
//    @Published var stories: [StoryUIState]
//
//    init() {
//        self.stories = Story.mock.map { StoryUIState(id: $0.id, story: $0) }
//    }
//
//    func markAsWatched(_ storyState: StoryUIState) {
//        if let index = stories.firstIndex(of: storyState) {
//            stories[index].isWatched = true
//        }
//    }
//}
