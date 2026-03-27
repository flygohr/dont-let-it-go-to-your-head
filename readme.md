Attempting [Godot Wild Jam #91](https://godotwildjam.com). It's my first jam, I might not be able to finish in time. I'm starting 3 days late because I was about to chicken out. 

Time will tell if the scope of my idea was actually manageable.

As I progress with the jam I remember more stuff about programming and Godot. The project is plagued by inconsistencies, bad practices, and is probably an unsalvageable mess. I'll make a better job next time.

Now on Itch.io: https://flygohr.itch.io/dont-let-it-go-to-your-head


Stuff I'm already banging my head against (and I won't be able to include, probably):
- Responsive UI / game screen. I'll stick to a fixed viewport for now, I will learn how to make a responsive interface when I won't be in a rush
- Animations, tweens, smooth transitions, spinners.. basically, all the juice? I'll see what I can implement, but if I realize I can't, I'll push the polish back to after the jam
- Clunky select, 100% bad implementation
- Theming is all messed up, inconsistent transitions and tweens
- Special cards could be added, with unique effects
- Need more events or a side quest system
- Would have been nice:
	- Highlight on progressbars the impact of the current choice
	- Import / export savefiles

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
	- Programmatically generate cards
	- Display generated cards, generate new ones on new day, saved to file
	- Scrapped the whole "shop for cards" idea, can't make it in time otherwise
	- Slight layout update
	- Cleaned up labels and colors
	- Started applying effects upon confirmation
- 2026-03-20
	- Finally added, troubleshooted, and fixed the application of card effects
	- Reduced the base for hunger, health, and infamy to 5 for more granularity
	- Re-arranged layout to merge "lives" with infamy, and make space for the "give up" button. my solution for softlocks lmao
	- Added events, implemented their effect
	- Added screens for text bits, could use for a tutorial if time
	- Fixed lots of bugs, reduced scope
- 2026-03-21
	- Building mockup data for cards, learning to import and parse it (used [this](https://codepen.io/tommygeorge/full/LYREPZW) to generate random words as names, [this](https://www.convertcsv.com/csv-to-json.htm) to parse CSV as array)
	- Rebuilding card generation functions on new data
	- Designing a 1st version of all the cards
	- Adding a bunch of random events
	- Handle gold softlock
	- Remove day / night cycle
	- Playtesting
- 2026-03-22
	- Added more cards and did my best to balance them
	- Added quit confirmation dialog
	- Added sprites
	- Added audio toggle
	- Added card balancing parameters
	- Bugfixes
	- Preparing itch.io page
	- Publishing for jam, now I wait a week
- 2026-03-23
	- Uploaded a better cover, adjusted tags
- 2026-03-24
	- Adjusting plans for final, "good enough" version
- 2026-03-25
	- Started implementing quests system
	- Adjusted contrast for green and red card text
- 2026-03-25
	- Quests are generated and implemented correctly
- 2026-03-26
	- They actually weren't, and won't for another day
- 2026-03-27
	- Truly finished the quest generation
	- Save and load quests
	- Advance quests
	- Fixed game-breaking bug: infamy was applied on hunger due to me not typing the correct variable name :(
	
### Plans for post-jam "good enough" polish:
- [ ] swap daily events system with a mini quest that stays there and scales with time
- [ ] add more sounds
- [ ] balance cards, remove temporary balance system
- [x] fix colorblind red contrast	

### To-do:
- [x] store cards in savegame, check for saved cards on resume
- [x] finish displaying cards effects
- [x] add death conditions
- [x] added lives, but broken
- [x] move death conditions out of process
- [x] apply card effects on confirm (with select property)
	- [x] troubleshoot currently broken
	- [x] check for enough gold before confirming
	- [x] effect is being applied wrong (subtracting negative numbers makes them positive, DUH)
- [x] fix progress bar colors.. had to make unique stylebox
- [x] fix card text display, + and - are wrong in some places
- [x] finish implementing death conditions and death text
- [x] restart game 
- [x] "event screen" for fullscreen text / tutorials / events
- [x] implement different screens for infamy levels
- [x] lose lives upon infamy reaching 100, first a finger, then a ear, then it's game over. use icons if time
- [x] define events, their rules, and check for current event upon applying card effect
- [x] selection and confirmation bugs
	- [x] bug (game breaking): can bypass gold check by selecting a valid card then switching. missing the usual else statement lmao
	- [x] bug: restarting doesn't clear selection
	- [x] bug: cards that have a negative gold value don't trigger the "are you sure?" text even if valid, I suspect there's something messed up in the cards selection / deselection process
- [x] card rarity doesn't make sense as it is rn, need to
	- [x] build data in csv, parse it and build a decent json, keyed rarity > type > card, so I can easily pick what I want and parse cards as well
	- [x] add weights to random selection process
	- [x] manually set rarity. pick process: weighted category > rarity with a simple float rand > then one random from that rarity
- [x] strip away all the daytime nighttime thing, I'm not implementing the day night cycle and all the probabilities for now. too much stuff
- [x] softlock: if all the cards require a cost in coin. extremely rare, but need to add a check on card generation, to keep rerolling until at least one option, not number of positive effects. ideally, each card should be graded on relative net effect and actual rarity?
- [x] current event is not being saved and loaded, maybe events are not generating correctly
- [x] add outline to give up button, make it another color, darker
- [x] implement tutorial first time play (notes: use random events to offset tough choices when you can)
- [x] fix mobile touch support
- [x] add text icon in place of IMG
- [x] fix bug, card selected before seeing game screen
- [x] add more cards
- [x] bug: are you sure? text not resetting after new day
- [x] important: restart screen needs a confirm button
- [x] bug: can advance without selecting card on mobile
- [x] bug: tutorial resets upon restarting the game despite savegame
- [x] add sound toggle on title and game screens
- [x] add balancing parameters for card gen to quickly adjust build to feedback
- [x] design icons and logo
- [x] playtesting and balancing
- [x] investigate iOS' safari returning 404 on launch game -> might be an issue with secret url

### Credits:
- Gane font: https://not-jam.itch.io/undead-pixel-light-8
- Cover font: https://www.1001fonts.com/bitmgothic-font.html
- Some colors from: https://lospec.com/palette-list/ty-celestial-sapien-26
- Background sound loop: https://opengameart.org/content/8-bit-battle-loop
