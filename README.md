# Work in progress

# Queller CLI: War of the Ring AI
This is a command line implementation of the [Queller Bot](https://boardgamegeek.com/filepage/141333/queller-bot-war-ring-solo-play) for War of the Ring. It started with me simply learning the bot but, since my play frequency is low at best, it evolved into an attempt to lower the barrier for entry.

## Goals
- No prior knowledge of Queller should be needed. Knowing the game and reading a short one page manual should be enough to get started. Queries to answer and actions to perform should be explicit and self-contained.
- Friendly command line interface (CLI). Features like help, undo, and reset the available dice are not needed in a perfect word but, alas, mistakes happen.
- Easy install, simply copy files over to your machine and run it.

How well I managed to execute these goals remains to be seen. I'm personally in to deep at this point to be able to judge how newcomer friendly it is but currently I'm satisfied. However, it might be a good idea to, in addition to the manual provided with the program, download the *Examples of Play* PDF for the paper version [Queller Bot](https://boardgamegeek.com/filepage/141333/queller-bot-war-ring-solo-play) and read it if you don't understand something. Since the manual for this program is rewritten specifically for the program it might not match perfectly but the *Examples of Play* PDF should convey what they rules are trying to achive.

# Install
Go to [Releases](https://github.com/mvmorin/queller-bot/releases) and download the latest version for the operating system you are on. Unpack the zip/tar file and open the resulting folder. There you will find a PDF with the manual and the program itself. Double click the `QuellerCLI` program/shortcut in your file manager or run it in a terminal to launch the program.

## Compatibility
I compile versions for x64 systems runnig Windows, Linux or macOS. However, I don't have access to any macOS machine and that version is hence completely untested and might not work. Furthermore, I can't guarantee that it will run on your machine even if you run Windows or a flavor of Linux and sadly I'm not in a possition where I can provide tech support. You can submit an issue here on github and I will try to look at it or you can try to run it from source.

## Run from source
To run the program from source you first need to install the [Julia Language](https://julialang.org/downloads/). I have used Julia 1.6 to test it but it will probably work with later versions as well.

After Julia is installed, clone or download this git repo. In the base directly of this repo there is a file called `run.jl`, run this file with julia to launch the program, i.e., execute `julia run.jl` if you are in a terminal and Julia is on your path or execute `include("run.jl")` in a julia session. Make sure the current working directory is the base directory of the repo.

# CLI vs. Paper
This CLI version is based on version 3.0.1 of Queller. However, simply to facilitate implementation and to avoid repeating the same queries again and again, the decision tree has been 'massaged' slightly. Many queries, statements, rules and parts of the glossary have also been rewritten to clarify the confusion I faced. Still, as far as I can tell is this software implementation equivalent to the paper version.

The exception to this is perhaps the "desperation" moves very late in the decision tree when all prioritized actions have been found impossible and the bot simply wishes to find anything possible. Simply for the ease of implementation I think I made the CLI version a bit more desperate. However, I doubt that will make much of a difference.

# Alternatives
For a number of years there have existed a Java implementation [Queller Bot - Java](https://www.boardgamegeek.com/thread/2070989/play-solo-queller-bot-java-program). If you have a Java runtime installed, or can install one, it is a perfectly valid option. Note, this implementation is independent of [Queller Bot - Java](https://www.boardgamegeek.com/thread/2070989/play-solo-queller-bot-java-program) and, although it implement the same AI, the command line interface and usage are not the same.
