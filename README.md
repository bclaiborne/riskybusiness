##Requirements##
</hr>
Requires the Gosu 2D game development library. http://www.libgosu.org/

##Running the Game##
</hr>
From the command prompt, run:
`
ruby start_game.rb
`

##Known Issues##
</hr>

1. Currently you are able to attack diagonally. The game does not check borders before initiating an attack. If the game expands beyond a 2x2 map, territory borders will need to be implemented.
2. For simplicity, attacking and defending use max available units.
3. Defender cannot retreat.
4. Transferring units to a conquered territory is currently one way only. If too many units are moved, you cannot 'undo' it. 
5. Right click control instructions do not update when transferring units after a battle or after game completion. Instructions should say, "Rt-Click: Stop Transferring." and "Rt-Click: Reset Game." respectively.

</hr>
Map created using vector map created by Erin Dill. http://www.vecteezy.com/map-vector/5937-united-states-map-vector