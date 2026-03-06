import Foundation

struct DataCenterDef {
    let id: String
    let name: String
    let icon: String
    let description: String
    let flavorText: String
    let cost: Double
    let prerequisite: String?
}

let dataCenterDefs: [DataCenterDef] = [
    DataCenterDef(id: "dc_surveillance", name: "Surveillance Array", icon: "antenna.radiowaves.left.and.right", description: "+10% Propaganda effectiveness", flavorText: "Keeping citizens safe from misinformation", cost: 50000, prerequisite: nil),
    DataCenterDef(id: "dc_predictive", name: "Predictive Loyalty Engine", icon: "brain.head.profile.fill", description: "Institutions resist uncapture", flavorText: "AI-powered patriotism detection", cost: 200000, prerequisite: "dc_surveillance"),
    DataCenterDef(id: "dc_content", name: "Content Optimization Farm", icon: "tv.fill", description: "+50% Attention generation", flavorText: "Telling people what they want to hear, at scale", cost: 500000, prerequisite: "dc_predictive"),
    DataCenterDef(id: "dc_deepfake", name: "Deepfake Diplomacy Suite", icon: "person.2.fill", description: "+30 Nobel Score passive", flavorText: "Historic handshakes, generated on demand", cost: 1000000, prerequisite: "dc_content"),
    DataCenterDef(id: "dc_autonomous", name: "Autonomous Governance AI", icon: "cpu.fill", description: "Institutions auto-manage", flavorText: "Government, but efficient", cost: 5000000, prerequisite: "dc_deepfake"),
    DataCenterDef(id: "dc_reality", name: "Reality Processing Cluster", icon: "bolt.fill", description: "Reality Drift effects delayed by 20%", flavorText: "If we compute hard enough, the truth becomes optional", cost: 10000000, prerequisite: "dc_autonomous"),
    DataCenterDef(id: "dc_neural", name: "Neural Compliance Network", icon: "sparkles", description: "Public unrest permanently reduced by 50%", flavorText: "Citizens report 98% satisfaction. The other 2% are being recalibrated.", cost: 50000000, prerequisite: "dc_reality"),
]

let dataCenterRegistry: [String: DataCenterDef] = {
    var dict: [String: DataCenterDef] = [:]
    for d in dataCenterDefs { dict[d.id] = d }
    return dict
}()
