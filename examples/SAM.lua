local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');

-- SAM template. No gear is filled in: put your own items in each set.
-- Sets named after an ability, spell, skill or weapon skill (['Meditate'], ['Savage Blade'])
-- are worn by name; add '<Name>_Hybrid' / '<Name>_Acc' for /meleeset. Empty sets do nothing.
local sets = {
    Cure_Received = {},
    Cursna_Received = {},
    Phalanx_Received = {},
    Protect_Shell_Received = {},
    Regen_Received = {},
    Refresh_Received = {},
    Waltz_Received = {},

    -- Weapon modes: add a Weapon_<Mode> set and the mode to WeaponModes in OnLoad.
    -- Weapon_Example = { Main = 'Item Name', Sub = 'Item Name' },

    Idle = {},
    Idle_Regen = {},
    Idle_Refresh = {},
    Resting = {},
    Town = {},
    Movement = {},
    Dt = {},
    mdt = {},
    Aminon = {},
    SIR = {},
    TH = {},

    Proc = {}, -- /proc: low-damage gear for proc windows, layered while engaged and on WS
    Tp_Default = {},
    Tp_Hybrid = {},
    Tp_Acc = {},

    Precast = {},
    Midcast = {},
    Preshot = {},
    Midshot = {},

    Ws_Default = {},
    Ws_Hybrid = {},
    Ws_Acc = {},
    -- ['Weapon Skill Name'] = {}, ['Weapon Skill Name_Acc'] = {},

    ['Meditate'] = {},
    ['Warding Circle'] = {},
    ['Third Eye'] = {},
    ['Hasso'] = {},
    ['Seigan'] = {},
    ['Sekkanoki'] = {},
    ['Sengikori'] = {},
    ['Meikyo Shisui'] = {},
    ['Blade Bash'] = {},
    ['Shikikoyo'] = {},
    ['Konzen-ittai'] = {},
    Absorb = {}, -- every Absorb- spell (land rate: Dark Magic skill, macc; potency is not skill)
    Absorb_TP = {}, -- Absorb-TP on top of Absorb
};
profile.Sets = sets;

profile.Packer = {
};

-- Wears the set named after an action, then its /meleeset variant. False if there is none.
local function ByName(name)
    local set = gcinclude.FindSet(name);
    if (set == nil) then return false end
    gFunc.EquipSet(set);
    local mode = gcdisplay.GetCycle('MeleeSet');
    if (mode ~= nil) and (mode ~= 'Default') then
        local v = gcinclude.FindSet(name .. '_' .. mode);
        if (v ~= nil) then gFunc.EquipSet(v) end
    end
    return true;
end

-- 'Utsusemi: Ni' -> 'Utsusemi', 'Drain III' -> 'Drain'.
local function Family(name)
    local base = string.match(name, '^(.-):') or name;
    return (string.gsub(base, ' [IVX]+$', ''));
end

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    gcinclude.WeaponModes = {'None'}; -- e.g. {'None', 'Example'} with a Weapon_Example set
    gcinclude.DefaultWeapons = 'None';
    gcinclude.Initialize();
end

profile.OnUnload = function()
    gcinclude.Unload();
end

profile.HandleCommand = function(args)
    gcinclude.HandleCommands(args);
end

profile.HandleDefault = function()
    local player = gData.GetPlayer();
    gFunc.EquipSet(sets.Idle);
    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.Tp_Default);
        if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Tp_' .. gcdisplay.GetCycle('MeleeSet'));
        end
        if (gcdisplay.GetToggle('PROC') == true) then gFunc.EquipSet(sets.Proc) end
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    elseif (player.IsMoving == true) then
        gFunc.EquipSet(sets.Movement);
    end

    -- job layers go before CheckDefault so engine layers (weapons, mdt/Aminon, Hoxne, TH, received, buffs, XIRoll) sit on top
    if (gcdisplay.GetToggle('DTset') == true) then gFunc.EquipSet(sets.Dt) end
    if (gcdisplay.GetToggle('Kite') == true) then gFunc.EquipSet(sets.Movement) end
    gcinclude.CheckDefault();
end

profile.HandleAbility = function()
    local ability = gData.GetAction();
    ByName(ability.Name);
    gcinclude.CheckCancels();
end

profile.HandleItem = function()
    local item = gData.GetAction();
    if string.match(item.Name, 'Holy Water') then gFunc.EquipSet(gcinclude.sets.Holy_Water) end
end

profile.HandlePrecast = function()
    gFunc.EquipSet(sets.Precast);
    gcinclude.CheckCancels();
end

profile.HandleMidcast = function()
    local spell = gData.GetAction();
    gFunc.EquipSet(sets.Midcast);
    ByName(spell.Skill);
    if not ByName(spell.Name) then ByName(Family(spell.Name)) end
    gcinclude.CheckTH();
end

profile.HandlePreshot = function()
    gFunc.EquipSet(sets.Preshot);
end

profile.HandleMidshot = function()
    gFunc.EquipSet(sets.Midshot);
    gcinclude.CheckTH();
end

profile.HandleWeaponskill = function()
    if (gcinclude.CheckWsBailout() == false) then gFunc.CancelAction(); return end
    local ws = gData.GetAction();
    gFunc.EquipSet(sets.Ws_Default);
    if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
        gFunc.EquipSet('Ws_' .. gcdisplay.GetCycle('MeleeSet'));
    end
    ByName(ws.Name);
    if (gcdisplay.GetToggle('PROC') == true) then gFunc.EquipSet(sets.Proc) end
end

return profile;
