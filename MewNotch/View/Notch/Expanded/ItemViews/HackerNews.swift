import SwiftUI

struct MirrorView: View {

    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject var notchViewModel: NotchViewModel

    @State private var stories: [HNStory] = []
    @State private var currentStory: HNStory?

    let refreshInterval: TimeInterval = 43200
    private let cachedStoriesKey = "cachedHNSnapshot"

    func loadCached() {
        guard let data = UserDefaults.standard.data(forKey: cachedStoriesKey),
              let decoded = try? JSONDecoder().decode([HNStory].self, from: data)
        else { return }

        stories = decoded
        currentStory = decoded.randomElement()
    }

    func saveCached(_ stories: [HNStory]) {
        if let data = try? JSONEncoder().encode(stories) {
            UserDefaults.standard.set(data, forKey: cachedStoriesKey)
        }
    }

    func fetchHN() {
        guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/beststories.json") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let ids = try? JSONDecoder().decode([Int].self, from: data)
            else { return }

            let top10IDs = Array(ids.prefix(10))
            let group = DispatchGroup()
            var fetchedStories: [HNStory] = []

            for id in top10IDs {
                guard let storyURL = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json") else { continue }
                group.enter()
                URLSession.shared.dataTask(with: storyURL) { data, _, _ in
                    defer { group.leave() }
                    guard let data = data,
                          let story = try? JSONDecoder().decode(HNStory.self, from: data)
                    else { return }

                    fetchedStories.append(story)
                }.resume()
            }

            group.notify(queue: .main) {
                self.stories = fetchedStories
                self.currentStory = fetchedStories.randomElement()
                self.saveCached(fetchedStories)
            }
        }.resume()
    }

    var body: some View {
        VStack {
            if let story = currentStory,
               let url = URL(string: story.url ?? "https://news.ycombinator.com/item?id=\(story.id)") {
                Link(destination: url) {
                    Text(story.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 2)
                        .padding(.vertical, 8)
                        .fontWeight(.medium)
  
                }
                .transition(.opacity)
            } else {
                ProgressView()
                    .padding()
            }
        }
        .frame(width: notchViewModel.notchSize.height * 3)
        .onAppear {
            loadCached()
            fetchHN()
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                currentStory = stories.randomElement()
            }
        }
        .task {
            while true {
                try? await Task.sleep(nanoseconds: UInt64(refreshInterval * 1_000_000_000))
                fetchHN()
            }
        }
    }
}

struct HNStory: Codable, Identifiable {
    let id: Int
    let title: String
    let url: String?
}
