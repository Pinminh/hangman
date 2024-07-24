# Hangman
This project is regarded as an assignment from [The Odin Project's Ruby curriculum](https://www.theodinproject.com/lessons/ruby-hangman).

## What is Hangman
Hangman is a popular game, it is all about guessing words. For details, you can find it [here](https://en.wikipedia.org/wiki/Hangman_(game)).

## Purposes
This project is intended for practicing serialization and working with I/O. For this purpose, I used Marshal serialization to attain high-speed dump and load.
Though, on the way, I picked up many other functionalities and implemented them into this project, which makes it look more like a real game with menus, options, settings...

## Found problems
### Stacking methods on call stack
There is a detrimental pitfall that I didn't realize before.
Every time a menu sends signals, the corresponding methods will be called. But they are called in such a way that they're stacked on top of each other.
Theoretically, if the game is played long enough, we'll get a stack overflow.