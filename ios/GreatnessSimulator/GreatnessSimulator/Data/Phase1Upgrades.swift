import Foundation

let phase1Upgrades: [UpgradeData] = [

    // ── Media Presence Tree ──

    UpgradeData(
        id: "media_social_account",
        name: "Social Media Account",
        description: "Post inflammatory content. Engagement is engagement.",
        tree: "Media Presence",
        icon: "megaphone.fill",
        baseCost: 10,
        costResource: .attention,
        production: 0.1,
        maxCount: 1,
        phase: 1
    ),
    UpgradeData(
        id: "media_cable_news",
        name: "Cable News Appearances",
        description: "Regular spots on friendly networks. Say anything — they love ratings.",
        tree: "Media Presence",
        icon: "tv.fill",
        baseCost: 50,
        costResource: .attention,
        production: 0.5,
        maxCount: 1,
        prerequisites: ["media_social_account"],
        phase: 1
    ),
    UpgradeData(
        id: "media_rage_tweets",
        name: "Rage-Tweet Automation",
        description: "Why type when software can generate controversy for you?",
        tree: "Media Presence",
        icon: "bolt.fill",
        baseCost: 200,
        costResource: .attention,
        production: 2,
        maxCount: 1,
        effects: [
            UpgradeEffect(type: .attentionPerClick, value: 1),
            UpgradeEffect(type: .attentionPerSecond, value: 3),
        ],
        prerequisites: ["media_cable_news"],
        phase: 1
    ),
    UpgradeData(
        id: "media_fake_news",
        name: "Alternative News Network",
        description: "Create your own \"alternative\" news sources. Who needs facts?",
        tree: "Media Presence",
        icon: "newspaper.fill",
        baseCost: 1000,
        costResource: .attention,
        production: 8,
        maxCount: 1,
        prerequisites: ["media_rage_tweets"],
        phase: 1
    ),
    UpgradeData(
        id: "media_buyout",
        name: "Media Buyout",
        description: "Why fight the press when you can own it?",
        tree: "Media Presence",
        icon: "building.2.fill",
        baseCost: 5000,
        costResource: .attention,
        production: 25,
        maxCount: 1,
        effects: [
            UpgradeEffect(type: .gpsMultiplier, value: 1.5),
            UpgradeEffect(type: .attentionPerSecond, value: 15),
        ],
        prerequisites: ["media_fake_news"],
        phase: 1
    ),

    // ── Merchandise Empire Tree ──

    UpgradeData(
        id: "merch_red_hat",
        name: "Red Hat Sales",
        description: "The iconic merchandise. A fashion statement and loyalty badge.",
        tree: "Merchandise Empire",
        icon: "tshirt.fill",
        baseCost: 15,
        costResource: .attention,
        production: 0.2,
        maxCount: 10,
        phase: 1
    ),
    UpgradeData(
        id: "merch_nft",
        name: "NFT Collection",
        description: "\"Limited edition\" digital art. Unlimited edition revenue.",
        tree: "Merchandise Empire",
        icon: "photo.artframe",
        baseCost: 100,
        costResource: .attention,
        production: 1,
        maxCount: 1,
        prerequisites: ["merch_red_hat"],
        phase: 1
    ),
    UpgradeData(
        id: "merch_gold",
        name: "Gold-Plated Everything",
        description: "Branded luxury items. Nothing says class like your name in gold.",
        tree: "Merchandise Empire",
        icon: "sparkles",
        baseCost: 400,
        costResource: .attention,
        production: 3,
        maxCount: 1,
        prerequisites: ["merch_nft"],
        phase: 1
    ),
    UpgradeData(
        id: "merch_fundraising",
        name: "Direct Mail Fundraising",
        description: "Letters that generate cash. Urgent! Act now! Final notice! Again!",
        tree: "Merchandise Empire",
        icon: "envelope.fill",
        baseCost: 1500,
        costResource: .attention,
        production: 6,
        maxCount: 1,
        effects: [UpgradeEffect(type: .cashPerSecond, value: 1)],
        prerequisites: ["merch_gold"],
        phase: 1
    ),
    UpgradeData(
        id: "merch_licensing",
        name: "Licensing Empire",
        description: "Put the brand on everything. Hotels, steaks, vodka, airlines...",
        tree: "Merchandise Empire",
        icon: "building.columns.fill",
        baseCost: 6000,
        costResource: .attention,
        production: 20,
        maxCount: 1,
        effects: [UpgradeEffect(type: .cashPerSecond, value: 5)],
        prerequisites: ["merch_fundraising"],
        phase: 1
    ),

    // ── Algorithm Manipulation Tree ──

    UpgradeData(
        id: "algo_bots",
        name: "Bot Farm Startup",
        description: "Generate fake engagement. Nobody can tell the difference anyway.",
        tree: "Algorithm Manipulation",
        icon: "desktopcomputer",
        baseCost: 25,
        costResource: .attention,
        production: 0.3,
        maxCount: 5,
        effects: [UpgradeEffect(type: .attentionPerSecond, value: 0.5)],
        phase: 1
    ),
    UpgradeData(
        id: "algo_trending",
        name: "Trending Topic Manipulation",
        description: "Game the algorithm. If everyone's talking about you, you must matter.",
        tree: "Algorithm Manipulation",
        icon: "chart.line.uptrend.xyaxis",
        baseCost: 150,
        costResource: .attention,
        production: 1.5,
        maxCount: 1,
        effects: [UpgradeEffect(type: .attentionPerSecond, value: 2)],
        prerequisites: ["algo_bots"],
        phase: 1
    ),
    UpgradeData(
        id: "algo_outrage",
        name: "Outrage Amplifier",
        description: "Controversial content gets 10x engagement. That's just good business.",
        tree: "Algorithm Manipulation",
        icon: "flame.fill",
        baseCost: 600,
        costResource: .attention,
        production: 4,
        maxCount: 1,
        effects: [UpgradeEffect(type: .attentionPerClick, value: 2)],
        prerequisites: ["algo_trending"],
        phase: 1
    ),
    UpgradeData(
        id: "algo_recommend",
        name: "Recommendation Exploit",
        description: "Hijack the algorithm. Every \"watch next\" leads back to you.",
        tree: "Algorithm Manipulation",
        icon: "target",
        baseCost: 2500,
        costResource: .attention,
        production: 12,
        maxCount: 1,
        effects: [UpgradeEffect(type: .attentionPerSecond, value: 8)],
        prerequisites: ["algo_outrage"],
        phase: 1
    ),
    UpgradeData(
        id: "algo_bubble",
        name: "Information Bubble Generator",
        description: "Create echo chambers. Everyone agrees — in their own reality.",
        tree: "Algorithm Manipulation",
        icon: "bubble.left.and.bubble.right.fill",
        baseCost: 8000,
        costResource: .attention,
        production: 30,
        maxCount: 1,
        effects: [
            UpgradeEffect(type: .gpsMultiplier, value: 1.3),
            UpgradeEffect(type: .attentionPerSecond, value: 20),
        ],
        prerequisites: ["algo_recommend"],
        phase: 1
    ),

    // ── Early "Science" Tree ──

    UpgradeData(
        id: "sci_research_div",
        name: "\"Research\" Division",
        description: "Hire people who already agree with you. Very efficient.",
        tree: "Early Science",
        icon: "flask.fill",
        baseCost: 75,
        costResource: .attention,
        production: 0.5,
        maxCount: 1,
        unlockAt: UnlockCondition(resource: "greatness", threshold: 10),
        phase: 1
    ),
    UpgradeData(
        id: "sci_alt_facts",
        name: "Alternative Facts Lab",
        description: "Create your own data. Peer review is just gatekeeping.",
        tree: "Early Science",
        icon: "chart.bar.fill",
        baseCost: 300,
        costResource: .attention,
        production: 2.5,
        maxCount: 1,
        prerequisites: ["sci_research_div"],
        phase: 1
    ),
    UpgradeData(
        id: "sci_climate",
        name: "Climate \"Reanalysis\"",
        description: "Reinterpret inconvenient data. The numbers were wrong anyway.",
        tree: "Early Science",
        icon: "thermometer.sun.fill",
        baseCost: 1200,
        costResource: .attention,
        production: 7,
        maxCount: 1,
        prerequisites: ["sci_alt_facts"],
        phase: 1
    ),
    UpgradeData(
        id: "sci_loyalty_review",
        name: "Loyalty-Based Peer Review",
        description: "Only approved scientists get published. Quality control.",
        tree: "Early Science",
        icon: "doc.text.magnifyingglass",
        baseCost: 4000,
        costResource: .attention,
        production: 15,
        maxCount: 1,
        prerequisites: ["sci_climate"],
        phase: 1
    ),
    UpgradeData(
        id: "sci_neural_backup",
        name: "Neural Backup",
        description: "Digitize the brand. Consciousness is just data, right? [UNLOCKS PHASE 2]",
        tree: "Early Science",
        icon: "brain.head.profile.fill",
        baseCost: 15000,
        costResource: .attention,
        production: 50,
        maxCount: 1,
        prerequisites: ["sci_loyalty_review"],
        phase: 1
    ),

    // ── "Entrepreneurship" Tree ──

    UpgradeData(
        id: "ent_bible",
        name: "Premium Bible Sales",
        description: "Special edition with your name on it. Divine endorsement implied.",
        tree: "Entrepreneurship",
        icon: "book.fill",
        baseCost: 30,
        costResource: .attention,
        production: 0.3,
        maxCount: 5,
        phase: 1
    ),
    UpgradeData(
        id: "ent_university",
        name: "\"University\"",
        description: "Sell educational certificates. Accreditation is overrated.",
        tree: "Entrepreneurship",
        icon: "graduationcap.fill",
        baseCost: 250,
        costResource: .attention,
        production: 2,
        maxCount: 1,
        prerequisites: ["ent_bible"],
        phase: 1
    ),
    UpgradeData(
        id: "ent_steak",
        name: "Steak Brand",
        description: "\"The greatest steaks, believe me.\" Well-done with ketchup.",
        tree: "Entrepreneurship",
        icon: "fork.knife",
        baseCost: 800,
        costResource: .attention,
        production: 5,
        maxCount: 1,
        effects: [UpgradeEffect(type: .cashPerSecond, value: 2)],
        prerequisites: ["ent_university"],
        phase: 1
    ),
    UpgradeData(
        id: "ent_crypto",
        name: "Branded Crypto Token",
        description: "Launch $GREAT coin. Definitely not a scam. To the moon!",
        tree: "Entrepreneurship",
        icon: "bitcoinsign.circle.fill",
        baseCost: 3000,
        costResource: .attention,
        production: 10,
        maxCount: 1,
        effects: [UpgradeEffect(type: .cashPerSecond, value: 5)],
        prerequisites: ["ent_steak"],
        phase: 1
    ),
    UpgradeData(
        id: "ent_truth_platform",
        name: "Truth Platform",
        description: "Your own social media. Free speech* (*terms may vary).",
        tree: "Entrepreneurship",
        icon: "megaphone.fill",
        baseCost: 10000,
        costResource: .attention,
        production: 35,
        maxCount: 1,
        effects: [
            UpgradeEffect(type: .attentionPerClick, value: 5),
            UpgradeEffect(type: .gpsMultiplier, value: 1.2),
        ],
        prerequisites: ["ent_crypto"],
        phase: 1
    ),

    // ── Donor Network Tree (costs CASH) ──

    UpgradeData(
        id: "donor_golf",
        name: "Golf Course Fundraisers",
        description: "Host $10,000-a-plate dinners on the back nine. Networking is just golf with checkbooks.",
        tree: "Donor Network",
        icon: "figure.golf",
        baseCost: 75,
        costResource: .cash,
        production: 0.5,
        maxCount: 1,
        effects: [UpgradeEffect(type: .cashPerSecond, value: 0.5)],
        unlockAt: UnlockCondition(resource: "cash", threshold: 50),
        phase: 1
    ),
    UpgradeData(
        id: "donor_superpac",
        name: "Super PAC Setup",
        description: "Unlimited corporate donations, totally not coordinated. Wink.",
        tree: "Donor Network",
        icon: "building.columns.fill",
        baseCost: 250,
        costResource: .cash,
        production: 2,
        maxCount: 1,
        effects: [UpgradeEffect(type: .attentionPerSecond, value: 2)],
        prerequisites: ["donor_golf"],
        phase: 1
    ),
    UpgradeData(
        id: "donor_dark_money",
        name: "Dark Money Pipeline",
        description: "Shell companies within shell companies. The money just... appears.",
        tree: "Donor Network",
        icon: "eye.slash.fill",
        baseCost: 800,
        costResource: .cash,
        production: 5,
        maxCount: 1,
        effects: [UpgradeEffect(type: .cashPerSecond, value: 3)],
        prerequisites: ["donor_superpac"],
        phase: 1
    ),
    UpgradeData(
        id: "donor_billionaire_dinner",
        name: "Billionaire Dinner Circuit",
        description: "Intimate gatherings where oligarchs bid on policy positions. Very exclusive.",
        tree: "Donor Network",
        icon: "wineglass.fill",
        baseCost: 2000,
        costResource: .cash,
        production: 12,
        maxCount: 1,
        effects: [
            UpgradeEffect(type: .cashPerSecond, value: 5),
            UpgradeEffect(type: .attentionPerSecond, value: 4),
        ],
        prerequisites: ["donor_dark_money"],
        phase: 1
    ),
    UpgradeData(
        id: "donor_oligarch_hotline",
        name: "Oligarch Hotline",
        description: "A direct line to the world's wealthiest. They call you now. Speed dial #1.",
        tree: "Donor Network",
        icon: "phone.fill",
        baseCost: 5000,
        costResource: .cash,
        production: 30,
        maxCount: 1,
        effects: [
            UpgradeEffect(type: .gpsMultiplier, value: 1.25),
            UpgradeEffect(type: .cashPerSecond, value: 10),
        ],
        prerequisites: ["donor_billionaire_dinner"],
        phase: 1
    ),

    // ── Legal Defense Tree (costs CASH) ──

    UpgradeData(
        id: "legal_fixer",
        name: "Personal Fixer",
        description: "A guy who knows a guy. Problems disappear. Don't ask how.",
        tree: "Legal Defense",
        icon: "person.fill.questionmark",
        baseCost: 100,
        costResource: .cash,
        production: 0.8,
        maxCount: 1,
        effects: [UpgradeEffect(type: .attentionPerSecond, value: 1)],
        unlockAt: UnlockCondition(resource: "cash", threshold: 75),
        phase: 1
    ),
    UpgradeData(
        id: "legal_dream_team",
        name: "Legal Dream Team",
        description: "An army of lawyers billing $2,000/hour. Justice isn't blind — it's expensive.",
        tree: "Legal Defense",
        icon: "scalemass.fill",
        baseCost: 350,
        costResource: .cash,
        production: 3,
        maxCount: 1,
        effects: [UpgradeEffect(type: .attentionPerSecond, value: 3)],
        prerequisites: ["legal_fixer"],
        phase: 1
    ),
    UpgradeData(
        id: "legal_nda_factory",
        name: "NDA Factory",
        description: "Industrial-scale non-disclosure agreements. Everyone signs. Everyone.",
        tree: "Legal Defense",
        icon: "doc.on.clipboard.fill",
        baseCost: 900,
        costResource: .cash,
        production: 6,
        maxCount: 1,
        effects: [UpgradeEffect(type: .cashPerSecond, value: 2)],
        prerequisites: ["legal_dream_team"],
        phase: 1
    ),
    UpgradeData(
        id: "legal_slapp",
        name: "SLAPP Suit Machine",
        description: "Sue critics into silence. Can't defame if you're bankrupt from legal fees.",
        tree: "Legal Defense",
        icon: "hammer.fill",
        baseCost: 2500,
        costResource: .cash,
        production: 15,
        maxCount: 1,
        effects: [
            UpgradeEffect(type: .attentionPerSecond, value: 6),
            UpgradeEffect(type: .cashPerSecond, value: 3),
        ],
        prerequisites: ["legal_nda_factory"],
        phase: 1
    ),
    UpgradeData(
        id: "legal_immunity",
        name: "\"Absolute Immunity\"",
        description: "You can't be sued, indicted, or even looked at funny. It's in the Constitution. Probably.",
        tree: "Legal Defense",
        icon: "shield.fill",
        baseCost: 6000,
        costResource: .cash,
        production: 35,
        maxCount: 1,
        effects: [
            UpgradeEffect(type: .gpsMultiplier, value: 1.2),
            UpgradeEffect(type: .attentionPerSecond, value: 10),
        ],
        prerequisites: ["legal_slapp"],
        phase: 1
    ),
]

/// Lookup table for quick access by ID
let upgradeRegistry: [String: UpgradeData] = {
    var dict: [String: UpgradeData] = [:]
    for u in phase1Upgrades {
        dict[u.id] = u
    }
    return dict
}()
