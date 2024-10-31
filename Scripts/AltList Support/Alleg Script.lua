-- Script: Alleg Script
-- Attribute: isActive

-- Script Code:
-- Define the data set
local AllegItems = {
    {
        clue = "A beacon from the stands would make me happy.",
        plane = "Noctopia",
        item = "Havynne's Lantern"
    },
    {
        clue = "A bow made of gold would be a fine addition to my collection.",
        plane = "Astral",
        item = "Golden Bow"
    },
    {
        clue = "A river of blood should make for some interesting flails.",
        plane = "Noctopia",
        item = "Bloodletter Flail"
    },
    {
        clue = "Be a lamb and fetch me a knife from Karnath.",
        plane = "Karnath",
        item = "Sacrificial Knife"
    },
    {
        clue = "Bring me a dagger I can use to cut glass.",
        plane = "Arcadia",
        item = "Diamond Dagger"
    },
    {
        clue = "Bring me a fiery ring.",
        plane = "Fire",
        item = "Ring Of The White Flame"
    },
    {
        clue = "Bring me a fiery signet.",
        plane = "Fire",
        item = "Signet Of The Pure Flame"
    },
    {
        clue = "Bring me a goat's head from the demons. Mount it on a stick or something.",
        plane = "Tarterus",
        item = "Ram's Head staff"
    },
    {
        clue = "Bring me a madman's embedded whip.",
        plane = "Stone",
        item = "Shard-Embedded Whip"
    },
    {
        clue = "Bring me a shroud. Be sure it has some heft to it.",
        plane = "Karnath",
        item = "Heavy Shroud"
    },
    {
        clue = "Bring me a Sultan's head! Or the turban that rests on it at least.",
        plane = "Water",
        item = "Sultan's Turban"
    },
    {
        clue = "Bring me something golden that will keep me well fed.",
        plane = "Kzinti",
        item = "Sceptre Of Creation"
    },
    {
        clue = "Bring me something truly exotic.",
        plane = "Arcadia",
        item = "Exotic Robes"
    },
    {
        clue = "Bring me the blade of Karnath, intact preferably but I will take what I get.",
        plane = "Karnath",
        item = "Broken Blade Of Karnath"
    },
    {
        clue = "Can domesticated frozen dogs be collared? Find out for me.",
        plane = "Airscape",
        item = "Ice Collar"
    },
    {
        clue = "Dagger of the dead, what else would you expect a spirit to wield?",
        plane = "Karnath",
        item = "Netherworld Dagger"
    },
    {
        clue = "Defeat a champion and bring me his sword.",
        plane = "Outland",
        item = "Black Sword Of The Keep"
    },
    {
        clue = "Do wild ice hounds still get collared? Return with one if they do.",
        plane = "Water",
        item = "Ice Collar"
    },
    {
        clue = "Do you think I would look good in sleeves of gold?",
        plane = "Astral",
        item = "Golden Sleeves"
    },
    {
        clue = "Each Cabal member has a staff of office, bring me one.",
        plane = "Astral",
        item = "Sun Staff"
    },
    {
        clue = "Even domesticated frozen dogs will yield their teeth.",
        plane = "Airscape",
        item = "Ice Hound's Tooth"
    },
    {
        clue = "Find a bow that is truly worthy of firing ice arrows.",
        plane = "Water",
        item = "Ice Bow"
    },
    {
        clue = "Find me some unfinished kzinti serum; I want to make Killaris jealous.",
        plane = "Kzinti",
        item = "Vial Of Unfinished Portal Serum"
    },
    {
        clue = "Flaming blue balls doesn't sound like something I would want a pair of so just relieve the owner of one for me please.",
        plane = "Arcadia",
        item = "Seething Ball Of Blue Flame"
    },
    {
        clue = "Gaius has interesting armor, heavy, but interesting.",
        plane = "Stone",
        item = "Stone Platemail"
    },
    {
        clue = "Go and de-robe the mistress of the south.",
        plane = "Outland",
        item = "Dark Purple Robe"
    },
    {
        clue = "Go play the ultimate game of hot potato in the realm of earth.",
        plane = "Stone",
        item = "Lavabomb"
    },
    {
        clue = "Go play the ultimate game of hot potato in the realm of fire.",
        plane = "Fire",
        item = "Lavabomb"
    },
    {
        clue = "Have you ever seen a katana dance? Neither have I. Please bring me this wonder.",
        plane = "Arcadia",
        item = "Dancing Katana"
    },
    {
        clue = "Hmm, according to my list I need the fang of a snake of some sort, like a viper.",
        plane = "Noctopia",
        item = "Viper Fang"
    },
    {
        clue = "I am not sure what use the Fae have for shield bracelets, get me one so I can take a look at it.",
        plane = "Noctopia",
        item = "Buckler Bracelet"
    },
    {
        clue = "I can't decide if a steam gun would add to my collection or not.",
        plane = "Air",
        item = "Small Steam Gun"
    },
    {
        clue = "I could use some custom made boots.",
        plane = "Water",
        item = "Pair Of Wind-Ravaged Boots"
    },
    {
        clue = "I desire a kzinti incantation, hop to.",
        plane = "Kzinti",
        item = "Incantation Note"
    },
    {
        clue = "I desire the bow of the air lord, be a dear and fetch it for me.",
        plane = "Air",
        item = "Aurora Bow"
    },
    {
        clue = "I desire the mace of the earth lord. Be kind to an old dragon and fetch it for me please.",
        plane = "Stone",
        item = "Earthen Mace Of Might"
    },
    {
        clue = "I don't know whether or not you will have to gather each feather individually, but I would like a cape of Durin feathers or the like.",
        plane = "Arcadia",
        item = "Cape Of Angel Feathers"
    },
    {
        clue = "I doubt there are any happy bone shields but find one with some sort of emotion.",
        plane = "Tarterus",
        item = "Grim Bone Shield"
    },
    {
        clue = "I find myself needing to purify a few sections of my hoard; perhaps a wand would aid me with this.",
        plane = "Fire",
        item = "Ritual Purification Wand"
    },
    {
        clue = "I found a bare spot in my collection that would benefit from a plain staff, or staff of a plane.",
        plane = "Tarterus",
        item = "Staff Of The Lower Planes"
    },
    {
        clue = "I have a leather restorer and preservative I would like to test on some leather armor that has seen better days.",
        plane = "Astral",
        item = "Decaying Vest Made From Cracked Leather"
    },
    {
        clue = "I just want you to do a quick trip to Astral shift and grab me a guardian's weapon.",
        plane = "Astral",
        item = "Massive Slate-grey Sledgehammer"
    },
    {
        clue = "I need you to go visit with the Demogorgon and see if you can purchase his whip, or maybe he would give it to me as a gift.",
        plane = "Tarterus",
        item = "Black Whip"
    },
    {
        clue = "I probably wouldn't want to encounter bugs attached to green webbing, but a veil made of such stuff intrigues me.",
        plane = "Astral",
        item = "Green Web Veil"
    },
    {
        clue = "I require a blindfold that has seen some action. Don't waste my time with the one that blind Fae wears.",
        plane = "Karnath",
        item = "Bloodstained Blindfold"
    },
    {
        clue = "I still don't understand why a mage would wield a sledgehammer, maybe it has something to do with the black rock from which it is made.",
        plane = "Kzinti",
        item = "Obsidian Sledgehammer"
    },
    {
        clue = "I think there might be some hidden information on a crumpled note on the Kzinti plane. Bring me this information.",
        plane = "Kzinti",
        item = "Crumpled Note"
    },
        {
        clue = "I think there might be some hidden information on a crumpled note on the Kzinti plane.",
        plane = "Kzinti",
        item = "Crumpled Note"
    },
    {
        clue = "I used to like to walk the straight and narrow line. Please bring me something that will help tell me where I'm going.",
        plane = "Outland",
        item = "Crystal Ball"
    },
    {
        clue = "I would just love to get my hands on the cloak of the Ruler of the Water plane.",
        plane = "Water",
        item = "Storm-skin Cloak"
    },
    {
        clue = "Imagine the most Goth wand possible then find it and bring it back to me.",
        plane = "Outland",
        item = "Black Wand With A Grinning Skull"
    },
    {
        clue = "Is it there or isn't it? Your back will know when you encounter this blade.",
        plane = "Noctopia",
        item = "Ethereal Blade"
    },
    {
        clue = "It is no katana, but it is still a dancing sword. Bring me this minor wonder.",
        plane = "Arcadia",
        item = "Dancing Rapier"
    },
    {
        clue = "It isn't Oni's kit, maybe it should be mine.",
        plane = "Noctopia",
        item = "Omayra's Kit"
    },
    {
        clue = "Let's sow a little discord; we just need the right weapon.",
        plane = "Tarterus",
        item = "Blade of Discord"
    },
    {
        clue = "Madness and wickedness, Elaxor radiates both.",
        plane = "Stone",
        item = "Radiance Of Wickedness"
    },
    {
        clue = "Malafont's armor, I want it.",
        plane = "Noctopia",
        item = "A Suit Of Dress Plate"
    },
    {
        clue = "The master of death needs to lose his hood.",
        plane = "Outland",
        item = "Black Master's Hood"
    },
    {
        clue = "Maybe if it was pure the elder wouldn't throw this clear thing around.",
        plane = "Nowhere",
        item = "Clear Psi-Blade"
    },
    {
        clue = "One of them will definitely be blue when you bring me his blade.",
        plane = "Nowhere",
        item = "Blue Psi-Blade"
    },
    {
        clue = "Minor illusions can be just as powerful as major ones. Bring me a minor illusionist's ring.",
        plane = "Air",
        item = "Ring Of Minor Imagery"
    },
    {
        clue = "My collection needs a heartbane loaded weapon in case I ever want to slaughter foes.",
        plane = "Astral",
        item = "Pair Of Kzinti Slaughter Gloves"
    },
    {
        clue = "My collection won't be complete without a way to tame death itself.",
        plane = "Tarterus",
        item = "Whip, \"Death-Tamer\""
    },
    {
        clue = "My dagger set just won't be complete without a golden handled weapon capable of damaging werewolves.",
        plane = "Outland",
        item = "Silver Dagger With A Golden Handle"
    },
    {
        clue = "My rock collection seems incomplete. See if you can turn up a blue or white stone for me.",
        plane = "Astral",
        item = "Blueish-White Stone"
    },
    {
        clue = "No clerics have this aura, just the kzinti war leader.",
        plane = "Kzinti",
        item = "Aura Of Domination"
    },
    {
        clue = "Peel the mark off of a madman.",
        plane = "Stone",
        item = "Mark Of Madness"
    },
    {
        clue = "Pick me up a memento I can use to remember the Gith.",
        plane = "Outland",
        item = "Amulet With A Small Silver Sword Inscribed On It"
    },
    {
        clue = "Please acquire custom made leggings made of panthrodrine. I wear a size 30.",
        plane = "Tarterus",
        item = "Panthrodrine-Skin Leggings"
    },
    {
        clue = "Pluck a phoenix for me please.",
        plane = "Fire",
        item = "Flaming Phoenix Feather"
    },
    {
        clue = "Pry the frozen tooth from a wild hound.",
        plane = "Water",
        item = "Ice Hound's Tooth"
    },
    {
        clue = "Retrieve a dark energy lance for me.",
        plane = "Fire",
        item = "Devilish Lance"
    },
    {
        clue = "Show me how loyal you can be.",
        plane = "Karnath",
        item = "Show Of Loyalty"
    },
    {
        clue = "Silk and velvet, but it is still just a dress of rags.",
        plane = "Noctopia",
        item = "Dress Of Silk And Velvet Rags"
    },
    {
        clue = "Skewer me something from the Orb.",
        plane = "Noctopia",
        item = "Glowing Iron Skewer"
    },
    {
        clue = "Skin a rock wyrm for me please.",
        plane = "Stone",
        item = "Shaleskin Arm Guard"
    },
    {
        clue = "Some merrily dancing fire would be appreciated.",
        plane = "Arcadia",
        item = "Baleflame"
    },
    {
        clue = "Something easy this time? Just grab Ralthar's weapon for me.",
        plane = "Fire",
        item = "Steel Broadsword"
    },
    {
        clue = "The location of the disc I want is considered a secret by some.",
        plane = "Midgaard",
        item = "Stone Disc"
    },
    {
        clue = "The monks are guarding something. Have a \"talk\" with Harold and see what you can bring me.",
        plane = "Thorngate",
        item = "Red Bracer"
    },
    {
        clue = "The thing I desire from you mostly resembles a spear, though it hardly qualifies.",
        plane = "Kzinti",
        item = "Crude Spear"
    },
    {
        clue = "These feathers may try to elude you but I expect you to get them for me anyway.",
        plane = "Arcadia",
        item = "Whirl Of Elusive Feathers"
    },
    {
        clue = "Though the item would make one think otherwise, I would be eternally happy if you were to gather a clasp for me.",
        plane = "Fire",
        item = "Clasp Of Eternal Anguish",
        keyword = "clasp anguish lordgear"
    },
    {
        clue = "Thy task involves an axe. Four shalt thou not count, neither count thou two.",
        plane = "Tarterus",
        item = "Axe Of The Third Plane"
    },
    {
        clue = "Try not to get eaten while retrieving a dha for me.",
        plane = "Karnath",
        item = "Iron Dha"
    },
    {
        clue = "Try not to lose anything yourself while gathering a green blade for me.",
        plane = "Nowhere",
        item = "Green Psi-Blade"
    },
    {
        clue = "Turning big rocks into little rocks by having big rocks wield little rocks I reckon could be useful.",
        plane = "Water",
        item = "Stone Hammer"
    },
    {
        clue = "Turning big rocks into little rocks by having big rocks wield little rocks, what madness.",
        plane = "Stone",
        item = "Rock Hammer"
    },
    {
        clue = "Unicorn horns are said to possess great magic. I want one to test out the properties it possesses.",
        plane = "Air",
        item = "Unicorn Horn"
    },
    {
        clue = "What else would you call a flametongue?",
        plane = "Kzinti",
        item = "Flametongue Called 'Firebrand'"
    },
    {
        clue = "I refuse to add dancing butter knives to my collection. I am drawing the line at a dagger.",
        plane = "Arcadia",
        item = "Dancing Dagger"
    },
    -- sometimes just says it this way:
    {
        clue = "I am drawing the line at a dagger.",
        plane = "Arcadia",
        item = "Dancing Dagger"
    },
    {
        clue = "Where's the beef? Actually, I prefer some venison.",
        plane = "Thorngate",
        item = "Side Of Venison"
    },
    {
        clue = "Which is mightier, earth or air? Bring me a gun where one pushes the other around.",
        plane = "Air",
        item = "Air Gun"
    },
    {
        clue = "Why the senior has to dance with yellow I will never know. He has two so it shouldn't hurt him too bad to give one up.",
        plane = "Nowhere",
        item = "Yellow Psi-Blade"
    },
    {
        clue = "Would you please bring me a talisman of evil? Something an evil witch or hag would hold onto.",
        plane = "Astral",
        item = "Devilish Talisman"
    },
    {
        clue = "You don't have to learn the actual ritual, just get an implement used in dark rites.",
        plane = "Karnath",
        item = "Dagger Of Dark Rites"
    },
    {
        clue = "You don't look to be all that skilled at basket weaving but perhaps you could make something nice from some gith hair.",
        plane = "Outland",
        item = "Assassin's Armband"
    },
    {
        clue = "You might have to bleed a bit to get the red just right on the robe I would like you to gather for me.",
        plane = "Outland",
        item = "Blood Red Robe"
    },
    {
        clue = "You will have to jump through a few hurdles but I know you have it in you to find a faerie script for my collection.",
        plane = "Thorngate",
        item = "Faerie Script"
    },
    {
        clue = "You will probably have to get them custom made, but I would like some coarse leather boots.",
        plane = "Noctopia",
        item = "Coarse Leather Boots"
    },
    {
        clue = "You would think that the boy will know you are coming to take his prophetic staff away and give it to me.",
        plane = "Water",
        item = "Staff Of Prophecy"
    },
    {
        clue = "Do not be oblivious to the signs leading to the item I desire.",
        plane = "Fire",
        item = "Signet Of The Oblivious Defender"
    },
    -- Add more data entries here
}

