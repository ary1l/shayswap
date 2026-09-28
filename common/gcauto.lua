local gcauto = {};

local inc = nil;
local disp = nil;
local nextTick = 0;
local busyUntil = 0;
local warned = {};
local seen = {};

local rolls = {};
local rollAbilities = nil;
local rollEleven = false;
local ROLL_STALE = 660;
local ROLL_RECAST = 193;

local function say(msg)
    print(chat.header('GCauto'):append(chat.message(msg)));
end

local function warn_once(key, msg)
    if warned[key] then return end
    warned[key] = true;
    print(chat.header('GCauto'):append(chat.error(msg)));
end

local function has_buff(name)
    return inc.BuffCount(name) > 0;
end

local function disabled()
    for _, b in ipairs(inc.HardCC) do
        if has_buff(b) then return true end
    end
    return false;
end

local CONTAINERS = { 0, 3 }; -- inventory, temporary items

local function item_count(name)
    local res = AshitaCore:GetResourceManager():GetItemByName(name, 0);
    if (res == nil) then return 0 end
    local inv = AshitaCore:GetMemoryManager():GetInventory();
    local n = 0;
    for _, c in ipairs(CONTAINERS) do
        local max = gData.GetContainerMax(c) or 0;
        for i = 1, max do
            local it = inv:GetContainerItem(c, i);
            if (it ~= nil) and (it.Id == res.Id) and (it.Count > 0) then
                n = n + it.Count;
            end
        end
    end
    return n;
end

gcauto.ItemCount = item_count;

local function queue(cmd, hold)
    AshitaCore:GetChatManager():QueueCommand(-1, cmd);
    busyUntil = os.clock() + hold;
end

