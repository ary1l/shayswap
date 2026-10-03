local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');

-- BST template. No gear is filled in: put your own items in each set.
-- Sets named after an ability, spell, skill or weapon skill (['Reward'], ['Savage Blade'])
-- are worn by name (gcinclude.ByName); a spell with no set uses its family's (['Cure'] for Cure IV).
-- Add '<Name>_Hybrid' / '<Name>_Acc' for /meleeset. Empty sets do nothing.
local sets = {
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
    TH = {}, -- /th: until the target is tagged; Main/Sub/Range here stay on while /th is on
    Idle_Pet = {},
    Pet_Dt = {},

    Tp_Default = {},
    Tp_Hybrid = {},
    Tp_Acc = {},

    Precast = {},
    Midcast = {},
    Preshot = {},
    Midshot = {},
    Ready_Delay = {}, -- worn when you use a Ready move
    PetAction = {}, -- default for pet moves; add a set named after a move to override

    Ws_Default = {},
    Ws_Hybrid = {},
    Ws_Acc = {},
    -- ['Weapon Skill Name'] = {}, ['Weapon Skill Name_Acc'] = {},

    ['Reward'] = {},
    ['Call Beast'] = {},
    ['Bestial Loyalty'] = {},
    ['Charm'] = {},
    ['Familiar'] = {},
    ['Killer Instinct'] = {},
    ['Spur'] = {},
    ['Feral Howl'] = {},
    ['Tame'] = {},
    ['Unleash'] = {},
    Absorb = {}, -- every Absorb- spell (land rate: Dark Magic skill, macc; potency is not skill)
    Absorb_TP = {}, -- Absorb-TP on top of Absorb
    Cure_Received = {},
    Cursna_Received = {},
    Phalanx_Received = {},
    Protect_Shell_Received = {},
    Regen_Received = {},
    Refresh_Received = {},
    Waltz_Received = {},
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
    local petAction = gData.GetPetAction(); -- pet actions arrive here, not in HandleAbility
    if (petAction ~= nil) then
        if not ByName(petAction.Name) then gFunc.EquipSet(sets.PetAction) end
        return;
    end
    local player = gData.GetPlayer();
    gFunc.EquipSet(sets.Idle);
    if (player.Status ~= 'Engaged') and (gData.GetPet() ~= nil) then
        gFunc.EquipSet(sets.Idle_Pet);
    end
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
    if (ability.Type == 'Ready') then gFunc.EquipSet(sets.Ready_Delay) end
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
    gcinclude.EquipMode('Ws');
    ByName(ws.Name);
end

return profile;
