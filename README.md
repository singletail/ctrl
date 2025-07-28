# ctrl

A quality-of-life addon suite for World of Warcraft 11.x.x+, written by Singletail@Proudmoore-US.

## Why?

You can do all of these things with other addons. But mine is faster. Much faster. Seriously, Lua is already fast, but I've written this for pure speed.

If you write addons, I encourage you to take a look at the code, especially the event dispatchers and timers. I'm quite proud of those.

## User Features

- Nameplates: User-definable color coding, icon, and notes for any npc.
- Extra-large minimap with sharp texture scaling.
- Taunt tracker with sound alerts.
- Info display with ping, taint status, etc.
- Target display with iLvl & npcId.
- Speedometer (with bonus speed % display).
- Re-summons your companion pet whenever possible.
- Raid pull notification via USER_FLAGS.
- Enemy mob scanner with distance.
- Automatic UI scaling for true pixel-perfect widgets.
- Custom font with hundreds of glyphs for use in frames or nameplates.
- Monitors CVar settings and fixes them if they change unexpectedly.

### In-progress/not yet working

- Loot roll tracker.
- Raid death sfx by role.
- Model viewer with options.
- Better distance tracking.

## Developer Features

- Blazing-fast event dispatcher.
- Ultra-performant CLEU monitor.
- Super-fast timer callbacks.
- Ridiculously fast table operations (see util.lua).
- Metatable-based modules with standardized timer/event callbacks.
- Easy frame/texture/fontString creation with standardized functions.
- FontOjbect caching.
- Fast display tables, minimizing string calls.
- Metatable generation with default value returns.
- Templates for buttons with some built-in designs.
- Efficient raid gear inspection (no GUI yet).
- Safe & efficient SavedVariables reading & writing.
- Write console log to SavedVariables in JSON, with log levels.

### Module Generation

- Files pre-load into a cache at client launch.
- Cache converts into metatables at login, adding standardized:
    - Events
    - Timers
    - CLEU
    - Frame management
    - Texture/Button/FontObject creation and storage
    - Logging to console and/or SavedVariables file
- When finished loading:
    - Cache is deleted
    - Prefs are loaded and verified from SavedVariables
    - module setup() functions are called for frame generation, etc.
    - Events & timers start.

### Event Handling

- Two local event frames (CLEU and everything else)
- One event registry and dispatcher for each. 
- Index-based dispatch for even more performance.
- Varargs delivered to module packed with n-index

### Timer

- One local event frame.
- One local event loop.
- Multiple registered timers for each module.
- Dispatch calls tick(interval) in registered modules.

#### Notably missing?

- In-game config.
- Chat system integration.
- Table builder.
- Error handler.
- Stack debugging.

## Resources

If you are just learning how to write addons, these are the only resources you need:

- https://warcraft.wiki.gg/wiki/World_of_Warcraft_API
- https://www.lua.org/manual/5.1/
- Blizzard's interface files (see below)

The vast majority of web sites are hopelessly outdated. Stick to these and you'll be fine.

### Blizzard interface files

Extract them. Study them. Learn them:

### Enable Console

Run your game client with the '-console' enabled.

MacOS:
```zsh
open -a /Applications/World\ of\ Warcraft/_retail_/World\ of\ Warcraft.app --args -console
```

Windows:
- Make a shortcut to the actual wow.exe file.
- Open the shortcut and add '-console' to the run command

### Extract Game Files

- Before logging in, hit the console key (default: '~'), then:

```zsh
exportInterfaceFiles code
exportInterfaceFiles art
```

Each of these commands will write a new directory inside your client directory for that version (e.g. /_retail_/BlizzardInterfaceCode). 

Just open the whole folder in your editor.

## Fonts

This addon uses fonts with custom glyphs added. You may want to install one or more at the system level if you want to modify the addon.

## Other Recommended Tools

- WowLua
- BugSack
- BugGrabber

## License

BSD-4-Clause. Deal with it.

## Contact

t@wse.nyc
