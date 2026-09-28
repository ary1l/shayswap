local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');

-- BLM template. No gear is filled in: put your own items in each set.
-- Sets named after an ability, spell, skill or weapon skill (['Manafont'], ['Savage Blade'])
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

    Tp_Default = {},
    Tp_Hybrid = {},
    Tp_Acc = {},

    Precast = {},
    Midcast = {},
    Preshot = {},
    Midshot = {},
    Nuke = {},
    NukeACC = {},
    Burst = {},
    Death_Mode = {},
    ['Enfeebling Magic'] = {},
    ['Dark Magic'] = {},
    ['Enhancing Magic'] = {},
    ['Healing Magic'] = {},
    ['Death'] = {}, -- all tiers
    ['Impact'] = {}, -- all tiers
    ['Stun'] = {}, -- all tiers
    ['Drain'] = {}, -- all tiers
    ['Aspir'] = {}, -- all tiers

    Ws_Default = {},
    Ws_Hybrid = {},
    Ws_Acc = {},
    -- ['Weapon Skill Name'] = {}, ['Weapon Skill Name_Acc'] = {},

    ['Manafont'] = {},
    ['Elemental Seal'] = {},
    ['Mana Wall'] = {},
    ['Subtle Sorcery'] = {},
    ['Cascade'] = {},
    ['Manawell'] = {},
    ['Enmity Douse'] = {},
    Absorb = {}, -- every Absorb- spell (land rate: Dark Magic skill, macc; potency is not skill)
    Absorb_TP = {}, -- Absorb-TP on top of Absorb
};
profile.Sets = sets;

profile.Packer = {
};

local ByName, Family = gcinclude.ByName, gcinclude.Family;

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
        gcinclude.EquipMode('Tp');
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
    if (spell.Skill == 'Elemental Magic') then
        gFunc.EquipSet(sets.Nuke);
        if (gcdisplay.GetCycle('NukeSet') == 'Macc') then gFunc.EquipSet(sets.NukeACC) end
        if gcinclude.BurstWanted() then gFunc.EquipSet(sets.Burst) end
        if (gcdisplay.GetToggle('Death') == true) then gFunc.EquipSet(sets.Death_Mode) end
    end
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
    gcinclude.EquipMode('Ws');
    ByName(ws.Name);
end

return profile;
