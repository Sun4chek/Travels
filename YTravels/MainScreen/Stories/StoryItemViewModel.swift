//
//  StoryItemViewModel.swift
//  YTravels
//
//  Created by Волошин Александр on 12/10/25.
//

//import Foundation
//
//@MainActor
//final class StoryItemViewModel: ObservableObject, Identifiable {
//
//    let id: UUID
//    let image: String
//    let fullSizeImage: String
//    let text: String
//    let description: String
//
//    @Published private(set) var isWatched: Bool
//
//    private let story: Story
//    private let parent: StoriesViewModel
//
//    init(story: Story, parent: StoriesViewModel) {
//        self.story = story
//        self.parent = parent
//
//        self.id = story.id
//        self.image = story.image
//        self.fullSizeImage = story.fullSizeImage
//        self.text = story.text
//        self.description = story.description
//        self.isWatched = parent.isWatched(story)
//    }
//
//    func markAsWatched() {
//        parent.markAsWatched(story)
//        isWatched = true
//    }
//}
