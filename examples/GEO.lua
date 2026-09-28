local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');
local sets = {
    Cure_Received = {
    },
    Cursna_Received = {
    },
    Phalanx_Received = {
    },
    Protect_Shell_Received = {
    },
    Regen_Received = {
    },
    Refresh_Received = {
    },
    Waltz_Received = {
    },
    Weapon_Idris = {
        Main = 'Idris',
        Sub = 'Bunzi\'s Rod',
        Range = 'Dunna',
    },
    Weapon_Idris_1h = {
        Main = 'Idris',
        Sub = 'Genmei Shield',
        Range = 'Dunna',
    },
    Weapon_Maxentius = {
        Main = 'Maxentius',
        Sub = 'Bunzi\'s Rod',
        Range = 'Dunna',
    },
    Weapon_Maxentius_1h = {
        Main = 'Maxentius',
        Sub = 'Genmei Shield',
        Range = 'Dunna',
    },
    Weapon_Tishtrya = {
        Main = 'Tishtrya',
        Sub = 'Bunzi\'s Rod',
        Range = 'Dunna',
    },
    Weapon_Tishtrya_1h = {
        Main = 'Tishtrya',
        Sub = 'Genmei Shield',
        Range = 'Dunna',
    },
    SIR = {
        Head = 'azimuth hood +3',
        Neck = 'loricate torque +1',
        Ear2 = 'lugalbanda Earring',
        Ear1 = 'alabaster Earring',
        Body = 'shamash robe',
        Hands = 'nyame gauntlets',
        Ring2 = 'gurebu\'s ring',
        Ring1 = 'murky ring',
        Back = { Name = 'Nantosuelta\'s Cape', Augment = { [1] = 'Mag. Evasion+30', [2] = 'HP+60', [3] = 'Pet: "Regen"+15', [4] = 'Evasion+20' } },
        Waist = 'carrier\'s sash',
        Legs = 'nyame flanchard',
        Feet = 'nyame sollerets',
    },
    Idle = {
        Main = 'idris',
        Sub = 'Genmei Shield',
        Range = 'Dunna',
        Head = 'azimuth hood +3',
        Neck = 'loricate torque +1',
        Ear2 = 'lugalbanda Earring',
        Ear1 = 'alabaster Earring',
        Body = 'shamash robe',
        Hands = 'nyame gauntlets',
        Ring2 = 'gurebu\'s ring',
        Ring1 = 'murky ring',
        Back = { Name = 'Nantosuelta\'s Cape', Augment = { [1] = 'Mag. Evasion+30', [2] = 'HP+60', [3] = 'Pet: "Regen"+15', [4] = 'Evasion+20' } },
        Waist = 'carrier\'s sash',
        Legs = 'nyame flanchard',
        Feet = 'nyame sollerets',
    },
    Idle_Pet = {
        Main = 'idris',
        Sub = 'Genmei Shield',
        Range = 'Dunna',
        Head = 'Azimuth Hood +3',
        Neck = 'bagua charm +2',
        ear2 = 'lugalbanda earring',
        Ear1 = 'alabaster Earring',
        Body = 'shamash robe',
        Hands = 'Geo. Mitaines +4',
        Ring2 = 'gurebu\'s ring',
        Ring1 = 'murky ring',
        Back = { Name = 'Nantosuelta\'s Cape', Augment = { [1] = 'Mag. Evasion+30', [2] = 'HP+60', [3] = 'Pet: "Regen"+15', [4] = 'Evasion+20' } },
        Waist = 'Isa Belt',
        Legs = 'nyame flanchard',
        Feet = 'bagua sandals +3',
    },
	    Pet_Dt = {
        Main = 'idris',
        Sub = 'Genmei Shield',
        Range = 'Dunna',
        Head = 'Azimuth Hood +3',
        Neck = 'bagua charm +2',
		ear2 = 'lugalbanda earring',
        Ear1 = 'alabaster earring',
        Body = 'shamash robe',
        Hands = 'Geo. Mitaines +4',
        Ring2 = 'gurebu\'s ring',
        Ring1 = 'murky ring',
        Back = { Name = 'Nantosuelta\'s Cape', Augment = { [1] = 'Mag. Evasion+30', [2] = 'HP+60', [3] = 'Pet: "Regen"+15', [4] = 'Evasion+20' } },
        Waist = 'Isa Belt',
        Legs = 'Nyame Flanchard',
        Feet = 'bagua sandals +3',
    },
    Resting = {},
    Idle_Regen = {
        Ring1 = 'Chirich Ring +1',
		waist = 'null belt',	
    },
    Idle_Refresh = {
        Main = 'Bolelabunga',
		head = 'volte beret',
		neck = 'sibyl scarf',
        Body = 'shamash robe',
        Hands = 'bagua mitaines +3',
		Ring1 = 'gurebu\'s ring',
		ring2 = 'stikini ring +1',
        Waist = 'Fucho-no-Obi',
        Legs = 'volte brais',
    },
    Town = {
		main = 'idris',
		sub = 'chanter\'s shield',
		range = 'dunna',
		ammo = 'remove',
		head = 'azimuth hood +3',
		neck = 'sibyl scarf',
        Body = 'shamash robe',
        Hands = 'Geo. Mitaines +4',
		Ring2 = 'gurebu\'s ring',
		Waist = 'carrier\'s sash',
        Legs = 'geo. pants +4',
        Feet = 'geo. sandals +4',
    },

    Dt = {
        Head = 'azimuth hood +3',
        Neck = 'loricate torque +1',
		ear2 = 'lugalbanda earring',
        Ear1 = 'alabaster earring',
        Body = 'shamash robe',
        Hands = 'azimuth gloves +2',
        Ring2 = 'Defending Ring',
        Ring1 = 'murky Ring',
        Back = 'null shawl',
        Waist = 'carrier\'s sash',
        Legs = 'Nyame Flanchard',
        Feet = 'nyame sollerets',
    },

    Tp_Default = {
        Main = 'idris',
        Sub = 'Ammurapi Shield',
        Range = 'Dunna',
		ammo = 'remove',
        Head = 'nyame helm',
        Neck = 'Sanctity Necklace',
        Ear2 = 'brutal Earring',
        Ear1 = 'alabaster Earring',
        Body = 'nyame mail',
        Hands = 'nyame gauntlets',
        Ring2 = 'Chirich Ring +1',
        Ring1 = 'murky Ring',
        Back = { Name = 'Nantosuelta\'s Cape', Augment = { [1] = 'Mag. Evasion+30', [2] = 'HP+60', [3] = 'Pet: "Regen"+15', [4] = 'Evasion+20' } },
        Waist = 'cornelia\'s belt',
        Legs = 'nyame flanchard',
        Feet = 'nyame sollerets',
    },
    Tp_Hybrid = {
    },
    Tp_Acc = {
        --Head = 'Blistering Sallet +1',
        --Ear1 = 'Mache Earring +1',
        --Ring1 = 'Cacoethic Ring +1',
        --Ring2 = 'Chirich Ring +1',
        --Back = 'Aurist\'s Cape +1',
    },


    Precast = {
        Main = 'idris',
		sub = 'chanter\'s shield',--3
        Range = 'Dunna',--3
		ammo = 'remove',
        Head = 'volte beret',--6
        Neck = 'voltsurge torque',--4
        Ear1 = 'loquac. Earring',--2
        Ear2 = 'malignance earring',--4
        Body = 'indomitable coat',--10
        Hands = 'volte gloves',--6
        Ring2 = 'Kishar Ring',--4
        Ring1 = 'weather. ring',--5
        Back = 'fi follet cape +1',--10
        Waist = 'witful belt',--3
        Legs = 'geo. pants +4',--15
        Feet = 'indom. sabots',--4
    },
    Cure_Precast = {
		Ear2 = 'Mendi. Earring',
    },
    Enhancing_Precast = {
        Waist = 'Siegel Sash',
    },
    Stoneskin_Precast = {
        Head = 'Umuthi Hat',
        --Hands = 'Carapacho Cuffs',
        Waist = 'Siegel Sash',
    },

	
    Cure = {--I cap is 50, II cap is 30
        Main = 'bunzi\'s rod',--30
        Sub = 'genmei Shield',
		head = 'nyame helm',
        Neck = 'loricate torque +1',
        Ear1 = 'alabaster earring',
        Ear2 = 'mendi. Earring',--5
		body = 'annoint. kalasiris',--10
        Hands = 'nyame gauntlets',
        Ring2 = 'gurebu\'s ring',
        Ring1 = 'murky ring',
        Back = 'Solemnity cape',--7
        Waist = 'witful belt',
		legs = 'geo. pants +4',
        Feet = 'nyame sollerets',
    },
    Self_Cure = {--cap 30
        Waist = 'Gishdubar Sash',
    },
    Regen = {
        Main = 'Bolelabunga',
        Sub = 'Ammurapi Shield',
        Body = 'Telchine Chas.',
        Waist = 'Embla Sash',
        Legs = 'Telchine Braconi',
        Feet = 'Telchine Pigaches',
    },
    Cursna = {
		neck = 'debilis medallion',
        Ring1 = 'haoma\'s Ring',
		Waist = 'Gishdubar Sash',
        Feet = 'Vanya Clogs',
    },

    Enhancing = {
        Main = 'Bunzi\'s Rod',
        Sub = 'Ammurapi Shield',
        Ammo = 'Pemphredo Tathlum',
        Head = 'telchine Cap',
        Neck = 'Incanter\'s Torque',
        Ear2 = 'Mendi. Earring',
        Ear1 = 'Andoaa Earring',
        Body = 'Telchine Chas.',
        Hands = 'Nyame Gauntlets',
        Ring2 = 'stikini ring +1',
        Ring1 = 'murky ring',
        Back = 'Solemnity Cape',
        Waist = 'Embla Sash',
        Legs = 'Telchine Braconi',
        Feet = 'Telchine Pigaches',
    },
    Stoneskin = {
        Neck = 'Nodens Gorget',
        Waist = 'Siegel Sash',
    },
    Phalanx = {},
    Refresh = {
		Waist = 'Gishdubar Sash',
    },
    Geomancy = { --900 skill, then indi duration, then CMP
        Main = 'idris',
        Range = 'Dunna',
		ammo = 'remove',
        Head = 'azimuth hood +3',
        Neck = 'Bagua Charm +2',
        Ear2 = 'Mendi. Earring',
		ear1 = 'alabaster earring',
        Body = 'bagua tunic +3',
        Hands = 'Geo. Mitaines +4',--15
        Ring2 = 'Stikini Ring +1',--8
        Ring1 = 'weather. Ring',
		Back = 'lifestream cape',
		waist = 'embla sash',
        --Waist = 'Hachirin-no-Obi',
        Legs = 'geo. pants +4',
        Feet = 'azimuth gaiters +2',
    },
    Indi = { --900 skill, then indi duration, then CMP
        Main = 'idris',
        Range = 'Dunna',
		ammo = 'remove',
        Head = 'azimuth hood +3',
        Neck = 'Bagua Charm +2',
        Ear2 = 'Mendi. Earring',
		ear1 = 'alabaster earring',
        Body = 'bagua tunic +3',
        Hands = 'Geo. Mitaines +4',--15
        Ring2 = 'Stikini Ring +1',--8
        Ring1 = 'weather. Ring',
		Back = 'lifestream cape',
		waist = 'embla sash',
        --Waist = 'Hachirin-no-Obi',
        Legs = 'bagua pants +4',
        Feet = 'azimuth gaiters +2',
    },

    Enfeebling = {
        Main = 'Bunzi\'s Rod',
        Sub = 'Ammurapi Shield',
        Ammo = 'Pemphredo Tathlum',
        Head = 'azimuth hood +3',
        Neck = 'Erra Pendant',
        --Ear1 = 'Regal Earring',--use this when u upgrade the AF
        Ear1 = 'Digni. Earring',
        Ear2 = 'Malignance Earring',
        Body = 'Agwu\'s Robe',
        Hands = 'Nyame Gauntlets',
        Ring2 = 'Stikini Ring +1',
        Ring1 = 'weather. Ring',
        Back = 'Aurist\'s Cape +1',
        Waist = 'Acuity Belt +1',
        Legs = 'Agwu\'s Slops',
        Feet = 'Medium\'s Sabots',
    },
    Macc = {
        Main = 'Bunzi\'s Rod',
        Sub = 'Ammurapi Shield',
        Ammo = 'Pemphredo Tathlum',
        Head = 'Nyame Helm',
        Neck = 'Erra Pendant',
        --Ear1 = 'Regal Earring',--use this when u upgrade the AF
        Ear1 = 'Digni. Earring',
        Ear2 = 'Malignance Earring',
        Body = 'Agwu\'s Robe',
        Hands = 'Nyame Gauntlets',
        Ring2 = 'Stikini Ring +1',
        Ring1 = 'Metamor. Ring +1',
        Back = 'Aurist\'s Cape +1',
        Waist = 'Acuity Belt +1',
        Legs = 'Agwu\'s Slops',
        Feet = 'Agwu\'s Pigaches',
    },

    Drain = {
        Main = 'Bunzi\'s Rod',
        Sub = 'Ammurapi Shield',
        Ammo = 'Pemphredo Tathlum',
        Head = 'Bagua Galero +1',
        Neck = 'Erra Pendant',
        Ear1 = 'Regal Earring',
        Ear2 = 'Malignance Earring',
        Body = 'Agwu\'s Robe',
        Ring1 = 'Kishar Ring',
        Ring2 = 'Metamor. Ring +1',
        Back = 'Aurist\'s Cape +1',
        Waist = 'Fucho-no-Obi',
        Legs = 'Agwu\'s Slops',
        Feet = 'Agwu\'s Pigaches',
    },

    Nuke = {
        Main = 'Bunzi\'s rod',
        Sub = 'Ammurapi Shield',
        ammo = 'hydrocera',
        Head = 'Azimuth Hood +3',
        Neck = 'sibyl scarf',
        Ear1 = 'lugalbanda Earring',
        Ear2 = 'Malignance Earring',
        Body = 'Azimuth Coat +2',
        Hands = 'azimuth gloves +2',
        Ring2 = 'stikini ring +1',
        Ring1 = 'Metamor. Ring +1',
        Back = { Name = 'Nantosuelta\'s Cape', Augment = { [1] = '"Mag. Atk. Bns."+10', [2] = 'INT+30', [3] = 'Mag. Acc.+20', [4] = 'Pet: Damage taken -5%', [5] = 'Magic Damage+20' } },
        Waist = 'null Belt',
        Legs = 'bagua pants +4',
        Feet = 'azimuth gaiters +2',
    },
    NukeACC = {
        Waist = 'Acuity Belt +1',
    },
    Burst = {
        Main = 'Bunzi\'s Rod', --10 and 0
        Sub = 'Ammurapi Shield',
        Head = 'Ea Hat', -- 6 and 6
        Body = 'Ea Houppelande', -- 8 and 8
        Hands = 'Amalric Gages +1', -- 0 and 6
        Ring2 = 'Mujin Band', -- 0 and 5
        Waist = 'Acuity Belt +1',
        Legs = 'Agwu\'s Slops', -- 9 and 0
        Feet = 'Ea Pigaches', -- 4 and 4
    },
    Mp_Body = {Body = 'Seidr Cotehardie',},

    Preshot = {
    },
    Midshot = {
        Ear1 = 'Telos Earring',
        Ear2 = 'Crep. Earring',
    },

    Ws_Default = {
        Ammo = 'oshasha\'s treatise',
        Head = 'Nyame Helm',
        Neck = 'rep. plat. medal',
        Ear1 = 'ishvara Earring',
        Ear2 = 'alabaster Earring',
        Body = 'egbesu frock',
        Hands = 'Jhakri Cuffs +2',
        Ring1 = 'gurebu\'s ring',
        Ring2 = 'metamor. ring +1',
        Back = { Name = 'Nantosuelta\'s Cape', Augment = { [1] = 'Pet: Damage taken -5%', [2] = 'Accuracy+30', [3] = 'Attack+20', [4] = 'MND+20', [5] = 'Weapon skill damage +10%' } },
        Waist = 'cornelia\'s belt',
        Legs = 'Nyame Flanchard',
        Feet = 'Nyame Sollerets',
    },
    Ws_Hybrid = {
    },
    Ws_Acc = {
    },
	
	BH_Default = {
        Ammo = 'Oshasha\'s Treatise',
        Head = 'Nyame Helm',
        Neck = 'rep. plat. medal',
        Ear1 = 'ishvara Earring',
		Ear2 = 'alabaster earring',
        Body = 'egbesu frock',
        Hands = 'jhakri cuffs +2',
        Ring1 = 'gurebu\'s Ring',
        Ring2 = 'Metamor. Ring +1',
        Back = { Name = 'Nantosuelta\'s Cape', Augment = { [1] = 'Pet: Damage taken -5%', [2] = 'Accuracy+30', [3] = 'Attack+20', [4] = 'MND+20', [5] = 'Weapon skill damage +10%' } },
        Waist = 'cornelia\'s belt',
        Legs = 'Nyame Flanchard',
        Feet = 'Nyame Sollerets',
    },
    BH_Hybrid = {
        Ammo = 'Crepuscular Pebble',
        Neck = 'Null Loop',
        Waist = 'Fotia Belt',
    },
    BH_Acc = {
    },
    Aedge_Default = {
        Ammo = 'Pemphredo Tathlum',
        Head = 'nyame helm',
        Neck = 'Baetyl Pendant',
        Ear1 = 'Regal Earring',
        Ear2 = 'Malignance Earring',
        Body = 'egbesu frock',
        Hands = 'Jhakri Cuffs +2',
        Ring1 = 'Shiva Ring +1',
        Ring2 = 'Karieyh Ring +1',
        Waist = 'Eschan Stone',
        Legs = 'Nyame Flanchard',
        Feet = 'Nyame Sollerets',
    },
    Aedge_Hybrid = {
    },
    Aedge_Acc = {
    },
    -- Exudation (Idris): physical, attack varies with TP (FFXIclopedia). Stat mods not published
    -- on FFXIclopedia/BG snippets I could reach, so this starts as Ws_Default; tune it.
    Exudation_Default = {
        Ammo = 'oshasha\'s treatise',
        Head = 'Nyame Helm',
        Neck = 'rep. plat. medal',
        Ear1 = 'ishvara Earring',
        Ear2 = 'alabaster Earring',
        Body = 'egbesu frock',
        Hands = 'Jhakri Cuffs +2',
        Ring1 = 'gurebu\'s ring',
        Ring2 = 'metamor. ring +1',
        Back = { Name = 'Nantosuelta\'s Cape', Augment = { [1] = 'Pet: Damage taken -5%', [2] = 'Accuracy+30', [3] = 'Attack+20', [4] = 'MND+20', [5] = 'Weapon skill damage +10%' } },
        Waist = 'cornelia\'s belt',
        Legs = 'Nyame Flanchard',
        Feet = 'Nyame Sollerets',
    },
    Exudation_Hybrid = {
    },
    Exudation_Acc = {
    },
    -- Judgment: physical single hit, STR + MND mods, damage varies with TP. Same profile as Black Halo.
    Judgment_Default = {
        Ammo = 'Oshasha\'s Treatise',
        Head = 'Nyame Helm',
        Neck = 'rep. plat. medal',
        Ear1 = 'ishvara Earring',
        Ear2 = 'alabaster earring',
        Body = 'egbesu frock',
        Hands = 'jhakri cuffs +2',
        Ring1 = 'gurebu\'s Ring',
        Ring2 = 'Metamor. Ring +1',
        Back = { Name = 'Nantosuelta\'s Cape', Augment = { [1] = 'Pet: Damage taken -5%', [2] = 'Accuracy+30', [3] = 'Attack+20', [4] = 'MND+20', [5] = 'Weapon skill damage +10%' } },
        Waist = 'cornelia\'s belt',
        Legs = 'Nyame Flanchard',
        Feet = 'Nyame Sollerets',
    },
    Judgment_Hybrid = {
    },
    Judgment_Acc = {
    },
    -- Shining Strike / Seraph Strike: magical, light, STR + MND mods; INT still counts (dINT term).
    -- Starts as your Aedge (MAB) set. Obi/Orpheus added by the engine (both are in ElementalWS).
    Strike_Default = {
        Ammo = 'Pemphredo Tathlum',
        Head = 'nyame helm',
        Neck = 'Baetyl Pendant',
        Ear1 = 'Regal Earring',
        Ear2 = 'Malignance Earring',
        Body = 'egbesu frock',
        Hands = 'Jhakri Cuffs +2',
        Ring1 = 'Shiva Ring +1',
        Ring2 = 'Karieyh Ring +1',
        Waist = 'Eschan Stone',
        Legs = 'Nyame Flanchard',
        Feet = 'Nyame Sollerets',
    },
    Strike_Hybrid = {
    },
    Strike_Acc = {
    },

    Bolster = {Body = 'Bagua Tunic +3'},
	fc = {head = 'Azimuth Hood +3',
		  body = 'geo. tunic +4',},	
    TH = {
        Ammo = 'Per. Lucky Egg',
		Waist = 'Chaac Belt',
	},
    Movement = {
        Feet = 'Geo. Sandals +4',
	},
    Absorb = {}, -- every Absorb- spell (land rate: Dark Magic skill, macc; potency is not skill)
    Absorb_TP = {}, -- Absorb-TP on top of Absorb
};	
profile.Sets = sets;

