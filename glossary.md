# Glossary

---

Focus
: A region defined by a Queller muster action.

Primary
: The muster region/settlement closest to the *Focus* of muster.

Secondary
: The muster region/settlement closest to the *Primary* of muster.

Playable
: A card for which the card-precondition is met and:

	- no paragraph is ineligible or would have no effect; and
	- does not achieve the same this the used die would on its own; and
	- does not require a non-*Aggressive* army to attack.

Aggressive
: An army is *Aggressive* if:

	- its nation is active and its *Value* is equal or greater than the specified
	  opposing army's *Value*; or
	- it has hit the stacking limit and contains the Witch King or 5 leadership.

Exposed
: A region is *Exposed* to a Shadow army if:

	- it could be the *Target* if distance is ignored; and
	- the shortest path to the region is clear of Free Peoples' armies.


Garrison
: An army inside a stronghold or in a stronghold region. A sieging army are
adjacent to the besieged *Garrison* as well as the surrounding regions. A besieged
army is adjacent to the sieging army.


Mobile
: An army which can move towards its *Target* without creating *Threat* and:

	- is *Aggressive* against its *Target*, or one within the same national border,
	  and all armies on the shortest route to it; or
	- would turn a non-*Aggressive* siege *Aggressive* when it reach its *Target*; or
	- has hit the stacking limit.


Target
: Each army has a *Target*. The *Target* is the region closest to an army containing
one of the following. When tied for distance, the priority is from top to
bottom.

	1. Conquered Shadow stronghold.
	2. Free Peoples' army creating *Threat*.
	3. Free Peoples' stronghold not currently under siege by a *Mobile* Shadow
	   army in a:
		1. Nation at war
		2. Active nation
		3. Passive nation
	4. Unconquered Free Peoples' city in a:
		1. Nation at war
		2. Active nation
	5. Lowest *Value* *Garrison*.


Threat
: A region which:

	- is within 2 regions of an unconqured Shadow stronghold; and
	- contains a Free Peoples' army of an active nation; and
	- is not a *Target* of a Shadow army; and
	- is not a Free Peoples' *Garrison*; and
	- the Free Peoples' army has higher *Value* than the Shadow *Garrison*.
	- Orthanc is considered under *Threat* if:
		- it contains less than 4 hit points of Shadow units; and
		- Gandalf the White is in play; and
		- a companion is in Fangorn.
		- In this case, no specific region is a *Threat* but the Orthanc
		  stronghold is still under *Threat*


Value
: Point rating of army calculated as:

	- +1 for each hit point. When defending in a region with a stronghold, only
	  count the 5 strongest units.
	- +1 for each combat die including Captain of the West (maximum of +5)
	- +1 for each point of leadership (maximum total of +X where X is the lower
	  of 5 or the number of army units). If an army is *Mobile*, exclude Saruman
	  from the *Value* calculation.
	- +1 for each Captain of the West
	- +1 for defending in a fortification or city region
	- x1.5 (rounded down) if
		- defending in a stronghold; or
		- army is *Mobile* and a *Threat*.
	- x0.5 if considered or performing a sortie (rounded down)
