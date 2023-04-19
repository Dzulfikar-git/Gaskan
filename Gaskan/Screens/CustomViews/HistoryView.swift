//
//  HistoryListView.swift
//  Gaskan
//
//  Created by Muhammad Adha Fajri Jonison on 15/04/23.
//

import SwiftUI

struct HistoryView: View {
    var calculationType: CalculationType?
    var mileageAmount: Double
    var unit: UnitDropdownOption?
    var date: Date?
    
    @Binding var isShowDeleteButton: Bool
    
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Image("Line")
            
            ZStack {
                Rectangle()
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 1, dash: [4])
                    )
                
                HStack {
                    Spacer()
                        .fixedSize()
                        .padding(2)
                    
                    if calculationType == .newCalculation || calculationType == .refuel {
                        Image(systemName: "plus.square.fill")
                            .resizable()
                            .frame(
                                width: 12,
                                height: 12
                            )
                    } else if calculationType == .newTrip {
                        Image(systemName: "minus.square.fill")
                            .resizable()
                            .frame(
                                width: 12,
                                height: 12
                            )
                    }
                    
                    if calculationType == .newCalculation {
                        Text("Calculation created")
                            .font(.sfMonoMedium(fontSize: 10.0))
                            .foregroundColor(.appTertiaryColor
                            )
                            .tracking(-0.88)
                            .lineLimit(1)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                    } else if calculationType == .refuel {
                        Text("Refuel | Mileage +\(String(format: "%.2f", mileageAmount)) \(unit == UnitData.metricOption ? "KM" : "miles")")
                            .font(.sfMonoMedium(fontSize: 10.0))
                            .foregroundColor(.appTertiaryColor
                            )
                            .tracking(-0.88)
                            .lineLimit(1)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                    } else if calculationType == .newTrip {
                        Text("Travelled | Mileage -\(String(format: "%.2f", mileageAmount)) \(unit == UnitData.metricOption ? "KM" : "miles")")
                            .font(.sfMonoMedium(fontSize: 10.0))
                            .foregroundColor(.appTertiaryColor
                            )
                            .tracking(-0.88)
                            .lineLimit(1)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                    }
                    
                    Text(
                        formatDateToString(date: date)
                    )
                    .font(.sfMonoMedium(fontSize: 10.0))
                    .foregroundColor(.appTertiaryColor)
                    .tracking(-0.88)
                    .frame(alignment: .trailing)
                    .lineLimit(2)
                    .multilineTextAlignment(.trailing)
                    
                    if isShowDeleteButton {
                        Button {
                            onDelete()
                        } label: {
                            Image(systemName: "trash.fill")
                                .resizable()
                                .foregroundColor(.appSecondaryColor)
                                .frame(width: 12, height: 12)
                        }
                    }
                    
                    Spacer()
                        .fixedSize()
                        .padding(2)
                }
            }
            .padding(.vertical, 8)
            
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())
        .padding(.leading, 24)
        .padding(.trailing, 8)
        .padding(.vertical, 0)
    }
    
    func formatDateToString(date: Date?) -> String {
        if date == nil {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date!) {
            dateFormatter.dateFormat = "'Today'\nHH:mm"
        } else if calendar.isDateInYesterday(date!) {
            dateFormatter.dateFormat = "'Yesterday'\nHH:mm"
        } else {
            dateFormatter.dateFormat = "dd MMM\nHH:mm"
        }
        
        let dateString = dateFormatter.string(from: date!)
        
        return dateString
    }
}

struct HistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(calculationType: .newCalculation, mileageAmount: 0.0, isShowDeleteButton: .constant(true)) {}
    }
}