profile.Packer = {
    --{Name = 'Tropical Crepe', Quantity = 'all'},
    --{Name = 'Rolan. Daifuku', Quantity = 'all'},
};

profile.OnLoad = function()
	gSettings.AllowAddSet = true;
    gcinclude.WeaponModes = {'None', 'Idris', 'Maxentius', 'Tishtrya'};
    gcinclude.DefaultWeapons = 'Idris';
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
    local pet = gData.GetPet();

    gFunc.EquipSet(sets.Idle);

    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.Tp_Default)
        if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
			gFunc.EquipSet('Tp_' .. gcdisplay.GetCycle('MeleeSet')) end
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    elseif (player.IsMoving == true) then
		gFunc.EquipSet(sets.Movement);
    end
	
    -- job layers go before CheckDefault so engine layers (weapons, mdt/Aminon, Hoxne, TH, received, buffs, XIRoll) sit on top
    if (pet ~= nil) and (player.Status ~= 'Engaged') then
        gFunc.EquipSet(sets.Idle_Pet);
    end
    if (gcdisplay.GetToggle('DTset') == true) then gFunc.EquipSet(sets.Dt) end;
    if (gcdisplay.GetToggle('Kite') == true) then gFunc.EquipSet(sets.Movement) end;
	if (player.IsMoving == true) then gFunc.EquipSet(sets.Movement) end;
    gcinclude.CheckDefault ();