local function food_list()
    local food = inc.AutoFood;
    if (food == nil) then food = inc.settings.AutoFoodItems end
    if (type(food) == 'string') then return { food } end
    if (type(food) == 'table') and (#food > 0) then return food end
    return nil;
end

local function check_food(player)
    if (disp.GetToggle('AutoFood') ~= true) then return false end
    if (player.IsMoving == true) then return false end
    local list = food_list();
    if (list == nil) then return false end
    if has_buff('Food') then return false end
    local area = gData.GetEnvironment().Area;
    if (area == nil) or inc.Towns:contains(area) then return false end
    local food = nil;
    for _, name in ipairs(list) do
        if (item_count(name) > 0) then food = name; break; end
    end
    if (food == nil) then
        warn_once('food', 'AutoFood: none of ' .. table.concat(list, ', ') .. ' in inventory.');
        return false;
    end
    queue('/item "' .. food .. '" <me>', 3);
    return true;
end

-- Auto-Soda, ported from sync's per-box pass: armed toggle, Regain (buff 170) missing,
-- 20s lock between tries, disarm after ConsumableMaxTries failed tries, tries reset when Regain is back.
-- Frontier Soda is item type 7 (medicine, like Echo Drops), not food, so it never replaces food.
local soda = { lock = 0, tries = 0 };

local function check_soda(player, now)
    if has_buff('Regain') then
        soda.tries = 0;
        return false;
    end
    if (disp.GetToggle('AutoSoda') ~= true) then return false end
    if (player.IsMoving == true) or (player.HP == 0) then return false end
    local area = gData.GetEnvironment().Area;
    if (area == nil) or inc.Towns:contains(area) then return false end
    if (now < soda.lock) then return false end
    local item = inc.settings.SodaItem or 'Frontier Soda';
    if (item_count(item) == 0) then
        warn_once('soda', 'AutoSoda: no ' .. item .. ' in inventory.');
        return false;
    end
    local cap = inc.settings.ConsumableMaxTries or 2;
    if (soda.tries >= cap) then
        disp.CreateToggle('AutoSoda', false);
        soda.tries = 0;
        say('AutoSoda: ' .. item .. ' failed ' .. cap .. ' times - disarmed. Check the item, then /autosoda on.');
        return false;
    end
    soda.tries = soda.tries + 1;
    soda.lock = now + 20.0;
    queue('/item "' .. item .. '" <me>', 3);
    return true;
end

-- Called by tick only while AutoHolyWater is on and Doom is up.
local function check_doom(player)
    local item = inc.settings.HolyWaterItem or 'Holy Water';
    if (item_count(item) == 0) then
        warn_once('doom', 'Doomed and no ' .. item .. ' in your bags.');
        return false;
    end
    local set = (inc.FindSet and inc.FindSet('HolyWater')) or (inc.sets and inc.sets.Holy_Water) or nil;
    if (set ~= nil) then inc.ForceUnlocked(set) end -- /lock stays absolute
    say('Doomed - using ' .. item .. '.');
    queue('/item "' .. item .. '" <me>', 4);
    return true;
end

local function check_auto_items(player)
    if (inc.settings.AutoRevitalizer ~= true) then return false end
    if (player.IsMoving == true) then return false end
    local list = inc.settings.AutoUseItems;
    if (type(list) ~= 'table') then return false end
    local area = gData.GetEnvironment().Area;
    if (area == nil) then return false end
    local here = string.lower(area);
    for _, entry in ipairs(list) do
        if (type(entry) == 'table') and (type(entry.Zone) == 'string') and (type(entry.Item) == 'string') then
            if (string.find(here, string.lower(entry.Zone), 1, true) ~= nil) then
                local key = string.lower(entry.Zone .. '|' .. entry.Item);
                local n = item_count(entry.Item);
                if (seen[key] == nil) then
                    seen[key] = n;
                elseif (n > seen[key]) then
                    seen[key] = n - 1;
                    say(entry.Item .. ' picked up, using it.');
                    queue('/item "' .. entry.Item .. '" <me>', 3);
                    return true;
                else
                    seen[key] = n;
                end
            end
        end
    end
    return false;
end

-- TH tags: drop a mob once it is at 0 HP, so a respawn with the same id gets TH again.
local tagged = {};
local function prune_tags()
    if (next(tagged) == nil) then return end
    local ent = AshitaCore:GetMemoryManager():GetEntity();
    for id in pairs(tagged) do
        local idx = bit.band(id, 0x7FF);
        if (ent:GetServerId(idx) == id) and ((ent:GetHPPercent(idx) or 0) == 0) then tagged[id] = nil end
    end
end

local function tick()
    local now = os.clock();
    if (now < nextTick) then return end
    nextTick = now + 0.5;
    if (inc == nil) or (disp == nil) then return end
    prune_tags();
    if (now < busyUntil) then return end
    if (gState == nil) or (gState.PlayerAction ~= nil) then return end
    local player = gData.GetPlayer();
    if (player == nil) then return end
    if (player.Status ~= 'Idle') and (player.Status ~= 'Engaged') then return end
    if (inc.settings.AutoHolyWater == true) and (inc.BuffCount('Doom') > 0) then
        check_doom(player);
        return;
    end
    if disabled() or has_buff('Invisible') then return end
    if (gcauto.NukeTick ~= nil) and gcauto.NukeTick(player, now) then return end
    if check_auto_items(player) then return end
    if check_food(player) then return end
    check_soda(player, now);
end

-- Reads the bit-packed 0x0028 action packet once, layout per atom0s' XiPackets notes.
-- Bits are LSB-first; one parse feeds the roll, combat and burst readers.
local band, rshift = bit.band, bit.rshift;
local POW2 = {};
for i = 0, 32 do POW2[i] = 2 ^ i end
local pdata, ppos, pbit = nil, 0, 0;
local function rd(n)
    local value, got = 0, 0;
    while (got < n) do
        local byte = string.byte(pdata, ppos) or 0;
        local take = 8 - pbit;
        if (take > (n - got)) then take = n - got end
        value = value + band(rshift(byte, pbit), POW2[take] - 1) * POW2[got];
        got = got + take;
        pbit = pbit + take;
        if (pbit >= 8) then pbit = 0; ppos = ppos + 1 end
    end
    return value;
end

local A = { tgt = {}, nres = {}, first = {}, rval = {}, rmsg = {}, rkind = {} };
local function parse_action(data)
    -- Lua index 6 = byte 0x05: skip the 4-byte header and the size byte (XiPackets 0x0028 Reversing.md;
    -- LAC reads the actor at e.data 0x05 + 1).
    pdata, ppos, pbit = data, 6, 0;
    A.actor = rd(32);
    A.ntgt = rd(6);
    rd(4);
    A.cat = rd(4);
    A.param = rd(32);
    rd(32);
    local k = 0;
    for t = 1, A.ntgt do
        A.tgt[t] = rd(32);
        local results = rd(4);
        A.nres[t] = results;
        A.first[t] = k + 1;
        for _ = 1, results do
            k = k + 1;
            rd(3); rd(2); rd(12); rd(5); rd(5);
            A.rval[k] = rd(17);
            A.rmsg[k] = rd(10);
            rd(31);
            if (rd(1) == 1) then A.rkind[k] = rd(6); rd(4); rd(17); rd(10) else A.rkind[k] = false end
            if (rd(1) == 1) then rd(6); rd(4); rd(14); rd(10) end
        end
    end
    pdata = nil;
    return A;
end

local function roll_abilities()
    if (rollAbilities ~= nil) then return rollAbilities end
    rollAbilities = {};
    local res = AshitaCore:GetResourceManager();
    for id = 0x200, 0x200 + 0x3FF do
        local ability = res:GetAbilityById(id);
        if (ability ~= nil) and (ability.RecastTimerId == ROLL_RECAST) then
            -- Ashita job ability resource id = packet id + 0x200 (LAC packethandlers / data.lua).
            rollAbilities[id - 0x200] = ability.Name[1];
        end
    end
    return rollAbilities;
end

local function my_id()
    local party = AshitaCore:GetMemoryManager():GetParty();
    if (party == nil) then return nil end
    return party:GetMemberServerId(0);
end

-- Combat window, Selindrile-style: a monster hits me or a party/alliance member
-- (melee, ranged, monster skill), or I act on a monster. Expires after CombatWindow.
local lastCombat = -1e9;
local monsterCache = {};

-- Monster: spawn flag 0x10 set, 0x01 (player) clear. Covers LAC's exact 16 = Monster.
local function monster_flags(sf)
    sf = sf or 0;
    return (bit.band(sf, 0x10) ~= 0) and (bit.band(sf, 0x01) == 0);
end

local function is_monster(id)
    if (id == nil) or (id == 0) then return false end
    local hit = monsterCache[id];
    if (hit ~= nil) then return hit end
    local entity = AshitaCore:GetMemoryManager():GetEntity();
    -- Zone entities sit at index = id & 0x7FF (LAC packethandlers does the same); others (players,
    -- pets, trusts) are found by scanning the whole array (0..0x8FF, as LAC does), then cached.
    local idx = bit.band(id, 0x7FF);
    if (entity:GetServerId(idx) ~= id) then
        idx = nil;
        for i = 0, 0x8FF do
            if (entity:GetServerId(i) == id) then idx = i; break end
        end
    end
    if (idx == nil) then return false end -- not loaded yet: don't cache
    local found = monster_flags(entity:GetSpawnFlags(idx));
    monsterCache[id] = found;
    return found;
end

local function is_ally(id)
    local party = AshitaCore:GetMemoryManager():GetParty();
    if (party == nil) then return false end
    for i = 0, 17 do
        if (party:GetMemberIsActive(i) == 1) and (party:GetMemberServerId(i) == id) then return true end
    end
    return false;
end

local function combat_packet(P)
    local me = my_id();
    if (me == nil) then return end
    local category = P.cat;
    local hostile = ((category == 1) or (category == 2) or (category == 11)) and is_monster(P.actor);
    local mine = (P.actor == me) and ((category == 1) or (category == 2) or (category == 3) or (category == 4) or (category == 6));
    if (not hostile) and (not mine) then return end
    for t = 1, P.ntgt do
        local target = P.tgt[t];
        if (hostile and is_ally(target)) or (mine and is_monster(target)) then
            lastCombat = os.clock();
            return;
        end
    end
end

-- Learned cast time, so no job needs gSettings.FastCast. XiPackets 0x0028: cmd_no 8 = Magic (Start),
-- cmd_arg low 16 bits 'ca' (24931) = start, 'sp' (28787) = interrupt; cmd_no 4 = Magic (Finish), cmd_arg = spell id.
-- Finish minus start is the real cast time (FC, Quick Cast, Celerity, cast-time gear, latency).
-- Per skill keep the last 5 ratios to base cast time and use the slowest, so a Quick Cast/Celerity cast
-- never makes a burst look like it will land when a normal cast would not.
local castStart = nil;  -- { id, t }
local castRatio = {};   -- [skill] = { ratios }

local function cast_packet(P)
    local cat = P.cat;
    if (cat ~= 8) and (cat ~= 4) then return end
    local me = my_id();
    if (me == nil) or (P.actor ~= me) then return end
    if (cat == 8) then
        local id = (P.ntgt > 0) and (P.nres[1] > 0) and P.rval[P.first[1]] or nil;
        castStart = (bit.band(P.param, 0xFFFF) == 24931) and (id ~= nil) and { id = id, t = os.clock() } or nil;
        return;
    end
    local s = castStart;
    castStart = nil;
    if (s == nil) or (s.id ~= P.param) then return end
    local res = AshitaCore:GetResourceManager():GetSpellById(s.id);
    if (res == nil) or (res.CastTime == nil) or (res.CastTime <= 0) then return end
    local ratio = (os.clock() - s.t) / (res.CastTime / 4);
    if (ratio < 0.05) or (ratio > 1.5) then return end
    local list = castRatio[res.Skill] or {};
    table.insert(list, ratio);
    if (#list > 5) then table.remove(list, 1) end
    castRatio[res.Skill] = list;
end

-- Seconds a spell resource takes to cast now: learned for its skill, else base less gSettings.FastCast.
function gcauto.CastTime(res)
    if (res == nil) or (res.CastTime == nil) then return 0 end
    local base = res.CastTime / 4;
    local list = castRatio[res.Skill];
    if (list ~= nil) and (#list > 0) then return base * math.max(unpack(list)), true end
    local fc = math.min(math.max(tonumber(gSettings.FastCast) or 0, 0), 80);
    return base * (1 - fc / 100), false;
end

-- Magic burst, ported from sync (sync_packethandler H028.sc + geo_mod.mb.tick).
-- Chain property = the result's proc kind (6 bits, 1..16 -> scdata.PROPNUM; LSB ActionProcSkillChain),
-- counted when the action is in scdata.BYCAT for its category (3 WS, 4 spell, 13 pet, 14); any WS chain counts.
-- Window: settings.MBWindow seconds (BG: 10) from the chain packet; another WS on the mob ends it.
-- A burst is cast only if its cast time (gcauto.CastTime) lands it inside the window.
local scdata = nil;
pcall(function() scdata = gFunc.LoadFile('common\\scdata.lua') end);

local MBELEM = {
    Liquefaction = { 'Fire' }, Induration = { 'Ice' }, Detonation = { 'Wind' }, Scission = { 'Earth' },
    Impaction = { 'Thunder' }, Reverberation = { 'Water' }, Transfixion = { 'Light' }, Compression = { 'Dark' },
    Fusion = { 'Fire', 'Light' }, Fragmentation = { 'Wind', 'Thunder' }, Distortion = { 'Ice', 'Water' },
    Gravitation = { 'Earth', 'Dark' },
    Light = { 'Fire', 'Wind', 'Thunder', 'Light' }, Darkness = { 'Ice', 'Earth', 'Water', 'Dark' },
    Radiance = { 'Fire', 'Wind', 'Thunder', 'Light' }, Umbra = { 'Ice', 'Earth', 'Water', 'Dark' },
};
local mbres = {};   -- [mob server id] = { props, ts, dur, step }
local mbst = {};    -- [mob server id] = { fired, elu, k_ts, k_step }

local function mb_packet(P)
    if (scdata == nil) then return end
    local now = os.clock();
    for t = 1, P.ntgt do
        local target = P.tgt[t];
        local prop, msg = nil, nil;
        if (P.nres[t] > 0) then
            local k = P.first[t];
            msg = P.rmsg[k];
            if (P.rkind[k] ~= false) then prop = scdata.PROPNUM[bit.band(P.rkind[k], 0x3F)] end
        end
        local cat = P.cat;
        if (msg ~= nil) and scdata.PETMSG[msg] then cat = 13 end
        local tbl = scdata.BYCAT[cat];
        local act = tbl and tbl[bit.band(P.param, 0xFFFF)];
        local chained = (prop ~= nil) and (scdata.CHAIN[prop] ~= nil);
        -- XiPackets documents proc_kind as the skillchain id for weapon skills (cmd 3), so a WS chain
        -- counts even when the WS is missing from scdata; other categories still need their table entry.
        if chained and ((act ~= nil) or (cat == 3)) and is_monster(target) then
            local old = mbres[target];
            if (old ~= nil) and (now > old.ts + old.dur) then old = nil end
            local step = ((old ~= nil) and old.step or 1) + 1;
            mbres[target] = { props = { prop }, ts = now, dur = inc.settings.MBWindow or 10, step = step };
        elseif (cat == 3) and (not chained) and (mbres[target] ~= nil) then
            -- BG: any further weapon skill on the target ends the magic burst window.
            mbres[target] = nil;
            mbst[target] = nil;
        end
    end
end

local function live_res(targetId, now)
    local r = mbres[targetId];
    if (r == nil) then return nil end
    if (now > r.ts + r.dur) then mbres[targetId] = nil; mbst[targetId] = nil; return nil end
    return r;
end

-- Burst gear: the spell's element fits the chain and it lands inside dur.
function gcauto.BurstLive(targetId, element, landsAt)
    if (targetId == nil) then return false end
    local now = os.clock();
    local r = live_res(targetId, now);
    if (r == nil) then return false end
    for _, pr in ipairs(r.props) do
        for _, el in ipairs(MBELEM[pr] or {}) do
            if (el == element) then return ((landsAt or now) <= r.ts + r.dur) end
        end
    end
    return false;
end

function gcauto.BurstInfo()
    local now, best, bestId = os.clock(), nil, nil;
    for id, r in pairs(mbres) do
        if (best == nil) or (r.ts > best.ts) then best, bestId = r, id end
    end
    if (best == nil) then return 'no skillchain seen' end
    return string.format('%s on %d, step %d, %.1fs ago, window %.1fs', best.props[1], bestId, best.step, now - best.ts, best.dur);
end

function gcauto.ResetNuke()
    mbst = {};
end

-- Current target index, sync's get_target_index (sub-target aware).
local function target_index(tm)
    if (tm == nil) then return 0 end
    local ok, idx = pcall(function() return tm:GetTargetIndex(tm:GetIsSubTargetActive()) end);
    return (ok and idx and idx > 0) and idx or 0;
end

-- sync's arming: mobs you or a party member are engaged on, plus your current target if it is a
-- monster (monster_flags). Returns [server id] = entity index.
local function armed_mobs()
    local mm = AshitaCore:GetMemoryManager();
    local ent, party = mm:GetEntity(), mm:GetParty();
    local sids = {};
    local mt = target_index(mm:GetTarget());
    if (mt > 0) then
        if monster_flags(ent:GetSpawnFlags(mt)) then
            local sid = ent:GetServerId(mt) or 0;
            if (sid ~= 0) then sids[sid] = mt end
        end
    end
    for i = 0, 5 do
        if (party:GetMemberIsActive(i) == 1) then
            local bi = party:GetMemberTargetIndex(i) or 0;
            if (bi > 0) and (ent:GetStatus(bi) == 1) then
                local bt = ent:GetTargetedIndex(bi) or 0;
                if (bt > 0) then
                    local sid = ent:GetServerId(bt) or 0;
                    if (sid ~= 0) then sids[sid] = bt end
                end
            end
        end
    end
    return sids;
end

-- A spell that can go out now: castable (gcinclude.CanCast), off recast, enough MP.
local function usable(name)
    local ok, res = inc.CanCast(name);
    if (not ok) or (res == nil) then return nil end
    local mm = AshitaCore:GetMemoryManager();
    if (mm:GetRecast():GetSpellTimer(res.Index) ~= 0) then return nil end
    if (mm:GetParty():GetMemberMP(0) < res.ManaCost) then return nil end
    return res;
end

-- Chain element -> single-target tiered nuke.
local NUKE = { Fire = 'Fire', Ice = 'Blizzard', Wind = 'Aero', Earth = 'Stone', Thunder = 'Thunder', Water = 'Water' };
-- Light/Dark have no tiered nuke; the helix is the fallback (SCH only; II needs 1200 JP, CanCast checks).
-- Tried after the tiered nukes, so Light/Darkness chains still prefer Fire/Aero/Thunder or Blizzard/Stone/Water,
-- and Transfixion/Compression (Light or Dark only) get a helix instead of nothing.
local HELIX = { Light = { 'Luminohelix II', 'Luminohelix' }, Dark = { 'Noctohelix II', 'Noctohelix' } };
local ROMAN = { '', ' II', ' III', ' IV', ' V' };

-- Spell for the next burst on chain r. Tier = /mbtier (Low I, Mid III, High V). Tries that tier on
-- each of the chain's elements (in chain order; MBRotate starts one element further per burst),
-- then the next tier down on each (settings.MBFallback), so Water V beats Blizzard IV.
-- SCH needs Addendum: Black or Enlightenment for tiers IV/V (BG-Wiki/FFXIclopedia); CanCast only
-- checks level/JP, so that is checked here.
local function pick_spell(r, st)
    local cand, seen = {}, {};
    for _, pr in ipairs(r.props) do
        for _, el in ipairs(MBELEM[pr] or {}) do
            if ((NUKE[el] ~= nil) or (HELIX[el] ~= nil)) and not seen[el] then
                seen[el] = true;
                cand[#cand + 1] = el;
            end
        end
    end
    if (#cand == 0) then return nil end
    local start = (inc.settings.MBRotate == true) and (st.fired % #cand) or 0;
    local top = inc.MBTierNum[disp.GetCycle('MBTier')] or 3;
    local p = gData.GetPlayer();
    local schLocked = (p ~= nil) and (p.MainJob == 'SCH') and not (has_buff('Addendum: Black') or has_buff('Enlightenment'));
    for t = top, 1, -1 do
        if not (schLocked and (t >= 4)) then
            for k = 0, #cand - 1 do
                local el = cand[((start + k) % #cand) + 1];
                if (NUKE[el] ~= nil) then
                    local name = NUKE[el] .. ROMAN[t];
                    local res = usable(name);
                    if (res ~= nil) then return name, el, res end
                end
            end
        end
        if (inc.settings.MBFallback == false) then break end
    end
    for _, el in ipairs(cand) do
        for _, name in ipairs(HELIX[el] or {}) do
            local res = usable(name);
            if (res ~= nil) then return name, el, res end
        end
    end
    return nil;
end

-- /autonuke, sync's geo_mod.mb.tick for one box. For each live chain on an armed mob: burst n
-- casts the nth spell of the element's list. If the chained mob is not your target and you are
-- not engaged, it targets it first (sync's set_target_safe: ITarget:SetTarget(index, false)).
function gcauto.NukeTick(player, now)
    if (disp.GetToggle('AutoNuke') ~= true) then return false end
    if has_buff('Silence') or has_buff('Mute') then return false end
    if (player.IsMoving == true) then return false end
    local mm = AshitaCore:GetMemoryManager();
    local ent = mm:GetEntity();
    local sids = armed_mobs();
    for sid, r in pairs(mbres) do
        local idx = sids[sid];
        if (idx == nil) or (now > r.ts + r.dur) or ((ent:GetHPPercent(idx) or 0) <= 0) then
            mbres[sid] = nil; mbst[sid] = nil;
        end
    end
    local minmp = inc.settings.MBMinMP or 0;
    for sid, r in pairs(mbres) do
        local idx = sids[sid];
        local st = mbst[sid];
        if (st == nil) then st = { fired = 0, elu = {} }; mbst[sid] = st end
        if (st.k_ts ~= r.ts) or (st.k_step ~= r.step) then
            st.k_ts, st.k_step, st.fired, st.elu = r.ts, r.step, 0, {};
        end
        if (now < r.ts + r.dur) and (st.fired < (inc.settings.MBCasts or 1)) then
            local spell, spellEl, res = pick_spell(r, st);
            -- Only cast if it can land inside the window (learned cast time, see gcauto.CastTime).
            local castTime = gcauto.CastTime(res);
            local fits = (res ~= nil) and ((now + castTime + 0.5) <= (r.ts + r.dur));
            if (spell ~= nil) and fits and ((minmp <= 0) or (mm:GetParty():GetMemberMP(0) >= minmp)) then
                local tm = mm:GetTarget();
                if (target_index(tm) ~= idx) and (player.Status ~= 'Engaged') and (tm ~= nil) then
                    pcall(function() tm:SetTarget(idx, false) end);
                end
                if (target_index(tm) == idx) then
                    st.fired = st.fired + 1;
                    st.elu[spellEl] = (st.elu[spellEl] or 0) + 1;
                    queue('/ma "' .. spell .. '" <t>', math.max(castTime, 5.0));
                    return true;
                end
            end
        end
    end
    return false;
end

function gcauto.InCombat()
    local window = (inc ~= nil) and inc.settings.CombatWindow or 6;
    return (os.clock() - lastCombat) <= window;
end

local function roll_recompute()
    local now, eleven = os.clock(), false;
    for id, entry in pairs(rolls) do
        if ((now - entry.at) > ROLL_STALE) then
            rolls[id] = nil;
        elseif (entry.name ~= nil) and (inc ~= nil) and (inc.BuffCount(entry.name) == 0) then
            rolls[id] = nil; -- roll folded, overwritten or worn off
        elseif (entry.total == 11) then
            eleven = true;
        end
    end
    rollEleven = eleven;
end

local function roll_packet(P)
    local actor, category, param = P.actor, P.cat, P.param;
    -- Magic (Start) from anyone else, aimed at me: gear up while it is still in the air.
    if (category == 8) then
        local me = my_id();
        if (me ~= nil) and (actor ~= me) and (gcauto.OnIncomingCast ~= nil) then
            for t = 1, P.ntgt do
                if (P.tgt[t] == me) then
                    local k = P.first[t];
                    for r = k, k + P.nres[t] - 1 do
                        local spell = AshitaCore:GetResourceManager():GetSpellById(P.rval[r]);
                        if (spell ~= nil) and (spell.Name ~= nil) then
                            gcauto.OnIncomingCast(spell.Name[1]);
                        end
                    end
                end
            end
        end
        return;
    end
    if (category == 1) or (category == 2) or (category == 3) or (category == 6) then
        local me = my_id();
        if (me ~= nil) and (actor == me) then
            for t = 1, P.ntgt do
                if is_monster(P.tgt[t]) then tagged[P.tgt[t]] = true end
            end
            -- category 6 falls through: your own Phantom Roll / Double-Up is also a roll packet.
            if (category ~= 6) then return end
        end
    end
    local rollName = (category == 6) and roll_abilities()[param] or nil;
    if (rollName == nil) then return end
    local me = my_id();
    if (me == nil) then return end
    for t = 1, P.ntgt do
        if (P.tgt[t] == me) then
            local k = P.first[t];
            for r = k, k + P.nres[t] - 1 do
                local value = P.rval[r];
                if (value >= 1) and (value <= 11) then
                    rolls[param] = { total = value, at = os.clock(), name = rollName };
                end
            end
        end
    end
    roll_recompute();
end

function gcauto.RollEleven()
    if (next(rolls) ~= nil) then roll_recompute() end
    return rollEleven;
end

function gcauto.IsTagged(id)
    return (id ~= nil) and (tagged[id] == true);
end

function gcauto.ClearTags()
    tagged = {};
end

function gcauto.RollInfo()
    local now = os.clock();
    local parts = {};
    for id, entry in pairs(rolls) do
        local name = entry.name or tostring(id);
        parts[#parts + 1] = name .. '=' .. tostring(entry.total) .. ' (' .. tostring(math.floor(now - entry.at)) .. 's)';
    end
    if (#parts == 0) then return 'no roll seen yet' end
    return table.concat(parts, ', ');
end

function gcauto.RollReset()
    rolls = {};
    rollEleven = false;
end

function gcauto.Bind(gcinclude, gcdisplay)
    inc = gcinclude;
    disp = gcdisplay;
end

function gcauto.CreateToggles()
    if (inc == nil) or (disp == nil) then return end
    if (food_list() ~= nil) then
        disp.CreateToggle('AutoFood', inc.settings.AutoFood == true);
    end
    disp.CreateToggle('AutoSoda', inc.settings.AutoSoda == true);
    soda = { lock = 0, tries = 0 };
    warned = {};
    seen = {};
end

-- on/off/toggle a boolean setting.
local function flip(key, arg)
    if (arg == 'on') or (arg == 'off') then
        inc.settings[key] = (arg == 'on');
    else
        inc.settings[key] = not (inc.settings[key] == true);
    end
    return inc.settings[key];
end

local function onoff(name, arg)
    if (arg == 'on') then
        disp.CreateToggle(name, true);
    elseif (arg == 'off') then
        disp.CreateToggle(name, false);
    else
        disp.AdvanceToggle(name);
    end
    return disp.GetToggle(name);
end

function gcauto.HandleCommand(args)
    local cmd = args[1];
    local arg = (args[2] ~= nil) and string.lower(args[2]) or nil;
    if (cmd == 'autofood') then
        local list = food_list();
        if (list == nil) then return true end
        local on = onoff('AutoFood', arg);
        say('AutoFood ' .. (on and 'on' or 'off') .. ' | ' .. table.concat(list, ' > '));
        return true;
    elseif (cmd == 'autosoda') then
        local on = onoff('AutoSoda', arg);
        soda = { lock = 0, tries = 0 };
        say('AutoSoda ' .. (on and 'on' or 'off') .. ' | ' .. (inc.settings.SodaItem or 'Frontier Soda'));
        return true;
    elseif (cmd == 'holywater') then
        say('Auto Holy Water ' .. (flip('AutoHolyWater', arg) and 'on' or 'off'));
        return true;
    elseif (cmd == 'revit') then
        seen = {};
        say('Auto Revitalizer ' .. (flip('AutoRevitalizer', arg) and 'on' or 'off'));
        return true;
    end
    return false;
end

function gcauto.Start()
    ashita.events.register('d3d_present', 'gcauto_tick', tick);
    ashita.events.register('packet_in', 'gcauto_packet', function (e)
        if (e.id == 0x0028) then
            local ok, P = pcall(parse_action, e.data);
            if ok then pcall(roll_packet, P); pcall(combat_packet, P); pcall(cast_packet, P); pcall(mb_packet, P) end
        end
        if (e.id == 0x000A) then gcauto.RollReset(); gcauto.ClearTags(); lastCombat = -1e9; monsterCache = {}; soda = { lock = 0, tries = 0 }; mbres = {}; mbst = {} end
    end);
end

function gcauto.Stop()
    ashita.events.unregister('d3d_present', 'gcauto_tick');
    ashita.events.unregister('packet_in', 'gcauto_packet');
end

return gcauto;
