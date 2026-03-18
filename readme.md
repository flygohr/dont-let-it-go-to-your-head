Attempting [Godot Wild Jam #91](https://godotwildjam.com). It's my first jam, I might not be able to finish in time. I'm starting 3 days late because I was about to chicken out. 

Time will tell if the scope of my idea was actually manageable.

Stuff I'm already banging my head against (and I won't be able to include, probably):
- Responsive UI / game screen. I'll stick to a fixed viewport for now, I will learn how to make a responsive interface when I won't be in a rush
- Animations, tweens, smooth transitions, spinners.. basically, all the juice? I'll see what I can implement, but if I realize I can't, I'll push the polish back to later
- Error messages like "not enough gold" or smth, should go on the bottom bar and flash red or smth
- Clunky select, 100% bad implementation
- Theming is all messed up
- Different death screens for each cause of death

### Devlog:
- 2026-03-16
    - Brainstorming, locking-in idea of a kind of card based game where you are a thief from middle ages Europe
    - Project setup, git refresher, thinking about data structure
    - Day by day plan
    - Mockup sketches
- 2026-03-17
    - Started working on the prototype
    - Added basic save and load, should work in browser
    - Added weeks and days advance, daytime logic
	- Added play / resume, death screen, high score tracking
	- Added card scene, with hover effect, rarity colors
- 2026-03-18
	- Added ability to select cards, highlight selected card, block confirm until selected
	- Polishing the layout
	- Tried exporting for itch just to be prepared
- 2026-03-19
	- Need to have cards store their effects, text, etc, and have functions to apply them upon confirmation
	- Need to programmatically generate cards
	- Need to actually "fill" the slots with what I draw, no need to instance and position, it can be all done with injecting code into the UI
	- And need to check for current effects and calculate
	- The "add more cards" mechanic is missing entirely, might need to scrap that..

Font: https://not-jam.itch.io/undead-pixel-light-8
Some colors from: https://lospec.com/palette-list/ty-celestial-sapien-26
