## What is it?

Balances an arbitrary number of input inventories with an arbitrary number of output inventories. Items will only be inserted into the output inventories if there are fewer of that item type in the output inventories than there are in the input inventories, combined.
The inputs and outputs are treated as one inventory representing the total sum of items in all inputs/outputs, respectively. For example:

- Input Chest #1: 2 stacks of cobblestone
- Input Chest #2: 1 stack of cobblestone
- Output Chest #1: 1 stack of cobblestone
- Output Chest #2: 0 stack of cobblestone

In this scenario, the script will move 2 stacks of cobblestone to the output inventories, however they will fit. No more will be transferred until the number of cobblestone in the input exceeds the number of cobblestone in the outputs again.

The intent is that the outputs will never have more of any given item in it than the inputs do. The true usefulness lies in stocking multiple different types of items without overflowing the output inventories with a bunch of a single type. For example, if you want to stock a few stacks of each log type in your outputs, but you produce 10x more dark oak than you do birch, this will prevent your outputs from being overwhelmed with dark oak logs.

## Why?
The script was created to have a train (from the Create mod) transfer a specific amount of multiple materials and resources to an oil drilling location (Modern Industrialization). I wanted a single train to carry some aluminum drills, some stainless steel drills, and some fuel items for maintaining a Steam Boiler at the location. Left unchecked, one of those item types would eventually fill up the train car, bringing operations to a halt. The problem is solvable entirely in Create by using a separate train car per item type, but I didn't want an entire train car dedicated to carrying a single item type. You can also achieve a similar result by using redstone and carefully timed item transfers, but I didn't want to go that route either.

## Usage

You must choose whether you will connect inventories that are directly touching the computer, or inventories connected via modem. Item transfer is only possible when all of your inventories either touch the computer OR when they are connected via modem. This is a quirk of default ComputerCraft, since the sides of a computer for their own network that doesn't interact with wired or wireless modems.

Once you have established your input and output chests, you can run the program by starting `inventory-loader.lua`. On startup, the script searches for all compatible inventories (including Fabric-specific `ItemStorage` inventories that are operated differently than the generic inventory). You can, for each individual inventory, choose one of the following options:
- Use as \[i\]nput: Use this specific inventory as input
- Use as \[o\]utput: Use this specific inventory as output
- Use all of this type as input \[ii\]: Starting with this inventory, this and every other inventory of the same type will be used as input
- Use all of this type as output \[oo\]: Starting with this inventory, this and every other inventory of the same type will be used as output

With these options, you are able to fine tune which inventories to use as input and which to use as output, even if you're using multiples of the same inventory type on the input side and output side. Alternatively, you could make things easier for yourself and use one type of inventory for input and another type for output, such that you'll only have to make two choices on the selection phase: One to use all of the first type as input or output, and again to use all of the other inventory type as the opposite.

After you select all your inputs and outputs, the program will start transferring items to the outputs based on your input inventory. It is expected that you will finely control the amount of items in your input inventories to make this effective. You can do a combination of techniques, such as:
- Use storage from another mod. In my use case, I use the Configurable Chest from Modern Industrialization to control exactly how much of each item I want to maintain
- Use something with a limited inventory size, like a hopper, as an input. Even if you don't finely control the amount of items in the hopper, you'll still only have 5 stacks of a given item per hopper which may be enough limit for your needs.
- Use comparators on your input inventories to stop transferring items into the input inventory once you reach a certain capacity

## Defaults

Every time you start the program (such as when you reload the world, or leave the chunk and come back) you will need to select your inputs and outputs again. To combat this, you can specify in `default.txt` inventory types that you want to use as inputs and as outputs. Currently, only the options `ii` and `oo` are supported. Enter one inventory type per line followed by `=ii` or `=oo`, such as:
```
minecraft:barrel=ii
minecraft:chest=oo
```
