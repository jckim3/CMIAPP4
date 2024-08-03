import SwiftUI

struct HeaderView: View {
    @State private var showSettings: Bool = false
    @State private var currentDate: String = ""

    var body: some View {
        ZStack {
            Image("carriagemotorinn_logo") // 에셋에 추가한 이미지 이름
                .resizable()
                .scaledToFill()
                .opacity(0.3) // 투명도를 높여 선명하게
                .frame(height: 80) // 필요에 따라 높이를 조절
                .clipped() // 이미지가 넘치지 않도록 자르기

            HStack {
                Text(currentDate)
                    .font(.headline)
                    .padding()
                    .background(Color.clear)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                Spacer()
                
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape")
                        .imageScale(.large)
                        .foregroundColor(.white)
                        .padding()
                }
                .background(Color.red.opacity(0.1))
            }
            .padding(.horizontal)
        }
        .background(Color.red)
        .onAppear {
            currentDate = currentDateString()
        }
    }
    
    func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: Date())
    }
}
