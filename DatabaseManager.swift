import Foundation

// Yüksek skor verisi için struct
struct HighScore: Codable {
    let playerName: String
    let score: Int
    let difficulty: String
    let date: Date
    
    // Debug için description
    var description: String {
        return "\(playerName) - \(score) points (\(difficulty))"
    }
}

class DatabaseManager {
    static let shared = DatabaseManager()
    
    // UserDefaults key
    private let highScoresKey = "highScores"
    
    private init() {
        // Debug: Başlangıçta test verisi ekle
        if getAllScores().isEmpty {
            print("DatabaseManager: Henüz kayıtlı skor yok, test verisi ekleniyor...")
            let testScores = [
                HighScore(playerName: "Test1", score: 100, difficulty: "Easy", date: Date()),
                HighScore(playerName: "Test2", score: 80, difficulty: "Hard", date: Date())
            ]
            saveScoresToDefaults(testScores)
        }
    }
    
    // Yüksek skorları kaydetme
    func saveHighScore(playerName: String, score: Int, difficulty: String) {
        print("DatabaseManager: Yeni skor kaydediliyor - \(playerName): \(score) (\(difficulty))")
        
        var scores = getAllScores()
        let newScore = HighScore(playerName: playerName, score: score, difficulty: difficulty, date: Date())
        scores.append(newScore)
        
        // Skorları puana göre sırala
        scores.sort { $0.score > $1.score }
        
        // Sadece en yüksek 10 skoru tut
        if scores.count > 10 {
            scores = Array(scores.prefix(10))
        }
        
        // Skorları kaydet
        saveScoresToDefaults(scores)
        
        // Debug: Kayıtlı skorları göster
        print("DatabaseManager: Güncel skor listesi:")
        scores.forEach { print($0.description) }
    }
    
    // Tüm skorları getir
    private func getAllScores() -> [HighScore] {
        guard let data = UserDefaults.standard.data(forKey: highScoresKey),
              let scores = try? JSONDecoder().decode([HighScore].self, from: data) else {
            print("DatabaseManager: Skor verisi bulunamadı veya okunamadı")
            return []
        }
        print("DatabaseManager: \(scores.count) skor okundu")
        return scores
    }
    
    // En yüksek 10 skoru getir
    func getTopScores() -> [HighScore] {
        let scores = getAllScores()
        print("DatabaseManager: getTopScores çağrıldı, \(scores.count) skor döndürülüyor")
        return scores
    }
    
    // Skorları UserDefaults'a kaydet
    private func saveScoresToDefaults(_ scores: [HighScore]) {
        do {
            let encoded = try JSONEncoder().encode(scores)
            UserDefaults.standard.set(encoded, forKey: highScoresKey)
            print("DatabaseManager: \(scores.count) skor başarıyla kaydedildi")
        } catch {
            print("DatabaseManager: Skor kaydedilirken hata oluştu: \(error)")
        }
    }
}
