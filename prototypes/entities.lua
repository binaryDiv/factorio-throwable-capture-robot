-- Reduce the capture robot search radius (default: 1) so that it doesn't capture spawners it barely touches, and, more
-- importantly, so that there is no ambiguity which spawner is captured if two spawners are right next to each other.
-- The collision box of a biter spawner has a border of 0.3 tiles compared to the full tile size.
data.raw["capture-robot"]["capture-robot"].search_radius = 0.28
