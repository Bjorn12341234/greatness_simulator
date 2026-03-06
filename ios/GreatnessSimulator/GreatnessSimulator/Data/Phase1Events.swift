import Foundation

let phase1Events: [GameEvent] = [

    // ── Scandals ──

    GameEvent(
        id: "p1_scandal_tweet",
        phase: 1,
        category: .scandal,
        headline: "Controversial Tweet Goes Viral",
        context: "A late-night post sparks international outrage. The algorithm is feeding.",
        choices: [
            EventChoice(label: "Double Down", effects: [
                Effect(resource: "attention", amount: 50),
                Effect(resource: "greatness", amount: 5),
            ], description: "More attention, less credibility"),
            EventChoice(label: "Issue Non-Apology", effects: [
                Effect(resource: "attention", amount: 20),
                Effect(resource: "greatness", amount: 2),
            ], description: "\"I'm sorry you were offended\""),
        ]
    ),

    GameEvent(
        id: "p1_scandal_tax",
        phase: 1,
        category: .scandal,
        headline: "Tax Records Surface Online",
        context: "Someone leaked financial documents. The numbers are... creative.",
        choices: [
            EventChoice(label: "\"Smart Business\"", effects: [
                Effect(resource: "attention", amount: 40),
                Effect(resource: "cash", amount: 50),
            ], description: "Spin it as genius"),
            EventChoice(label: "Threaten Lawsuit", effects: [
                Effect(resource: "attention", amount: 30),
                Effect(resource: "influence", amount: 10),
            ], description: "Fear is a resource"),
        ],
        conditions: [EventCondition(resource: "clickCount", op: .gte, value: 20)]
    ),

    GameEvent(
        id: "p1_scandal_ghostwriter",
        phase: 1,
        category: .scandal,
        headline: "Ghostwriter Reveals All",
        context: "The person who actually wrote your bestseller is doing interviews.",
        choices: [
            EventChoice(label: "Deny Everything", effects: [
                Effect(resource: "attention", amount: 60),
            ], description: "Who are you going to believe?"),
            EventChoice(label: "Sue for NDA Violation", effects: [
                Effect(resource: "cash", amount: -20),
                Effect(resource: "influence", amount: 15),
            ], description: "Legal intimidation works"),
        ],
        conditions: [EventCondition(resource: "greatness", op: .gte, value: 20)]
    ),

    GameEvent(
        id: "p1_scandal_charity",
        phase: 1,
        category: .scandal,
        headline: "Charity Funds \"Redirected\"",
        context: "An audit reveals your children's charity spent 90% on \"administrative golf.\"",
        choices: [
            EventChoice(label: "\"Networking IS Charity\"", effects: [
                Effect(resource: "attention", amount: 60),
                Effect(resource: "cash", amount: 40),
            ], description: "Golf builds relationships that help people"),
            EventChoice(label: "Dissolve the Charity", effects: [
                Effect(resource: "cash", amount: 80),
                Effect(resource: "influence", amount: 5),
            ], description: "Can't audit what doesn't exist"),
        ]
    ),

    GameEvent(
        id: "p1_scandal_plagiarism",
        phase: 1,
        category: .scandal,
        headline: "Speech Plagiarism Exposed",
        context: "Your big keynote was copy-pasted from three different TED talks and a fortune cookie.",
        choices: [
            EventChoice(label: "\"Great Minds Think Alike\"", effects: [
                Effect(resource: "attention", amount: 45),
                Effect(resource: "greatness", amount: 3),
            ], description: "Parallel thinking happens all the time"),
            EventChoice(label: "Blame the Speechwriter", effects: [
                Effect(resource: "attention", amount: 30),
                Effect(resource: "influence", amount: 8),
            ], description: "Throw them under the podium"),
        ],
        conditions: [EventCondition(resource: "clickCount", op: .gte, value: 15)]
    ),

    GameEvent(
        id: "p1_scandal_crowd_size",
        phase: 1,
        category: .scandal,
        headline: "Crowd Size Photos Don't Match Claims",
        context: "Aerial shots show 2,000 attendees. You claimed 200,000. Close enough.",
        choices: [
            EventChoice(label: "\"Fake Photos!\"", effects: [
                Effect(resource: "attention", amount: 70),
                Effect(resource: "greatness", amount: 5),
            ], description: "The camera adds negative people"),
            EventChoice(label: "Release \"Official\" Photos", effects: [
                Effect(resource: "attention", amount: 40),
                Effect(resource: "cash", amount: 25),
            ], description: "Photoshop is a legitimate tool"),
        ],
        conditions: [EventCondition(resource: "attention", op: .gte, value: 75)]
    ),

    GameEvent(
        id: "p1_scandal_health",
        phase: 1,
        category: .scandal,
        headline: "Health Records Leaked",
        context: "Medical documents reveal your doctor's note was dictated by you. \"Astonishingly excellent.\"",
        choices: [
            EventChoice(label: "\"Healthiest Ever\"", effects: [
                Effect(resource: "attention", amount: 80),
                Effect(resource: "greatness", amount: 8),
            ], description: "Challenge doubters to a fitness test"),
            EventChoice(label: "Threaten the Hospital", effects: [
                Effect(resource: "influence", amount: 12),
                Effect(resource: "cash", amount: -25),
            ], description: "HIPAA works both ways... sort of"),
        ],
        conditions: [EventCondition(resource: "greatness", op: .gte, value: 40)]
    ),

    GameEvent(
        id: "p1_scandal_intern",
        phase: 1,
        category: .scandal,
        headline: "Former Intern Publishes Tell-All",
        context: "A memoir titled \"Covfefe and Chaos\" is topping the bestseller charts.",
        choices: [
            EventChoice(label: "Buy All Copies", effects: [
                Effect(resource: "cash", amount: -60),
                Effect(resource: "attention", amount: 30),
            ], description: "If you buy them all, nobody else can read it"),
            EventChoice(label: "Write Your Own Tell-All", effects: [
                Effect(resource: "cash", amount: 100),
                Effect(resource: "attention", amount: 70),
            ], description: "About yourself. The authorized version."),
        ],
        conditions: [EventCondition(resource: "greatness", op: .gte, value: 80)]
    ),

    // ── Opportunities ──

    GameEvent(
        id: "p1_opp_rally",
        phase: 1,
        category: .opportunity,
        headline: "Rally Opportunity",
        context: "A venue just opened up. Time to give the people what they want.",
        choices: [
            EventChoice(label: "Pack the Arena", effects: [
                Effect(resource: "attention", amount: 80),
                Effect(resource: "greatness", amount: 10),
            ], description: "Maximum crowd, maximum attention"),
            EventChoice(label: "Intimate Fundraiser", effects: [
                Effect(resource: "cash", amount: 100),
                Effect(resource: "attention", amount: 20),
            ], description: "Less spectacle, more donations"),
        ]
    ),

    GameEvent(
        id: "p1_opp_endorsement",
        phase: 1,
        category: .opportunity,
        headline: "Celebrity Endorsement Offer",
        context: "A reality TV star wants to publicly support the brand. Very on-brand.",
        choices: [
            EventChoice(label: "Accept Gladly", effects: [
                Effect(resource: "attention", amount: 100),
                Effect(resource: "greatness", amount: 8),
            ], description: "Free publicity"),
            EventChoice(label: "Demand Payment", effects: [
                Effect(resource: "cash", amount: 75),
            ], description: "Nothing is free in this game"),
        ],
        conditions: [EventCondition(resource: "attention", op: .gte, value: 50)]
    ),

    GameEvent(
        id: "p1_opp_book_deal",
        phase: 1,
        category: .opportunity,
        headline: "Book Deal on the Table",
        context: "A publisher wants your name on a new title. Content optional.",
        choices: [
            EventChoice(label: "Cash Advance", effects: [
                Effect(resource: "cash", amount: 200),
            ], description: "Take the money upfront"),
            EventChoice(label: "Publicity Blitz", effects: [
                Effect(resource: "attention", amount: 120),
                Effect(resource: "greatness", amount: 15),
            ], description: "Book tour generates attention"),
        ],
        conditions: [EventCondition(resource: "greatness", op: .gte, value: 10)]
    ),

    GameEvent(
        id: "p1_opp_merch_viral",
        phase: 1,
        category: .opportunity,
        headline: "Merchandise Goes Viral",
        context: "Your branded products are trending on social media. Everyone wants one.",
        choices: [
            EventChoice(label: "Limited Edition Drop", effects: [
                Effect(resource: "cash", amount: 150),
                Effect(resource: "attention", amount: 40),
            ], description: "Scarcity creates demand"),
            EventChoice(label: "Mass Production", effects: [
                Effect(resource: "cash", amount: 80),
                Effect(resource: "attention", amount: 80),
            ], description: "Flood the market"),
        ],
        conditions: [EventCondition(resource: "attention", op: .gte, value: 100)]
    ),

    GameEvent(
        id: "p1_opp_podcast",
        phase: 1,
        category: .opportunity,
        headline: "Podcast Appearance Invite",
        context: "The #1 podcast wants you on. Three hours of unfiltered conversation.",
        choices: [
            EventChoice(label: "Go Long", effects: [
                Effect(resource: "attention", amount: 200),
                Effect(resource: "greatness", amount: 25),
            ], description: "Three hours of pure content"),
            EventChoice(label: "Counter-Offer: Your Platform Only", effects: [
                Effect(resource: "attention", amount: 80),
                Effect(resource: "influence", amount: 20),
            ], description: "Drive traffic to your platform"),
        ],
        conditions: [EventCondition(resource: "greatness", op: .gte, value: 30)]
    ),

    GameEvent(
        id: "p1_opp_meme",
        phase: 1,
        category: .opportunity,
        headline: "You've Become a Meme",
        context: "The internet has turned your latest gaffe into a viral meme format.",
        choices: [
            EventChoice(label: "Embrace It", effects: [
                Effect(resource: "attention", amount: 100),
                Effect(resource: "greatness", amount: 8),
            ], description: "Post the meme yourself"),
            EventChoice(label: "Copyright Claim Everything", effects: [
                Effect(resource: "cash", amount: 30),
                Effect(resource: "influence", amount: 10),
            ], description: "Your face, your rules"),
        ]
    ),

    GameEvent(
        id: "p1_opp_tabloid",
        phase: 1,
        category: .opportunity,
        headline: "Tabloid Exclusive Offer",
        context: "A major tabloid wants a front-page exclusive. They'll print whatever you say.",
        choices: [
            EventChoice(label: "Outrageous Claims", effects: [
                Effect(resource: "attention", amount: 90),
                Effect(resource: "greatness", amount: 7),
            ], description: "The wilder the headline, the better the sales"),
            EventChoice(label: "Paid Advertorial", effects: [
                Effect(resource: "cash", amount: 120),
                Effect(resource: "attention", amount: 30),
            ], description: "It looks like news but it's an ad"),
        ]
    ),

    GameEvent(
        id: "p1_opp_reality_tv",
        phase: 1,
        category: .opportunity,
        headline: "Reality TV Pitch Meeting",
        context: "A network wants a show where you fire people. Groundbreaking television.",
        choices: [
            EventChoice(label: "Accept the Deal", effects: [
                Effect(resource: "attention", amount: 150),
                Effect(resource: "greatness", amount: 15),
            ], description: "National exposure + catchphrase rights"),
            EventChoice(label: "Demand Executive Producer Credit", effects: [
                Effect(resource: "cash", amount: 200),
                Effect(resource: "influence", amount: 10),
            ], description: "More money, more control"),
        ],
        conditions: [EventCondition(resource: "attention", op: .gte, value: 120)]
    ),

    GameEvent(
        id: "p1_opp_foreign_interview",
        phase: 1,
        category: .opportunity,
        headline: "Foreign Media Requests Interview",
        context: "International journalists want your \"unique perspective.\" They seem... fascinated.",
        choices: [
            EventChoice(label: "Go International", effects: [
                Effect(resource: "attention", amount: 100),
                Effect(resource: "influence", amount: 15),
            ], description: "Global brand awareness"),
            EventChoice(label: "\"America First\"", effects: [
                Effect(resource: "attention", amount: 60),
                Effect(resource: "greatness", amount: 10),
            ], description: "Refuse and make that the story"),
        ],
        conditions: [EventCondition(resource: "greatness", op: .gte, value: 25)]
    ),

    GameEvent(
        id: "p1_opp_speaking_gig",
        phase: 1,
        category: .opportunity,
        headline: "Corporate Speaking Gig",
        context: "Fortune 500 company offers $250K for a 20-minute speech. Topics optional.",
        choices: [
            EventChoice(label: "Take the Money", effects: [
                Effect(resource: "cash", amount: 250),
            ], description: "$12,500 per minute. Not bad."),
            EventChoice(label: "Demand More + Branding", effects: [
                Effect(resource: "cash", amount: 150),
                Effect(resource: "attention", amount: 50),
                Effect(resource: "influence", amount: 8),
            ], description: "Rename their conference room"),
        ],
        conditions: [EventCondition(resource: "cash", op: .gte, value: 75)]
    ),

    GameEvent(
        id: "p1_opp_debate",
        phase: 1,
        category: .opportunity,
        headline: "Debate Challenge Issued",
        context: "A prominent critic challenges you to a live debate. Ratings would be huge.",
        choices: [
            EventChoice(label: "Accept (With Conditions)", effects: [
                Effect(resource: "attention", amount: 180),
                Effect(resource: "greatness", amount: 20),
            ], description: "You pick the moderator, the venue, and the questions"),
            EventChoice(label: "\"Too Busy Being Great\"", effects: [
                Effect(resource: "attention", amount: 70),
                Effect(resource: "influence", amount: 12),
            ], description: "Decline with maximum condescension"),
        ],
        conditions: [EventCondition(resource: "greatness", op: .gte, value: 60)]
    ),

    // ── Absurd ──

    GameEvent(
        id: "p1_absurd_covfefe",
        phase: 1,
        category: .absurd,
        headline: "Mysterious Post Baffles Internet",
        context: "You posted a single incomprehensible word at 3 AM. It's now a movement.",
        choices: [
            EventChoice(label: "\"Meant Every Word\"", effects: [
                Effect(resource: "attention", amount: 70),
                Effect(resource: "greatness", amount: 5),
            ], description: "Own the mystery"),
            EventChoice(label: "Sell the Merchandise", effects: [
                Effect(resource: "cash", amount: 60),
                Effect(resource: "attention", amount: 30),
            ], description: "Put it on a hat"),
        ]
    ),

    GameEvent(
        id: "p1_absurd_steak",
        phase: 1,
        category: .absurd,
        headline: "Steak Brand Controversy",
        context: "Food critics unanimously pan your branded steaks. Sales are through the roof.",
        choices: [
            EventChoice(label: "\"Best Steaks, Believe Me\"", effects: [
                Effect(resource: "cash", amount: 40),
                Effect(resource: "attention", amount: 50),
            ], description: "Critics don't know real food"),
            EventChoice(label: "Challenge Critics to Taste Test", effects: [
                Effect(resource: "attention", amount: 90),
            ], description: "Content goldmine"),
        ],
        conditions: [EventCondition(resource: "clickCount", op: .gte, value: 30)]
    ),

    GameEvent(
        id: "p1_absurd_impersonator",
        phase: 1,
        category: .absurd,
        headline: "Professional Impersonator Goes Viral",
        context: "Someone is impersonating you so well that even supporters are confused.",
        choices: [
            EventChoice(label: "Hire Them", effects: [
                Effect(resource: "attention", amount: 60),
                Effect(resource: "cash", amount: -30),
            ], description: "Two of you = twice the attention"),
            EventChoice(label: "Sue Them", effects: [
                Effect(resource: "influence", amount: 10),
                Effect(resource: "cash", amount: -15),
            ], description: "There can only be one"),
        ],
        conditions: [EventCondition(resource: "attention", op: .gte, value: 200)]
    ),

    GameEvent(
        id: "p1_absurd_gold_toilet",
        phase: 1,
        category: .absurd,
        headline: "Gold Toilet Photo Leaks",
        context: "Paparazzi captured your bathroom renovation. It's... golden.",
        choices: [
            EventChoice(label: "\"That's Called Success\"", effects: [
                Effect(resource: "attention", amount: 80),
                Effect(resource: "greatness", amount: 5),
            ], description: "If you've got it, flush it"),
            EventChoice(label: "Launch Gold Bathroom Line", effects: [
                Effect(resource: "cash", amount: 120),
                Effect(resource: "attention", amount: 40),
            ], description: "If they want it, sell it"),
        ],
        conditions: [EventCondition(resource: "cash", op: .gte, value: 100)]
    ),

    GameEvent(
        id: "p1_absurd_sharpie",
        phase: 1,
        category: .absurd,
        headline: "Sharpie Weather Map Incident",
        context: "You extended a hurricane's path with a marker to prove you were right. The evidence is on live TV.",
        choices: [
            EventChoice(label: "\"The Sharpie Was Prophetic\"", effects: [
                Effect(resource: "attention", amount: 90),
                Effect(resource: "greatness", amount: 6),
            ], description: "Predict more weather with office supplies"),
            EventChoice(label: "Sell Autographed Sharpies", effects: [
                Effect(resource: "cash", amount: 80),
                Effect(resource: "attention", amount: 40),
            ], description: "Turn controversy into commerce"),
        ]
    ),

    GameEvent(
        id: "p1_absurd_tan",
        phase: 1,
        category: .absurd,
        headline: "The Tan Line Mystery",
        context: "A gust of wind reveals a stark tan line that doesn't match your \"natural glow\" claims.",
        choices: [
            EventChoice(label: "\"Lighting Conditions\"", effects: [
                Effect(resource: "attention", amount: 60),
                Effect(resource: "greatness", amount: 4),
            ], description: "It's the sun's fault"),
            EventChoice(label: "Launch Bronzer Brand", effects: [
                Effect(resource: "cash", amount: 100),
                Effect(resource: "attention", amount: 50),
            ], description: "\"Presidential Glow\" — $49.99 a bottle"),
        ],
        conditions: [EventCondition(resource: "clickCount", op: .gte, value: 25)]
    ),

    GameEvent(
        id: "p1_absurd_love_letters",
        phase: 1,
        category: .absurd,
        headline: "\"Beautiful Letters\" from Dictators",
        context: "You're showing off personal correspondence from authoritarian leaders. \"We fell in love,\" you explain.",
        choices: [
            EventChoice(label: "Publish a Coffee Table Book", effects: [
                Effect(resource: "cash", amount: 90),
                Effect(resource: "attention", amount: 70),
            ], description: "\"Letters from Strongmen\" — a collector's edition"),
            EventChoice(label: "Frame Them in Gold", effects: [
                Effect(resource: "influence", amount: 15),
                Effect(resource: "greatness", amount: 8),
            ], description: "Display in the lobby. Very diplomatic."),
        ],
        conditions: [EventCondition(resource: "greatness", op: .gte, value: 35)]
    ),

    GameEvent(
        id: "p1_absurd_eclipse",
        phase: 1,
        category: .absurd,
        headline: "Staring at the Eclipse",
        context: "Despite every warning, you looked directly at the solar eclipse. On camera. Without glasses.",
        choices: [
            EventChoice(label: "\"The Sun Looked Away First\"", effects: [
                Effect(resource: "attention", amount: 100),
                Effect(resource: "greatness", amount: 10),
            ], description: "Assert dominance over celestial objects"),
            EventChoice(label: "Sell Eclipse Merch", effects: [
                Effect(resource: "cash", amount: 70),
                Effect(resource: "attention", amount: 50),
            ], description: "Branded sunglasses: \"I LOOKED\""),
        ],
        conditions: [EventCondition(resource: "attention", op: .gte, value: 150)]
    ),

    GameEvent(
        id: "p1_absurd_paper_towels",
        phase: 1,
        category: .absurd,
        headline: "Paper Towel Throwing Incident",
        context: "At a disaster relief event, you're tossing paper towels into the crowd like basketballs.",
        choices: [
            EventChoice(label: "\"Three-Pointer!\"", effects: [
                Effect(resource: "attention", amount: 110),
                Effect(resource: "greatness", amount: 7),
            ], description: "Turn relief into a sport"),
            EventChoice(label: "Branded Paper Towels", effects: [
                Effect(resource: "cash", amount: 60),
                Effect(resource: "attention", amount: 40),
            ], description: "\"The Absorber\" — for the biggest messes"),
        ],
        conditions: [EventCondition(resource: "greatness", op: .gte, value: 15)]
    ),

    GameEvent(
        id: "p1_absurd_fast_food",
        phase: 1,
        category: .absurd,
        headline: "Fast Food Banquet at the Mansion",
        context: "You're hosting dignitaries with a table full of cold Big Macs and Filet-O-Fish. On silver platters.",
        choices: [
            EventChoice(label: "\"American Cuisine!\"", effects: [
                Effect(resource: "attention", amount: 85),
                Effect(resource: "greatness", amount: 5),
            ], description: "Declare fast food a national treasure"),
            EventChoice(label: "Franchise Deal", effects: [
                Effect(resource: "cash", amount: 150),
                Effect(resource: "attention", amount: 30),
            ], description: "Negotiate a branded meal"),
        ],
        conditions: [EventCondition(resource: "cash", op: .gte, value: 120)]
    ),

    // ── Contradictions ──

    GameEvent(
        id: "p1_contra_billionaire_populist",
        phase: 1,
        category: .contradiction,
        headline: "Billionaire Populism Questioned",
        context: "A reporter asks how a gold-penthouse dweller understands working families.",
        choices: [
            EventChoice(label: "\"I Eat McDonald's\"", effects: [
                Effect(resource: "attention", amount: 50),
                Effect(resource: "greatness", amount: 3),
            ], description: "Relatable! Just like you!"),
            EventChoice(label: "Attack the Reporter", effects: [
                Effect(resource: "attention", amount: 70),
                Effect(resource: "influence", amount: 5),
            ], description: "The best defense"),
        ],
        conditions: [EventCondition(resource: "cash", op: .gte, value: 50)]
    ),

    GameEvent(
        id: "p1_contra_freedom_censorship",
        phase: 1,
        category: .contradiction,
        headline: "Free Speech Champion Blocks Critics",
        context: "Your \"free speech\" platform is suspending accounts that disagree with you.",
        choices: [
            EventChoice(label: "\"Maintaining Standards\"", effects: [
                Effect(resource: "influence", amount: 15),
                Effect(resource: "attention", amount: 20),
            ], description: "Free speech doesn't mean consequence-free speech"),
            EventChoice(label: "Unblock Everyone", effects: [
                Effect(resource: "attention", amount: 40),
                Effect(resource: "greatness", amount: 5),
            ], description: "The algorithm will bury them anyway"),
        ],
        conditions: [EventCondition(resource: "greatness", op: .gte, value: 50)]
    ),

    GameEvent(
        id: "p1_contra_self_made",
        phase: 1,
        category: .contradiction,
        headline: "\"Self-Made\" Origin Story Questioned",
        context: "Records show a \"small loan\" of several million. Self-made is a spectrum, you argue.",
        choices: [
            EventChoice(label: "\"A Mere Million\"", effects: [
                Effect(resource: "attention", amount: 55),
                Effect(resource: "greatness", amount: 5),
            ], description: "Minimize. It was basically nothing."),
            EventChoice(label: "Redefine Self-Made", effects: [
                Effect(resource: "attention", amount: 40),
                Effect(resource: "influence", amount: 10),
            ], description: "Self-made means making the call to accept the money"),
        ]
    ),

    GameEvent(
        id: "p1_contra_drain_swamp",
        phase: 1,
        category: .contradiction,
        headline: "Swamp Draining Goes Sideways",
        context: "Your anti-corruption team is now under investigation for corruption. Layers.",
        choices: [
            EventChoice(label: "\"Deeper Than Expected\"", effects: [
                Effect(resource: "attention", amount: 65),
                Effect(resource: "greatness", amount: 4),
            ], description: "The swamp has swamps"),
            EventChoice(label: "Rebrand the Swamp", effects: [
                Effect(resource: "influence", amount: 12),
                Effect(resource: "cash", amount: 30),
            ], description: "\"Strategic Wetland Preservation\""),
        ],
        conditions: [EventCondition(resource: "greatness", op: .gte, value: 30)]
    ),

    GameEvent(
        id: "p1_contra_gold_elevator",
        phase: 1,
        category: .contradiction,
        headline: "Gold Elevator, Blue Collar Speech",
        context: "You descend a golden escalator to announce you're fighting for the working class.",
        choices: [
            EventChoice(label: "\"Gold Inspires\"", effects: [
                Effect(resource: "attention", amount: 75),
                Effect(resource: "greatness", amount: 8),
            ], description: "This is what success looks like"),
            EventChoice(label: "Sell Escalator Rides", effects: [
                Effect(resource: "cash", amount: 100),
                Effect(resource: "attention", amount: 35),
            ], description: "$50 for the \"Descent of Greatness\" experience"),
        ],
        conditions: [EventCondition(resource: "attention", op: .gte, value: 80)]
    ),

    GameEvent(
        id: "p1_contra_family_values",
        phase: 1,
        category: .contradiction,
        headline: "Family Values Champion, Wife #3",
        context: "You're giving a speech about traditional family values. The math is getting complicated.",
        choices: [
            EventChoice(label: "\"Family is Evolving\"", effects: [
                Effect(resource: "attention", amount: 50),
                Effect(resource: "greatness", amount: 6),
            ], description: "More marriages = more family"),
            EventChoice(label: "Pivot to \"Dynasty\"", effects: [
                Effect(resource: "influence", amount: 15),
                Effect(resource: "attention", amount: 30),
            ], description: "Rebrand as legacy-building"),
        ],
        conditions: [EventCondition(resource: "greatness", op: .gte, value: 45)]
    ),

    GameEvent(
        id: "p1_contra_bible",
        phase: 1,
        category: .contradiction,
        headline: "Bible Verse Fumble",
        context: "Asked to name a favorite Bible verse, you cite \"Two Corinthians\" and trail off. The faithful look concerned.",
        choices: [
            EventChoice(label: "\"It's a Personal Relationship\"", effects: [
                Effect(resource: "attention", amount: 45),
                Effect(resource: "greatness", amount: 3),
            ], description: "Too sacred to share publicly"),
            EventChoice(label: "Sell Branded Bibles", effects: [
                Effect(resource: "cash", amount: 130),
                Effect(resource: "attention", amount: 60),
            ], description: "Your name on the cover. $59.99."),
        ],
        conditions: [EventCondition(resource: "clickCount", op: .gte, value: 40)]
    ),

    // ── Crisis ──

    GameEvent(
        id: "p1_crisis_investigation",
        phase: 1,
        category: .crisis,
        headline: "Federal Investigation Announced",
        context: "Authorities are looking into your business practices. This could be trouble.",
        choices: [
            EventChoice(label: "\"Witch Hunt!\"", effects: [
                Effect(resource: "attention", amount: 150),
                Effect(resource: "cash", amount: -50),
                Effect(resource: "greatness", amount: 20),
            ], description: "Rally the base around persecution"),
            EventChoice(label: "Cooperate Quietly", effects: [
                Effect(resource: "cash", amount: -100),
            ], description: "Boring but safe"),
        ],
        conditions: [EventCondition(resource: "greatness", op: .gte, value: 100)]
    ),

    GameEvent(
        id: "p1_crisis_lawsuit",
        phase: 1,
        category: .crisis,
        headline: "Class Action Lawsuit Filed",
        context: "Former \"university\" students want their money back. How unreasonable.",
        choices: [
            EventChoice(label: "Settle Quietly", effects: [
                Effect(resource: "cash", amount: -75),
            ], description: "Make it go away"),
            EventChoice(label: "Counter-Sue", effects: [
                Effect(resource: "attention", amount: 60),
                Effect(resource: "cash", amount: -30),
                Effect(resource: "influence", amount: 10),
            ], description: "Offense is the best defense"),
        ],
        conditions: [EventCondition(resource: "attention", op: .gte, value: 300)]
    ),

    GameEvent(
        id: "p1_crisis_bank",
        phase: 1,
        category: .crisis,
        headline: "Branded Bank Collapses",
        context: "Your name-licensed bank just failed. Depositors are furious. Regulators are circling.",
        choices: [
            EventChoice(label: "\"I Only Licensed the Name\"", effects: [
                Effect(resource: "attention", amount: 100),
                Effect(resource: "cash", amount: -80),
            ], description: "Distance from the wreckage"),
            EventChoice(label: "Blame the Manager", effects: [
                Effect(resource: "attention", amount: 60),
                Effect(resource: "influence", amount: 10),
                Effect(resource: "cash", amount: -40),
            ], description: "\"I hire the best people. Sometimes they're the worst.\""),
        ],
        conditions: [EventCondition(resource: "cash", op: .gte, value: 150)]
    ),

    GameEvent(
        id: "p1_crisis_documentary",
        phase: 1,
        category: .crisis,
        headline: "Damning Documentary Drops",
        context: "A streaming platform just released a 6-part expose. It's trending #1 in 40 countries.",
        choices: [
            EventChoice(label: "\"Free Publicity\"", effects: [
                Effect(resource: "attention", amount: 200),
                Effect(resource: "greatness", amount: 15),
                Effect(resource: "cash", amount: -50),
            ], description: "All press is good press, even the bad kind"),
            EventChoice(label: "Counter-Documentary", effects: [
                Effect(resource: "cash", amount: -100),
                Effect(resource: "attention", amount: 80),
                Effect(resource: "influence", amount: 15),
            ], description: "Fund your own version. \"The REAL Story.\""),
        ],
        conditions: [EventCondition(resource: "greatness", op: .gte, value: 70)]
    ),

    GameEvent(
        id: "p1_crisis_whistleblower",
        phase: 1,
        category: .crisis,
        headline: "Ally Turns Whistleblower",
        context: "Your most loyal lieutenant just flipped. They have recordings. Lots of recordings.",
        choices: [
            EventChoice(label: "\"Never Knew Them\"", effects: [
                Effect(resource: "attention", amount: 120),
                Effect(resource: "influence", amount: -10),
            ], description: "Deny any close relationship (despite 200 photos together)"),
            EventChoice(label: "Release Counter-Tapes", effects: [
                Effect(resource: "attention", amount: 180),
                Effect(resource: "greatness", amount: 25),
                Effect(resource: "cash", amount: -70),
            ], description: "You recorded everything too. Mutually assured destruction."),
        ],
        conditions: [EventCondition(resource: "greatness", op: .gte, value: 90)]
    ),

    GameEvent(
        id: "p1_crisis_platform_ban",
        phase: 1,
        category: .crisis,
        headline: "Banned from Major Platform",
        context: "Your main social media account just got permanently suspended. 80 million followers — gone.",
        choices: [
            EventChoice(label: "\"This Proves They Fear Me\"", effects: [
                Effect(resource: "attention", amount: 250),
                Effect(resource: "greatness", amount: 30),
            ], description: "Martyrdom is the ultimate brand"),
            EventChoice(label: "Launch Own Platform", effects: [
                Effect(resource: "cash", amount: -150),
                Effect(resource: "attention", amount: 100),
                Effect(resource: "influence", amount: 25),
            ], description: "With blackjack and no moderation"),
        ],
        conditions: [EventCondition(resource: "attention", op: .gte, value: 400)],
        unique: true
    ),
]
