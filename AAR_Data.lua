-- Azeroth Angler Records
-- Local fish database for WoW 1.12 / Turtle-style clients.
-- Ranges are gameplay-friendly approximations inspired by real-world species sizes.

AAR_FISH = {
  [6291] = { wow="Raw Brilliant Smallfish", real="European minnow", sci="Phoxinus phoxinus", habitat="freshwater", minL=4, maxL=14, minW=0.002, maxW=0.040, rarity=1.00 },
  [6289] = { wow="Raw Longjaw Mud Snapper", real="Brown bullhead", sci="Ameiurus nebulosus", habitat="freshwater", minL=15, maxL=55, minW=0.080, maxW=2.500, rarity=1.00 },
  [6303] = { wow="Raw Slitherskin Mackerel", real="Atlantic mackerel", sci="Scomber scombrus", habitat="saltwater", minL=20, maxL=60, minW=0.150, maxW=3.400, rarity=1.00 },
  [6361] = { wow="Raw Rainbow Fin Albacore", real="Skipjack tuna", sci="Katsuwonus pelamis", habitat="saltwater", minL=25, maxL=108, minW=0.500, maxW=34.500, rarity=0.70 },
  [6317] = { wow="Raw Loch Frenzy", real="European perch", sci="Perca fluviatilis", habitat="freshwater", minL=10, maxL=60, minW=0.030, maxW=4.800, rarity=0.95 },
  [6308] = { wow="Raw Bristle Whisker Catfish", real="Channel catfish", sci="Ictalurus punctatus", habitat="freshwater", minL=25, maxL=130, minW=0.300, maxW=26.000, rarity=0.85 },
  [6362] = { wow="Raw Rockscale Cod", real="Atlantic cod", sci="Gadus morhua", habitat="saltwater", minL=35, maxL=200, minW=0.500, maxW=96.000, rarity=0.65 },
  [8365] = { wow="Raw Mithril Head Trout", real="Brown trout", sci="Salmo trutta", habitat="freshwater", minL=20, maxL=100, minW=0.150, maxW=20.000, rarity=0.80 },
  [4603] = { wow="Raw Spotted Yellowtail", real="Yellowtail amberjack", sci="Seriola lalandi", habitat="saltwater", minL=40, maxL=160, minW=1.000, maxW=70.000, rarity=0.55 },
  [13754] = { wow="Raw Glossy Mightfish", real="Goliath grouper", sci="Epinephelus itajara", habitat="saltwater", minL=60, maxL=250, minW=5.000, maxW=360.000, rarity=0.25 },
  [13756] = { wow="Raw Summer Bass", real="Largemouth bass", sci="Micropterus salmoides", habitat="freshwater", minL=20, maxL=75, minW=0.200, maxW=10.000, rarity=0.75 },
  [13755] = { wow="Winter Squid", real="European squid", sci="Loligo vulgaris", habitat="saltwater", minL=15, maxL=90, minW=0.100, maxW=3.000, rarity=0.55 },
  [13758] = { wow="Raw Redgill", real="Redbreast sunfish", sci="Lepomis auritus", habitat="freshwater", minL=10, maxL=30, minW=0.050, maxW=0.800, rarity=1.00 },
  [13759] = { wow="Raw Nightfin Snapper", real="Northern red snapper", sci="Lutjanus campechanus", habitat="saltwater", minL=25, maxL=100, minW=0.500, maxW=22.000, rarity=0.65 },
  [13760] = { wow="Raw Sunscale Salmon", real="Atlantic salmon", sci="Salmo salar", habitat="anadromous", minL=35, maxL=150, minW=0.700, maxW=46.800, rarity=0.55 },
  [13889] = { wow="Raw Whitescale Salmon", real="Chinook salmon", sci="Oncorhynchus tshawytscha", habitat="anadromous", minL=45, maxL=150, minW=1.500, maxW=57.000, rarity=0.45 },
  [13888] = { wow="Darkclaw Lobster", real="American lobster", sci="Homarus americanus", habitat="saltwater", minL=20, maxL=110, minW=0.400, maxW=20.000, rarity=0.45 },
  [13757] = { wow="Lightning Eel", real="Electric eel", sci="Electrophorus electricus", habitat="freshwater", minL=50, maxL=250, minW=1.000, maxW=20.000, rarity=0.50 },
  [6358] = { wow="Oily Blackmouth", real="Blackmouth chinook salmon", sci="Oncorhynchus tshawytscha", habitat="saltwater", minL=25, maxL=120, minW=0.500, maxW=35.000, rarity=0.65 },
  [6359] = { wow="Firefin Snapper", real="Northern red snapper", sci="Lutjanus campechanus", habitat="saltwater", minL=25, maxL=100, minW=0.500, maxW=22.000, rarity=0.65 },
  [13422] = { wow="Stonescale Eel", real="European eel", sci="Anguilla anguilla", habitat="freshwater/saltwater", minL=30, maxL=130, minW=0.200, maxW=6.500, rarity=0.50 },
  [6522] = { wow="Deviate Fish", real="Mandarinfish", sci="Synchiropus splendidus", habitat="saltwater", minL=4, maxL=10, minW=0.002, maxW=0.030, rarity=0.95, fantasy=1 },
  [21071] = { wow="Raw Sagefish", real="European grayling", sci="Thymallus thymallus", habitat="freshwater", minL=20, maxL=60, minW=0.150, maxW=2.500, rarity=0.80 },
  [21153] = { wow="Raw Greater Sagefish", real="Arctic grayling", sci="Thymallus arcticus", habitat="freshwater", minL=25, maxL=76, minW=0.250, maxW=3.800, rarity=0.70 },

  -- Bloated fish are container versions of ordinary fish. They still count for fun contests.
  [6643] = { wow="Bloated Smallfish", real="European minnow", sci="Phoxinus phoxinus", habitat="freshwater", minL=5, maxL=16, minW=0.003, maxW=0.050, rarity=0.90 },
  [6645] = { wow="Bloated Mud Snapper", real="Brown bullhead", sci="Ameiurus nebulosus", habitat="freshwater", minL=18, maxL=60, minW=0.100, maxW=3.000, rarity=0.85 },
  [6647] = { wow="Bloated Catfish", real="Channel catfish", sci="Ictalurus punctatus", habitat="freshwater", minL=30, maxL=140, minW=0.400, maxW=28.000, rarity=0.70 },
  [13890] = { wow="Bloated Redgill", real="Redbreast sunfish", sci="Lepomis auritus", habitat="freshwater", minL=12, maxL=34, minW=0.070, maxW=1.000, rarity=0.80 },
  [13891] = { wow="Bloated Salmon", real="Atlantic salmon", sci="Salmo salar", habitat="anadromous", minL=40, maxL=155, minW=0.900, maxW=50.000, rarity=0.50 },
  [13893] = { wow="Large Raw Mightfish", real="Goliath grouper", sci="Epinephelus itajara", habitat="saltwater", minL=80, maxL=250, minW=10.000, maxW=360.000, rarity=0.20 },
}

AAR_FISH_NAME_TO_ID = {}
for id, fish in pairs(AAR_FISH) do
  AAR_FISH_NAME_TO_ID[string.lower(fish.wow)] = id
end
