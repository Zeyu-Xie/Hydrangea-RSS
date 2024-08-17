import SwiftUI

struct FeedLabelView: View {
    var labelText: String
    var labelTime: String?
    var labelGenerator: String?
    
    var body: some View {
        VStack {
            Text(labelText)
            if let time = labelTime {
                Text(time)
            }
            if let generator = labelGenerator {
                Text(generator)
            }
        }
    }
}
