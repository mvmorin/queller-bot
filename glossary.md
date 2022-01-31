# Glossary

---

Focus
: A region defined in each muster statement made by the program.

Primary
: The muster region/settlement closest to the `*focus*` of muster.

Secondary
: The muster region/settlement closest to the `*primary*` of muster.

---

Playable
: A card for which the card-precondition is met and:

	- no paragraph is ineligible or would have no effect; and
	- does not achieve the same this the used die would on its own; and
	- does not require a non-`*aggressive*` army to attack.

---

Aggressive
: An army is `*aggressive*` if:

	- its nation is active and its `*value*` is equal or greater than the specified
	  opposing army's `*value*`; or
	- it has hit the stacking limit and contains the Witch King or 5 leadership.

Exposed
: A region is `*exposed*` to a Shadow army if it is the `*target*` and it does not contain a Free Peoples' army and the shortest path to the region is clear of Free Peoples' armies.


Mobile
: An army which can move towards its `*target*` without creating `*threat*` and:

	- is `*aggressive*` against its `*target*`, or an army within the same national border,
	  and all armies on the shortest route to it; or
	- would turn a non-`*aggressive*` siege `*aggressive*` when it reach its `*target*`; or
	- has hit the stacking limit.


Target
: Each army has a `*target*`. The `*target*` is the region closest to an army
containing one of the following. When tied for distance, the priority is from
top to bottom and last by `*value*` of Free Peoples' army in region.

	1. Conquered Shadow stronghold.
	2. Free Peoples' army that creates a `*threat*` if it's not a `*target*`.
	3. Free Peoples' stronghold not currently under siege by a `*mobile*` Shadow
	   army in a:
		1. Nation at war
		2. Active nation
		3. Passive nation
	4. Unconquered Free Peoples' city in a:
		1. Nation at war
		2. Active nation


Threat
: A region which:

	- is within 2 regions of an unconquered Shadow stronghold; and
	- contains a Free Peoples' army of an active nation; and
	- is not a `*target*` of a Shadow army; and
	- does not contain a besieged Free Peoples' army; and
	- the Free Peoples' army has higher `*value*` than the Shadow army att he
	  unconquered stronghold.
	- Orthanc is considered under `*threat*` if:
		- it contains less than 4 hit points of Shadow units; and
		- Gandalf the White is in play; and
		- a companion is in Fangorn.
		- In this case, no specific region is a `*threat*` but the Orthanc
		  stronghold is still under `*threat*`


Value
: Point rating of army calculated as:

	- 1 point for each hit point. When defending in a region with a stronghold, only
	  count the 5 strongest units.
	- 1 point for each combat die, including Captain of the West, (max 5
	  points).
	- 1 point for each leadership reroll (max \<number of combat dice\> points). If an army is `*mobile*`, exclude reroll from Saruman.
	- 1 point for each Captain of the West.
	- 1 point for defending in a fortification or city region.
	- x1.5 (rounded down) if defending in a stronghold, or, the army is `*mobile*` and a `*threat*`.
	- x0.5 (rounded down) if a sortie is considered or performed
