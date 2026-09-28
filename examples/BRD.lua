local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');

local sets = {
    Midshot = {
    },
    Preshot = {
    },
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
    Weapon_Carnwenhan = {
        Main = 'Carnwenhan',
        Sub = 'Fusetto +2',
    },
    Weapon_Carnwenhan_1h = {
        Main = 'Carnwenhan',
        Sub = 'Genmei Shield',
    },
    Weapon_CarnwenhanAcc = {
        Main = 'Carnwenhan',
        Sub = 'Gleti\'s Knife',
    },
    Weapon_CarnwenhanAcc_1h = {
        Main = 'Carnwenhan',
        Sub = 'Genmei Shield',
    },
    Weapon_Naegling = {
        Main = 'Naegling',
        Sub = 'Fusetto +2',
    },
    Weapon_Naegling_1h = {
        Main = 'Naegling',
        Sub = 'Genmei Shield',
    },
    Weapon_Hoxne = {
        Range = 'remove',
        Ammo = 'Hoxne Ampulla',
    },
    SIR = {
        Head = 'fili calot +3',
        Neck = 'warder\'s charm +1',
        Ear1 = 'alabaster earring',
		Ear2 = 'hearty earring',
        Body = 'adamantite armor',
        Hands = 'Nyame Gauntlets',
        Ring1 = 'murky Ring',
        Ring2 = 'shadow ring',
        Back = 'shadow mantle',
		waist = 'carrier\'s sash',
		legs = 'fili rhingrave +3',
        Feet = 'nyame sollerets',	
    },
    ['Idle'] = {
        Main = 'Carnwenhan',
        Sub = 'ammurapi Shield',
        Range = 'loughnashade',
        Head = 'fili calot +3',
        Neck = 'warder\'s charm +1',
        Ear1 = 'alabaster earring',
		Ear2 = 'hearty earring',
        Body = 'adamantite armor',
        Hands = 'Nyame Gauntlets',
        Ring1 = 'murky Ring',
        Ring2 = 'shadow ring',
        Back = 'shadow mantle',
		waist = 'carrier\'s sash',
		legs = 'fili rhingrave +3',
        Feet = 'nyame sollerets',	
    },
    Resting = {},
    Idle_Regen = {
        Neck = 'null loop',
        Ear1 = 'Infused Earring',
        Ring1 = 'Chirich Ring +1',
    },
    Idle_Refresh = {
        --Legs = 'Assid. Pants +1',
        --Feet = 'Volte Gaiters',
    },
    Town = {
        Main = 'Carnwenhan',
        Sub = 'Ammurapi Shield',
        Range = 'loughnashade',
        Head = 'nyame helm',
        Neck = 'warder\'s charm +1',
        Body = 'adamantite armor',
        Hands = 'brioso cuffs +4',
        Back = 'shadow mantle',
        Legs = 'revelation brais',
        Feet = 'revelation sab.',
    },

    Dt = {
        Head = 'fili calot +3',
        Neck = 'warder\'s charm +1',
        Ear1 = 'alabaster earring',
        ear2 = 'eabani Earring',
        Body = 'adamantite armor',
        Hands = 'Nyame Gauntlets',
        Ring1 = 'fortified ring',
        Ring2 = 'shadow ring',
        Back = 'shadow mantle',
        Waist = 'carrier\'s sash',
        Legs = 'Nyame Flanchard',
        Feet = 'Nyame Sollerets',
    },

    Tp_Default = {
		Main = 'naegling',
        Sub = 'fusetto +2',
        Range = { Name = 'Linos', Augment = { [1] = 'Accuracy+13', [2] = '"Store TP"+4', [3] = 'Attack+13', [4] = 'Quadruple Attack +3' } },
        Head = 'perfection masque',
        Neck = 'Bard\'s Charm +2',
        Ear1 = 'Telos Earring',
        Ear2 = 'eabani Earring',
        Body = 'perfection plate.',
        Hands = 'Bunzi\'s gloves',
        Ring2 = 'Moonlight Ring',
        Ring1 = 'Chirich Ring +1',
        Back = 'null shawl',
        Waist = 'reiki yotai',
        Legs = 'revelation brais',
        Feet = 'revelation sab.',
    },
    Tp_Hybrid = {
		sub = 'genmei shield',
		ammo = 'hoxne ampulla',
		ear2 = 'cessance earring',
		waist = 'sailfi belt +1',
    },
    Tp_Acc = {
        main = 'carnwenhan',
		sub = 'gleti\'s knife',
    },


    Precast = { --74
        Main = 'Carnwenhan',
        Sub = 'Kali',
        Range = 'loughnashade',
        Head = 'Bunzi\'s Hat', --10
        Neck = 'voltsurge torque',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Etiolation Earring', --2
		Body = 'Inyanga Jubbah +2', --14
        Hands = 'leyline gloves', --6
        Ring1 = 'weather. Ring',
        Ring2 = 'Kishar Ring', --5
        Back = 'fi follet cape +1',
        Waist = 'witful belt', --3
        Legs = 'volte brais',
        Feet = 'Fili Cothurnes +3',
    },
    Cure_Precast = {
        Ear2 = 'Mendi. Earring',
        Feet = 'Vanya Clogs',
    },
    Enhancing_Precast = {
        Waist = 'Siegel Sash',
    },
    Stoneskin_Precast = {
        Head = 'Umuthi Hat',
		neck = 'stone gorget',
        Waist = 'Siegel Sash',
		legs = 'haven hose',
    },
    Song_Precast = { --87
		Main = 'Carnwenhan',
		Sub = 'Kali',
		Range = 'loughnashade',
        Head = 'Fili Calot +3', --14
        Neck = 'voltsurge torque',
        Ear1 = 'loquac. earring',
        Ear2 = 'Etiolation earring',
		Body = 'Inyanga Jubbah +2', --14
		Hands = 'Gende. Gages +1', --6
        Ring1 = 'weather. Ring',
        Ring2 = 'Kishar Ring', --5
        Back = 'fi follet cape +1',
        Waist = 'witful belt', --3
		Legs = 'Kaykaus tights +1', --6
        Feet = 'Fili Cothurnes +3',
    },

	Honor_Precast = { --87
        Main = 'Carnwenhan',
		Sub = 'Kali',
		Range = 'Marsyas',
        Head = 'Fili Calot +3', --14
        Neck = 'voltsurge torque',
        Ear1 = 'loquac. earring',
        Ear2 = 'Etiolation earring',
		Body = 'Inyanga Jubbah +2', --14
		Hands = 'Gende. Gages +1', --7
        Ring1 = 'weather. Ring',
        Ring2 = 'Kishar Ring', --5
        Back = 'fi follet cape +1',
        Waist = 'witful belt', --3
		Legs = 'Kaykaus tights +1', --7
        Feet = 'Fili Cothurnes +3',
    },

	Aria_Precast = { --87
        Main = 'Carnwenhan',
		Sub = 'Kali',
		Range = 'Loughnashade',
        Head = 'Fili Calot +3', --14
        Neck = 'voltsurge torque',--4
        Ear1 = 'loquac. earring', --2
        Ear2 = 'etiolation Earring', --2
		Body = 'Inyanga Jubbah +2', --14
		Hands = 'Gende. Gages +1', --7
        Ring1 = 'weather. Ring',--2
        Ring2 = 'Kishar Ring', --5
        Back = 'fi follet cape +1',
        Waist = 'witful belt', --3
		Legs = 'Kaykaus tights +1', --7
        Feet = 'Fili Cothurnes +3',--13
    },
	
    Cure = {--I cap is 50, II cap is 30
       --Main = 'Bunzi\'s Rod',--I 30
        Sub = 'Ammurapi Shield',
        Ammo = 'Pemphredo Tathlum',
        Neck = 'Nodens Gorget',--I 5
        Ear1 = 'Mendi. Earring',--I 5
        Ear2 = 'Regal Earring',
        Hands = 'Nyame Gauntlets',
        Ring2 = 'Stikini Ring +1',
        Ring1 = 'Metamor. Ring +1',
        Back = 'Solemnity Cape',
		Legs = 'Kaykaus tights +1', --7
        Waist = 'Rumination Sash',
        Feet = 'Vanya Clogs',--I 10
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
        Ring1 = 'Purity Ring',
		Waist = 'Gishdubar Sash',
        Feet = 'Vanya Clogs',
    },

    Enhancing = {
        Head = 'Befouled Crown',
        Neck = 'Incanter\'s Torque',
        Ear2 = 'Mendi. Earring',
        Ear1 = 'Andoaa Earring',
        Body = 'Telchine Chas.',
        Hands = 'Nyame Gauntlets',
        Ring1 = 'murky Ring',
        Ring2 = 'Metamor. Ring +1',
        Back = 'Solemnity Cape',
        Waist = 'witful belt',
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

    Enfeebling = { --abs-tp
        Sub = 'Ammurapi Shield',
        Head = 'bunzi\'s hat',
        Neck = 'voltsurge torque',
        Ear1 = 'alabaster Earring',
        Ear2 = 'regal Earring',
        Body = 'inyanga jubbah +2',
        Hands = 'leyline gloves',
        Ring1 = 'weather. ring',
        Ring2 = 'stikini ring +1',
        Back = 'null shawl',
        Waist = 'null belt',
        Legs = 'volte brais',
        Feet = 'fili cothurnes +3',
    },

    Wind = {
        Main = 'Carnwenhan',
		Sub = 'Ammurapi Shield',
        Range = 'loughnashade',
        Head = 'Brioso Roundlet +2',
        Neck = 'Mnbw. Whistle +1',
        Ear1 = 'loquac. earring',
        Ear2 = 'Etiolation Earring',
        Body = 'Fili Hongreline +3',
        Hands = 'Brioso Cuffs +2',
        Ring2 = 'Stikini Ring +1',
        Ring1 = 'kishar ring',
        Back = 'fi follet cape +1',
        Waist = 'witful belt',
        Legs = 'Fili Rhingrave +3',
        Feet = 'Brioso Slippers +4',
    },
	Aria = {
        Main = 'Carnwenhan',
		sub = 'Kali',
        Range = 'Loughnashade',
        Head = 'Fili Calot +3',
        Neck = 'Mnbw. Whistle +1',
        Ear1 = 'loquac. earring',
        Ear2 = 'Etiolation Earring',
        Body = 'Fili Hongreline +3',
        Hands = 'Fili Manchettes +3',
        Ring2 = 'Stikini Ring +1',
        Ring1 = 'kishar ring',
        Back = 'fi follet cape +1',
        Waist = 'witful belt',
        Legs = 'Inyanga Shalwar +2',
        Feet = 'Brioso Slippers +4',
    },
	Honor = {
        Main = 'Carnwenhan',
		sub = 'kali',
        Range = 'Marsyas',
        Head = 'Fili Calot +3',
        Neck = 'Mnbw. Whistle +1',
        Ear1 = 'loquac. earring',
        Ear2 = 'Etiolation Earring',
        Body = 'Fili Hongreline +3',
        Hands = 'Fili Manchettes +3',
        Ring2 = 'Stikini Ring +1',
        Ring1 = 'kishar ring',
        Back = 'fi follet cape +1',
        Waist = 'witful belt',
        Legs = 'Inyanga Shalwar +2',
        Feet = 'Brioso Slippers +4',
    },
    Harp = {--use /forcestring in game to lock this on all songs, I personally just use Paeons
        Range = 'Daurdabla', -- This should be ur extra song harp, whichever you use
	},
	
	
	
    Foe = {
        Main = 'Carnwenhan',
		Sub = 'Ammurapi Shield',
        Range = 'Marsyas',
        Head = 'Brioso Roundlet +2',
        Neck = 'Mnbw. Whistle +1',
        Ear2 = 'regal earring',
        Ear1 = 'fili Earring +1',
        Body = 'Fili Hongreline +3',
        Hands = 'Brioso Cuffs +4',
		Ring1 = 'stikini ring +1',
        Ring2 = 'stikini ring +1',
        Back = 'null shawl',
        Waist = 'null belt',
        Legs = 'Inyanga Shalwar +2',
        Feet = 'Bihu Slippers +4',
    },
    Horde = {
        Main = 'Carnwenhan',
        Sub = 'Ammurapi Shield',
        Range = 'Daurdabla',
        Head = 'Brioso Roundlet +2',
        Neck = 'Mnbw. Whistle +1',
		Ear1 = 'Gersemi Earring',
        Ear2 = 'Regal Earring',
        Body = 'Brioso Justau. +2',
        Hands = 'Inyan. Dastanas +2',
		Ring1 = 'stikini ring +1',
        Ring2 = 'stikini ring +1',
        Back = 'null shawl',
        Waist = 'Harfner\'s Sash',
        Legs = 'Inyanga Shalwar +2',
        Feet = 'Bihu Slippers +4',
    },
    Buff = {
        Main = 'Carnwenhan',
        Sub = 'Kali',
        Range = 'loughnashade',
        Head = 'Fili Calot +3',
        Neck = 'Mnbw. Whistle +1',
        Ear1 = 'loquac. earring',
        Ear2 = 'etiolation Earring',
        Body = 'Fili Hongreline +3',
        Hands = 'Fili Manchettes +3',
        Ring1 = 'murky Ring',
        Ring2 = 'Moonlight Ring',
        Back = 'fi follet cape +1',
        Waist = 'witful belt',
        Legs = 'Inyanga Shalwar +2',
        Feet = 'Brioso Slippers +4',
    },
    Paeon = {
        Main = 'Carnwenhan',
        Sub = 'Kali',
        Range = 'loughnashade',
		Ear1 = 'loquac. earring',
        Ear2 = 'Etiolation Earring',
        Ring1 = 'murky Ring',
		Ring2 = 'kishar Ring',
        Back = 'fi follet cape +1',
        Waist = 'witful belt',
        Legs = 'Inyanga Shalwar +2',
        Feet = 'Fili Cothurnes +3',
    },
	Dummy = {--you can also use /forcestring if you want
        Main = 'Carnwenhan',
		Sub = 'Ammurapi Shield',
        Range = 'Daurdabla',
        Ear1 = 'loquac. earring',
        Ear2 = 'Etiolation Earring',
        Ring1 = 'murky Ring',
		Ring2 = 'kishar Ring',
        Back = 'fi follet cape +1',
        Waist = 'witful belt',
        Legs = 'Inyanga Shalwar +2',
        Feet = 'Fili Cothurnes +3',
    },
    March = {
		Main = 'Carnwenhan',
        Sub = 'Kali',
        Range = 'loughnashade',
        Head = 'Fili Calot +3',
        Neck = 'Mnbw. Whistle +1',
        Ear1 = 'loquac. earring',
        Ear2 = 'etiolation Earring',
        Body = 'Fili Hongreline +3',
        Hands = 'Fili Manchettes +3',
        Ring1 = 'murky Ring',
        Ring2 = 'Moonlight Ring',
        Back = 'fi follet cape +1',
        Waist = 'witful belt',
        Legs = 'Inyanga Shalwar +2',
        Feet = 'Brioso Slippers +4',
		},

    Madrigal = {
        Main = 'Carnwenhan',
        Sub = 'Kali',
        Range = 'loughnashade',
        Head = 'Fili Calot +3',
        Neck = 'Mnbw. Whistle +1',
        Ear1 = 'loquac. earring',
        Ear2 = 'etiolation Earring',
        Body = 'Fili Hongreline +3',
        Hands = 'Fili Manchettes +3',
        Ring1 = 'murky Ring',
        Ring2 = 'Moonlight Ring',
        Back = 'fi follet cape +1',
        Waist = 'witful belt',
        Legs = 'Inyanga Shalwar +2',
        Feet = 'Brioso Slippers +4',
    },
    Ballad = {
		Main = 'Carnwenhan',
        Sub = 'Kali',
        Range = 'loughnashade',
        Head = 'Fili Calot +3',
        Neck = 'Mnbw. Whistle +1',
        Ear1 = 'loquac. earring',
        Ear2 = 'etiolation Earring',
        Body = 'Fili Hongreline +3',
        Hands = 'Fili Manchettes +3',
        Ring1 = 'murky Ring',
        Ring2 = 'defending Ring',
        Back = 'fi follet cape +1',
        Waist = 'witful belt',
        Legs = 'Inyanga Shalwar +2',
        Feet = 'Brioso Slippers +4',
    },
	Mambo = {
		Main = 'Carnwenhan',
        Sub = 'Kali',
        Range = 'loughnashade',
        Head = 'Fili Calot +3',
        Neck = 'Mnbw. Whistle +1',
        Ear1 = 'loquac. earring',
        Ear2 = 'etiolation Earring',
        Body = 'Fili Hongreline +3',
        Hands = 'Fili Manchettes +3',
        Ring1 = 'murky Ring',
        Ring2 = 'defending Ring',
        Back = 'fi follet cape +1',
        Waist = 'witful belt',
        Legs = 'Inyanga Shalwar +2',
        Feet = 'Mou. Crackows +1',
    },
	
	Etude = {
        Main = 'Carnwenhan',
        Sub = 'Kali',
        Range = 'loughnashade',
        Head = 'Mousai turban',
        Neck = 'Mnbw. Whistle +1',
        Ear1 = 'loquac. earring',
        Ear2 = 'etiolation Earring',
        Body = 'Fili Hongreline +3',
        Hands = 'Fili Manchettes +3',
        Ring1 = 'murky Ring',
        Ring2 = 'Moonlight Ring',
        Back = 'fi follet cape +1',
        Waist = 'witful belt',
        Legs = 'Inyanga Shalwar +2',
        Feet = 'Brioso Slippers +4',
    },
    Scherzo = {
		Main = 'Carnwenhan',
        Sub = 'Kali',
        Range = 'loughnashade',
        Head = 'Fili Calot +3',
        Neck = 'Mnbw. Whistle +1',
        Ear1 = 'loquac. earring',
        Ear2 = 'etiolation Earring',
        Body = 'Fili Hongreline +3',
        Hands = 'Fili Manchettes +3',
        Ring1 = 'murky Ring',
        Ring2 = 'Moonlight Ring',
        Back = 'fi follet cape +1',
        Waist = 'witful belt',
        Legs = 'Inyanga Shalwar +2',
        Feet = 'Fili Cothurnes +3',
    },

    Drain = {},
	
    Nuke = {
	--main = '',
	},
    
	--Preshot = {},
    --Midshot = {
        Ear1 = 'Telos Earring',
        Ear2 = 'Crep. Earring',
    --},

    Ws_Default = {
        Range = { Name = 'Linos', Augment = { [1] = 'Weapon skill damage +2%', [2] = 'Attack+13', [3] = 'STR+8' } },
        Head = 'Nyame Helm',
        Neck = 'Bard\'s Charm +2',
        Ear1 = 'telos Earring',
        Ear2 = 'brutal Earring',
        Body = 'Bihu Just. +4',
        Hands = 'Nyame Gauntlets',
        Ring2 = 'Ephramad\'s Ring',
        Ring1 = 'Ilabrat Ring',
        Back = { Name = 'Intarabus\'s Cape', Augment = { [1] = 'Phys. dmg. taken -10%', [2] = 'STR+30', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'Weapon skill damage +10%' } },
        Waist = 'Sailfi Belt +1',
        Legs = 'Nyame Flanchard',
        Feet = 'Nyame Sollerets',
    },
    Ws_Hybrid = {},
    Ws_Acc = {},

    Mordant_Default = {
        Range = { Name = 'Linos', Augment = { [1] = 'Weapon skill damage +2%', [2] = 'Attack+13', [3] = 'STR+8' } },
		Head = 'Nyame Helm',
        Neck = 'Bard\'s Charm +2',
		ear1 = 'ishvara earring',
		ear2 = 'regal earring',
        Body = 'Bihu Just. +4',
		Hands = 'Nyame Gauntlets',
        Ring1 = 'Ephramad\'s Ring',
        Ring2 = 'metamor. Ring +1',
        Back = { Name = 'Intarabus\'s Cape', Augment = { [1] = 'Phys. dmg. taken -10%', [2] = 'STR+30', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'Weapon skill damage +10%' } },
        Waist = 'Sailfi Belt +1',
		Legs = 'Nyame Flanchard',
        Feet = 'Nyame Sollerets',
    },
    Mordant_Hybrid = {},
    Mordant_Acc = {},

    Savage_Default = {
        Range = { Name = 'Linos', Augment = { [1] = 'Weapon skill damage +2%', [2] = 'Attack+13', [3] = 'STR+8' } },
		head = 'nyame helm',
        Neck = 'Bard\'s Charm +2',
		ear1 = 'telos earring',
		ear2 = 'regal earring',
		Body = 'Bihu Just. +4',
		hands = 'nyame Gauntlets',
        Ring2 = 'Ephramad\'s Ring',
        Ring1 = 'sroda ring',
        Back = { Name = 'Intarabus\'s Cape', Augment = { [1] = 'Phys. dmg. taken -10%', [2] = 'STR+30', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'Weapon skill damage +10%' } },
        Waist = 'Sailfi Belt +1',
		Legs = 'Nyame Flanchard',
        Feet = 'Nyame Sollerets',
    },
    Savage_Hybrid = {},
    Savage_Acc = {},
	
	Ruthless_Default = {
        Range = { Name = 'Linos', Augment = { [1] = 'Weapon skill damage +2%', [2] = 'Attack+13', [3] = 'STR+8' } },
		head = 'nyame helm',
        Neck = 'Bard\'s Charm +2',
		ear1 = 'telos earring',
		ear2 = 'regal earring',
		Body = 'Bihu Just. +4',
		hands = 'nyame Gauntlets',
        Ring2 = 'Ephramad\'s Ring',
        Ring1 = 'sroda ring',
        Back = { Name = 'Intarabus\'s Cape', Augment = { [1] = 'Phys. dmg. taken -10%', [2] = 'STR+30', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'Weapon skill damage +10%' } },
        Waist = 'Sailfi Belt +1',
		Legs = 'Nyame Flanchard',
        Feet = 'Nyame Sollerets',
    },
    Ruthless_Hybrid = {},
    Ruthless_Acc = {},
	
    Nitro = {--includes legs for soul voice as well
        Body = 'Bihu Just. +4',
        Legs = 'Bihu Cannions',
        Feet = 'Bihu Slippers +4',
    },

    TH = {
		Waist = 'Chaac Belt',
		Feet = 'Volte Boots',
	},
    Movement = {
        Feet = 'Fili Cothurnes +3',
	},
    Absorb = {}, -- every Absorb- spell (land rate: Dark Magic skill, macc; potency is not skill)
    Absorb_TP = {}, -- Absorb-TP on top of Absorb
};
profile.Sets = sets;

-- No Dual Wield (sub not NIN/DNC): casting or not engaged = Ammurapi Shield, engaged = Genmei Shield.
local function FixSub(casting)
    if gcinclude.CanDualWield() then return end
    local player = gData.GetPlayer();
    if (not casting) and (player ~= nil) and (player.Status == 'Engaged') then
        gFunc.Equip('Sub', 'Genmei Shield');
    else
        gFunc.Equip('Sub', 'Ammurapi Shield');
    end
end


profile.OnLoad = function()
	gSettings.AllowAddSet = true;
    gcinclude.WeaponModes = {'None', 'Naegling', 'Carnwenhan', 'CarnwenhanAcc', 'Hoxne'};
    gcinclude.DefaultWeapons = 'Naegling';
    gcinclude.Initialize();	
end

profile.OnUnload = function()
    gcinclude.Unload();
end

profile.HandleCommand = function(args)
    gcinclude.HandleCommands(args);
end

profile.HandleDefault = function()
    gFunc.EquipSet(sets.Idle);
	
	local player = gData.GetPlayer();
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
    if (gcdisplay.GetToggle('DTset') == true) then gFunc.EquipSet(sets.Dt) end;
    if (gcdisplay.GetToggle('Kite') == true) then gFunc.EquipSet(sets.Movement) end;
    FixSub(false);
    gcinclude.CheckDefault ();
end
    
profile.HandleAbility = function()
    local ability = gData.GetAction();
    
    if string.match(ability.Name, 'Troubadour') 
        or string.match(ability.Name, 'Nightingale') 
        or string.match(ability.Name, 'Soul Voice') 
        or string.match(ability.Name, 'Clarion Call') then
        
        gFunc.EquipSet(sets.Nitro)
    end

    gcinclude.CheckCancels();
    FixSub(false);
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
    elseif (spell.Skill == 'Singing') then
        gFunc.EquipSet(sets.Song_Precast);
    end
	if string.contains(spell.Name, 'Honor March') then
            gFunc.EquipSet(sets.Honor_Precast);
        end
			if string.contains(spell.Name, 'Aria of Passion') then
            gFunc.EquipSet(sets.Aria_Precast);
        end

    gcinclude.CheckCancels();
    FixSub(true);
end

profile.HandleMidcast = function()
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
        elseif string.contains(spell.Name, 'Refresh') then
            gFunc.EquipSet(sets.Refresh);
        elseif string.contains(spell.Name, 'Regen') then
            gFunc.EquipSet(sets.Regen);
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

    elseif (spell.Skill == 'Enfeebling Magic') then
        gFunc.EquipSet(sets.Enfeebling);
    elseif (spell.Skill == 'Dark Magic') then
        gFunc.EquipSet(sets.Enfeebling); -- mostly macc anyways
        if (string.contains(spell.Name, 'Aspir') or string.contains(spell.Name, 'Drain')) then
            gFunc.EquipSet(sets.Drain);
        end
    elseif (spell.Skill == 'Singing') then
        if (string.contains(spell.Name, 'Army\'s Paeon III')) or (string.contains(spell.Name, 'Army\'s Paeon IV')) or (string.contains(spell.Name, 'Army\'s Paeon V')) then
            gFunc.EquipSet(sets.Paeon);
        elseif (string.contains(spell.Name, 'Victory March')) or (string.contains(spell.Name, 'Advancing March')) then
            gFunc.EquipSet(sets.March);
        elseif (string.contains(spell.Name, 'Blade Madrigal')) or (string.contains(spell.Name, 'Sword Madrigal')) then
            gFunc.EquipSet(sets.Madrigal);
		elseif (string.contains(spell.Name, 'Honor March')) then
            gFunc.EquipSet(sets.Honor);
		elseif (string.contains(spell.Name, 'Aria of Passion')) then
            gFunc.EquipSet(sets.Aria);
        elseif (string.contains(spell.Name, 'Sentinel\'s Scherzo')) then
            gFunc.EquipSet(sets.Scherzo);
		elseif (string.contains(spell.Name, 'Dragonfoe Mambo')) or (string.contains(spell.Name, 'Sheepfoe Mambo')) then
            gFunc.EquipSet(sets.Mambo);
        elseif (string.contains(spell.Name, 'Ballad')) then
            gFunc.EquipSet(sets.Ballad);
		elseif (string.contains(spell.Name, 'Etude')) then
            gFunc.EquipSet(sets.Etude);
		elseif (string.match(spell.Name, 'Army\'s Paeon')) or (string.match(spell.Name, 'Goblin Gavotte')) then
            gFunc.EquipSet(sets.Dummy);
		else
            gFunc.EquipSet(sets.Buff);
        end
        if (string.contains(spell.Name, 'Requiem')) or (string.contains(spell.Name, 'Elegy')) or (string.contains(spell.Name, 'Threnody')) or (string.contains(spell.Name, 'Finale')) or (string.contains(spell.Name, 'Lullaby')) then
            gFunc.EquipSet(sets.Wind);
        end
        if (string.contains(spell.Name, 'Horde Lullaby')) then
            gFunc.EquipSet(sets.Horde);
        elseif (string.contains(spell.Name, 'Foe Lullaby')) then
            gFunc.EquipSet(sets.Foe);
        end

        if (gcdisplay.GetToggle('String') == true) then
            gFunc.EquipSet(sets.Harp);
        end
    end
	if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
    FixSub(true);
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
   
           if string.match(ws.Name, 'Mordant Rime') then
            gFunc.EquipSet(sets.Mordant_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Mordant_' .. gcdisplay.GetCycle('MeleeSet')); end
        end
		
		if string.match(ws.Name, 'Ruthless Stroke') then
            gFunc.EquipSet(sets.Ruthless_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Ruthless_' .. gcdisplay.GetCycle('MeleeSet')); end
        end
   
        if string.match(ws.Name, 'Savage Blade') then
            gFunc.EquipSet(sets.Savage_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Savage_' .. gcdisplay.GetCycle('MeleeSet')); end
        end
    end
    FixSub(false);
end

return profile;