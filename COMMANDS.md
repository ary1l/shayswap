# ShaySwap commands

Every command works as `/name` or `/lac fwd name`. All boxes: `/mss /lac fwd <cmd>`.
One box: `/ms sendto <name> /lac fwd <cmd>`.

## Weapons

| Command | Does |
|---|---|
| `/wm` | Next weapon mode (`/weaponset` same) |
| `/wm savage` | Match by name: exact, prefix, substring |
| `/wm 3` | By position (1 = None) |
| `/wm none` | Stop managing weapons (`TH`-set weapons still apply while `/th` is on) |
| `/wm default` | This job's `DefaultWeapons` |
| `/wm melee` | Role name from `gcinclude.WeaponRoles` |
| `/wm leaden force` | Swap even at 1000+ TP |
| `/mainset` `/subset` `/rangeset` `/ammoset` `[name\|N\|none]` | Per-slot cycles, on jobs that define them |

- A weapon mode is what you return to at rest. Action sets that swap weapons still do.
- Per-slot cycles override the mode for their slot. COR/RNG modes are named for the gun, so
  `/mainset` changes the melee weapon.
- `/th` on: Main/Sub/Range in the `TH` set override the mode and per-slot cycles, tagged or not (Sub only if
  you can dual wield). `/th` off gives them back.
- **TP hold:** at 1000+ TP, engaged or not, Main/Sub/Range don't change (songs, rolls, cures, enfeebling,
  enhancing, geomancy excepted). `force` overrides; `settings.WeaponTPGuard = 0` disables.
- `Weapon_<Mode>_1h` is used when you can't dual wield: main or sub job NIN Lv10+, DNC Lv20+ or THF Lv83+
  (FFXIclopedia Dual Wield), at the effective level, so a restricted support job (Sheol Gaol, SJ Restriction:
  sub Lv0) doesn't count. Losing Dual Wield puts the `_1h` set on at once, past the TP hold (the offhand weapon
  is no use); getting it back waits for the TP hold. `gcinclude.AlwaysDualWield = true` forces the DW pair (BLU,
  THF). The same check decides whether the `TH` set's Sub is used.

Augmented items in a per-slot cycle:

```lua
gcinclude.MainModes = {'None', 'Naegling', 'Rostam B', 'Rostam C'};
gcinclude.WeaponItemMap = {
    ['Rostam B'] = { Name = 'Rostam', AugPath = 'B' },
    ['Rostam C'] = { Name = 'Rostam', AugPath = 'C' },
};
```

## Defense and locks

