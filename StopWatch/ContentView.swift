//
//  ContentView.swift
//  StopWatch
//
//  Created by 이용석 on 2021/07/04.
//

import SwiftUI

struct ContentView: View {
    
    @State var inputs: CGFloat = 0
    
    var body: some View {
        VStack{
            
            Slider(value: $inputs, in: 0...1.2)
                .padding()
            Spacer()
            ZStack {
                ClockLayout(clockCount: 120, yOffset: 100, dotPoint: 5)
                ClockNumber(clockCount: 120, yOffset: -130, dotPoint: 10)
                TickArrow(inputs: $inputs)
            }
            Spacer()
        }

        
    }
}

struct ClockLayout: View {
    
    public var clockCount: Int
    public var yOffset: CGFloat
    public var dotPoint: Int
    
    var body: some View {
        ZStack{
            ForEach(0..<clockCount) { tick in
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 1, height: tick % dotPoint == 0 ? 25 : 15)
                    .offset(y: self.yOffset)
                    .rotationEffect(.degrees(Double(tick) / Double(clockCount) * 360))
                
            }
        }
    }
}

struct TickArrow: View {
    
    @Binding var inputs: CGFloat
    
    var body: some View {
        ZStack{

            Rectangle()
                .fill(Color.blue)
                .frame(width: 1, height: 80)
                .offset(y: -40)
                .rotationEffect(.degrees(Double(inputs * 100) / Double(120) * 360))
            
            Circle()
                .frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(.blue)
        }
    }
}

struct ClockNumber: View {
    
    public var clockCount: Int
    public var yOffset: CGFloat
    public var dotPoint: Int
    
    var body: some View {
        ZStack{
            ForEach(0..<clockCount) { tick in
                if tick % self.dotPoint == 0 {
                    ZStack {
                        Text("\(tick)")
                            .font(.system(size: 15))
                            .rotationEffect(.degrees(Double(tick) / Double(clockCount) * -360))
                    }
                    .offset(y: yOffset)
                    .rotationEffect(.degrees(Double(tick) / Double(clockCount) * 360))
                        
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
