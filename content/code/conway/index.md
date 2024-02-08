+++
title = "Conways Game of Life"
date = "2020-05-30T21:16:00+10:00"
+++

I wrote this shortly after the passing of [John Conway](https://en.wikipedia.org/wiki/John_Horton_Conway), who's responsible for 
devising a cellular automaton with a few simple rules that leads to some pretty extraordinary patterns.

Rules:
- Any live cell with two or three live neighbours survives.
- Any dead cell with three live neighbours becomes a live cell.
- All other live cells die in the next generation. Similarly, all other dead cells stay dead.

Over the 50 or so years it's been studied to death, and is infact Turing complete (you can even play Tetris with it!)

You can read the code at https://github.com/michaelmcallister/conway

{{< iframe "https://code.sknk.ws/conway">}}
