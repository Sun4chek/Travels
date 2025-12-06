import SwiftUI
import Combine

struct StoryFullScreenView: View {
    @ObservedObject var story: Storyes
    let stories: [Storyes]    // все истории
    @Binding var isShown: Bool
    @Environment(\.dismiss) private var dismiss
    let initialIndex: Int
    

    struct Configuration {
        let timerTickInternal: TimeInterval
        let progressPerTick: CGFloat

        init(storiesCount: Int, secondsPerStory: TimeInterval = 5, timerTickInternal: TimeInterval = 0.05) {
            self.timerTickInternal = timerTickInternal
            self.progressPerTick = 1.0 / CGFloat(storiesCount) / secondsPerStory * timerTickInternal
        }
    }

    @State private var progress: CGFloat = 0
    @State private var timer: Timer.TimerPublisher
    @State private var cancellable: Cancellable?

    private let configuration: Configuration

    init(story: Storyes, stories: [Storyes], isShown: Binding<Bool>, initialIndex: Int) {
        self.story = story
        self.stories = stories
        self._isShown = isShown
        self.initialIndex = initialIndex // ← важно!
        self.configuration = Configuration(storiesCount: stories.count)
        self._timer = State(initialValue: Timer.publish(every: configuration.timerTickInternal, on: .main, in: .common))
    }


    var body: some View {
        ZStack(alignment: .topTrailing) {
            // 🔥 Тут теперь картинка!!!
            Image(currentStory.fullSizeImage)
                .resizable()
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 40))

            ProgressBar(numberOfSections: stories.count, progress: progress)
                .padding(.top, 28)
                .padding(.horizontal, 12)

            CloseButton {
                dismiss()
                isShown = false
            }
            .padding(.top, 57)
            .padding(.trailing, 12)
        }
        .overlay(
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    Text(story.text)
                        .font(.custom("SFProText-Bold", size: 34))
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .foregroundColor(.white)
                    Text(story.discription)
                        .font(.custom("SFProText-Regular", size: 20))
                        .lineLimit(3)
                        .truncationMode(.tail)
                        .foregroundColor(.white)
                }
                .padding(.init(top: 0, leading: 16, bottom: 40, trailing: 16))
            }
        )
        .onAppear {
            progress = CGFloat(initialIndex) / CGFloat(stories.count)
            timer = Self.createTimer(configuration: configuration)
            cancellable = timer.connect()
            markCurrentAsWatched()
        }
        .onDisappear {
            cancellable?.cancel()
        }
        .onReceive(timer) { _ in
            timerTick()
        }
        .onTapGesture {
            nextStory()
            resetTimer()
        }
    }

    // MARK: — ЛОГИКА

    private var currentIndex: Int {
        Int(progress * CGFloat(stories.count))
    }

    private var currentStory: Storyes {
        stories[currentIndex]
    }

    private func timerTick() {
        let newProgress = progress + configuration.progressPerTick
        if newProgress >= 1 {
            dismiss()
            isShown = false  // закрываем сторис
        } else {
            progress = newProgress
        }
    }

    private func nextStory() {
        let i = currentIndex
        if i + 1 < stories.count {
            progress = CGFloat(i + 1) / CGFloat(stories.count)
            markCurrentAsWatched()
        } else {
            dismiss()
            isShown = false
        }
    }


    private func resetTimer() {
        cancellable?.cancel()
        timer = Self.createTimer(configuration: configuration)
        cancellable = timer.connect()
    }

    private static func createTimer(configuration: Configuration) -> Timer.TimerPublisher {
        Timer.publish(every: configuration.timerTickInternal, on: .main, in: .common)
    }

    private func markCurrentAsWatched() {
        currentStory.isWatched = true
    }
}
