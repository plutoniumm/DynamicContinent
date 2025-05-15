import SwiftUI

struct StatsModel: Codable {
    var cpu: Double
    var ram: Double
    var hdd: Double
}

class StatsViewModel: ObservableObject {
    @Published var deviceStats = StatsModel(cpu: 0, ram: 0, hdd: 0)
    @Published var serverStats = StatsModel(cpu: 0, ram: 0, hdd: 0)

    let notchDefaults = NotchDefaults.shared

    @AppStorage("cSrvStats") private var cSrvStats: Data = Data()
    @AppStorage("cSrvStatsTimestamp") private var cSrvStatsTimestamp: Double = 0

    init() {
        getDevStats()
        loadcSrvStats()
        if shouldRefreshServerStats() {
            getStats()
        }
    }

    func getDevStats() {
        let usedCPU = 0.0

        let totalRAM = Double(ProcessInfo.processInfo.physicalMemory)
        let usedRAM = usedMem()
        let ramPercent = percentage(usedRAM, of: totalRAM)

        let url = URL(fileURLWithPath: "/")
        var hddPct = 0.0
        if let values = try? url.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey, .volumeTotalCapacityKey]),
           let available = values.volumeAvailableCapacityForImportantUsage,
           let total = values.volumeTotalCapacity {
            let used = Double(Int64(total) - available)
            hddPct = percentage(used, of: Double(total))
        }

        deviceStats = StatsModel(cpu: usedCPU, ram: ramPercent, hdd: hddPct)
    }

    private func usedMem() -> Double {
        var taskInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        let result = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }

        if result == KERN_SUCCESS {
            return Double(taskInfo.resident_size)
        }
        return 0
    }

    func getStats() {
        guard let url = URL(string: "https://bahamut.manav.ch/hardware/") else { return }
        var request = URLRequest(url: url)
      request.setValue(notchDefaults.Bahamut_auth, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data,
                  let stats = try? JSONDecoder().decode(StatsModel.self, from: data) else { return }

            DispatchQueue.main.async {
                self.serverStats = stats
                self.cSrvStats = data
                self.cSrvStatsTimestamp = Date().timeIntervalSince1970
            }
        }.resume()
    }

    private func loadcSrvStats() {
        if let stats = try? JSONDecoder().decode(StatsModel.self, from: cSrvStats) {
            serverStats = stats
        }
    }

    private func shouldRefreshServerStats() -> Bool {
        let oneHour: TimeInterval = 3600
        let now = Date().timeIntervalSince1970
        return now - cSrvStatsTimestamp > oneHour
    }

    private func percentage(_ value: Double, of total: Double) -> Double {
        guard total != 0 else { return 0 }
        return min(100.0, (value / total) * 100)
    }
}

struct StatsDetailView: View {
    @StateObject var viewModel = StatsViewModel()

    var body: some View {
        VStack(spacing: 12) {
            // Header row with icons
            HStack {
                Text("") // Empty top-left cell
                    .frame(width: 60, alignment: .leading)
                Image(systemName: "cpu")
                    .frame(maxWidth: .infinity)
                Image(systemName: "memorychip")
                    .frame(maxWidth: .infinity)
                Image(systemName: "externaldrive")
                    .frame(maxWidth: .infinity)
            }

            // Server stats row
            HStack {
                Text("BAHAMUT")
                    .font(.caption.smallCaps())
                    .frame(width: 60, alignment: .leading)
                StatValue(viewModel.serverStats.cpu)
                StatValue(viewModel.serverStats.ram)
                StatValue(viewModel.serverStats.hdd)
            }

            // Device stats row
            HStack {
                Text("GOJIRA")
                    .font(.caption.smallCaps())
                    .frame(width: 60, alignment: .leading)
                StatValue(viewModel.deviceStats.cpu)
                StatValue(viewModel.deviceStats.ram)
                StatValue(viewModel.deviceStats.hdd)
            }
        }
        .padding()
        .frame(width: 300)
    }
}

struct StatValue: View {
    let value: Double

    init(_ value: Double) {
        self.value = value
    }

    var body: some View {
        Text(String(format: "%.1f%%", value))
            .font(.body.weight(.regular))
            .frame(maxWidth: .infinity)
    }
}
