//
//  TransitAgency.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2017-12-30.
//  Copyright © 2017 JeffreyCA. All rights reserved.
//

enum TransitAgency: String {
    case BRAMPTON = "Brampton Transit"
    case BURLINGTON = "Burlington Transit"
    case DURHAM = "Durham Region Transit"
    case GO = "GO Transit"
    case HAMILTON = "Hamilton Street Railway"
    case MI_WAY = "MiWay"
    case OAKVILLE = "Oakville Transit"
    case OC_TRANSPO = "OC Transpo"
    case PRESTO = "PRESTO"
    case TTC = "Toronto Transit Commission"
    case UP_EXPRESS = "UP Express"
    case YRT_VIVA = "York Region Transit/VIVA"

    func getImage() -> String {
        switch self {
        case .BRAMPTON:
            return "icon_brampton"
        case .BURLINGTON:
            return "icon_burlington"
        case .DURHAM:
            return "icon_durham"
        case .GO:
            return "icon_go"
        case .HAMILTON:
            return "icon_hamilton"
        case .MI_WAY:
            return "icon_mi_way"
        case .OAKVILLE:
            return "icon_oakville"
        case .OC_TRANSPO:
            return "icon_oc_transpo"
        case .PRESTO:
            return "icon_presto_green"
        case .TTC:
            return "icon_ttc"
        case .UP_EXPRESS:
            return "icon_up_express"
        case .YRT_VIVA:
            return "icon_yrt_viva"
        }
    }
}
