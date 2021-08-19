* remove *preferred* keyword from graphs. user won't know what strategy is used
  so need to create explicit branches in each case. however, only the
  event-cards graph seem to be affected.

* corruption strategy should try to use a ring as a last resort but this isn't
  added yet. only add actions that weren't allowed to use a ring already.

* remove phase 2 and phase 4 graphs, just write the code for it directly
  instead. This should simplify the graph crawler

* things to have in the main menu of phase 5
	- decide action die and action (this should check ring and modt availability
	  before jumping to the graph)
	- resolve card
	- resolve battle
	- recruit minion as final action with an action die that have been set aside earlier
	- set the available die. use if the bot available die does not match the real world