end

profile.HandleAbility = function()
    local ability = gData.GetAction();

    if string.match(ability.Name, 'Full Circle') then gFunc.EquipSet(sets.fc) end --lazy way to ensure the empy head piece is in on use
    if string.match(ability.Name, 'Bolster') then gFunc.EquipSet(sets.Bolster) end

    gcinclude.CheckCancels();
end

profile.HandleItem = function()
    local item = gData.GetAction();

	if string.match(item.Name, 'Holy Water') then gFunc.EquipSet(gcinclude.sets.Holy_Water) end
end

profile.HandlePrecast = function()
    local spell = gData.GetAction();

    gFunc.EquipSet(sets.Precast)

    if (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(sets.Enhancing_Precast);
        if string.contains(spell.Name, 'Stoneskin') then
            gFunc.EquipSet(sets.Stoneskin_Precast);
        end
    elseif (spell.Skill == 'Healing Magic') then
        gFunc.EquipSet(sets.Cure_Precast);
    end
	
    gcinclude.CheckCancels();
end

profile.HandleMidcast = function()
    local player = gData.GetPlayer();
    local weather = gData.GetEnvironment();
    local spell = gData.GetAction();
    local target = gData.GetActionTarget();
    local me = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0);

    if (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(sets.Enhancing);

        if string.match(spell.Name, 'Phalanx') then
            gFunc.EquipSet(sets.Phalanx);
        elseif string.match(spell.Name, 'Stoneskin') then
            gFunc.EquipSet(sets.Stoneskin);
        elseif string.contains(spell.Name, 'Regen') then
            gFunc.EquipSet(sets.Regen);
        elseif string.contains(spell.Name, 'Refresh') then
            gFunc.EquipSet(sets.Refresh);
        end
    elseif (spell.Skill == 'Healing Magic') then
        gFunc.EquipSet(sets.Cure);
        if (target.Name == me) then
            gFunc.EquipSet(sets.Self_Cure);
        end
        if string.match(spell.Name, 'Cursna') then
            gFunc.EquipSet(sets.Cursna);
        end
    elseif (spell.Skill == 'Elemental Magic') then
        gFunc.EquipSet(sets.Nuke);

        if (gcdisplay.GetCycle('NukeSet') == 'Macc') then
            gFunc.EquipSet(sets.NukeACC);
        end
        if gcinclude.BurstWanted() then
            gFunc.EquipSet(sets.Burst);
        end
        if (player.MPP <= 40) then
            gFunc.EquipSet(sets.Mp_Body);
        end
    elseif (spell.Skill == 'Enfeebling Magic') then
        gFunc.EquipSet(sets.Enfeebling);
        if (gcdisplay.GetCycle('NukeSet') == 'Macc') then
            gFunc.EquipSet(sets.Macc);
        end
    elseif (spell.Skill == 'Dark Magic') then
        gFunc.EquipSet(sets.Macc);
        if (string.contains(spell.Name, 'Aspir') or string.contains(spell.Name, 'Drain')) then
            gFunc.EquipSet(sets.Drain);
        end
    elseif (spell.Skill == 'Geomancy') then
        gFunc.EquipSet(sets.Geomancy);
        if (string.contains(spell.Name, 'Indi')) then
            gFunc.EquipSet(sets.Indi);
        end
    end
	if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
end

profile.HandlePreshot = function()
    gFunc.EquipSet(sets.Preshot);
end

profile.HandleMidshot = function()
    gFunc.EquipSet(sets.Midshot);
	if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
end

profile.HandleWeaponskill = function()
    local canWS = gcinclude.CheckWsBailout();
    if (canWS == false) then gFunc.CancelAction() return;
    else
        local ws = gData.GetAction();
    
        gFunc.EquipSet(sets.Ws_Default)
        if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
        gFunc.EquipSet('Ws_' .. gcdisplay.GetCycle('MeleeSet')) end

        if string.match(ws.Name, 'Black Halo') then
            gFunc.EquipSet(sets.BH_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('BH_' .. gcdisplay.GetCycle('MeleeSet')); end
        elseif string.match(ws.Name, 'Aeolian Edge') then
            gFunc.EquipSet(sets.Aedge_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Aedge_' .. gcdisplay.GetCycle('MeleeSet')); end
        elseif (ws.Name == 'Exudation') then
            gFunc.EquipSet(sets.Exudation_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Exudation_' .. gcdisplay.GetCycle('MeleeSet')); end
        elseif (ws.Name == 'Judgment') then
            gFunc.EquipSet(sets.Judgment_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Judgment_' .. gcdisplay.GetCycle('MeleeSet')); end
        elseif (ws.Name == 'Shining Strike') or (ws.Name == 'Seraph Strike') then
            gFunc.EquipSet(sets.Strike_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Strike_' .. gcdisplay.GetCycle('MeleeSet')); end
        end
    end
end

return profile;