-- Function to search for the item and plane based on a given clue
function findItemAndPlane(clue)
    for _, entry in ipairs(AllegItems) do
        if clue == entry.clue then
            return entry.item, entry.plane
        end
    end
    return nil, nil  -- Clue not found
end

function checkItemIsAlleg(item)
  local alleg_item
  item = string.lower(item)

  for _, entry in pairs(AllegItems) do
    alleg_item = string.lower(entry.item)
    if item == alleg_item then return true end
  end
  
  return false
end

local AllegKeywordTable = {
  ["amulet with a small silver sword inscribed on it"] = "amulet silver sword inscribed",


}

function getAllegKeyword(item)
 -- some items are too hard to determine their keywords based on the trick below, in that case use the table above
 -- if we have the item in the lookup table, return it's keyword
 --if AllegKeywordTable[item] then return AllegKeywordTable[item] end

 -- otherwise, the below does a good job of determining most alleg item's keywords without having to have every item in the lookup table
 item = string.lower(item)
 item = " " .. item .. " "
 item = string.gsub(item, " of ", " ")
 item = string.gsub(item, " the ", " ")
 item = string.gsub(item, " with ", " ")
 item = string.gsub(item, " a ", " ")
 item = string.gsub(item, " on ", " ")
 item = string.gsub(item, " it ", " ")
 item = string.gsub(item, " small ", " ")
 item = string.gsub(item, " called ", " ")
 item = string.gsub(item, " pair ", " ")
 item = string.gsub(item, " heavy ", "")
 item = string.gsub(item, "broadsword", "broad sword")
 item = string.gsub(item, "shard%-embedded", "shard")
 item = string.gsub(item, "devilish", "devil")
 item = string.gsub(item, "seething", "blaze")
 item = string.gsub(item, "blueish", "bluish")
 item = string.gsub(item, "eternal anguish", "anguish")
 item = string.gsub(item, "%'s", "")
 item = string.gsub(item, "'", "")
 --item = string.gsub(item, " -", " ")
 item = string.gsub(item, '^%s*(.-)%s*$', '%1')
 return item
end



