# Do
* remove *preferred* keyword from graphs. user won't know what strategy is used
  so need to create explicit branches in each case. however, only the
  event-cards graph seem to be affected.

* corruption strategy should try to use a ring as a last resort but this isn't
  added yet. only add actions that weren't allowed to use a ring already.

* pretty up output when traversing the graphs (add2msgbuf)

# Maybe
* some sort of debug output (node ids of the nodes at least)
