# Windower port map

How each Ashita / LuAshitacast (LAC) piece ShaySwap uses maps to Windower 4 / GearSwap (GS).
Plan only. Nothing is ported yet.

**Sources checked:** LAC (ThornyFFXI/LuAshitacast), GS and libs (Windower/Lua `dev`),
Rahvin GS (RahvinCode/Gearswap, MIT), Selindrile (Selindrile/GearSwap, no license file: use its
patterns, don't copy its code). Paths below are relative to those repos.

**Legend:** ✅ direct swap · 🔁 same idea, rewritten · ⛔ no equivalent found (a decision is needed)

## Size

| File | Lines | Port |
|---|---:|---|
| `scdata.lua` | 217 | ✅ plain data, no Ashita calls |
| `gcaction.lua` | 253 | 🔁 recast/target reads |
| `gcdisplay.lua` | 253 | 🔁 state is plain Lua; the imgui bar becomes a `texts` box |
| `gchud.lua` | 781 | 🔁 display only, driven by commands (see HUD) |
| `gcauto.lua` | 814 | 🔁 packet events, entity reads |
| `gcinclude.lua` | 2365 | 🔁 the core. Most of the work is here |
| `examples/*.lua` (22) | | 🔁 set tables and handler names (see Job files) |

## 1. Engine model

| LAC | GS | Notes |
|---|---|---|
| `HandleDefault` | ⛔ no per-packet hook | LAC calls it on every outgoing packet chunk while no action is pending (`packethandlers.lua` ~L291). Rahvin does the same thing with `raw_register_event('outgoing chunk', main_engine)`, then `send_command('gs c update auto')` to equip (`Rahvin-Engine.lua` L103, L169-173). Or use `windower.register_event` (not raw): GS wraps that handler so `equip()` inside it is sent (`user_functions.lua` `register_event_user` → `user_equip_sets`). |
| `HandlePrecast` `HandleAbility` `HandleWeaponskill` `HandleItem` `HandlePreshot` | `precast(spell)` | One function. Branch on `spell.action_type` / `spell.type`. |
| `HandleMidcast` `HandleMidshot` | `midcast(spell)` | Same timing: precast gear, action packet, midcast gear at once (LAC `packethandlers.lua` ~L196-206; GS `flow.lua` L155). |
| back to idle when the action clears | `aftercast(spell)` | Driven by the action packet in both. LAC's backup timer (`gSettings.FastCast`) has no GS counterpart that I found. Keep ShaySwap's own timer in a `prerender` check. |
| pet actions (`gData.GetPetAction`) | `pet_midcast` / `pet_aftercast` | |
| `HandleCommand(args)` | `self_command(cmd)` | Called by `//gs c <cmd>`. |
| `OnLoad` / `OnUnload` | `get_sets()` / `file_unload()` | |
| `profile.Sets` / `gProfile.Sets` | `sets` | |
| `profile.Packer` | ⛔ | Selindrile ships `libs/organizer-lib.lua`. |
| `gFunc.LoadFile('common\\x.lua')` | `include('x.lua')` | Returns the file's return value, like LoadFile (`user_functions.lua` `include_user`). |

## 2. gFunc / gData / gState

| LAC | GS / Windower | |
|---|---|---|
| `gFunc.EquipSet(set)` / `gFunc.Equip(slot, item)` | `equip(set)` / `equip({[slot]=item})` | ✅ |
| filter on `gFunc.EquipSet` (the ShaySwap hook) | wrap `equip` in the job env | 🔁 GS rebuilds the user env on every load (`refresh.lua` `load_user_files`), so install the wrapper in `get_sets` each time. |
| `gFunc.ForceEquipSet` (ignores `gState.Disabled`) | `gearswap.set_merge(false, gearswap.equip_list, set)` | 🔁 GS checks `disable` when `equip()` is called (`helper_functions.lua` `set_merge`). `gearswap` is `_G` inside job files (`refresh.lua` user_env). This reaches into GS internals. Or `enable` → `equip` → `disable` inside one handler. |
| `gFunc.CancelAction()` | `cancel_spell()` | ✅ Only valid in `pretarget`/`precast`/`filtered_action` (`user_functions.lua` L62). Every ShaySwap cancel is precast-stage. |
| `gState.Disabled[slot]` | `disable(...)` / `enable(...)`, read `gearswap.disable_table` | 🔁 |
| `gState.PlayerAction` | `midaction()` | 🔁 |
| `gSettings.AllowAddSet` | ⛔ | No `/addset` in GS. Drop it. |
| `gSettings.EquipBags` | none needed | GS searches the equip bags itself. |
| `gData.GetAction()` | `spell` argument | `.english` `.type` `.skill` `.element` `.mp_cost` `.action_type` |
| `gData.GetActionTarget()` | `spell.target` | |
| `gData.GetPlayer()` | `player` | `.main_job` `.sub_job` `.main_job_level` `.tp` `.hpp` `.mpp` `.status` (`refresh.lua` L202+) |
| `player.IsMoving` | ⛔ not in GS | Selindrile compares position every 0.1s in `prerender` (`Sel-Utility.lua` L2835+). LAC does it from 0x015. |
| `gData.GetEnvironment()` | `world` | `.day` `.day_element` `.weather_element` `.area`. Both apply storm buffs to the weather (`refresh.lua` `weather_update`; LAC `data.lua` ~L487). |
| `gData.GetEquipment()` | `player.equipment` | |
| `gData.GetEquipSlot(slot)` | `windower.ffxi.get_items('equipment')` | `[slot]` = index, `[slot..'_bag']` = bag |
| `gData.GetContainerMax(c)` | `windower.ffxi.get_bag_info(c).max` | |
| `gData.GetPet()` | `pet` | `.isvalid` `.name` `.hpp` |
| `gData.GetTarget()` | `player.target` | |

## 3. AshitaCore memory and resources

| Ashita | Windower |
|---|---|
| `GetResourceManager()` items/spells/abilities | `res = require('resources')`: `res.items`, `res.spells`, `res.job_abilities`, `res.weapon_skills` |
| `GetString('jobs.names_abbr', id)` | `res.jobs[id].ens` |
| `GetString('buffs.names', id)` | `res.buffs[id].english` |
| `GetString('zones.names', id)` | `res.zones[id].english` |
| `GetPlayer():GetMainJob/…Level/GetSubJob…` | `windower.ffxi.get_player()` `.main_job_id` `.main_job_level` `.sub_job_id` … |
| `GetPlayer():GetJobPointsSpent(j)` | `get_player().job_points[job].jp_spent` |
| `GetPlayer():HasSpell(id)` | `windower.ffxi.get_spells()[id]` |
| `GetPlayer():GetBuffs()` | `buffactive` / `player.buffs`, or `buff_change(name, gain)` |
| `GetPlayer():GetIsZoning()` | `zone change` event (both suites use it) |
| `GetPlayer():GetAttack()/GetDefense()` | not checked. Only the bar shows them; drop or verify. |
| `GetRecast():GetSpellTimer(id)` | `windower.ffxi.get_spell_recasts()[id]`, in 1/60 s (Selindrile `spell_latency = latency*60 + 18`) |
| `GetRecast():GetAbilityTimer/Id` | `windower.ffxi.get_ability_recasts()[recast_id]`. ShaySwap already uses Windower recast ids. |
| `GetParty():GetMember*` (name, zone, TP, MP, server id, target index) | `windower.ffxi.get_party().p0..p5`: `.name` `.zone` `.tp` `.mp` `.mob.id` `.mob.index` |
| `GetEntity():GetSpawnFlags(i)` (monster bit) | `get_mob_by_index(i).spawn_type == 16` (monster), `14` (trust) |
| `GetEntity():GetDistance(i)` (squared) | `mob.distance`, also squared: `math.sqrt(mob.distance)` (both suites) |
| `GetEntity():GetStatus(i)` / `GetTargetedIndex(i)` | `mob.status` / `mob.target_index` |
| `GetTarget():GetTargetIndex(GetIsSubTargetActive())` | `get_mob_by_target('st') or get_mob_by_target('t')` |
| `GetTarget():SetTarget(idx)` | ⛔ Not in Windower/Lua libs or either suite. Auto-nuke already names the mob by server id. Selindrile casts the same way (`windower.chat.input('/ma "Stun" '..id)`, `Sel-SelfCommands.lua` `do_stun`). Drop the retarget; the box won't show the mob as its target. |
| `GetInventory():GetContainerItem/GetEquippedItem` | `windower.ffxi.get_items(bag, index)` / `get_items('equipment')` |
| `GetInstallPath()` + `ashita.fs.*` | `windower.addon_path`, `windower.dir_exists`, `windower.create_dir`, `windower.get_dir`. `io` is open to job files (`refresh.lua` user_env). |
| `chat.header/message/error` | `add_to_chat(color, text)` (Selindrile uses 123 for errors) |
| `bit.*`, `T{}` `:contains` `:append` | ✅ `bit` and `T` are in the job env. Windower `tables.lua` has both methods. |

## 4. Packets and events

| Ashita | Windower |
|---|---|
| `d3d_present` ticks (gcauto, gcinclude TP hold, gcdisplay, gchud) | `prerender`. Throttle with `os.clock()`, as Rahvin and Selindrile do. |
| `packet_in` 0x028 + ShaySwap's bit reader | `action` event, already parsed (GS `triggers.lua`, Rahvin `monitor.lua`). Same layout (`libs/packets/fields.lua` L1870+): `actor_id`, `category`, `param`, `targets[i].id`, `targets[i].actions[j]`. ShaySwap's `rmiss` (3 bits) is the low 3 bits of Windower's 5-bit `reaction`: `bit.band(reaction, 7)`. `rval` → `.param`, `rmsg` → `.message`, `rkind` → `.add_effect_animation` when `.has_add_effect`. |
| `packet_in` 0x00A (zone in) | `zone change` event |
| skillchain detection | ShaySwap reads the add-effect kind with `scdata`; Rahvin uses `add_effect_message` 288-301 / 385-398 / 767-770 (`monitor.lua` L93). Either works. |
| `/cancel <buff>` | Inject 0xF1: `windower.packets.inject_outgoing(0xF1, string.char(0xF1,0x04,0,0,id%256,math.floor(id/256),0,0))` (Rahvin `monitor.lua` L149). Or the Cancel addon. |

## 5. Commands, binds, multibox

| ShaySwap now | Windower |
|---|---|
| `/lac fwd <cmd>` | `gs c <cmd>` |
| `/alias /wm /lac fwd wm` | `alias wm gs c wm`, typed `//wm`. Single-slash `/wm` is untested. |
| `/bind <key> /lac fwd <cmd>` | `bind <key> gs c <cmd>`. Ctrl `^`, Alt `!`, Win `@` are the same; **Shift is `~` in Windower** (Ashita `+`). Default `+\`` becomes `~\``. |
| `/mss /lac fwd <cmd>` (all boxes) | `send @all gs c <cmd>` (Send addon: `@all` / `@others`) |
| `/ms sendto <name> /lac fwd <cmd>` | `send <name> gs c <cmd>` |
| received-gear notice (`/ms sendto … received …`) | `windower.send_ipc_message` + `ipc message` event. Rahvin's `spellreceived.lua` does exactly this. Same-machine only, like MultiSend. |
| `/lac equip ring2 "x"` / `/lac set Idle` | `equip({ring2='x'})` / `equip(sets.Idle)` inside a wrapped handler |
| `/lac disable ammo` / `enable` | `disable('ammo')` / `enable('ammo')` |
| `/ma` `/ja` `/item` `/lockstyleset` | Same game commands via `send_command('input /ma "…" <t>')` |

## 6. HUD and bar

- Display plus commands, no click cells. Rahvin does the same: two `texts` boxes, draggable,
  set by commands (`display.lua`).
- `texts` can hit-test the whole box (`texts.hover`) but not one cell. Cell clicks would need a
  `texts` object per cell. Leave that out.
- Box-to-box state: keep the per-character files (`io` + `windower.addon_path`), or send it over
  IPC. IPC drops the file polling.
- The `gchud.CycleCommands` / `ToggleCommands` names become `gs c` commands and bind targets as they are.

## 7. Job files

- Handler names: see section 1.
- Slot keys: GS lowercases them (`helper_functions.lua` `user_key_filter`), so `Main`/`Ear1` work.
- Item keys are read lowercase (`equip_processing.lua` L88-95). Convert them:
  `Name` → `name`, `Augment` → `augments`, `Priority` → `priority`,
  `AugPath = 'B'` → `augments = {'Path: B'}`. A script can do this.
- `gcinclude.sets` / template set lookup (`['Savage Blade']`, `_Hybrid`) is plain Lua and carries over.

## 8. Decisions needed

1. **Default tick:** Rahvin's pattern (raw outgoing chunk + `gs c update`) or a wrapped `register_event`
   that equips directly.
2. **ForceEquipSet:** reach into `gearswap.equip_list` / `set_merge` (exact match, internal API),
   or `enable` / `equip` / `disable` (public API).
3. **Auto-nuke retarget:** drop it (recommended) or look for a packet method.
4. **HUD transport:** files or IPC.
5. **`/addset`, `Packer`:** drop, or use organizer-lib.

## 9. Order

1. Set and job-file converter (section 7).
2. Engine skeleton: `get_sets`, `precast`, `midcast`, `aftercast`, `self_command`, the default tick,
   the `equip` filter. Port the `gcinclude` layering.
3. `gcaction` checks in `precast`, with the queue on `coroutine.schedule`.
4. `gcauto`: `action`, `zone change`, `prerender`.
5. `gcdisplay` bar and `gchud` grid as `texts` boxes.
6. Multibox: `send` and IPC.

Every step needs in-game testing on Windower. None of this has run yet.
