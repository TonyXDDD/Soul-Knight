## 2024-10-17 - 6hr: Implementing the Puzzles ( 3 types of door puzzles)
*Item 1 - Today i worked on finnaly implementing the puzzles for my Soul to solve
*Item 2 - The puzzles constist of 3 types of doors, 1# Button, Soul presses the button and door opens. 2# Lever, Soul pulls lever and has 10 seconds to pass through the open door until it closes again. #3 Key, Soul must find a key on the map, pick it up and bring it to the door inorder to open it.

## 2024-10-16 - 8hr: Trying to fix my game
*Item 1 - I started out by working on the Soul so it would proberly collide with only areas that i set it to collide with, problem is that somehow while working on this issue i managed to currupt my files for the game.
*Item 2 - Thank god for my repo's and commits because i was able to get old files of my game and build it up again to fix the currupted files

## 2024-10-09 - 5hr: Implementing a simple dash mechanic for the Knight
* Item 1 - created a dash for the Knight mechanic so traversing the map would be a little more fun
* Item 2 - I was able to learn on how to implement the mechanic via this youtube video: https://youtu.be/fp_XugQvOKU

## 2024-10-05 4hr: Creating limitations for the Soul
* Item 1 - I wanted to fix the distance that the Soul can move around the map
* ITem 2 - before the Soul could go anywhere it wanted to, even of the screen!
* Item 3 - Now i made it that from where it spawns in the Soul can move only within a invisible cirlce

## 2024-10-01 - 7hr: Creating a pause Menu
* Item 1 - created a simple pause menu for the player to return to the main menu when they want to or even quit the game with out having to alt-f4

## 2024-09-26 - 6hr: Creating a main Menu
* Item 1 - created a simple menu
* Item 2 - This includes a Start button, Tutorial buton and an exit button

## 2024-09-22 - 6hr: Learning Level Transitioning
* Item 1 - before I continued to work on my game mechanic i thought it might be important to learn how to make a level transition so that later on when i start making proper levels the player can move on to the next level
* Item 2 - Initially it was a huge struggle for me to make a level transitioner but in the end what i did was create a new scene that will play this animation of a fade in and fade out
* Item 3 - Now this new scene would only play when the player enters a Area2D that will run a script that simply loads my next Level once the screen is completly fadded out

## 2024-09-15 - 4hr: Created multiple animations for Knight movement and attacks, and Some soul animations
* Item 1 - I created left and right walk animations, jump animation and idle animation
* Item 2 - When I started to make the attack animation i ran into multiple problems, 1 being that at the time I didint know how to properly make my animation not loop so i manually made a animationplayer to make it.
* Item 3 - The issues still presisted and i had to deal with multiple animtations breaking when the attack animation was being played
* Item 4 - Was able to fix everything by setting all other animations to not be visible when the attack is being played and then set back to visible once the attack animation is done playing
* Item 5 - I created a cool swirl fade in and fade out for my Soul so it looks better when transitioning into soul mode

## 2024-09-09 - 5hr: Starting to implement my Soul mode
* Item 1 - Found simple Ghost assets on itch.io
* Item 2 - Started to implemet into my game but ran into multiple issues
* item 3 - Found a fix for the main issues, i was able to directly connect the Soulnode as a child node of the Knightnode

## 2024-09-08 - 2hr: Imported assets for simple tile map and made a level
* Item 1 - I searched around itch.io for a while and ended up buying a asset pack that perfectly fits my theme
* Item 2 - Ran into some issue's with player character not proporly moving along the map
* Item 3 - Was able to fix the problem by updating the physics layer to be more flat so the player can traverse normally

### 2024-09-07 - 6hr: Worked on the main player and movement.
* Item 1 - I started mapping out a basic level for my player
* Item 2 - Importet Knight assets off itch.io
* Item 3 - Fully implemented normal movement controls and character

