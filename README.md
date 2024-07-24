# hangman
There is a detrimental pitfall that I didn't realize before.
Every time any menu sends a signal to navigate, the corresponding methods will be called. But they are called in such a way that they're stacked onto each other.
Theoretically, if play the game long enough, we'll get stack overflow.