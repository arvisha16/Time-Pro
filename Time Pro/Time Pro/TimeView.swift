//
//  ContentView.swift
//  Analog Clock
//
//  Created by Derek Chan on 2020/9/9.
//

import SwiftUI
//#if !os(macOS)
//    import UserNotificationsUI
//#endif

struct TimeView: View {
    @State var isDark: Bool = false
    @State var is12h: Bool = true
    
    var body: some View {
        Home(is12h: $is12h, isDark: $isDark)
    }
}

struct TimeView_Previews: PreviewProvider {
    static var previews: some View {
        TimeView()
    }
}

struct Home: View {
    @State var currentTime = Time(sec: 0, min: 0, hour: 0)
    @State var receiver = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    @Binding var is12h: Bool
    @Binding var isDark: Bool
        
    var body: some View {
        VStack {
            HStack {
                Text(Locale.current.localizedString(forRegionCode: Locale.current.regionCode!) ?? "")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
//                    .padding(.top, 35)
                
                Spacer()
                
//                Button(action: {
//                    isDark.toggle()
//                    vibrationFeedback()
//                }, label: {
//                    Image(systemName: isDark ? "sun.min.fill" : "moon.fill")
//                        .font(.system(size: 22))
//                        .foregroundColor(isDark ? .black : .white)
//                        .padding()
//                        .background(Color.primary)
//                        .clipShape(Circle())
//                })
            }
            .padding()
            
            Spacer()
            
            Text(getTime())
                .font(.system(size: 45))
                .fontWeight(.heavy)
                .padding(.top, 10)
            
            Spacer()
            
            ZStack {// Dial
                Circle()
                    .fill(Color("Color"))
                
                // Seconds And Min dots...
                ForEach(0..<60, id: \.self){ i in
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 2, height: (i % 5) == 0 ? 15 : 5)// 60/12 = 5
                        .offset(y: (500 - 110) / 2)
                        .rotationEffect(.init(degrees: Double(i) * 6))
                }
                
                //Minutes
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4, height: (500 - 150) / 2)
                    .offset(y: -(500 - 200) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.min) * 6))
                
                //Hours
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4.5, height: (500 - 240) / 2)
                    .offset(y: -(500 - 240) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.hour + currentTime.min / 60) * 30))
                
                //Seconds
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 2, height: (500 - 180) / 2)
                    .offset(y: -(500 - 180) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.sec) * 6))
                
                Circle()
                    .fill(Color.primary)
                    .frame(width: 15, height: 15)
            }
            .frame(width: 500 - 80, height: 500 - 80)
            
            Button(action: {
                is12h.toggle()
            }, label: {
                if is12h {
                    Text("12h")
                        .modifier(FormatFomt())
                } else {
                    Text("24h")
                        .modifier(FormatFomt())
                }
            })
            .padding(.top)
            
            Spacer()
        }
        .onAppear(perform: {
            let calender = Calendar.current
            
            let sec = calender.component(.second, from: Date())
            let min = calender.component(.minute, from: Date())
            let hour = calender.component(.hour, from: Date())
            
            withAnimation(Animation.linear(duration: 0.01)){
                currentTime = Time(sec: sec, min: min, hour: hour)
            }
        })
        .onReceive(receiver){ _ in
            let calender = Calendar.current
            
            let sec = calender.component(.second, from: Date())
            let min = calender.component(.minute, from: Date())
            let hour = calender.component(.hour, from: Date())
            
            withAnimation(Animation.linear(duration: 0.01)){
                currentTime = Time(sec: sec, min: min, hour: hour)
            }
        }
    }
    
//    func vibrationFeedback() {
//        let generator = UINotificationFeedbackGenerator()
//            generator.notificationOccurred(.success)
//    }
    
    func getTime() -> String {
        let format = DateFormatter()
        if is12h {
            format.dateFormat = "hh:mm a"
        } else {
            format.dateFormat = "HH:mm"
        }

//        format.dateFormat = "HH:mm"
        return format.string(from: Date())
    }
}

struct FormatFomt: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.primary)
            .cornerRadius(20)
    }
}