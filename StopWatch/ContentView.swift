//
//  ContentView.swift
//  StopWatch
//
//  Created by 이용석 on 2021/07/04.
//

import SwiftUI

struct ContentView: View {
    
    @State private var inputMMS: Double = 0.0
    @State var isStart: Bool = false
    @State var recoding: String = ""
    
    var timer = Timer.publish(every: 0.1, on: .current, in: .default).autoconnect()
    
    var ConvertTime: String {
        let minute = String(format: "%02d", Int(inputMMS) / 60)
        let sec = String(format: "%02d" ,Int(inputMMS) % 60)
        let miliSec = String(format: "%0.2f", inputMMS.truncatingRemainder(dividingBy: 1)).split(separator: ".").last!
        
        return minute + ":" + sec + ":" + miliSec
    }
    
    var body: some View {
        VStack{

            ProgressBar(value: $inputMMS)
                .frame(height: 15)

            Spacer()
            
            ZStack {
                Minute(minutes: 60, yOffset: 150, dotPoint: 5)
                MinuteArrow(inputs: $inputMMS)
                Numbers(numberCount: 60, yOffset: -180, dotPoint: 5)
                
                Second(seconds: 60, yOffset: 30, dotPoint: 5)
                    .offset(x: -45, y: 80)
                SecArrow(inputs: $inputMMS)
                    .offset(x: -45, y: 80)
                
                MiliSecond(miliSeconds: 10, yOffset: 30)
                    .offset(x: 45, y: 80)
                MiliSecArrow(inputs: $inputMMS)
                    .offset(x: 45, y: 80)
            }
            .onReceive(timer, perform: { _ in
                withAnimation {
                    if isStart {
                        self.inputMMS += 0.1
                    }
                }
            })
            
            Spacer()
            
            StartStopButton(isStart: $isStart, inputMMS: $inputMMS)
                .padding(.vertical, 5)
            
            Text("\(ConvertTime)")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 40))
                .padding(.vertical, 5)

            LapTimeList(recoding: $recoding)
            
// Pause
            Button(action: {
                
                if isStart {
                    self.recoding = "\(ConvertTime)"
                }

            }, label: {
                Text("Pause")
                    .frame(width: UIScreen.main.bounds.width, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color.blue.opacity(0.5))
            }).padding(.top, 0)
            
        }
    }

}

struct LapTimes {
    
    static func recodingLaps(lap: String) -> [String] {
        var laps = [String]()
        laps.insert(lap, at: 0)
        return laps
    }
}


struct LapTimeList: View {
    
    @Binding var recoding: String
    
    var body: some View {
        ScrollView{
            
            VStack {
                Text("recoding Lap")
                Text(self.recoding)
                let laps = LapTimes.recodingLaps(lap: self.recoding)
                
                List {
                    ForEach(laps, id: \.self) { lap in
                        Text("\(lap)")
                    }
                }
                
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

struct ProgressBar: View {
    @Binding var value: Double
    
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geometry in
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(.blue)
                    .padding(.trailing, 10)
                Rectangle().frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width) , height: geometry.size.height)
                    .foregroundColor(.blue)
                    .cornerRadius(10.0)
                    .padding(.trailing, 10)
            }
            .cornerRadius(10.0)
        }
    }
}

struct StartStopButton: View {
    
    @Binding var isStart: Bool
    @Binding var inputMMS: Double
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            Button(action: {
                isStart = true
            }, label: {
                Text("Strat")
                    .frame(width: UIScreen.main.bounds.width / 3, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color.orange)
                
            })
            
            Button(action: {
                isStart = false
            }, label: {
                Text("Stop")
                    .frame(width: UIScreen.main.bounds.width / 3, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color.orange.opacity(0.5))
            })
            
            Button(action: {
                isStart = false
                inputMMS = 0.0
                
            }, label: {
                Text("Reset")
                    .frame(width: UIScreen.main.bounds.width / 3, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color.purple.opacity(0.5))
            })

        }

    }
}


struct Minute: View {
    
    public var minutes: Int
    public var yOffset: CGFloat
    public var dotPoint: Int
    
    var body: some View {
        ZStack{
            ForEach(0..<minutes) { tick in
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 1, height: tick % dotPoint == 0 ? 25 : 15)
                    .offset(y: self.yOffset)
                    .rotationEffect(.degrees(Double(tick) / Double(minutes) * 360))
                
            }
        }
    }
}

struct MinuteArrow: View {
    
    @Binding var inputs: Double
    private var arrHeight: CGFloat = 120
    
    init(inputs: Binding<Double>) {
        _inputs = inputs
    }
    
    var body: some View {
        ZStack{

            Rectangle()
                .fill(Color.black)
                .frame(width: 1, height: arrHeight)
                .offset(y: -arrHeight / 2)
                .rotationEffect(.degrees((Double(inputs) / Double(60)) / Double(60) * 360))
            
            Circle()
                .frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(.black)
        }
    }
}

struct Second: View {
    
    public var seconds: Int
    public var yOffset: CGFloat
    public var dotPoint: Int
    
    var body: some View {
        ZStack{
            ForEach(0..<seconds) { tick in
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 1, height: tick % dotPoint == 0 ? 10 : 5)
                    .offset(y: self.yOffset)
                    .rotationEffect(.degrees(Double(tick) / Double(seconds) * 360))
                
            }
        }
    }
}

struct SecArrow: View {
    
    @Binding var inputs: Double
    private var arrHeight: CGFloat = 20
    
    init(inputs: Binding<Double>) {
        _inputs = inputs
    }
    
    var body: some View {
        ZStack{

            Rectangle()
                .fill(Color.pink)
                .frame(width: 1, height: arrHeight)
                .offset(y: -arrHeight / 2)
                .rotationEffect(.degrees(Double(inputs) / Double(60) * 360))
            
            Circle()
                .frame(width: 6, height: 6, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(.black)
        }
    }
}

struct MiliSecond: View {
    
    public var miliSeconds: Int
    public var yOffset: CGFloat
    
    var body: some View {
        ZStack{
            ForEach(0..<miliSeconds) { tick in
                Rectangle()
                    .fill(Color.pink)
                    .frame(width: 1, height: 8)
                    .offset(y: self.yOffset)
                    .rotationEffect(.degrees(Double(tick) / Double(miliSeconds) * 360))
                
            }
        }
    }
}

struct MiliSecArrow: View {
    
    @Binding var inputs: Double
    private var arrHeight: CGFloat = 20
    
    init(inputs: Binding<Double>) {
        self._inputs = inputs
    }
    
    var body: some View {
        ZStack{

            Rectangle()
                .fill(Color.pink)
                .frame(width: 1, height: arrHeight)
                .offset(y: -arrHeight / 2)
                .rotationEffect(.degrees(Double(inputs) / Double(60) * Double(60) * 360))
            
            Circle()
                .frame(width: 6, height: 6, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(.black)
        }
    }
}

struct Numbers: View {
    
    public var numberCount: Int
    public var yOffset: CGFloat
    public var dotPoint: Int
    
    var body: some View {
        ZStack{
            ForEach(0..<numberCount) { tick in
                if tick % self.dotPoint == 0 {
                    ZStack {
                        Text("\(tick)")
                            .font(.system(size: 15))
                            .rotationEffect(.degrees(Double(tick) / Double(numberCount) * -360))
                    }
                    .offset(y: yOffset)
                    .rotationEffect(.degrees(Double(tick) / Double(numberCount) * 360))
                        
                }

            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
