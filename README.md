# GC Baggo

GC Baggo is a simple Cornhole scoring application. Cornhole is a game where teams of two players play each other by throwing a bag full of corn to a board that has a hole on it. Each round consists of four throws for each team. If a bag lands in the ground, the team gets no points. If it lands in the board, the team gets 1 point. And if the bag goes in the hole, the team gets 3 points. At the end of each round, the team with the most points wins and adds the point difference to their total score.

There's two alternatives to decide the winning team:

 - At the end of a round, if a team has a total score of more than 21 points and has a lead of 2 or more points over the other team, they are declared the winners.
 - At the end of a round, if a team has a total score of 21 points exactly, they're the winners. If the team goes over their total score is reverted back to 11.

You can check the full rules of Cornhole in http://www.cornholehowto.com/how-to-play/.


#SAVEGAME TASK


Right now the app doesn't have any persistence mechanism, which means the app is closed or crashes all information would be lost. There's two pieces of information we want to save and restore: the state of the current game if there's one in progress so that it can be resumed, and user preferences.

You can use whatever mechanism you think fits each of these needs better.

 Save state of in progress games so that it can be restored after the user closes the app or if a crash occurs.

 When a user changes the rules to pick who wins  this selection should be applied to future games as well.

