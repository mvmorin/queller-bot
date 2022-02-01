# Queller CLI: War of the Ring AI
This is a command line interface (CLI) for the [Queller Bot](https://boardgamegeek.com/filepage/141333/queller-bot-war-ring-solo-play) for War of the Ring. It started with me simply trying to learn and understand the bot but, since my play frequency is low at best, it evolved into an attempt to lower the barrier for entry.

## Goals
- No prior knowledge of Queller should be needed to run the program. Knowing the game and reading a short CLI specific manual should be enough. Queries to answer and actions to perform should be explicit and self-contained.
- Friendly command line interface. Features like help, undo, and reset the available dice are not needed in a perfect word but, alas, mistakes happen.
- Easy install, simply copy files over to your machine and run it.

How well I managed to execute these goals remains to be seen... The first round is most likely not still gonna take some time and it is probably beneficial if one can tolerate and work with some ambiguity. I am not gonna be able to, nor do I really want to, perform the amount of play testing necessary to make the experience completely friction free and I'm simply releasing this to the curious in an 'as-is' state, "Here Be Dragons".

# CLI vs. Paper
This CLI version is based on version 3.0.1 of Queller and I believe it to be a faithful adaptation. However, the decision tree has been 'massaged' slightly and many queries, statements, rules, and parts of the glossary have been rewritten. I can therefore not guarantee equivalence with the paper version, or even consistency within the CLI itself.

The reasons for these rewrites was mainly for the first goal above: to make each query self contained and so that the user shouldn't need to reference forward or backward in the decision tree. But, these changes can of course have introduction new errors/ambiguities and the chance of my limited play testing catching all these errors is low. Also, I can honestly say there are some parts of the paper version where I don't completely understand the intent of the bot. Hence, even if these are taken verbatim from the paper version, that their result is 'correct' is hard for me to evaluate.

The manual accompanying this CLI is meant to be self contained, but, it might be a good idea to read the *Examples of Play* PDF for the paper version [Queller Bot](https://boardgamegeek.com/filepage/141333/queller-bot-war-ring-solo-play) if you don't understand something. Since the manual and glossary for this program is rewritten specifically for the program it might not match perfectly but the *Examples of Play* PDF should convey what they rules are trying to achieve. Of course, if you are really desperate/curious you can download to entire manual to the paper version as well.

---

# Install
Go to [Releases](https://github.com/mvmorin/queller-bot/releases) and download the latest version for the operating system you are on. Unpack the zip/tar file and open the resulting folder. There you will find a PDF with the manual and the program itself. Double click the `QuellerCLI` program/shortcut in your file manager or run it in a terminal to launch the program.

## Compatibility
I compile versions for x64 systems running Windows, Linux or macOS. However, I don't have access to any macOS machine and that version is hence completely untested. Even the Windows and Linux version I can't guarantee will work on all machines. If you face problems and still want to press on, you can always try running it from source.

## Run from source
To run the program from source you first need to install the [Julia Language](https://julialang.org/downloads/). I have used Julia 1.6 to test it but it will probably work with later versions as well.

After Julia is installed, clone or download this git repo. In the base directly of this repo there is a file called `run.jl`, run this file with Julia to launch the program, i.e., execute `julia run.jl` if you are in a terminal and Julia is on your path or execute `include("run.jl")` in a Julia session. Make sure the current working directory is the base directory of the repo.

# Issues
You can always create an issue but I'm currently not planing on developing this much further than the current rough state. However, if I get back to this project they might still be useful.

---

# Alternatives
For a number of years there have existed a Java implementation [Queller Bot - Java](https://www.boardgamegeek.com/thread/2070989/play-solo-queller-bot-java-program). If you have a Java runtime installed, or can install one, it is a perfectly valid option. Note, this implementation is independent of [Queller Bot - Java](https://www.boardgamegeek.com/thread/2070989/play-solo-queller-bot-java-program) and, although it implement the same AI, the command line interface and usage are not the same.
