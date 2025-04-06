import SwiftUI

struct ContentView: View {
    @State private var selectedIndex = 0
    @State private var currentGradientIndex = 0
    @State private var fullText: String = ""
    @State private var displayedText: String = ""
    @State private var timer: Timer?
    @State private var cursorVisible: Bool = false
    @State private var isGenerating: Bool = true
    @State private var isEnglish = true
    
//    let excuses: [Int: [String]] = [
//        0: [
//            "The professor forgot to send the assignment.",
//            "I left my laptop on the bus.",
//            "The system crashed, I couldn't upload my files.",
//            "I accidentally sent a file with a virus, and it deleted everything.",
//            "My roommate decided to test the fire alarm.",
//            "My cat spilled water all over my notes.",
//            "I thought the deadline was tomorrow.",
//            "The student portal was down, you can check yourself."
//        ],
//        1: [
//            "I missed the meeting because my internet suddenly went out.",
//            "I got stuck in the elevator.",
//            "Boss, I was testing a productive power nap.",
//            "I went to the kitchen for coffee and walked into a team-building session.",
//            "My alarm clock decided today was Sunday.",
//            "I couldn't leave because my cat fell asleep on my lap.",
//            "Aliens abducted me, but I negotiated my return by lunchtime.",
//            "My computer updated for 3 hours, then spent another 2 hours rolling back the update."
//        ],
//        2: [
//            "I was on my way, but I met a cat, and we had a deep conversation about life.",
//            "I forgot that today isn't Thursday.",
//            "I was leaving, but I forgot my keys, then my phone, then my keys again.",
//            "I took a short detour, and somehow I ended up in a different neighborhood.",
//            "My outdoor Wi-Fi ran out.",
//            "I got lost staring at the sunset and forgot where I was going.",
//            "I mixed up AM and PM in my reminders.",
//            "I opened YouTube for a minute and woke up two hours later."
//        ]
//    ]


    let excuses: [Int: [String]] = [
        0: [
            "Препод забыл отправить задание.",
            "Я забыл ноутбук в автобусе.",
            "Система зависла, не смог загрузить файлы.",
            "Я случайно отправил файл с вирусом, и он всё удалил.",
            "Сосед по комнате решил протестировать fire alarm.",
            "Кот пролил воду на мой конспект.",
            "Я думал, дедлайн завтра.",
            "Учебный портал не работал, можете сами проверить."
        ],
        1: [
            "Пропустил собрание, потому что интернет внезапно пропал.",
            "Застрял в лифте.",
            "Босс, я тестировал продуктивный сон.",
            "Я зашёл на кухню за кофе, а там корпоративный тимбилдинг.",
            "Мой будильник решил, что сегодня воскресенье.",
            "Не успел выйти, потому что кошка уснула у меня на коленях.",
            "Меня похитили инопланетяне, но я договорился вернуться к обеду.",
            "Компьютер обновлялся 3 часа, а потом ещё 2 часа откатывал обновления."
        ],
        2: [
            "Я шёл, но встретил кота, и мы поговорили о жизни.",
            "Забыл, что сегодня не четверг.",
            "Я уже выходил, но вспомнил, что забыл ключи, потом телефон, потом снова ключи.",
            "Шёл на встречу, но решил сделать один небольшой круг, и вот я в другом районе.",
            "У меня просто закончился Wi-Fi на улице.",
            "Засмотрелся на красивый закат и забыл, куда шёл.",
            "Перепутал AM и PM в напоминалке.",
            "Открыл YouTube на минутку, а потом очнулся через два часа."
        ]
    ]
    
    let gradients: [LinearGradient] = [
        LinearGradient(
            gradient: Gradient(colors: [Color(red: 0.70, green: 0.90, blue: 0.95), Color(red: 0.60, green: 0.85, blue: 0.75)]),
            startPoint: .top,
            endPoint: .bottom
        ),
        LinearGradient(
            gradient: Gradient(colors: [Color(red: 0.95, green: 0.70, blue: 0.80), Color(red: 0.85, green: 0.60, blue: 0.75)]),
            startPoint: .top,
            endPoint: .bottom
        ),
        LinearGradient(
            gradient: Gradient(colors: [Color(red: 0.80, green: 0.70, blue: 0.95), Color(red: 0.75, green: 0.60, blue: 0.85)]),
            startPoint: .top,
            endPoint: .bottom
        )
    ]


    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.70, green: 0.90, blue: 0.95),
                    Color(red: 0.60, green: 0.85, blue: 0.75)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.9),
                    Color.clear
                ]),
                center: .bottomLeading,
                startRadius: 5,
                endRadius: 400
            )
            .blendMode(.overlay)
            .edgesIgnoringSafeArea(.all)
            
            gradients[currentGradientIndex]
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Picker("Select", selection: $selectedIndex) {
                    Text("Uni").tag(0)
                    Text("Job").tag(1)
                    Text("Friends").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, 20)
                .onChange(of: selectedIndex) {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        currentGradientIndex = selectedIndex
                    }
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.8))
                        .frame(width: 300, height: 180)
                        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)

                    Text(displayedText + (isGenerating && cursorVisible ? "_" : ""))
                        .font(.system(size: 18, weight: .medium).monospaced())
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(width: 280)
                }
                .padding(.top, 20)

                Spacer()

                Button(action: {
                    generateExcuse()
                }) {
                    Text("Generate")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.pink.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .cornerRadius(25)
                        .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 4)
                }
                .buttonStyle(ScaleButtonStyle())
            }
            .padding()
        }
        .onAppear {
            startCursorAnimation()
        }
        .preferredColorScheme(.light)
    }

    func generateExcuse() {
        if let selectedExcuses = excuses[selectedIndex] {
            fullText = selectedExcuses.randomElement() ?? "Нет отмазок!"
            displayedText = ""
            isGenerating = true
            startTypingAnimation()
        }
    }

    func startTypingAnimation() {
        timer?.invalidate()
        var index = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { t in
            if index < fullText.count {
                let charIndex = fullText.index(fullText.startIndex, offsetBy: index)
                displayedText.append(fullText[charIndex])
                index += 1
            } else {
                t.invalidate()
                isGenerating = false
            }
        }
    }
    
    func startCursorAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            cursorVisible.toggle()
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: configuration.isPressed)
    }
}

#Preview {
    ContentView()
}
