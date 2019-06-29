This folder contains Fire Emblem custom cards.
To use these cards: Move the "pics" folder into the main YGOPro folder. (C:\...\ygopro_vs_links_beta)  
If there is no expansions folder, make one.
Then, move the .cdb file into the expansions folder. (C:\...\ygopro_vs_links_beta\expansions)    
Finally, move the "script" folder into the expansions folder. (C:\...\ygopro_vs_links_beta\expansions)

These cards are based on the "Fire Emblem" game series, published by Nintendo.
While they look pretty simple, the monster cards in this card set have a lot of
complicated effects that I didn't write on the cards because the YGOPro client
simply can't render images with high enough resolution to make small enough letters.
So, let's go over what these cards actually do:
"Compatible weapon types" determine the weapons you can equip to each monster.
If you're wondering how you're supposed to equip weapons when there aren't any weapon
cards, it's because the weapons are actually tokens - you create them with a card's
effect rather than putting them in your deck.  All level 4 monsters automatically
equip themselves with an appropriate basic weapon when you summon them.  Any time
a monster is upgraded to a new class, the upgraded monster inherits any weapons 
equipped to the old monster, with the same durability.  That's right, weapons have
durability.  Weaker weapons have more durability, but aren't as powerful.  All
weapons start with full durability when you first equip them, and lose 1 durability
every time the equipped monster battles or is targeted by an effect.  When a weapon
reaches 0 durability, it is automatically destroyed, and the monster becomes useless
until you get a new one, since Fire Emblem monsters can only attack while they have a
weapon equipped.  A monster can only wield 1 weapon at a time - equipping a new weapon 
destroys the old one.  The only exception to this rule is staves; a monster can 
wield 1 staff alongside an offensive weapon.  Now, on to the monster stats.  
HP keeps a monster alive - it can't be removed from the field in any way 
other than being tributed by its owner as long as it has HP remaining.  
Losing a battle makes the monster lose 1 HP for every 100 points of damage 
its owner took.  Being targeted by an opponent's card effect makes it 
lose 10 HP.  Str or Mag increases the ATK of the monster - Str if it's a physical 
attacker and Mag if it's a mage. (if it can use both types, the most recently equipped 
weapon determines which stat matters.) The monster gains 100 ATK for each point.  Def 
does exactly the same thing, but for defense.  The rest of the monster stats affect the
results of RNG-based effects.  YGOPro doesn't have any functions to produce a random 
number directly, so I used this system: when an RNG-based effect is being called, the
card's owner rolls 4 dice, and the result is stored in two numbers: one for
common effects(the product of the first two rolls plus the sum of the last two rolls)
and one for rare effects(half of the square of the sum of the first two rolls plus
the sum of the last two rolls).  The roll is considered successful for a common
effect if the sum of the common result and the monster's relevant stat is at least
50, and the roll is considered successful for a rare effect if the sum of the
rare result and the monster's relevant stat is at least 85.  When attacking, Skill
is used for a common effect that causes the monster to inflict piercing battle
damage if successful.  Additionally, Skill is the stat used for most unique effects;
innate skills are common effects and tier 3 class skills are rare effects, with a
few exceptions.  Speed is used for a common effect that allows the monster to
make a follow-up attack once per turn.  Speed is also used for a common effect
that allows the monster to negate an attack when targeted for an attack, and
one more common effect that allows the monster to dodge an effect that targets it,
avoiding the usual HP loss.  Luck is used for a rare effect that causes the monster
to inflict triple battle damage when attacking an opponent's monster.  Alright, those
are the basics, so let's move on to stat advancement.  Each time a Fire Emblem
monster battles, is targeted by an opponent's card effect, or activates its staff,
it gains a level.  If it destroys an opponent's monster by battle, it gains 1
more level, in addition to the one it gained for battling.  When the monster levels
up, its owner rolls 2 dice for each stat.  If the sum of the rolls and the monster's
growth rate in that stat is at least 12, it gains a point in that stat.  If a level
20 monster would level up, it evolves to the next class instead.  When a monster
is summoned by class evolution, it inherits all the stats the pre-evolved monster had,
as well as its weapon, and then gains additional points in each stat equal to its
promotional gains for that stat.  If an advanced class is synchro summoned instead
of being summoned by evolution, its base stats replace the stats it would have
inherited, and it gets the starting weapon for its base class.  However, only tier 2
classes can be synchro summoned; tier 3 classes can only be summoned by evolution,
which is why they have no base stats.