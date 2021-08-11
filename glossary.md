# Muster Glossary
- Focus: A region selected by a priority list defined by the muster action.

- Primary: The muster region/settlement closest to the *Focus* of muster. If
  tied for distance, it is selected at random.

- Secondary: The muster region/settlement closest to the *Primary* of muster. If
  tied for distance, it is selected at random.

# Card and Dice Glossary
- Playable: A card for which the card-precondition is met and:
	- no paragraph is ineligible or would have no effect; and
	- does not achieve the same this the used die would on its own; and
	- does not require a non-aggressive army to attack.

- Preferred:
	- Corruption strategy: Character Dice for dice, Character Cards when drawing cards and cards with a character symbol when playing cards.
	- Military strategy: Army, Muster and Army/Muster Dice and Strategy Cards when drawing cards and cards with an army or muster symbol when playing cards.

# Army Glossary
- Aggressive: An army is aggressive if
	- its nation is active and its value is equal or greater than the specified opposing army's value; or
	- it has hit the stacking limit and contains the Witch King or 5 leadership.

- Exposed: A region is exposed by a Shadow army if
	- it could be the target if distance is ignored; and
	- the shortest path to the region is clear of Free Peoples' armies.

- Garrison: An army inside a stronghold or in a stronghold region. A sieging army are adjacent the besieged garrison as well as the surrounding regions. A besieged army is adjacent to the sieging army.

- Mobile: An army which can move towards its target without creating threat and:
	- is aggressive against its target, or one within the same national border, and all armies on the shortest route to it; or
	- would turn a non-aggressive siege aggressive when it reach its target; or
	- has hit the stacking limit.

- Target: The region closest to an army containing one of the following. When tied for distance, the priority is from top to bottom.
	1. Conquered Shadow stronghold.
	2. Free Peoples' army creating threat.
	3. Free Peoples' stronghold not currently under siege by a mobile Shadow army in a:
		3.1. Nation at war
		3.2. Active nation
		3.3. Passive nation
	4. Unconquered Free Peoples' city in a:
		4.1. Nation at war
		4.2. Active nation
	5. Lowest value garrison.

- Threat:
	- A region which
		- is within 2 regions of an unconqured Shadow stronghold; and
		- contains a Free Peoples' army of an active nation; and
		- is not a target of a Shadow army; and
		- is not a Free Peoples' garrison; and
		- the Free Peoples' army has higher value than the Shadow garrison.
	- Orthanc is considered under threat if
		- it contains less than 4 hit points of Shadow units; and
		- Gandalf the White is in play; and
		- a companion is in Fangorn.
	  In this case, no specific region is a threat but the Orthanc stronghold is still under threat

- Value: Point rating of army calculated as:
	- +1 for each hit point
		- When defending in a region with a stronghold, only count the 5
		  strongest units.
	- +1 for each combat die including Captain of the West (maximum of +5)
	- +1 for each point of leadership (maximum of +X where X is the lower of 5 or the number of army units)
	- +1 for each Captain of the West
	- +1 for defending in a fortification or city region
	- x1.5 (rounded down) if
		- defending in a stronghold; or
		- army is mobile and a threat.
	- x0.5 if considered or performing a sortie (rounded down)
	- If an army is mobile, exclude Saruman from the value calculation.
