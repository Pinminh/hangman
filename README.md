# Hangman
This project is regarded as an assignment from [The Odin Project's Ruby curriculum](https://www.theodinproject.com/lessons/ruby-hangman).

## What is Hangman
Hangman is a popular game, it is all about guessing words. For details, you can find it [here](https://en.wikipedia.org/wiki/Hangman_(game)).

## Purposes
This project is intended for practicing serialization and working with I/O. For this purpose, I used Marshal serialization to attain high-speed dump and load.
Though, on the way, I picked up many other functionalities and implemented them into this project, which makes it look more like a real game with menus, options, settings...

## Credit to Dictionaries
To build Hangman game, a list of words is needed. I used 3 different dictionaries (which can be chosen in-game):
- [google-10000-english-no-swears.txt](https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt) recommended by [The Odin Project](https://www.theodinproject.com/lessons/ruby-hangman).
- [animals.txt](https://gist.githubusercontent.com/atduskgreg/3cf8ef48cb0d29cf151bedad81553a54/raw/82f142562cf50b0f6fb8010f890b2f934093553e/animals.txt) from [atduskgreg](https://gist.github.com/atduskgreg/3cf8ef48cb0d29cf151bedad81553a54).
- [wikipedia-acronyms.txt](https://raw.githubusercontent.com/davidsbatista/lexicons/master/wikipedia-acronyms.txt) from [davidsbatista](https://github.com/davidsbatista/lexicons/blob/master/wikipedia-acronyms.txt).

## Found problems
### Stacking methods on call stack
There is a detrimental pitfall that I didn't realize before.
Every time a menu sends signals, the corresponding methods will be called. But they are called in such a way that they're stacked on top of each other.
Theoretically, if the game is played long enough, we'll get a stack overflow.