| Command | Does |
|---|---|
| `/def` | none → DT → MDT → Aminon → SIRD → none, one at a time (Ctrl+grave) |
| `/dt` `/mdt` `/aminon` | Toggle one. `/aminon` uses `mdt` if the job has no `Aminon` set, and locks Main/Sub (the set's items, else what you wear) plus Range/Ammo when the set names them, until off; other slots still swap for actions |
| `/sir` | `SIR` set over every midcast. `SIRSkip` exempts spells; engaged or not |
| `/hoxne` | Off → On → Locked (Alt+grave). On keeps the ampulla in Ammo and keeps bows/guns/crossbows out of Range (they need matching ammo); Locked also locks Ammo and Range. While On/Locked it is used by itself: when it goes on, 30 min after each use (BG-Wiki: Double Attack +100% for 30 min, 60s recast, lost when unequipped or zoning), and again after being swapped out; one try a minute. `HoxneAutoUse = false` stops that |
| `/hoxne use` | Locked, equip, wait its delay, use |
| `/lock` | Lock Main, Sub, Ammo |
| `/lock ear1 back` | Lock any slots by name |
| `/unlock` / `/unlock ammo` | Release all / one |
| `/dw [on\|off\|auto]` | Dual Wield: no arg shows yes/no and why (e.g. `sub NIN Lv0`). `off` = always `_1h` sets, `on` = always DW sets, `auto` = detect (default) |
| `/smartswap [on\|off]` | On: at `SmartSwapTP`+, `NoWeaponSpells` (Dia, Blink, spikes…) don't swap weapons; `KeepWeaponsFor` (Cure/Cura) keep Daybreak or Bunzi's Rod |
| `/naked` `/weaponsonly` `/abysseaproc` `[on\|off]` | Strip all 16 / the 12 armor slots / head, hands, legs, feet and keep them bare. One at a time |
| `/capacity` `/jubilee` `/dynamisrp` `[on\|off]` | Wear and hold: the best carried capacity cape (BG-Wiki: Aptitude Mantle +1 30%, Aptitude Mantle 25%, Mecisto. Mantle by its augment) / Jubilee Ring (`JubileeSlot`, Ring1) / your main job's best Dynamis - Divergence neck (+2, +1, base). Entering a `[D]` zone reminds you |

Defense toggles only wear gear, except `/aminon`, which also locks the weapon slots. `/lock` is absolute until `/unlock`, even against force-equips.
Unknown slot names are refused. Holds skip slots already locked or TP-held; off releases only what they took.

## Magic burst (RDM BLM SCH GEO)

| Command | Does |
|---|---|
| `/mbmode` | Off → Chain → Auto → Force (Win+grave) |
| `/automb` | Burst set only on a live matching skillchain (on by default) |
| `/autonuke` | Cast into live skillchains (off by default) |
| `/burst` | Burst set on every nuke |
| `/mbtier [low\|mid\|high]` | Autonuke tier I / III / V. No arg cycles; `1\|3\|5` work too |
| `/mbinfo` | Last skillchain seen |

| Mode | Sets | Nukes wear | Casts itself |
|---|---|---|---|
| `Off` | nothing | normal set | no |
| `Chain` (default) | `/automb` | Burst set if it lands in a live chain of its element | no |
| `Auto` | `/automb` + `/autonuke` | same as Chain | yes |
| `Force` | `/burst` | Burst set always | no |

Autonuke:
- Targets a chain on a mob you or your party are engaged on, or your target; your target's chain first.
  It casts on the chained mob by its id, so it works while you're engaged on another mob (skipped if
  that mob is past 21.8', the usual spell range per FFXIclopedia). Not engaged: it also targets the chained mob.
- Casts the chain element's nuke (Fire, Blizzard, Aero, Stone, Thunder, Water) at the tier.
  Light/Darkness chains use those elements. Transfixion/Compression (Light or Dark only): SCH casts
  Luminohelix/Noctohelix (II with 1200 JP); other jobs have no Light/Dark nuke, so they skip it.
- Tries the tier on each chain element, then one tier lower (`MBFallback`). Blizzard V on recast
  during Distortion → Water V.
- Only casts if it lands inside the window (`MBWindow` 10s; cast time is learned from your last casts),
  is castable, off recast, affordable, and you're not moving.
- Waits out the game's delay after your own actions: 3s after a spell finishes or is interrupted,
  2s after a WS or job ability (BG-Wiki). Its own wait ends when its cast finishes (5s if no finish is seen).
- SCH IV/V need Addendum: Black or Enlightenment. Tier V: BLM 86, SCH 91, RDM/GEO 100 JP gift.
- `MBCasts` (1) per chain, `MBRotate` rotates elements, `MBMinMP` holds fire.
- Default tier `settings.MBTier = 'Mid'`; per job `gcinclude.MBTier` before `Initialize()`.
- Anything else (helix, -ja, Death) is manual.

`BurstWanted()` decides the Burst set; `settings.MBSkills` (Elemental Magic) sets which skills
count. Cast time per skill is learned from your own start/finish packets (slowest of the last 5);
until one cast is seen it falls back to `gSettings.FastCast`.

If you turn `/autonuke` or `/automb` on or off by hand, the HUD may show a combo `/mbmode` doesn't have,
marked `*`: e.g. `Off*` = casting bursts itself, but not wearing the Burst set.

## Action checks

Spells, abilities and WS that would fail are cancelled before any gear moves, with the reason in chat
(`Validate = false` turns it off):

| Check | Result |
|---|---|
| KO, sleep, stun, petrification, terror, charm | Cancelled |
| Mute; Amnesia (abilities, WS) | Cancelled |
| Silence | Cancelled; uses Echo Drops, else Remedy (Remedy first if paralyzed). `AutoRemedy`, not under Muddle |
| Paralysis on an ability | Uses a Remedy instead, if carried |
| Recast | Back within `MiniQueueMax` (5s): queued and sent when ready and past the forced delay (BG-Wiki: 3s after a spell, 2s after a WS, 2s after a job ability with job abilities allowed after 1s) (`<me>`, a player, or `<t>` if still targeted). Longer: shows `m:ss`. `MiniQueue = false` to only cancel |
| MP short | Cost adjusted for Light/Dark Arts (own school -10% rounded down, other +20% rounded up). Skipped under Manafont, Manawell, Parsimony, Penury, Addenda, Tabula Rasa. Gear "MP cost -%" isn't counted: `ValidateMP = false` if it bites |
| Stratagems at 0 | Cancelled, next charge time shown |
| Waltz short on TP | Cancelled. Set `WaltzTPCut` to your gear's "Waltz TP cost" reduction |
| Required item missing | Cancelled when not carried, or its slot is `/lock`ed: Dispelga (Daybreak), Honor March (Marsyas), Aria of Passion (Loughnashade), Impact (Crepuscular or Twilight Cloak), Tomahawk (Thr. Tomahawk), Angon (Angon). When carried it is put on for you (Impact also empties Head: the cloak covers it) |

Charge-pool abilities (Ready, Sic, Quick Draw) skip the recast check. LAC only sees what the client sends,
so anything the client refuses itself never gets here.

## Automation

| Command | Does |
|---|---|
| `/autofood [on\|off]` | Eat when Food is missing (outside town, not moving) |
| `/autosoda [on\|off]` | Use `SodaItem` when Regain is missing; 20s between tries, off after `ConsumableMaxTries` (2) |
| `/revit [on\|off]` | Zone item list (below) |
| `/holywater [on\|off]` | Holy Water on Doom (on by default) |
| `/gce <item>` | Equip enchanted item, lock slot, wait its delay, use |
| `/gce cancel` | Stop every item use under way and give the slots back (zoning does too) |
| `/temps` | Drink the carried Escha temps, 3s apart: Monarch's, Braver's, Fighter's, Champion's, Soldier's, Barbarian's Drink |

```lua
AutoUseItems = T{
    { Zone = 'Ghoyu',    Item = 'Revitalizer' },   -- zone: case-insensitive substring
    { Zone = 'Al Zahbi', Item = "Giant's Drink" },
};
AutoFoodItems = T{'Grape Daifuku +1', 'Grape Daifuku'}; -- in order; per job gcinclude.AutoFood
```

Enchanted item delay comes from the item's `CastDelay`; override with `settings.EnchantDelays`,
fallback `EnchantWindow`. The wait starts once the item is really on (not at the command); then `/item`, retried
every 2s (up to 5 tries) until the use starts. The slot stays locked until the use finishes, then unlocks.
Gives up (and unlocks) if the item never goes on within 10s or 5 tries never start. One per slot, several at once.
The first try waits the delay + 3s (the server refuses for about 3s past it). Once the item is on, its extdata
(Windower extdata.lua layout) is read: no charges left, or a reuse timer longer than the delay, releases it at
once with the time left, instead of 5 failed tries (only after the extdata shows this equip; if it doesn't
refresh within 2s the tries decide). Already worn: it is tried right away.

**Supply warnings** (never cancel anything; BG-Wiki: Barrage fires only as many shots as you have ammo):
the ammo in use, counted over inventory and wardrobes, at or under `AmmoWarn` (20), and Utsusemi tools
(Shihei, plus Shikanofuda on a NIN main) at or under `NinjaToolWarn` (10). Said once, then every 10 fewer,
and at 0. Unlimited Shot: quiet.

**Asleep under Stoneskin:** damage it absorbs can't wake you (FFXIclopedia Sleep), so the engine sends
`/cancel Stoneskin` (needs a cancel addon, as `CheckCancels` already does). `SleepCancelStoneskin = false` to stop.

## HUD

| Command | Does |
|---|---|
| `/gchud [on\|off]` | Show/hide |
| `/gchud pos 500 120` | Place it (dragging also saves) |
| `/gchud debug` | Files found, rows parsed |
| `/gcbar [on\|off]` | Local one-line status bar (off by default) |
| `/gcbar pos 300 0` | Place it |

Each box writes `hud/<name>.txt` 4x a second. Opens on load for names in `settings.HUDOwners`.

Default state:

```
     wpn  ml   nk   def  mb     kt fd sd
COR  Ana  Def       -           .  .  .
RDM  Max  Def  Pow  -    Chain  .  .  .
SCH       Def  Pow  -    Chain  .  .  .
BRD  Nae  Def       -           .  .  .
BLU  Tiz  Def       -           .  .  .
GEO  Idr  Def  Pow  -    Chain  .  .  .
```

After some changes, BLU's name clicked:

```
     wpn  ml   nk    def  mb     th kt fd sd
COR  Ana  Def        MDT         .  .  .  .
RDM  Max  Def  Pow   -    AutoV  .  .  fd .
SCH       Def  Pow   -    Off    .  .  .  .
BRD  Nae  Acc        -           .  kt .  .
BLU  Tiz  Def        DT          th .  .  .
     BLU/DRG a- hx- cj
GEO  Idr  Def  Macc  -    Chain  .  .  .  sd
```

- Columns: cycles, then `def` (`/def` state), `mb` (`/mbmode`, Auto shows tier), then toggles.
- `.` off, glyph on, blank = job doesn't have it, `-` none.
- Bright = changed since load, dim = default, orange = turned off but loads on (SCH `Off`).
- Columns at default on every box are hidden unless in `HUDPinned`; they reappear when changed.
- Click a cell: runs it on that box. Click a name: shows its hidden columns. Hover: full names.
- `mb` cell in Auto: Ctrl+click cycles that box's autonuke tier (`/mbtier`: I → III → V).
- Values shorten automatically (`Death Penalty` → `DeaP`, `Anarchy +2` → `Ana+2`). A warning prints
  if two weapons shorten the same.

Glyphs: `wpn` Weapons, `ml` MeleeSet, `m` `s` `r` `a` Main/Sub/Range/Ammo, `nk` NukeSet,
`el` Element, `tk` TankSet, `hx` Hoxne, `pp` PupMode, `w` Weapon, `th` TH, `kt` Kite,
`fd` AutoFood, `sd` AutoSoda, `hp` String, `sl` SongLock, `pr` PROC, `dh` Death, `tier` MBTier.

| Setting | Default | |
|---|---|---|
| `HUDPinned` | `Def MB Kite AutoFood AutoSoda` | Always-shown columns |
| `HUDAbbr` | `{}` | Value names: `{ ['CarnwenhanAcc'] = 'CarnA' }` |
| `HUDLabels` | `{}` | Glyphs: `{ Main = 'mn' }` |
| `HUDScale` | `0.9` | Text size |
| `HUDAlpha` | `0.45` | Background, 0 = none |

## Other commands

| Command | Does |
|---|---|
| `/meleeset` | MeleeSet: Default → Hybrid → Acc. Wears `Tp_`/`Ws_Hybrid` or `_Acc` over `Tp_`/`Ws_Default`, and `<Name>_Hybrid`/`_Acc` over a named set |
| `/kite` | Kite toggle |
| `/th` | TH toggle: `TH` set until the target is tagged; its Main/Sub/Range the whole time it's on |
| `/setcycle <name> <value>` | Set any cycle |
| `/wsdistance [yalms]` | Toggle WS distance check / set distance (default 5) |
| `/gcmessages` | Chat confirmations on/off |
| `/autogear [on\|off]` | Auto sets by HP/MP %; no arg shows thresholds |
| `/autogear regen\|refresh\|dt\|petdt N` | Threshold %, 0 = never. Defaults 60 / 60 / 50 / 50 |
| | Regen/Refresh only out of combat and never over `/dt`; Dt any time |
| `/received <spell>` | Wear that `*_Received` set |
| `/gcaspir` `/gcdrain` | Best castable, off-recast tier on `<t>` |
| `/ontic` `/shard` | Use Ontic Extremity / V. Con. Shard. Add more in `gcinclude.ExitItems` |
| `/rrset` `/craftset` `/zeniset` `/fishset` | Toggle Reraise / Crafting / Zeni / Fishing set |
| `/gcstyle [N]` | `/lockstyleset N` now. `LockstyleSet` (or per job `gcinclude.LockstyleSet`) applies it 4s after load and job change |

| Command | Jobs | Does |
|---|---|---|
| `/nukeset` | RDM BLM SCH GEO WHM | NukeSet: Power → Macc |
| `/weapon` | BLM SCH | Club → Staff |
| `/elecycle` | BLM SCH | Element cycle |
| `/nuke <1-6>` | BLM SCH | Element's nuke at that tier |
| `/helix` `/weather` | BLM/SCH, SCH | Element's helix / storm, II if available |
| `/death` | BLM | Death toggle |
| `/tankset` | PLD RUN | None → Main → MEVA |
| `/proc` | SAM NIN | Proc set; NIN also disables ammo |
| `/pupmode` | PUP | Tank → Melee → Ranger → Mage |
| `/forcestring` | BRD | Force harp |
| `/songlock` | BRD | Enemy songs (Requiem, Lullaby, Elegy, Finale, Threnody, Nocturne, Virelai) keep main/sub (no TP loss); buff songs and instruments still swap |
| `/cormsg` | COR | Roll messages |
| `/siphon` | SMN | Swap to day's spirit, Elemental Siphon, resummon |

## Tele rings

| Command | Setting | Goes to |
|---|---|---|
| `/warpring` | `warp_Ring` | Warp point |
| `/mea` | `mea_Ring` | Tahrongi portal |
| `/holla` | `holla_Ring` | La Theine portal |
| `/dem` | `dem_Ring` | Konschtat portal |

Force-equips to Ring2 (ignores `/lock`), holds it through the equip delay, uses it at 11s, then
`/lac set Idle` at 22s (retries while zoning). If `Idle` has no Ring2 the ring stays on.
Change per job: `gcinclude.settings.dem_Ring = 'Teleport Ring: Dem'`.

## Diagnostics

| Command | Does |
|---|---|
| `/checksets` | Empty sets, bad item names, `_Default` gaps, ear/ring slot swaps, leftover Moonshade |
| `/gctrace` | One chat line per action: `[Cure IV] Precast > Cure_Precast \| Midcast > Cure`. `{Waist}` = engine-made set (obi/Orpheus, TH without its weapons) |
| `/gchelp` | Command list in game |
| `/gckey <key> <cmd>` | Bind a key |
| `/gcinfo` | Show element gear picks |
| `/xiroll` | Roll tracking |

## Sets the engine uses

| Set | Worn |
|---|---|
| `Weapon_<Mode>` / `_1h` | Weapon mode |
| `mdt`, `Aminon`, `SIR` | With their toggles |
| `LightBonus` | Healing Magic midcast |
| `TH` | `/th` on: at rest, and over midcast/midshot at a mob, until it is tagged (your hit, shot, WS or ability; a spell, step or Effusion only if it lands; clears on death or zone). Not over actions on you or allies. BLU: only `BluMagTH` spells, always (AoE). Main/Sub/Range stay on while `/th` is on, tagged or not (Sub only if you can dual wield; a weapon swap resets TP) |
| `HolyWater` | When Doomed (else `gcinclude.sets.Holy_Water`) |
| `XIRoll` | Idle only, with a roll on you at 11 (default Roller's Ring) |
| `Absorb` | Absorb-TP and every other Absorb- spell, over midcast |
| `Absorb_TP` | Optional, Absorb-TP only, on top of `Absorb` |
| `Buffs = { Name = {...} }` | While that buff is up (idle/engaged) |
| `Buffs_Ws`, `Buffs_Midcast` | Same, over every weaponskill / every spell's midcast, e.g. `Buffs_Ws = { ['Aftermath: Lv.3'] = {...} }`. Name the buff as the buff list shows it |
| `*_Received` | See below |

Moonshade goes in Ear2 on WS below `MoonshadeTP` (1750), except `MoonshadeSkip`.

Layer order: your sets → weapons (+ `TH` weapons while `/th` is on) → mdt/Aminon → Hoxne → TH → received → buff sets → XIRoll →
debuff (Sleep/Doom/Weakness) and craft/zeni/fish/rr sets.
Midcast: job sets → TH → `Buffs_Midcast` → Absorb → LightBonus → obi/Orpheus/back/ring → SIR → required items.
WS: job sets → `Buffs_Ws` → Moonshade → obi/Orpheus/back.

Sub vs Main (FFXIclopedia Grips): a two-handed main (Great Sword, Great Axe, Scythe, Polearm, Great Katana,
Staff) takes only a grip in Sub, and a grip needs a two-handed main. After each handler a Sub that can't go
with the final Main (or the worn one, if Main is held) is dropped, so the swap can't fail.

**Received sets** (worn until the spell lands or is interrupted, `ReceivedWindow` 8s at most; mapping in `settings.ReceivedSets`):

| Cast on you | Set |
|---|---|
| Cure, Cura, Curaga | `Cure_Received` |
| Cursna | `Cursna_Received` |
| Phalanx | `Phalanx_Received` |
| Protect, Shell | `Protect_Shell_Received` |
| Regen | `Regen_Received` |
| Refresh | `Refresh_Received` |
| Curing/Divine Waltz | `Waltz_Received` |

Spells: triggered by anyone's "starts casting" packet on you, and by your own boxes (Multisend at precast).
Area spells reach you too (BG-Wiki/FFXIclopedia, 10'): a party member's Curaga landing near you, or Cura,
Protectra, Shellra cast near you; your own boxes are also told for Majesty Cure/Protect and Accession white
magic. The set comes off as soon as that caster's spell finishes or is interrupted.
The Multisend notice goes only to your own boxes: ones running this engine (fresh `hud\<Name>.txt`) or
listed in `settings.MyBoxes`. Other players' characters are never sent to.
Waltzes are instant, so only your own boxes' Curing Waltz is announced (Multisend when used) and it can
land after the heal; Divine Waltz is aimed at the dancer, so never. Doesn't interrupt your own action;
locked slots skipped.

**Element gear** (spells in `ElementSkills`, elemental ninjutsu, Quick Draw, Cure/Cura/Curaga, WS in `ElementalWS`):

```lua
ElementGear = T{
    Obis = T{ Dark = 'Anrin Obi' },
    AnyObi = 'Hachirin-no-Obi',
    Distance = "Orpheus's Sash",
    DistanceMax = nil,
    Back = 'Twilight Cape',   -- optional
    Ring = 'Zodiac Ring',     -- optional
};
```

Per BG-Wiki: helixes always get day/weather, so never an obi (Orpheus still); cures get Light day/weather
(+10/+10/+25, the obi forces it) but no sash and no ring (`BackOnCures = true` adds the back, `Cures = false` skips cures); Quick Draw
and elemental ninjutsu (Katon…Suiton) take obi/Orpheus/back; the Twilight Cape adds +5% to a day bonus, or to a
weather bonus that applies (obi on, or a helix); Zodiac Ring never on Lightsday/Darksday nor on cures.

Obi score: day +10, weather +10 (double +25), opposing element subtracts. Orpheus: `OrpheusPoints`
(+15 at ≤1.93', +1 at ≥13', linear between; the middle is assumed). Higher wins; obi never at ≤0.
`Ring` goes on when the day matches (`ElementSkills` spells only). `Keep` items are never displaced.

## Hotkeys

| Key | Command |
|---|---|
| grave | `wm` |
| Shift+grave | `wm default` |
| Ctrl+grave | `def` |
| Alt+grave | `hoxne` |
| Win+grave | `mbmode` |

```lua
Keybinds = T{ {'`','wm'}, {'+`','wm default'}, {'^`','def'}, {'!`','hoxne'}, {'@`','mbmode'} };
```

Prefixes: `!` Alt, `^` Ctrl, `+` Shift, `@` Win, `#` Apps. `T{}` = none. Binds replace existing ones
on that key and are removed on unload; check `/bind list`. `/bind block 1` stops them firing while
typing. If Win+grave opens Start, try `/keyboard winkey 0` or another key.

## Job file

```lua
profile.OnLoad = function()
    gcinclude.WeaponModes = {'None', 'Savage', 'Leaden'};
    gcinclude.DefaultWeapons = 'Savage';          -- or { Main = 'Burtgang', Sub = 'Aegis' }
    gcinclude.WeaponRoles = { melee = 'Savage', ranged = 'Leaden' };
    gcinclude.MainModes = {'None', 'Burtgang', 'Caliburnus'};
    gcinclude.SubModes  = {'None', 'Aegis', 'Duban'};
    gcinclude.RangeModes = {'None', 'Annihilator', 'Fomalhaut'};
    gcinclude.AlwaysDualWield = true;
    gcinclude.AutoFood = 'Grape Daifuku +1';
    gcinclude.BuffSetOrder = T{'Saboteur', 'Aftermath'};
    gcinclude.MBTier = 'High';
    gcinclude.Initialize();
end
```

`gcinclude.BuffCount('Name')` or `(id)` counts buffs (same as `gData.GetBuffCount`, cached ids).

Handler helpers:

| Call | Does |
|---|---|
| `gcinclude.EquipMode('Ws')` | `Ws_Default`, then `Ws_<MeleeSet>` unless Default |
| `gcinclude.ByName(name)` | Set named `name` (any case), then `name_<MeleeSet>`. False if none |
| `gcinclude.Family(name)` | `'Utsusemi: Ni'` → `'Utsusemi'`, `'Drain III'` → `'Drain'` |
| `gcinclude.CheckTH(force)` | `TH` set without its weapons if `/th` is on and the target is an untagged mob; `force` skips the target checks |
| `gcinclude.CheckWsBailout()` | False if the WS would fail: `if (gcinclude.CheckWsBailout() == false) then gFunc.CancelAction(); return end` |

## Multibox examples

```
/mss /lac fwd wm default
/mss /lac fwd def
/mss /lac fwd autofood on
/ms sendto <name> /lac fwd wm 3
```
