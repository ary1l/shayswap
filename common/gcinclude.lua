	local gcinclude = T{};
	function gcinclude.Say(msg) print(chat.header('GCinclude'):append(chat.message(msg))) end
	function gcinclude.Err(msg) print(chat.header('GCinclude'):append(chat.error(msg))) end

	--[[
	Only edit the next two small sections here. See the readme on my github for more information on usages for my profiles.

	These are universal sets for things like doomed or asleep; avoid main/sub/range/ammo here.
	The second section is a couple basic settings to decide on whether or not to use you the automatic equiping function of idle regen, idle refresh, DT gear etc.
	More details in each section.
	]]
	gcinclude.sets = T{
		Doomed = { -- this set will equip any time you have the doom status
			Ring1 = 'Purity Ring',
			Waist = 'Gishdubar Sash',
		},
		Holy_Water = { -- update with whatever gear you use for the Holy Water item
			Ring1 = 'Purity Ring',
			Ring2 = 'Blenmot\'s Ring',
		},
		Sleeping = { -- this set will auto equip if you are asleep
		},
		Reraise = { -- this set will try to equip when weakened if AutoGear variable is true below or you can force it with /rrset in game
			Head = 'Crepuscular Helm',
			Body = 'Crepuscular Mail',
		},
		Crafting = { -- this set is meant as a default set for crafting, equip using /craftset, be sure to dbl check what rings you want to use
			Head = 'Midras\'s Helm +1',
			Body = 'Tanner\'s Apron',
			Hands = 'Tanner\'s Gloves',
			Ring1 = 'Artificer\'s Ring',
			Ring2 = 'Craftmaster\'s Ring',
		},
		Zeni = { -- this set is meant as a default set for pictures, equip using /zeniset
			Range = 'Soultrapper 2000',
			Ammo = 'Blank Soulplate',
			Head = 'Malignance Chapeau',
			Neck = 'Bathy Choker +1';
			Ear1 = 'Infused Earring',
			Ear2 = 'Eabani Earring',
			Body = 'Nyame Mail',
			Hands = 'Malignance Gloves',
			Ring1 = 'Ilabrat Ring',
			Ring2 = 'Vengeful Ring',
			Back = 'Solemnity Cape',
			Waist = 'Svelt. Gouriz +1',
			Legs = 'Nyame Flanchard',
			Feet = 'Nyame Sollerets',
		},
		Fishing = { -- this set is meant as a default set for fishing, equip using /fishset
			Range = 'Halcyon Rod',
			Ring2 = 'Pelican Ring',
		},
	};
	gcinclude.settings = {
		--[[
		You can also set any of these on a per job basis in the job file in the OnLoad function. See my COR job file to see how this is done
		but as an example you can just put 'gcinclude.settings.RefreshGearMPP = 50;' in your job files OnLoad function to modify for that job only
		]]
		Messages = false; --set to true if you want chat log messages to appear on any /gc command used such as DT, TH, or KITE gear toggles, certain messages will always appear
		AutoGear = true; -- master switch for the four auto sets below, /autogear to change any of them in game
		WScheck = true; --set to false if you dont want to use the WSdistance safety check
		WSdistance = 5; --default max distance (yalms) to allow non-ranged WS to go off at if the above WScheck is true
		RegenGearHPP = 60; -- Idle_Regen below this HPP, out of combat only, 0 = never
		RefreshGearMPP = 60; -- Idle_Refresh below this MPP, out of combat only, 0 = never
		DTGearHPP = 50; -- Dt below this HPP, any status (engaged, idle, in or out of combat), 0 = never
		PetDTGearHPP = 50; -- Pet_Dt below this pet HPP, 0 = never
		MoonshadeTP = 1750; -- every WS, every job: Moonshade Earring below this TP, never at or above it; 0 = engine leaves Moonshade alone
		MoonshadeSlot = 'Ear2'; -- the slot the engine puts it in
		MoonshadeSkip = T{}; -- WS names the engine never gives Moonshade, e.g. T{'Myrkr'}
		DisplayBar = false; -- one-line status bar (job, atk/def, toggles, cycles), /gcbar to toggle
		DisplayBarX = 300;
		DisplayBarY = 0;
		warp_Ring = 'Warp Ring'; -- /warpring, /mea, /holla, /dem: equip in Ring2, use 11s later, back to Idle 11s after that
		mea_Ring = 'Dim. Ring (Mea)';
		dem_Ring = 'Dim. Ring (Dem)';
		holla_Ring = 'Dim. Ring (Holla)';
		WeaponTPGuard = 1000; -- while engaged at or above this TP, main/sub/range are held and weapon commands are refused unless you add force, 0 to disable
		HoldExemptSkills = T{'Singing', 'Geomancy', 'Healing Magic', 'Enfeebling Magic', 'Enhancing Magic'}; -- spells of these skills always get their weapon swaps
		HoldExemptAbilities = T{'Corsair Roll'}; -- ability types that always get their weapon swaps
		SmartSwap = true; -- keep main/sub/range on the spells below instead of losing TP to a weapon swap, /smartswap to toggle
		SmartSwapTP = 1; -- SmartSwap only acts at or above this TP
		NoWeaponSpells = T{'Dia', 'Dia II', 'Dia III', 'Diaga', 'Blink', 'Ice Spikes', 'Blaze Spikes', 'Shock Spikes'}; -- exact spell names that never swap main/sub/range
		KeepWeaponsFor = T{ -- spells starting with Spells keep main/sub/range while any Worn item is in main or sub
			{ Spells = T{'Cure', 'Cura'}, Worn = T{'Daybreak', 'Bunzi\'s Rod'} },
		};
		AutoFood = false; -- default state of the AutoFood toggle on load
		AutoFoodItems = T{'Grape Daifuku +1', 'Grape Daifuku'}; -- eaten in this order, a job can override with gcinclude.AutoFood
		AutoRevitalizer = true; -- master switch for AutoUseItems below, /revit off to stop
		AutoUseItems = T{ -- use one of these the moment it lands in your bags in a matching zone
			{ Zone = 'Ghoyu', Item = 'Revitalizer' },
		};
		EnchantWindow = 12; -- fallback wait when the item resource has no equip delay
		EnchantDelays = T{}; -- per-item override in seconds, e.g. T{ ['Reraise Earring'] = 30 }
		AutoHolyWater = true; -- use a Holy Water the moment you are Doomed
		HolyWaterItem = 'Holy Water';
		ReceivedSets = T{ -- spell or ability name (lowercase, matched as a prefix) -> set worn while it is on its way to you
			['cure'] = 'Cure_Received',
			['cura'] = 'Cure_Received',
			['curaga'] = 'Cure_Received',
			['cursna'] = 'Cursna_Received',
			['phalanx'] = 'Phalanx_Received',
			['protect'] = 'Protect_Shell_Received',
			['shell'] = 'Protect_Shell_Received',
			['regen'] = 'Regen_Received',
			['refresh'] = 'Refresh_Received',
			['curing waltz'] = 'Waltz_Received',
			['divine waltz'] = 'Waltz_Received',
		};
		ReceivedWindow = 8; -- seconds the received gear stays on before it gives up
		ElementReport = false;
		OrpheusPoints = T{ {1.93, 15}, {13, 1} }; -- {yalms, affinity %}: BG's two documented ends; linear between them is assumed. Add tested points in order. -- /gcinfo prints what the element picker chose and why
		ElementGear = T{ -- waist chosen by the spell's element, day and weather
			Obis = T{ Dark = 'Anrin Obi' }, -- element obis you own; add as you get them
			AnyObi = 'Hachirin-no-Obi', -- every element; worn only when day/weather nets positive
			Distance = 'Orpheus\'s Sash', -- used when it beats the obi's day/weather value
			DistanceMax = nil, -- optional yalm cap for Orpheus; nil = any distance (it is never below +1)
			Ring = nil, -- e.g. 'Zodiac Ring', worn when the day matches the element
			RingSlot = 'Ring2',
			Keep = T{'Oneiros Rope'}, -- items that are never displaced by the picks above
		};
		AutoSoda = false; -- /autosoda: keep Regain up with SodaItem
		SodaItem = 'Frontier Soda';
		ConsumableMaxTries = 2; -- AutoSoda disarms after this many tries without Regain showing up
		AutoNuke = false; -- /autonuke (or /mbmode Auto): cast into live skillchains on your target (RDM/BLM/SCH/GEO). Sync's logic.
		MBCasts = 1; -- bursts per chain (sync: count)
		MBRotate = false; -- spread bursts across the chain's elements (sync: rotate)
		MBMinMP = 0; -- hold fire below this MP (sync: mp)
		MBWindow = 10; -- magic burst window in seconds from the skillchain (BG: 10); another WS on the mob ends it
		-- /autonuke casts the chain element's single-target nuke (Fire, Blizzard, Aero, Stone, Thunder,
		-- Water) at this tier: 'Low' = I, 'Mid' = III, 'High' = V. /mbtier changes it in game.
		-- Light/Dark have no tiered nuke: SCH falls back to Luminohelix/Noctohelix. Per job: gcinclude.MBTier = 'High'.
		MBTier = 'Mid';
		MBFallback = true; -- tier not castable / on recast / short MP: try the next tier down (V > IV > III > II > I)
		MBSkills = T{'Elemental Magic'}; -- skills /automb dresses; add 'Dark Magic' etc. as you like
		ElementSkills = T{'Elemental Magic','Blue Magic'}; -- spell skills that get obi/Orpheus/element ring
		-- Elemental WS and their element (BG-Wiki Category:Elemental Weapon Skill). Starburst/Sunburst
		-- (Light or Dark), Spirits Within and Atonement (breath damage) are left out on purpose.
		ElementalWS = {
			['Gust Slash'] = 'Wind', ['Cyclone'] = 'Wind', ['Energy Steal'] = 'Dark', ['Energy Drain'] = 'Dark', ['Aeolian Edge'] = 'Wind',
			['Burning Blade'] = 'Fire', ['Red Lotus Blade'] = 'Fire', ['Shining Blade'] = 'Light', ['Seraph Blade'] = 'Light', ['Sanguine Blade'] = 'Dark',
			['Frostbite'] = 'Ice', ['Freezebite'] = 'Ice', ['Herculean Slash'] = 'Ice',
			['Cloudsplitter'] = 'Thunder', ['Primal Rend'] = 'Light',
			['Dark Harvest'] = 'Dark', ['Shadow of Death'] = 'Dark', ['Infernal Scythe'] = 'Dark',
			['Thunder Thrust'] = 'Thunder', ['Raiden Thrust'] = 'Thunder',
			['Blade: Teki'] = 'Water', ['Blade: To'] = 'Ice', ['Blade: Chi'] = 'Earth', ['Blade: Ei'] = 'Dark', ['Blade: Yu'] = 'Water',
			['Tachi: Goten'] = 'Thunder', ['Tachi: Kagero'] = 'Fire', ['Tachi: Jinpu'] = 'Wind', ['Tachi: Koki'] = 'Light',
			['Shining Strike'] = 'Light', ['Seraph Strike'] = 'Light', ['Flash Nova'] = 'Light',
			['Rock Crusher'] = 'Earth', ['Earth Crusher'] = 'Earth', ['Cataclysm'] = 'Dark', ['Vidohunir'] = 'Dark',
			['Garland of Bliss'] = 'Light', ['Omniscience'] = 'Dark',
			['Flaming Arrow'] = 'Fire', ['Hot Shot'] = 'Fire', ['Wildfire'] = 'Fire', ['Trueflight'] = 'Light', ['Leaden Salute'] = 'Dark',
		};
		SIRCombatOnly = true; -- /sir only while in combat (engaged, or hit/acted within CombatWindow)
		CombatWindow = 6; -- seconds; Selindrile uses 6
		SIRSkip = T{}; -- spell names /sir leaves alone, e.g. T{'Phalanx','Reprisal'}
		HoxneItem = 'Hoxne Ampulla'; -- what the Hoxne states keep in your ammo slot
		HoxneLockSlots = T{'Ammo', 'Range'}; -- locked by the Locked state
		Keybinds = T{ {'`','wm'}, {'+`','wm default'}, {'^`','def'}, {'!`','hoxne'}, {'@`','mbmode'} }; -- bound on load, unbound on unload; T{} for none. Per job: set gcinclude.settings.Keybinds in OnLoad before gcinclude.Initialize()
		XIRollSet = T{ Ring2 = 'Roller\'s Ring' }; -- used when a job file has no XIRoll set of its own
		HUDOwners = T{'Shaymin'}; -- character names that open the alt HUD on load
		HUDX = 300; -- alt HUD position; drag it in game, saved per character
		HUDY = 40;
		HUDAlpha = 0.45; -- HUD background opacity, 0 = none
		HUDScale = 0.9; -- HUD text size
		HUDPinned = T{'Def', 'MB', 'Kite', 'AutoFood', 'AutoSoda'}; -- HUD columns always shown (Def = DT/MDT/Aminon/SIR via /def, MB = /mbmode); others only once a box changes them
		HUDAbbr = {}; -- HUD short value overrides, e.g. { ['CarnwenhanAcc'] = 'CarnA' }; auto-shortened otherwise
		HUDLabels = {}; -- HUD column glyph overrides, e.g. { Main = 'mn', AutoSoda = 'so' }
		Validate = true; -- cancel spells/abilities/WS that would fail: KO, sleep/stun/petrify/terror/charm, mute, silence, recast, MP, stratagems, Waltz TP, amnesia
		ValidateMP = true; -- the MP part; gear "MP cost -%" isn't counted, so turn off if it stops casts that would go off
		AutoRemedy = true; -- silenced: Echo Drops, else Remedy (Remedy first if also paralyzed); paralyzed on an ability: Remedy. Not under Muddle
		WaltzTPCut = 0; -- total "Waltz TP cost" reduction on your Waltz gear, in TP
		MiniQueue = true; -- recast back within MiniQueueMax seconds: send it then instead of just cancelling
		MiniQueueMax = 5;
		Trace = false; -- /gctrace: one chat line per action naming each set put on
		LockstyleSet = nil; -- /lockstyleset N 4s after load and job change; per job gcinclude.LockstyleSet = N in OnLoad
		CapacityCapes = T{'Aptitude Mantle +1', 'Aptitude Mantle', 'Mecisto. Mantle'}; -- /capacity wears the first one carried
		JubileeSlot = 'Ring1'; -- /jubilee ring slot
	};

	--[[
	Everything else in this file should not be editted by anyone trying to use my profiles. You really just want to update the various gear sets
	in each individual job lua file. Unless you know what you're doing then it is best to leave everything below this line alone, the rest here are various functions and arrays etc.
	]]
	gcdisplay = gFunc.LoadFile('common\\gcdisplay.lua');
	gcauto = gFunc.LoadFile('common\\gcauto.lua');
	gcaction = gFunc.LoadFile('common\\gcaction.lua');
	local hudOk, hudModule = pcall(gFunc.LoadFile, 'common\\gchud.lua');
	if (hudOk == true) and (type(hudModule) == 'table') then
		gchud = hudModule;
	else
		gchud = nil;
		gcinclude.Err('HUD disabled: gchud.lua failed to load.');
	end

	gcinclude.AliasList = T{'gcmessages','wsdistance','setcycle','dt','mdt','th','kite','meleeset','gcdrain','gcaspir','nukeset','burst','automb','autonuke','weapon','elecycle','helix','weather','nuke','death','sir','tankset','proc',
	'pupmode','weaponset','wm','mainset','subset','rangeset','ammoset','autofood','autosoda','revit','holywater','aminon','gchud','lock','unlock','hoxne','gchelp','gckey','def','mbmode','received','gcinfo','gce','xiroll','checksets','smartswap','autogear','gcbar','mbinfo','cormsg','forcestring','siphon','warpring','mea','holla','dem','rrset','craftset','zeniset','fishset','mbtier',
	'gctrace','naked','weaponsonly','abysseaproc','capacity','jubilee','gcstyle'};
	-- Exit/use-on-self items: key = /command, value = exact /item name. Add a line, /lac reload.
	gcinclude.ExitItems = {
		ontic = 'ontic extremity',
		shard = 'v. con. shard',
	};
	for k in pairs(gcinclude.ExitItems) do
		if not gcinclude.AliasList:contains(k) then table.insert(gcinclude.AliasList, k) end
	end
	gcinclude.Towns = T{'Tavnazian Safehold','Aht Urhgan Whitegate','Nashmau','Southern San d\'Oria [S]','Bastok Markets [S]','Windurst Waters [S]','San d\'Oria-Jeuno Airship','Bastok-Jeuno Airship','Windurst-Jeuno Airship','Kazham-Jeuno Airship','Southern San d\'Oria','Northern San d\'Oria','Port San d\'Oria','Chateau d\'Oraguille','Bastok Mines','Bastok Markets','Port Bastok','Metalworks','Windurst Waters','Windurst Walls','Port Windurst','Windurst Woods','Heavens Tower','Ru\'Lude Gardens','Upper Jeuno','Lower Jeuno','Port Jeuno','Rabao','Selbina','Mhaura','Kazham','Norg','Mog Garden','Celennia Memorial Library','Western Adoulin','Eastern Adoulin'};
	gcinclude.LockingRings = T{'Echad Ring', 'Trizek Ring', 'Endorsement Ring', 'Capacity Ring', 'Warp Ring','Facility Ring','Dim. Ring (Dem)','Dim. Ring (Mea)','Dim. Ring (Holla)'};
	gcinclude.DistanceWS = T{'Flaming Arrow','Piercing Arrow','Dulling Arrow','Sidewinder','Blast Arrow','Arching Arrow','Empyreal Arrow','Refulgent Arrow','Apex Arrow','Namas Arrow','Jishnu\'s Radiance','Hot Shot','Split Shot','Sniper Shot','Slug Shot','Blast Shot','Heavy Shot','Detonator','Numbing Shot','Last Stand','Coronach','Wildfire','Trueflight','Leaden Salute','Myrkr','Dagan','Moonlight','Starlight','Mistral Axe','Bora Axe','Sarv','Terminus'};
	gcinclude.NoAmmoWS = T{'Myrkr','Dagan','Moonlight','Starlight','Mistral Axe','Bora Axe'};
	gcinclude.BluMagDebuff = T{'Filamented Hold','Cimicine Discharge','Demoralizing Roar','Venom Shell','Light of Penance','Sandspray','Auroral Drape','Frightful Roar','Enervation','Infrasonics','Lowing','Cold Wave','Awful Eye','Voracious Trunk','Sheep Song','Soporific','Yawn','Dream Flower','Chaotic Eye','Sound Blast','Blank Gaze','Stinking Gas','Geist Wall','Feather Tickle','Reaving Wind','Mortal Ray','Absolute Terror','Blistering Roar','Cruel Joke'};
	gcinclude.BluMagStun = T{'Head Butt','Frypan','Tail Slap','Sub-zero Smash','Sudden Lunge'};
	gcinclude.BluMagBuff = T{'Cocoon','Refueling','Feather Barrier','Memento Mori','Zephyr Mantle','Warm-Up','Amplification','Triumphant Roar','Saline Coat','Reactor Cool','Plasma Charge','Regeneration','Animating Wail','Battery Charge','Winds of Promy.','Barrier Tusk','Orcish Counterstance','Pyric Bulwark','Nat. Meditation','Restoral','Erratic Flutter','Carcharian Verve','Harden Shell','Mighty Guard'};
	gcinclude.BluMagSkill = T{'Metallic Body','Diamondhide','Magic Barrier','Occultation','Atra. Libations'};
	gcinclude.BluMagCure = T{'Pollen','Healing Breeze','Wild Carrot','Magic Fruit','Plenilune Embrace'};
	gcinclude.BluMagEnmity = T{'Actinic Burst','Exuviation','Fantod','Jettatura','Temporal Shift'};
	gcinclude.BluMagTH = T{'Actinic Burst','Dream Flower','Subduction'};
	gcinclude.Elements = T{'Thunder', 'Blizzard', 'Fire', 'Stone', 'Aero', 'Water', 'Light', 'Dark'};
	gcinclude.HelixSpells = T{'Ionohelix', 'Cryohelix', 'Pyrohelix', 'Geohelix', 'Anemohelix', 'Hydrohelix', 'Luminohelix', 'Noctohelix'};
	gcinclude.StormSpells = T{'Thunderstorm', 'Hailstorm', 'Firestorm', 'Sandstorm', 'Windstorm', 'Rainstorm', 'Aurorastorm', 'Voidstorm'};
	gcinclude.Rolls = T{{'Fighter\'s Roll',5,9}, {'Monk\'s Roll',3,7}, {'Healer\'s Roll',3,7}, {'Corsair\'s Roll',5,9}, {'Ninja Roll',4,8},{'Hunter\'s Roll',4,8}, {'Chaos Roll',4,8}, {'Magus\'s Roll',2,6}, {'Drachen Roll',4,8}, {'Choral Roll',2,6},{'Beast Roll',4,8}, {'Samurai Roll',2,6}, {'Evoker\'s Roll',5,9}, {'Rogue\'s Roll',5,9}, {'Warlock\'s Roll',4,8},
		{'Puppet Roll',3,7}, {'Gallant\'s Roll',3,7}, {'Wizard\'s Roll',5,9}, {'Dancer\'s Roll',3,7}, {'Scholar\'s Roll',2,6},{'Naturalist\'s Roll',3,7}, {'Runeist\'s Roll',4,8}, {'Bolter\'s Roll',3,9}, {'Caster\'s Roll',2,7}, {'Courser\'s Roll',3,9},{'Blitzer\'s Roll',4,9}, {'Tactician\'s Roll',5,8}, {'Allies\' Roll',3,10}, {'Miser\'s Roll',5,7},
		{'Companion\'s Roll',2,10},{'Avenger\'s Roll',4,8},}; -- {name,lucky,unlucky}
	-- /rrset /craftset /zeniset /fishset: command -> gcinclude.sets name; on ones layer over everything.
	gcinclude.UtilSets = { rrset = 'Reraise', craftset = 'Crafting', zeniset = 'Zeni', fishset = 'Fishing' };
	gcinclude.UtilOn = {};
	gcinclude.HardCC = T{'Sleep', 'Petrification', 'Stun', 'Terror', 'Charm'}; -- can't act (gcauto, gcaction, WS bailout)
	gcinclude.CORmsg = true;

	-- /def: none > DT > MDT > Aminon > SIRD > none. Only one of the four is on at a time.
	gcinclude.DefenseCycle = T{ {'DTset','DT'}, {'MDTset','MDT'}, {'Aminon','Aminon'}, {'SIR','SIRD'} };
	function gcinclude.CycleDefense()
		local current = 0;
		for i, d in ipairs(gcinclude.DefenseCycle) do
			if (gcdisplay.GetToggle(d[1]) == true) and (current == 0) then current = i end
			gcdisplay.SetToggle(d[1], false);
		end
		local nextOne = gcinclude.DefenseCycle[current + 1];
		if (nextOne == nil) then return 'None' end
		gcdisplay.SetToggle(nextOne[1], true);
		return nextOne[2];
	end

	-- /mbtier: Low (tier I) / Mid (tier III) / High (tier V) for /autonuke. Accepts low|mid|high|hi|1|3|5.
	gcinclude.MBTierAlias = { low = 'Low', l = 'Low', ['1'] = 'Low', i = 'Low', mid = 'Mid', m = 'Mid', ['3'] = 'Mid', iii = 'Mid',
		high = 'High', hi = 'High', h = 'High', ['5'] = 'High', v = 'High' };
	gcinclude.MBTierNum = { Low = 1, Mid = 3, High = 5 };
	function gcinclude.SetMBTier(v, quiet)
		local t = gcinclude.MBTierAlias[string.lower(tostring(v or ''))];
		if (t == nil) then
			if not quiet then gcinclude.Err('/mbtier low|mid|high (tier I / III / V)') end
			return;
		end
		gcdisplay.SetCycle('MBTier', t);
	end
	function gcinclude.MBTierText()
		local t = gcdisplay.GetCycle('MBTier');
		local roman = { Low = 'I', Mid = 'III', High = 'V' };
		return tostring(t) .. ' (tier ' .. (roman[t] or '?') .. ')';
	end

	-- /mbmode sets three toggles as one mode: Off > Chain > Auto > Force > Off.
	--   Off   : AutoMB off, AutoNuke off, Burst off. Nukes use the normal set; nothing casts by itself.
	--   Chain : AutoMB on.  Burst set only when the nuke lands in a live skillchain of a matching element.
	--   Auto  : AutoMB on + AutoNuke on. Chain, plus the box casts into live skillchains by itself.
	--   Force : Burst on.   Burst set on every nuke, no skillchain check. Nothing casts by itself.
	function gcinclude.CycleMB()
		local job = gData.GetPlayer().MainJob;
		if not T{'RDM','BLM','SCH','GEO'}:contains(job) then return 'not used on ' .. tostring(job) end
		local auto, forced, nuke = gcdisplay.GetToggle('AutoMB'), gcdisplay.GetToggle('Burst'), gcdisplay.GetToggle('AutoNuke');
		local nextMode = 'Chain';
		if forced then nextMode = 'Off'
		elseif nuke then nextMode = 'Force'
		elseif auto then nextMode = 'Auto' end
		gcdisplay.SetToggle('AutoMB', (nextMode == 'Chain') or (nextMode == 'Auto'));
		gcdisplay.SetToggle('AutoNuke', nextMode == 'Auto');
		gcdisplay.SetToggle('Burst', nextMode == 'Force');
		if (gcauto ~= nil) and (gcauto.ResetNuke ~= nil) then gcauto.ResetNuke() end
		return nextMode;
	end

	function gcinclude.Message(toggle, status)
		if toggle ~= nil and status ~= nil then
			gcinclude.Say(toggle .. ' is now ' .. tostring(status))
		end
	end

	function gcinclude.SetAlias()
		for _, v in ipairs(gcinclude.AliasList) do
			AshitaCore:GetChatManager():QueueCommand(-1, '/alias /' .. v .. ' /lac fwd ' .. v);
		end
	end

	function gcinclude.ClearAlias()
		for _, v in ipairs(gcinclude.AliasList) do
			AshitaCore:GetChatManager():QueueCommand(-1, '/alias del /' .. v);
		end
	end

function gcinclude.SetVariables()
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    local mJob = 'NON';
    gcinclude.ActiveJobId = nil;
    if (player ~= nil) then
        local mainJobId = player:GetMainJob();
        gcinclude.ActiveJobId = mainJobId;
        mJob = AshitaCore:GetResourceManager():GetString("jobs.names_abbr", mainJobId) or 'NON';
    end

    -- Track the job we are building variables for
    gcinclude.ActiveJob = mJob;

    gcinclude.UnlockSlots(nil);
    gcinclude.UnlockWeapons();
    gcinclude.Holds, gcinclude.Strip = {}, nil;
    gcdisplay.ClearAll();
    gcdisplay.CreateToggle('DTset', false);
    gcdisplay.CreateToggle('MDTset', false);
    gcdisplay.CreateToggle('Aminon', false);
    gcdisplay.CreateToggle('SIR', false);
    gcdisplay.CreateCycle('Hoxne', {[1] = 'Off', [2] = 'On', [3] = 'Locked'});
    gcdisplay.CreateToggle('Kite', false);
    gcdisplay.CreateToggle('TH', false);
    gcdisplay.CreateCycle('MeleeSet', {[1] = 'Default', [2] = 'Hybrid', [3] = 'Acc'});
    gcinclude.BuildWeaponCycles(mJob);
    if (type(gcinclude.DefaultWeapons) == 'string') then
        gcinclude.SetWeaponCycle('Weapons', gcinclude.DefaultWeapons, true);
    elseif (type(gcinclude.DefaultWeapons) == 'table') then
        for cname, val in pairs(gcinclude.DefaultWeapons) do
            gcinclude.SetWeaponCycle(cname, val, true);
        end
    end
    gcauto.Bind(gcinclude, gcdisplay);
    gcaction.Bind(gcinclude, gcdisplay);
    if (gchud ~= nil) then gchud.Bind(gcinclude, gcdisplay) end
    gcauto.CreateToggles();
    if (mJob == 'RDM') or (mJob == 'BLM') or (mJob == 'SCH') or (mJob == 'GEO') then
        gcdisplay.CreateToggle('Burst', false); -- force the Burst set on every nuke
        gcdisplay.CreateToggle('AutoMB', true); -- Burst set only when a matching skillchain is live
        gcdisplay.CreateToggle('AutoNuke', gcinclude.settings.AutoNuke == true); -- cast into live skillchains
        gcdisplay.CreateCycle('NukeSet', {[1] = 'Power', [2] = 'Macc',});
        gcdisplay.CreateCycle('MBTier', {[1] = 'Low', [2] = 'Mid', [3] = 'High'}); -- /autonuke tier: I / III / V
        gcinclude.SetMBTier(gcinclude.MBTier or gcinclude.settings.MBTier or 'Mid', true);
        if (mJob == 'BLM') or (mJob == 'SCH') then
            gcdisplay.CreateCycle('Weapon', {[1] = 'Club', [2] = 'Staff'});
            gcdisplay.CreateCycle('Element', {[1] = 'Thunder', [2] = 'Blizzard', [3] = 'Fire', [4] = 'Stone', [5] = 'Aero', [6] = 'Water', [7] = 'Light', [8] = 'Dark'});
            if (mJob == 'BLM') then
                gcdisplay.CreateToggle('Death', false);
            end
        end
    end
    if (mJob == 'WHM') then
        gcdisplay.CreateCycle('NukeSet', {[1] = 'Power', [2] = 'Macc',});
    end
    if (mJob == 'PLD') or (mJob == 'RUN') then
        gcdisplay.CreateCycle('TankSet', {[1] = 'None', [2] = 'Main', [3] = 'MEVA'});
    end
    if (mJob == 'SAM') or (mJob == 'NIN') then
        gcdisplay.CreateToggle('PROC', false);
    end
    if (mJob == 'PUP') then
        gcdisplay.CreateCycle('PupMode', {[1] = 'Tank', [2] = 'Melee', [3] = 'Ranger', [4] = 'Mage'});
    end
    if (mJob == 'BRD') then
        gcdisplay.CreateToggle('String', false);
    end
    gcdisplay.MarkDefaults();
end

	function gcinclude.HandleCommands(args)
		if not gcinclude.AliasList:contains(args[1]) then return end

		local player = gData.GetPlayer();
		local toggle = nil;
		local status = nil;
		
		if args[1] == 'gcmessages' then
			gcinclude.settings.Messages = not gcinclude.settings.Messages;
			gcinclude.Say('Chat messages ' .. (gcinclude.settings.Messages and 'on' or 'off'));
		elseif (args[1] == 'wsdistance') then
			if (tonumber(args[2])) then 
				gcinclude.settings.WScheck = true;
				gcinclude.settings.WSdistance = tonumber(args[2]);
				gcinclude.Say('WS Distance is on and set to ' .. gcinclude.settings.WSdistance);
			else
				gcinclude.settings.WScheck = not gcinclude.settings.WScheck;
				gcinclude.Say('WS distance check is now ' .. tostring(gcinclude.settings.WScheck));
				gcinclude.Say('Can change WS distance allowed by using /wsdistance ##');
			end
		elseif (args[1] == 'dt') then
			gcdisplay.AdvanceToggle('DTset');
			toggle = 'DT Set';
			status = gcdisplay.GetToggle('DTset');
		elseif (args[1] == 'sir') then
			gcdisplay.AdvanceToggle('SIR');
			toggle = 'Spell Interrupt Set';
			status = gcdisplay.GetToggle('SIR');
		elseif (args[1] == 'mbmode') then
			toggle, status = 'Magic Burst', gcinclude.CycleMB();
		elseif (args[1] == 'def') then
			toggle, status = 'Defense', gcinclude.CycleDefense();
		elseif (args[1] == 'mdt') then
			gcdisplay.AdvanceToggle('MDTset');
			toggle = 'MDT Set';
			status = gcdisplay.GetToggle('MDTset');
		elseif (args[1] == 'meleeset') then
			gcdisplay.AdvanceCycle('MeleeSet');
			toggle = 'Melee Set';
			status = gcdisplay.GetCycle('MeleeSet');
		elseif (gcinclude.WeaponCommands[args[1]] ~= nil) then
			local cname = gcinclude.WeaponCommands[args[1]];
			gcinclude.WeaponCommand(cname, args);
			toggle = cname;
			status = gcdisplay.GetCycle(cname);
		elseif (args[1] == 'autofood') or (args[1] == 'autosoda') or (args[1] == 'revit') or (args[1] == 'holywater') then
			gcauto.HandleCommand(args);
		elseif (args[1] == 'hoxne') then
			if (args[2] ~= nil) and (string.lower(args[2]) == 'use') then
				gcinclude.SetWeaponCycle('Hoxne', 'Locked', true);
				gcinclude.CheckHoxne();
				gcinclude.UseEnchanted(gcinclude.settings.HoxneItem, 'Ammo', true);
			elseif (args[2] ~= nil) then
				gcinclude.SetWeaponCycle('Hoxne', args[2], true);
			else
				gcdisplay.AdvanceCycle('Hoxne');
			end
			toggle = 'Hoxne';
			status = gcdisplay.GetCycle('Hoxne');
		elseif (args[1] == 'received') then
			gcinclude.ReceivedCommand(args);
		elseif (args[1] == 'gcinfo') then
			gcinclude.settings.ElementReport = not (gcinclude.settings.ElementReport == true);
			toggle = 'Element report';
			status = gcinclude.settings.ElementReport;
		elseif (args[1] == 'gce') then
			gcinclude.EnchantCommand(args);
		elseif (args[1] == 'gchelp') then
			gcinclude.Help();
		elseif (args[1] == 'gckey') then
			gcinclude.KeyCommand(args);
		elseif (args[1] == 'aminon') then
			gcdisplay.AdvanceToggle('Aminon');
			toggle = 'Aminon Set';
			status = gcdisplay.GetToggle('Aminon');
		elseif (args[1] == 'gchud') then
			if (gchud ~= nil) then
				gchud.HandleCommand(args);
			else
				gcinclude.Err('HUD is not loaded.');
			end
		elseif (args[1] == 'smartswap') then
			gcinclude.SmartSwapCommand(args);
		elseif (args[1] == 'autogear') then
			gcinclude.AutoGearCommand(args);
		elseif (args[1] == 'gcbar') then
			gcdisplay.BarCommand(args);
		elseif (args[1] == 'lock') then
			gcinclude.LockCommand(args);
		elseif (args[1] == 'unlock') then
			gcinclude.UnlockCommand(args);
		elseif (args[1] == 'mbinfo') then
			gcinclude.Say('last chain: ' .. ((gcauto ~= nil) and gcauto.BurstInfo() or 'no tracker'));
		elseif (args[1] == 'checksets') then
			gcinclude.CheckSets();
		elseif (args[1] == 'xiroll') then
			gcinclude.Say('rolls up: ' .. tostring(gcinclude.RollActive()) .. ' | eleven: ' .. tostring((gcauto ~= nil) and gcauto.RollEleven() or false) .. ' | ' .. ((gcauto ~= nil) and gcauto.RollInfo() or 'no tracker'));
		elseif (#args == 3 and args[1] == 'setcycle') then
			if gcdisplay.SetCycle(args[2], args[3]) then
				toggle = args[2];
				status = gcdisplay.GetCycle(args[2]);
				if (gcinclude.WeaponCycleList(args[2]) ~= nil) then gcinclude.ApplyWeapons() end
			end
		elseif (args[1] == 'kite') then
			gcdisplay.AdvanceToggle('Kite');
			toggle = 'Kite Set';
			status = gcdisplay.GetToggle('Kite');
		elseif (args[1] == 'th') then
			gcdisplay.AdvanceToggle('TH');
			toggle = 'TH Set';
			status = gcdisplay.GetToggle('TH');
		elseif (args[1] == 'gcaspir') then
			gcinclude.DoAspir();
		elseif (args[1] == 'gcdrain') then
			gcinclude.DoDrain();
		elseif (gcinclude.TeleRings[args[1]] ~= nil) then
			gcinclude.UseTeleRing(gcinclude.TeleRings[args[1]]);
		elseif (gcinclude.ExitItems[args[1]] ~= nil) then
			AshitaCore:GetChatManager():QueueCommand(-1, '/item "' .. gcinclude.ExitItems[args[1]] .. '" <me>');
		elseif (args[1] == 'gctrace') then
			gcinclude.settings.Trace = not (gcinclude.settings.Trace == true);
			gcinclude.Say('Trace: ' .. (gcinclude.settings.Trace and 'on' or 'off'));
		elseif (gcinclude.StripModes[args[1]] ~= nil) then
			gcinclude.StripCommand(args[1], args[2] and string.lower(args[2]));
		elseif (gcinclude.CarriedKeys:contains(args[1])) then
			gcinclude.CarriedCommand(args[1], args[2] and string.lower(args[2]));
		elseif (args[1] == 'gcstyle') then
			if not gcinclude.ApplyLockstyle(args[2], 0) then gcinclude.Say('usage: /gcstyle <N>, or set LockstyleSet') end
		elseif (gcinclude.UtilSets[args[1]] ~= nil) then
			gcinclude.UtilOn[args[1]] = not gcinclude.UtilOn[args[1]];
			toggle, status = gcinclude.UtilSets[args[1]] .. ' Set', gcinclude.UtilOn[args[1]];
		end
		if (player.MainJob == 'RDM') or (player.MainJob == 'BLM') or (player.MainJob == 'SCH') or (player.MainJob == 'GEO') then
			if (args[1] == 'nukeset') then
				gcdisplay.AdvanceCycle('NukeSet');
				toggle = 'Nuking Gear Set';
				status = gcdisplay.GetCycle('NukeSet');
			elseif (args[1] == 'burst') then
				gcdisplay.AdvanceToggle('Burst');
				toggle = 'Magic Burst Set (forced)';
				status = gcdisplay.GetToggle('Burst');
			elseif (args[1] == 'autonuke') then
				gcdisplay.AdvanceToggle('AutoNuke');
				if (gcauto ~= nil) and (gcauto.ResetNuke ~= nil) then gcauto.ResetNuke() end
				toggle = 'Auto Nuke';
				status = gcdisplay.GetToggle('AutoNuke');
			elseif (args[1] == 'automb') then
				gcdisplay.AdvanceToggle('AutoMB');
				toggle = 'Auto Magic Burst';
				status = gcdisplay.GetToggle('AutoMB');
			elseif (args[1] == 'mbtier') then
				if (args[2] ~= nil) then
					gcinclude.SetMBTier(args[2]);
				else
					gcdisplay.AdvanceCycle('MBTier');
				end
				toggle = 'Auto Nuke tier';
				status = gcinclude.MBTierText();
			end
			if (player.MainJob == 'BLM') or (player.MainJob == 'SCH') then
				if (args[1] == 'weapon') then
					gcdisplay.AdvanceCycle('Weapon');
					toggle = 'Mage Weapon';
					status = gcdisplay.GetCycle('Weapon');
				elseif (args[1] == 'elecycle') then
					gcdisplay.AdvanceCycle('Element');
					toggle = 'Spell Element';
					status = gcdisplay.GetCycle('Element');
				elseif (args[1] == 'helix') then
					gcinclude.DoSCHspells('helix');
				elseif (args[1] == 'weather') then
					gcinclude.DoSCHspells('weather');
				elseif (args[1] == 'nuke') then
					gcinclude.DoNukes(args[2]);
				end
				if (player.MainJob == 'BLM') then
					if (args[1] == 'death') then
						gcdisplay.AdvanceToggle('Death');
						toggle = 'BLM Death Set';
						status = gcdisplay.GetToggle('Death');
					end
				end
			end
		end
		if (player.MainJob == 'WHM') and (args[1] == 'nukeset') then
			gcdisplay.AdvanceCycle('NukeSet');
			toggle = 'Nuking Gear Set';
			status = gcdisplay.GetCycle('NukeSet');
		end
		if (player.MainJob == 'PLD') or (player.MainJob == 'RUN') then
			if (args[1] == 'tankset') then
				gcdisplay.AdvanceCycle('TankSet');
				toggle = 'Tank Gear Set';
				status = gcdisplay.GetCycle('TankSet');
			end
		end
		if (player.MainJob == 'SAM') or (player.MainJob == 'NIN') then
			if (args[1] == 'proc') then
				gcdisplay.AdvanceToggle('PROC');
				toggle = 'Low Damage PROC Set';
				status = gcdisplay.GetToggle('PROC');
				if (player.MainJob == 'NIN') then
					if gcdisplay.GetToggle('PROC') == true then
						AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable ammo');
					else
						AshitaCore:GetChatManager():QueueCommand(-1, '/lac enable ammo');
					end
				end
			end
		end
		if (player.MainJob == 'PUP') then
			if (args[1] == 'pupmode') then
				gcdisplay.AdvanceCycle('PupMode');
				toggle = 'Puppet Mode';
				status = gcdisplay.GetCycle('PupMode');
			end
		end
		if (player.MainJob == 'BRD') then
			if (args[1] == 'forcestring') then
				gcdisplay.AdvanceToggle('String');
				toggle = 'BRD Forced Harp';
				status = gcdisplay.GetToggle('String');
			end
		end
		if (player.MainJob == 'COR') then
			if (args[1] == 'cormsg') then
				if gcinclude.CORmsg == true then
					gcinclude.CORmsg = false;
					gcinclude.Say('COR Roll messages will no longer show');
				else
					gcinclude.CORmsg = true;
					gcinclude.Say('COR Roll messages will show now');
				end
			end
		end
		if (player.MainJob == 'SMN') then
			if (args[1] == 'siphon') then
				gcinclude.DoSiphon();
			end
		end

		if gcinclude.settings.Messages then
			gcinclude.Message(toggle, status)
		end
	end

	gcinclude.WeaponSlots = T{1, 2, 3, 4};
	gcinclude.DualWieldSubs = T{'NIN', 'DNC'};
	gcinclude.WeaponSlotNames = T{'Main', 'Sub', 'Range', 'Ammo'};
	gcinclude.WeaponCommands = T{weaponset = 'Weapons', wm = 'Weapons', mainset = 'Main', subset = 'Sub', rangeset = 'Range', ammoset = 'Ammo'};
	gcinclude.WeaponRoleNames = T{'melee', 'ranged', 'caster', 'tank'};
	gcinclude.WeaponKeywords = T{'remove', 'displaced', 'ignore'};
	gcinclude.BlockedAmmo = T{'hauksbok'};
	gcinclude.ExtraAmmo = T{'Hoxne Ampulla'};
	gcinclude.WeaponItems = {};

	function gcinclude.WeaponCycleList(cname)
		if (cname == 'Weapons') then return gcinclude.WeaponModes end
		if (cname == 'Main') then return gcinclude.MainModes end
		if (cname == 'Sub') then return gcinclude.SubModes end
		if (cname == 'Range') then return gcinclude.RangeModes end
		if (cname == 'Ammo') then return gcinclude.AmmoModes end
		if (cname == 'Hoxne') then return T{'Off', 'On', 'Locked'} end
		return nil;
	end

	function gcinclude.WeaponLabel(v)
		if (type(v) == 'string') then return v end
		if (type(v) ~= 'table') or (type(v.Name) ~= 'string') then return nil end
		if (v.AugPath ~= nil) then return v.Name .. ' (' .. tostring(v.AugPath) .. ')' end
		return v.Name;
	end

	function gcinclude.BuildWeaponCycles(mJob)
		gcinclude.WeaponItems = {};
		if (type(gcinclude.WeaponItemMap) == 'table') then
			for label, item in pairs(gcinclude.WeaponItemMap) do
				gcinclude.WeaponItems[string.lower(label)] = item;
			end
		end
		local ammo = T{};
		if (type(gcinclude.AmmoModes) == 'table') and (#gcinclude.AmmoModes > 0) then
			ammo = gcinclude.AmmoModes;
		else
			ammo:append('None');
			for _, extra in ipairs(gcinclude.ExtraAmmo) do ammo:append(extra) end
			gcinclude.AmmoModes = ammo;
		end
		for _, cname in ipairs(T{'Weapons', 'Main', 'Sub', 'Range'}) do
			local list = gcinclude.WeaponCycleList(cname);
			if (type(list) == 'table') and (#list > 0) then
				gcdisplay.CreateCycle(cname, list);
			end
		end
		if (#ammo > 1) then gcdisplay.CreateCycle('Ammo', ammo) end
	end

	function gcinclude.SetWeaponCycle(cname, val, quiet)
		local list = gcinclude.WeaponCycleList(cname);
		if (type(list) ~= 'table') then return false end
		local index = tonumber(val);
		if (index ~= nil) and (index >= 1) and (index <= #list) then
			return gcdisplay.SetCycle(cname, list[index]);
		end
		local want = string.lower(val);
		for _, v in ipairs(list) do
			if (string.lower(v) == want) then
				return gcdisplay.SetCycle(cname, v);
			end
		end
		local hits = T{};
		for _, v in ipairs(list) do
			local lv = string.lower(v);
			if (string.sub(lv, 1, string.len(want)) == want) then hits:append(v) end
		end
		if (#hits == 0) then
			for _, v in ipairs(list) do
				if (string.find(string.lower(v), want, 1, true) ~= nil) then hits:append(v) end
			end
		end
		if (#hits == 1) then
			return gcdisplay.SetCycle(cname, hits[1]);
		elseif (quiet == true) then
			return false;
		elseif (#hits > 1) then
			gcinclude.Err(cname .. ' match is ambiguous: ' .. table.concat(hits, ', '));
		else
			gcinclude.Err('No ' .. cname .. ' match for: ' .. val);
		end
		return false;
	end

	function gcinclude.WeaponCommand(cname, args)
		local force = false;
		local words = T{};
		for i = 2, #args do
			if (string.lower(args[i]) == 'force') then force = true else words:append(args[i]) end
		end
		local arg = (#words > 0) and table.concat(words, ' ') or nil;
		if (cname == 'Weapons') and (arg ~= nil) and (string.lower(arg) == 'default') and (type(gcinclude.DefaultWeapons) == 'table') then
			if (not force) and gcinclude.HoldActive() then
				gcinclude.Err('Weapons kept: engaged at ' .. tostring(gData.GetPlayer().TP) .. ' TP (add force to override)');
				return;
			end
			for dname, dval in pairs(gcinclude.DefaultWeapons) do gcinclude.SetWeaponCycle(dname, dval, true) end
			gcinclude.ApplyWeapons(force);
			return;
		end
		local list = gcinclude.WeaponCycleList(cname);
		if (type(list) ~= 'table') or (#list == 0) then return end
		local old = gcdisplay.GetCycle(cname);
		if (arg == nil) then
			gcdisplay.AdvanceCycle(cname);
		else
			local want = string.lower(arg);
			local quiet = false;
			if (cname == 'Weapons') then
				if (want == 'default') then
					arg = gcinclude.DefaultWeapons or 'None';
					quiet = true;
				elseif (type(gcinclude.WeaponRoles) == 'table') and (gcinclude.WeaponRoles[want] ~= nil) then
					arg = gcinclude.WeaponRoles[want];
				elseif gcinclude.WeaponRoleNames:contains(want) then
					arg = nil;
				end
			end
			if (arg == nil) then return end
			if not gcinclude.SetWeaponCycle(cname, arg, quiet) then return end
		end
		local new = gcdisplay.GetCycle(cname);
		if (new == old) then return end
		if (cname ~= 'Ammo') and (not force) and gcinclude.HoldActive() then
			gcdisplay.SetCycle(cname, old);
			gcinclude.Err(cname .. ' kept on ' .. tostring(old) .. ': engaged at ' .. tostring(gData.GetPlayer().TP) .. ' TP (add force to override)');
			return;
		end
		gcinclude.ApplyWeapons(force);
	end

	function gcinclude.IsWeaponValue(v)
		return (v ~= nil) and (v ~= 'None') and (v ~= 'Unknown');
	end

	gcinclude.HoldSlots = T{1, 2, 3};
	gcinclude.HeldSlots = {};
	gcinclude.LockedSlots = {};
	gcinclude.NextHoldCheck = 0;
	gcinclude.MissingWarned = {};
	gcinclude.LastDualWield = false;
	gcinclude.RollBuffs = T{'Fighter\'s Roll','Monk\'s Roll','Healer\'s Roll','Wizard\'s Roll','Warlock\'s Roll','Rogue\'s Roll','Gallant\'s Roll','Chaos Roll','Beast Roll','Choral Roll','Hunter\'s Roll','Samurai Roll','Ninja Roll','Drachen Roll','Evoker\'s Roll','Magus\'s Roll','Corsair\'s Roll','Puppet Roll','Dancer\'s Roll','Scholar\'s Roll','Bolter\'s Roll','Caster\'s Roll','Courser\'s Roll','Blitzer\'s Roll','Tactician\'s Roll','Allies\' Roll','Miser\'s Roll','Companion\'s Roll','Avenger\'s Roll','Naturalist\'s Roll','Runeist\'s Roll'};

	function gcinclude.UnlockWeapons()
		for slot, _ in pairs(gcinclude.HeldSlots) do
			if (gcinclude.LockedSlots[slot] == nil) then gState.Disabled[slot] = false end
		end
		gcinclude.HeldSlots = {};
	end

	gcinclude.AllSlotNames = T{'Main', 'Sub', 'Range', 'Ammo', 'Head', 'Body', 'Hands', 'Legs', 'Feet',
		'Neck', 'Waist', 'Ear1', 'Ear2', 'Ring1', 'Ring2', 'Back'};

	function gcinclude.SlotNumbers(args, first)
		local slots, unknown = T{}, T{};
		for i = first, #args do
			local want = string.lower(args[i]);
			local hit = false;
			for _, name in ipairs(gcinclude.AllSlotNames) do
				if (string.sub(string.lower(name), 1, string.len(want)) == want) then
					local n = gData.GetEquipSlot(name);
					hit = true;
					if not slots:contains(n) then slots:append(n) end
				end
			end
			if not hit then unknown:append(args[i]) end
		end
		return slots, unknown;
	end

	function gcinclude.SlotName(index)
		for _, name in ipairs(gcinclude.AllSlotNames) do
			if (gData.GetEquipSlot(name) == index) then return name end
		end
		return tostring(index);
	end

	function gcinclude.LockSlots(slots)
		if (slots == nil) or (#slots == 0) then slots = T{1, 2, 4} end
		for _, slot in ipairs(slots) do
			gcinclude.LockedSlots[slot] = true;
			gState.Disabled[slot] = true;
			gcinclude.HeldSlots[slot] = nil;
		end
		return slots;
	end

	function gcinclude.UnlockSlots(slots)
		if (slots == nil) or (#slots == 0) then
			slots = T{};
			for slot, _ in pairs(gcinclude.LockedSlots) do slots:append(slot) end
		end
		for _, slot in ipairs(slots) do
			gcinclude.LockedSlots[slot] = nil;
			gState.Disabled[slot] = false;
		end
		return slots;
	end

	function gcinclude.LockCommand(args)
		local wanted, unknown = gcinclude.SlotNumbers(args, 2);
		if (#unknown > 0) then
			gcinclude.Err('No such slot: ' .. table.concat(unknown, ', ') .. ' - nothing locked');
			return;
		end
		local slots = gcinclude.LockSlots(wanted);
		local names = T{};
		for _, slot in ipairs(slots) do names:append(gcinclude.SlotName(slot)) end
		gcinclude.Say('Locked: ' .. table.concat(names, ', '));
	end

	function gcinclude.UnlockCommand(args)
		local wanted, unknown = gcinclude.SlotNumbers(args, 2);
		if (#unknown > 0) then
			gcinclude.Err('No such slot: ' .. table.concat(unknown, ', ') .. ' - nothing unlocked');
			return;
		end
		gcinclude.UnlockSlots(wanted);
		gcinclude.Say('Unlocked');
	end


	-- Holds: put items on and keep those slots until released. Slots already /locked or TP-held are skipped.
	gcinclude.Holds = {}; -- key -> slot numbers it locked
	function gcinclude.ReleaseHold(key)
		local owned = gcinclude.Holds[key];
		if (owned ~= nil) then gcinclude.UnlockSlots(owned) end
		gcinclude.Holds[key] = nil;
	end

	function gcinclude.HoldSet(key, set)
		gcinclude.ReleaseHold(key);
		local out, owned = {}, T{};
		for slotName, item in pairs(set) do
			local n = gData.GetEquipSlot(slotName);
			if (n ~= 0) and (gState.Disabled[n] ~= true) then out[slotName] = item; owned:append(n) end
		end
		if (#owned == 0) then return false end
		gFunc.ForceEquipSet(out);
		gcinclude.LockSlots(owned);
		gcinclude.Holds[key] = owned;
		return true;
	end

	-- Strip holds, one at a time: bare these slots and keep them bare.
	gcinclude.StripModes = T{
		naked = gcinclude.AllSlotNames,
		weaponsonly = T{'Head', 'Body', 'Hands', 'Legs', 'Feet', 'Neck', 'Waist', 'Ear1', 'Ear2', 'Ring1', 'Ring2', 'Back'},
		abysseaproc = T{'Head', 'Hands', 'Legs', 'Feet'},
	};

	function gcinclude.StripCommand(mode, arg)
		local cur = gcinclude.Strip;
		if (arg == 'off') or ((arg ~= 'on') and (cur == mode)) then
			if (cur ~= mode) then gcinclude.Say(mode .. ': not on'); return end
			gcinclude.ReleaseHold('strip');
			gcinclude.Strip = nil;
			gcinclude.Say(mode .. ': off');
			return;
		end
		local set = {};
		for _, slot in ipairs(gcinclude.StripModes[mode]) do set[slot] = 'remove' end
		gcinclude.Strip = gcinclude.HoldSet('strip', set) and mode or nil;
		gcinclude.Say(mode .. ': ' .. (gcinclude.Strip and 'on' or 'every slot is locked'));
	end

	-- Carried-item holds: the best carried capacity cape, the Jubilee Ring.
	gcinclude.CarriedKeys = T{'capacity', 'jubilee'};

	local function carriedId(id)
		local inv = AshitaCore:GetMemoryManager():GetInventory();
		local bags = gSettings.EquipBags;
		if (type(bags) ~= 'table') or (#bags == 0) then bags = {8, 10, 11, 12, 13, 14, 15, 16, 0} end
		for _, c in ipairs(bags) do
			for i = 1, (gData.GetContainerMax(c) or 0) do
				local it = inv:GetContainerItem(c, i);
				if (it ~= nil) and (it.Id == id) then return true end
			end
		end
		return false;
	end

	local function carriedName(name)
		local r = AshitaCore:GetResourceManager():GetItemByName(name, 0);
		return (r ~= nil) and carriedId(r.Id);
	end

	function gcinclude.CarriedPick(key)
		if (key == 'capacity') then
			for _, name in ipairs(gcinclude.settings.CapacityCapes or {}) do
				if carriedName(name) then return 'Back', name end
			end
		elseif (key == 'jubilee') and carriedName('Jubilee Ring') then
			return (gcinclude.settings.JubileeSlot or 'Ring1'), 'Jubilee Ring';
		end
		return nil;
	end

	function gcinclude.CarriedCommand(key, arg)
		if (arg == 'off') or ((arg ~= 'on') and (gcinclude.Holds[key] ~= nil)) then
			gcinclude.ReleaseHold(key);
			gcinclude.Say(key .. ': off');
			return;
		end
		local slot, item = gcinclude.CarriedPick(key);
		if (item == nil) then gcinclude.Say(key .. ': none carried'); return end
		gcinclude.Say(key .. ': ' .. (gcinclude.HoldSet(key, { [slot] = item }) and item or (slot .. ' is locked')));
	end

	-- /lockstyleset after the gear settles.
	function gcinclude.ApplyLockstyle(n, delay)
		n = tonumber(n or gcinclude.LockstyleSet or gcinclude.settings.LockstyleSet);
		if (n == nil) then return false end
		local function go() AshitaCore:GetChatManager():QueueCommand(-1, '/lockstyleset ' .. n) end
		if ((delay or 4) > 0) then go:once(delay or 4) else go() end
		return true;
	end

	function gcinclude.HoldActive()
		local guard = gcinclude.settings.WeaponTPGuard or 0;
		if (guard <= 0) then return false end
		local player = gData.GetPlayer();
		return (player ~= nil) and (player.Status == 'Engaged') and (player.TP >= guard);
	end

	function gcinclude.UpdateHold()
		if gcinclude.HoldActive() then
			for _, slot in ipairs(gcinclude.HoldSlots) do
				if (gcinclude.HeldSlots[slot] == nil) and (gcinclude.LockedSlots[slot] == nil) and (gState.Disabled[slot] ~= true) then
					gState.Disabled[slot] = true;
					gcinclude.HeldSlots[slot] = true;
				end
			end
		elseif (next(gcinclude.HeldSlots) ~= nil) then
			gcinclude.UnlockWeapons();
		end
	end

	function gcinclude.CheckEnchantHold()
		if (gcinclude.EnchantHold == nil) then return end
		local now = os.clock();
		if (gcinclude.EnchantUseAt ~= nil) and (now >= gcinclude.EnchantUseAt) then
			AshitaCore:GetChatManager():QueueCommand(-1, '/item "' .. gcinclude.EnchantItem .. '" <me>');
			gcinclude.EnchantUseAt = nil;
		end
		if (now < (gcinclude.EnchantUntil or 0)) then return end
		if (gcinclude.EnchantWasLocked ~= true) then gcinclude.UnlockSlots(T{gcinclude.EnchantHold}) end
		gcinclude.EnchantWasLocked = nil;
		gcinclude.EnchantHold = nil;
		gcinclude.EnchantItem = nil;
	end

	function gcinclude.HoldTick()
		local now = os.clock();
		if (now < gcinclude.NextHoldCheck) then return end
		gcinclude.NextHoldCheck = now + 0.1;
		gcinclude.CheckEnchantHold();
		gcaction.Tick();
		if (gcinclude.HoldSuspended == true) then
			if (gState.PlayerAction ~= nil) then return end
			gcinclude.HoldSuspended = false;
		end
		gcinclude.UpdateHold();
	end

	gcinclude.SlotBits = T{ Main = 1, Sub = 2, Range = 4, Ammo = 8, Head = 16, Body = 32,
		Hands = 64, Legs = 128, Feet = 256, Neck = 512, Waist = 1024, Ear1 = 2048, Ear2 = 2048,
		Ring1 = 8192, Ring2 = 8192, Back = 32768 };

	gcinclude.WeakTo = T{ Fire = 'Water', Ice = 'Fire', Wind = 'Ice', Earth = 'Wind',
		Thunder = 'Earth', Water = 'Thunder', Light = 'Dark', Dark = 'Light' };

	-- Day/weather value for an element, in %: day +10, single weather +10, double weather +25; the element
	-- strong against it (WeakTo) subtracts the same. An obi forces all of it, bonus and penalty (BG
	-- Category:Elemental Obi: Hachirin keeps the forced penalty; example day +10 / double weather -25).
	function gcinclude.DayWeatherNet(element)
		local env = gData.GetEnvironment();
		if (env == nil) or (element == nil) then return 0 end
		local against = gcinclude.WeakTo[element];
		local double = (type(env.Weather) == 'string') and (string.find(env.Weather, 'x2', 1, true) ~= nil);
		local function weather(el)
			if (el ~= nil) and (env.WeatherElement == el) then return double and 25 or 10 end
			return 0;
		end
		local net = weather(element) - weather(against);
		if (env.DayElement == element) then net = net + 10 end
		if (against ~= nil) and (env.DayElement == against) then net = net - 10 end
		return net;
	end

	-- Orpheus's Sash: affinity rises as the target gets closer. BG documents only the ends: +15 at <= 1.93',
	-- +1 at >= 13'. In between it is interpolated linearly through settings.OrpheusPoints - an assumption,
	-- not a published formula. Add measured {distance, value} points there to refine it.
	function gcinclude.OrpheusValue(distance)
		if (distance == nil) then return nil end
		local pts = gcinclude.settings.OrpheusPoints;
		if (type(pts) ~= 'table') or (#pts == 0) then return nil end
		if (distance <= pts[1][1]) then return pts[1][2] end
		for i = 2, #pts do
			local a, b = pts[i - 1], pts[i];
			if (distance <= b[1]) then
				return a[2] + (b[2] - a[2]) * (distance - a[1]) / (b[1] - a[1]);
			end
		end
		return pts[#pts][2];
	end

	function gcinclude.ElementCfg()
		return gcinclude.ElementGear or gcinclude.settings.ElementGear;
	end

	function gcinclude.ElementWaist(element)
		local cfg = gcinclude.ElementCfg();
		if (type(cfg) ~= 'table') or (element == nil) then return nil end
		local obi = (type(cfg.Obis) == 'table') and cfg.Obis[element] or nil;
		obi = obi or cfg.AnyObi;
		local obiValue = (obi ~= nil) and gcinclude.DayWeatherNet(element) or 0;
		local sashValue = nil;
		if (cfg.Distance ~= nil) then
			local target = gData.GetActionTarget() or gData.GetTarget(); -- the action's target, not whatever is selected
			local d = (target ~= nil) and tonumber(target.Distance) or nil;
			if (d ~= nil) and ((cfg.DistanceMax == nil) or (d <= cfg.DistanceMax)) then
				sashValue = gcinclude.OrpheusValue(d);
			end
		end
		if (obiValue > 0) and ((sashValue == nil) or (obiValue > sashValue)) then return obi, obiValue end
		if (sashValue ~= nil) then return cfg.Distance, sashValue end
		return nil;
	end

	-- gFunc.ForceEquipSet sends packets directly and ignores gState.Disabled, so /lock and the TP hold
	-- would be bypassed. Engine force-equips drop disabled slots first.
	function gcinclude.ForceUnlocked(set)
		if (type(set) ~= 'table') then return end
		local out, n = {}, 0;
		for k, v in pairs(set) do
			local slot = gData.GetEquipSlot(k);
			if (slot ~= 0) and (gState.Disabled[slot] ~= true) then
				out[k] = v;
				n = n + 1;
			end
		end
		if (n > 0) then gFunc.ForceEquipSet(out) end
	end

	-- Received set: remembered for ReceivedWindow and layered by CheckReceived in HandleDefault.
	-- Put on at once only when you are not mid-action, so your own precast/midcast gear is never replaced.
	function gcinclude.StartReceived(spellName)
		local setName = gcinclude.ReceivedSetFor(spellName);
		if (setName == nil) then return end
		local set = gcinclude.FindSet(setName);
		if (set == nil) or (next(set) == nil) then return end
		gcinclude.ReceivedSet = set;
		gcinclude.ReceivedUntil = os.clock() + (gcinclude.settings.ReceivedWindow or 8);
		if (gState.PlayerAction == nil) then gcinclude.ForceUnlocked(set) end
	end

	function gcinclude.ReceivedSetFor(name)
		if (type(name) ~= 'string') then return nil end
		local lower = string.lower(name);
		local best, bestLen = nil, -1;
		for prefix, setName in pairs(gcinclude.settings.ReceivedSets) do
			if (string.sub(lower, 1, string.len(prefix)) == prefix) and (string.len(prefix) > bestLen) then
				best, bestLen = setName, string.len(prefix);
			end
		end
		return best;
	end

	function gcinclude.AnnounceCast()
		local action = gData.GetAction();
		if (action == nil) or (action.Name == nil) then return end
		if (gcinclude.ReceivedSetFor(action.Name) == nil) then return end
		local target = gData.GetActionTarget();
		if (target == nil) or (target.Name == nil) then return end
		local me = gData.GetPlayer();
		if (me ~= nil) and (me.Name == target.Name) then return end
		if (target.Type ~= 'PC') and (target.Type ~= 'Party') and (target.Type ~= 'Alliance') then return end
		AshitaCore:GetChatManager():QueueCommand(-1, '/ms sendto ' .. target.Name .. ' /lac fwd received ' .. action.Name);
	end

	function gcinclude.ReceivedCommand(args)
		local words = T{};
		for i = 2, #args do words:append(args[i]) end
		if (#words == 0) then return end
		gcinclude.StartReceived(table.concat(words, ' '));
	end

	function gcinclude.WearReceived(spellName)
		gcinclude.StartReceived(spellName);
	end

	function gcinclude.CheckReceived()
		if (gcinclude.ReceivedSet == nil) then return end
		if (os.clock() > (gcinclude.ReceivedUntil or 0)) then
			gcinclude.ReceivedSet = nil;
			return;
		end
		gFunc.EquipSet(gcinclude.ReceivedSet);
	end

	function gcinclude.ElementKept(slot)
		local cfg = gcinclude.ElementCfg();
		local keep = (type(cfg) == 'table') and cfg.Keep or nil;
		if (type(keep) ~= 'table') or (#keep == 0) then return false end
		local equip = gData.GetEquipment();
		if (equip == nil) or (equip[slot] == nil) or (equip[slot].Name == nil) then return false end
		local worn = string.lower(equip[slot].Name);
		for _, item in ipairs(keep) do
			if (string.lower(item) == worn) then return true end
		end
		return false;
	end

	function gcinclude.ElementRing(element)
		local cfg = gcinclude.ElementCfg();
		if (type(cfg) ~= 'table') or (cfg.Ring == nil) or (element == nil) then return nil end
		local env = gData.GetEnvironment();
		if (env == nil) or (env.DayElement ~= element) then return nil end
		return cfg.Ring, (cfg.RingSlot or 'Ring2');
	end

	-- Obi / Orpheus / element ring: only spells in ElementSkills and WS in ElementalWS.
	function gcinclude.CheckElementGear()
		local action = gData.GetAction();
		if (action == nil) then return end
		local element = nil;
		if (action.ActionType == 'Spell') then
			local skills = gcinclude.settings.ElementSkills;
			if (type(skills) == 'table') and skills:contains(action.Skill) then element = action.Element end
		elseif (action.ActionType == 'Weaponskill') then
			local list = gcinclude.settings.ElementalWS;
			if (type(list) == 'table') then element = list[action.Name] end
		end
		if (element == nil) or (element == 'Non-Elemental') then return end
		-- Zodiac-type ring only on spells: its effect on WS is unverified.
		gcinclude.ApplyElementGear(element, action.Name, action.ActionType ~= 'Spell');
	end

	function gcinclude.ApplyElementGear(element, label, noRing)
		local set = {};
		local report = T{};
		local waist, value = gcinclude.ElementWaist(element);
		if (waist ~= nil) then
			if gcinclude.ElementKept('Waist') then
				report:append('waist kept');
			else
				set.Waist = waist;
				report:append('waist ' .. waist .. string.format(' (+%.1f%%)', value));
			end
		end
		local ring, slot = nil, nil;
		if (noRing ~= true) then ring, slot = gcinclude.ElementRing(element) end
		if (ring ~= nil) then
			if gcinclude.ElementKept(slot) then
				report:append(string.lower(slot) .. ' kept');
			else
				set[slot] = ring;
				report:append(string.lower(slot) .. ' ' .. ring);
			end
		end
		if (next(set) == nil) then return end
		gFunc.EquipSet(set);
		if (gcinclude.settings.ElementReport == true) then
			print(chat.header('ShaySwap'):append(chat.message((label or element) .. ' [' .. element .. ']: ' .. table.concat(report, ', '))));
		end
	end

	function gcinclude.CheckLightBonus()
		local action = gData.GetAction();
		if (action == nil) or (action.Skill ~= 'Healing Magic') then return end
		local set = gcinclude.FindSet('LightBonus');
		if (set ~= nil) then gFunc.EquipSet(set) end
	end

	function gcinclude.IsHoldExempt()
		local action = gData.GetAction();
		if (action == nil) then return false end
		if (action.ActionType == 'Spell') then
			return gcinclude.settings.HoldExemptSkills:contains(action.Skill);
		elseif (action.ActionType == 'Ability') then
			return gcinclude.settings.HoldExemptAbilities:contains(action.Type);
		end
		return false;
	end

	function gcinclude.CheckHoldExempt()
		if gcinclude.IsHoldExempt() then
			gcinclude.UnlockWeapons();
			gcinclude.HoldSuspended = true;
		end
	end

	gcinclude.SmartKeep = false;

	function gcinclude.SmartSwapCommand(args)
		local v = (args[2] ~= nil) and string.lower(args[2]) or nil;
		if (v == 'on') then gcinclude.settings.SmartSwap = true;
		elseif (v == 'off') then gcinclude.settings.SmartSwap = false;
		else gcinclude.settings.SmartSwap = not (gcinclude.settings.SmartSwap == true) end
		gcinclude.Say('SmartSwap: ' .. (gcinclude.settings.SmartSwap and 'On' or 'Off'));
	end

	gcinclude.AutoGearKeys = T{ regen = 'RegenGearHPP', refresh = 'RefreshGearMPP', dt = 'DTGearHPP', petdt = 'PetDTGearHPP' };

	function gcinclude.AutoGearCommand(args)
		local cfg = gcinclude.settings;
		local what = (args[2] ~= nil) and string.lower(args[2]) or nil;
		if (what == 'on') then cfg.AutoGear = true;
		elseif (what == 'off') then cfg.AutoGear = false;
		elseif (what ~= nil) and (gcinclude.AutoGearKeys[what] ~= nil) and (tonumber(args[3]) ~= nil) then
			cfg[gcinclude.AutoGearKeys[what]] = math.max(0, math.min(100, tonumber(args[3])));
		elseif (what ~= nil) then
			gcinclude.Err('usage: /autogear [on|off|regen N|refresh N|dt N|petdt N], 0 = never');
			return;
		end
		print(chat.header('GCinclude'):append(chat.message(string.format('AutoGear %s | regen <%d%% hp, refresh <%d%% mp (both out of combat) | dt <%d%% hp | petdt <%d%% pet hp',
			(cfg.AutoGear ~= false) and 'on' or 'off', cfg.RegenGearHPP or 0, cfg.RefreshGearMPP or 0, cfg.DTGearHPP or 0, cfg.PetDTGearHPP or 0))));
	end

	function gcinclude.SmartKeepFor(action)
		local cfg = gcinclude.settings;
		if (cfg.SmartSwap ~= true) or (action == nil) or (action.ActionType ~= 'Spell') or (type(action.Name) ~= 'string') then return false end
		local player = gData.GetPlayer();
		if (player == nil) or (player.TP < (cfg.SmartSwapTP or 1)) then return false end
		local lname = string.lower(action.Name);
		for _, n in ipairs(cfg.NoWeaponSpells or {}) do
			if (string.lower(n) == lname) then return true end
		end
		local equip = gData.GetEquipment();
		if (equip == nil) then return false end
		for _, rule in ipairs(cfg.KeepWeaponsFor or {}) do
			local hit = false;
			for _, pre in ipairs(rule.Spells or {}) do
				local lp = string.lower(pre);
				if (string.sub(lname, 1, string.len(lp)) == lp) then hit = true end
			end
			if hit then
				for _, slot in ipairs(T{'Main', 'Sub'}) do
					local worn = equip[slot];
					if (worn ~= nil) and (type(worn.Name) == 'string') then
						local wn = string.lower(worn.Name);
						for _, item in ipairs(rule.Worn or {}) do
							if (string.lower(item) == wn) then return true end
						end
					end
				end
			end
		end
		return false;
	end

	function gcinclude.StripWeaponSwaps()
		gFunc.Equip('Main', 'ignore');
		gFunc.Equip('Sub', 'ignore');
		gFunc.Equip('Range', 'ignore');
	end

	-- Trace phase per handler: 'pre' waits for its 'mid' so a spell or shot prints one line.
	gcinclude.TracePhase = { HandlePrecast = 'pre', HandleMidcast = 'mid', HandlePreshot = 'pre', HandleMidshot = 'mid' };
	gcinclude.Checked = T{'HandlePrecast', 'HandleAbility'};

	function gcinclude.WrapHoldHandlers()
		if (gProfile == nil) or (gProfile.GcHoldWrapped == true) then return end
		gcaction.Hook();
		for _, name in ipairs(T{'HandlePrecast', 'HandleAbility', 'HandleMidcast'}) do
			local original = gProfile[name];
			if (type(original) == 'function') then
				gProfile[name] = function(...)
					if gcinclude.Checked:contains(name) and gcaction.Check() then gFunc.CancelAction(); return end
					gcaction.TraceStart();
					gcinclude.CheckHoldExempt();
					if (name == 'HandleAbility') then gcinclude.AnnounceCast() end -- Waltzes to your own boxes
					if (name == 'HandlePrecast') then
						gcinclude.AnnounceCast();
						gcinclude.SmartKeep = gcinclude.SmartKeepFor(gData.GetAction());
					end
					local result = original(...);
					if (name == 'HandleMidcast') then
						gcinclude.CheckAbsorb();
						gcinclude.CheckLightBonus();
						gcinclude.CheckElementGear();
						gcinclude.CheckSIR();
					end
					if (gcinclude.SmartKeep == true) and ((name == 'HandlePrecast') or (name == 'HandleMidcast')) then
						gcinclude.StripWeaponSwaps();
					end
					gcaction.TraceEnd(gcinclude.TracePhase[name]);
					return result;
				end
			end
		end
		local ws = gProfile.HandleWeaponskill;
		if (type(ws) == 'function') then
			gProfile.HandleWeaponskill = function(...)
				if gcaction.Check() then gFunc.CancelAction(); return end
				gcaction.TraceStart();
				local result, trail = gcinclude.TrackEars(ws, ...);
				if (gState.PlayerAction ~= nil) and (gState.PlayerAction.Block == true) then gcaction.TraceEnd(); return result end -- WS cancelled
				gcinclude.CheckMoonshade(trail);
				gcinclude.CheckElementGear();
				gcaction.TraceEnd();
				return result;
			end
		end
		for _, name in ipairs(T{'HandlePreshot', 'HandleMidshot', 'HandleItem'}) do
			local original = gProfile[name];
			if (type(original) == 'function') then
				gProfile[name] = function(...)
					gcaction.TraceStart();
					local result = original(...);
					gcaction.TraceEnd(gcinclude.TracePhase[name]);
					return result;
				end
			end
		end
		gProfile.GcHoldWrapped = true;
	end

	-- Buff counts by id. LAC's GetBuffCount(name) converts every active buff name on each call;
	-- here each name is resolved to its ids once and counted against the raw buff list.
	local buffIds = {};
	function gcinclude.BuffCount(m)
		local buffs = AshitaCore:GetMemoryManager():GetPlayer():GetBuffs();
		local count = 0;
		if (type(m) == 'number') then
			for _, b in pairs(buffs) do
				if (b == m) then count = count + 1 end
			end
			return count;
		end
		if (type(m) ~= 'string') then return 0 end
		local key = string.lower(m);
		local ids = buffIds[key];
		if (ids == nil) then
			ids = {};
			local res = AshitaCore:GetResourceManager();
			for id = 0, 1023 do
				local name = res:GetString('buffs.names', id);
				if (type(name) == 'string') and (string.lower((name:gsub('%z+$', ''))) == key) then ids[id] = true end
			end
			buffIds[key] = ids;
		end
		for _, b in pairs(buffs) do
			if ids[b] then count = count + 1 end
		end
		return count;
	end

	-- Lowercase name -> set, built once per Sets table. HandleDefault looks up ~10 sets per call;
	-- scanning every set each time was the costliest part of it. /lac addset reloads the profile,
	-- which gives a new Sets table and so a fresh index.
	local setIndex, setIndexOf = {}, nil;
	function gcinclude.FindSet(name)
		if (gProfile == nil) or (type(gProfile.Sets) ~= 'table') or (type(name) ~= 'string') then return nil end
		if (setIndexOf ~= gProfile.Sets) then
			setIndex, setIndexOf = {}, gProfile.Sets;
			for key, set in pairs(gProfile.Sets) do
				if (type(key) == 'string') and (type(set) == 'table') then setIndex[string.lower(key)] = set end
			end
		end
		return setIndex[string.lower(name)];
	end

	-- Job-file helpers.
	-- Wears <prefix>_Default, then <prefix>_<mode> when /meleeset is not Default.
	function gcinclude.EquipMode(prefix)
		gFunc.EquipSet(gProfile.Sets[prefix .. '_Default']);
		local mode = gcdisplay.GetCycle('MeleeSet');
		if (mode ~= 'Default') then gFunc.EquipSet(prefix .. '_' .. mode) end
	end

	-- Wears the set named after an action, then its /meleeset variant. False if there is none.
	function gcinclude.ByName(name)
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
	function gcinclude.Family(name)
		local base = string.match(name, '^(.-):') or name;
		return (string.gsub(base, ' [IVX]+$', ''));
	end

	function gcinclude.CanDualWield()
		if (gcinclude.AlwaysDualWield == true) then return true end
		local player = gData.GetPlayer();
		local sub = (player ~= nil) and player.SubJob or nil;
		if (sub == nil) or (sub == '') or (sub == 'NON') then
			return (gcinclude.LastDualWield == true);
		end
		gcinclude.LastDualWield = gcinclude.DualWieldSubs:contains(sub);
		return gcinclude.LastDualWield;
	end

	function gcinclude.BuildWeaponLayer()
		local equip = {};
		local mode = gcdisplay.GetCycle('Weapons');
		if gcinclude.IsWeaponValue(mode) then
			local set = nil;
			if not gcinclude.CanDualWield() then
				set = gcinclude.FindSet('Weapon_' .. mode .. '_1h');
			end
			if (set == nil) then
				set = gcinclude.FindSet('Weapon_' .. mode);
			end
			if (set == nil) then
				if (gcinclude.MissingWarned[mode] == nil) then
					gcinclude.MissingWarned[mode] = true;
					gcinclude.Err('Missing set: Weapon_' .. mode);
				end
			else
				for k, v in pairs(set) do
					local slot = gData.GetEquipSlot(k);
					if gcinclude.WeaponSlots:contains(slot) then
						equip[slot] = v;
					end
				end
			end
		end
		for slot, cname in ipairs(gcinclude.WeaponSlotNames) do
			local v = gcdisplay.GetCycle(cname);
			if gcinclude.IsWeaponValue(v) then equip[slot] = gcinclude.WeaponItems[string.lower(v)] or v end
		end
		-- Main/Sub/Range in the TH set stay on while /th is on, tagged or not: swapping them resets TP.
		-- Sub only when you can dual wield; otherwise it is dropped (CheckTH skips it too).
		if (gcdisplay.GetToggle('TH') == true) then
			local th = gcinclude.FindSet('TH');
			if (th ~= nil) then
				for k, v in pairs(th) do
					local slot = gData.GetEquipSlot(k);
					if gcinclude.HoldSlots:contains(slot) and ((slot ~= 2) or gcinclude.CanDualWield()) then equip[slot] = v end
				end
			end
		end
		local set = {};
		local count = 0;
		for slot, v in pairs(equip) do
			set[gcinclude.WeaponSlotNames[slot]] = v;
			count = count + 1;
		end
		if (count == 0) then return nil end
		return set;
	end

	function gcinclude.ApplyWeapons(force)
		local set = gcinclude.BuildWeaponLayer();
		if (set == nil) then return end
		if (force == true) then
			gcinclude.UnlockWeapons(); -- force lifts the TP hold only; /lock stays absolute
			gcinclude.NextHoldCheck = os.clock() + 0.5; -- let the swap land before the hold re-checks
		end
		gcinclude.ForceUnlocked(set);
	end


	-- No-ops kept so job files copied from older versions still load. Don't remove.
	function gcinclude.CheckWeaponSwap() end
	function gcinclude.DoMoonshade() end
	function gcinclude.GetWeaponSet(mode) return gcinclude.FindSet('Weapon_' .. mode) end

	-- TH gear until the action's target (else the selected one) is tagged; none for an action on you or an
	-- ally. force skips both checks (AoE TH spells, which can be self-targeted). Main/Sub/Range are left to BuildWeaponLayer, so they don't come off at the tag. The TH set
	-- minus those slots is built once per set table (the set itself when it has none, so /gctrace names it).
	local thGear, thGearOf = nil, nil;
	function gcinclude.CheckTH(force)
		if (gcdisplay.GetToggle('TH') ~= true) then return end
		local set = gcinclude.FindSet('TH');
		if (set == nil) then return end
		if (force ~= true) then
			local action = gData.GetActionTarget();
			if (action ~= nil) and (action.Type ~= 'Monster') then return end
			local target = action or gData.GetTarget();
			if (target ~= nil) and (target.Type == 'Monster') and (gcauto ~= nil) and (gcauto.IsTagged ~= nil) and gcauto.IsTagged(target.Id) then
				return;
			end
		end
		if (thGearOf ~= set) then
			thGear, thGearOf = set, set;
			for k, _ in pairs(set) do
				if gcinclude.HoldSlots:contains(gData.GetEquipSlot(k)) then
					thGear = {};
					for k2, v2 in pairs(set) do
						if not gcinclude.HoldSlots:contains(gData.GetEquipSlot(k2)) then thGear[k2] = v2 end
					end
					break;
				end
			end
		end
		gFunc.EquipSet(thGear);
	end

	gcinclude.HoxneOwned = T{};

	function gcinclude.CheckHoxne()
		local state = gcdisplay.GetCycle('Hoxne');
		if (state == 'Locked') then
			if (gcinclude.HoxneLocked ~= true) then
				gcinclude.HoxneLocked = true;
				gcinclude.HoxneOwned = T{};
				for _, slot in ipairs(gcinclude.SlotNumbers(gcinclude.settings.HoxneLockSlots, 1)) do
					if (gcinclude.LockedSlots[slot] == nil) then gcinclude.HoxneOwned:append(slot) end
				end
				if (#gcinclude.HoxneOwned > 0) then gcinclude.LockSlots(gcinclude.HoxneOwned) end
			end
		elseif (gcinclude.HoxneLocked == true) then
			gcinclude.HoxneLocked = false;
			if (#gcinclude.HoxneOwned > 0) then gcinclude.UnlockSlots(gcinclude.HoxneOwned) end
			gcinclude.HoxneOwned = T{};
		end
		if (state ~= 'On') and (state ~= 'Locked') then return end
		gFunc.EquipSet({ Ammo = gcinclude.settings.HoxneItem });
	end

	gcinclude.BoundKeys = T{};

	function gcinclude.ApplyKeybinds()
		local binds = gcinclude.settings.Keybinds;
		if (type(binds) ~= 'table') then return end
		for _, bind in ipairs(binds) do
			if (type(bind) == 'table') and (bind[1] ~= nil) and (bind[2] ~= nil) then
				AshitaCore:GetChatManager():QueueCommand(-1, '/bind ' .. bind[1] .. ' /lac fwd ' .. bind[2]);
				if not gcinclude.BoundKeys:contains(bind[1]) then gcinclude.BoundKeys:append(bind[1]) end
			end
		end
	end

	function gcinclude.ClearKeybinds()
		for _, key in ipairs(gcinclude.BoundKeys) do
			AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ' .. key);
		end
		gcinclude.BoundKeys = T{};
	end

	function gcinclude.KeyCommand(args)
		if (args[2] == nil) or (args[3] == nil) then
			gcinclude.Say('usage: /gckey <key> <command>  (key uses Ashita names and ! ^ + @ # modifiers)');
			return;
		end
		local rest = T{};
		for i = 3, #args do rest:append(args[i]) end
		AshitaCore:GetChatManager():QueueCommand(-1, '/bind ' .. args[2] .. ' /lac fwd ' .. table.concat(rest, ' '));
		if not gcinclude.BoundKeys:contains(args[2]) then gcinclude.BoundKeys:append(args[2]) end
		gcinclude.Say(args[2] .. ' -> /' .. table.concat(rest, ' '));
	end

	function gcinclude.EnchantDelay(name, res)
		local override = gcinclude.settings.EnchantDelays[name];
		if (override == nil) then
			for key, value in pairs(gcinclude.settings.EnchantDelays) do
				if (string.lower(key) == string.lower(name)) then override = value; break end
			end
		end
		if (tonumber(override) ~= nil) then return tonumber(override), 'setting' end
		local delay = (res ~= nil) and tonumber(res.CastDelay) or nil;
		if (delay ~= nil) and (delay > 0) and (delay <= 600) then return delay, 'item' end
		return (gcinclude.settings.EnchantWindow or 12), 'default';
	end

	function gcinclude.UseEnchanted(name, slot, allowLocked)
		local res = AshitaCore:GetResourceManager():GetItemByName(name, 0);
		if (res == nil) then
			gcinclude.Err('no such item: ' .. name);
			return false;
		end
		if (slot == nil) then
			local slots = gcinclude.EnchantSlots or T{'Ring1', 'Ring2', 'Neck', 'Waist', 'Back', 'Ear1', 'Ear2', 'Head', 'Body', 'Hands', 'Legs', 'Feet', 'Ammo'};
			for _, candidate in ipairs(slots) do
				if (bit.band(res.Slots, gcinclude.SlotBits[candidate] or 0) ~= 0) then slot = candidate; break end
			end
		end
		if (slot == nil) then
			gcinclude.Err(name .. ' has no slot to wear');
			return false;
		end
		local delay, source = gcinclude.EnchantDelay(name, res);
		local index = gData.GetEquipSlot(slot);
		local wasLocked = (gcinclude.LockedSlots[index] == true);
		if wasLocked and (allowLocked ~= true) then
			gcinclude.Err(slot .. ' is locked - /unlock ' .. string.lower(slot) .. ' first');
			return false;
		end
		gFunc.ForceEquipSet({ [slot] = name }); -- slot is free or owned by the caller
		gcinclude.LockSlots(T{index});
		gcinclude.EnchantWasLocked = wasLocked;
		gcinclude.EnchantHold = index;
		gcinclude.EnchantItem = name;
		gcinclude.EnchantUseAt = os.clock() + delay + 0.5;
		gcinclude.EnchantUntil = gcinclude.EnchantUseAt + 3;
		gcinclude.Say(name .. ' on ' .. string.lower(slot) .. ', using it in ' .. tostring(delay) .. 's (' .. source .. ')');
		return true;
	end

	function gcinclude.EnchantCommand(args)
		local words = T{};
		for i = 2, #args do words:append(args[i]) end
		if (#words == 0) then
			gcinclude.Say('usage: /gce Warp Ring');
			return;
		end
		local name = table.concat(words, ' ');
		gcinclude.UseEnchanted(name, nil);
	end

	function gcinclude.Help()
		local lines = T{
			'weapons: /wm [name|N|none|default|role] [force], /mainset /subset /rangeset /ammoset',
			'defense: /def (cycle DT > MDT > Aminon > SIRD > none), /dt /mdt /aminon /sir, /lock [slots] /unlock [slots]',
			'hoxne  : /hoxne (Off > On > Locked)',
			'toggles: /th (TH gear until the target is tagged; TH-set weapons while on), /kite, /meleeset (Default > Hybrid > Acc)',
			'auto   : /autofood [on|off], /autosoda [on|off], /revit [on|off], /holywater [on|off]',
			'hud    : /gchud [on|off|pos x y|debug]',
			'checks : /checksets, /xiroll, /mbinfo',
			'swap   : /smartswap [on|off]',
			'holds  : /naked /weaponsonly /abysseaproc [on|off] (one at a time), /capacity /jubilee [on|off]',
			'checks : /gctrace (sets per action), /gcstyle N (lockstyle); failing actions cancel, recasts under 5s queue',
			'gear   : /autogear [on|off|regen N|refresh N|dt N|petdt N]',
			'bar    : /gcbar [on|off|pos x y]',
			'nuke   : /mbmode Off > Chain (burst gear on live SC) > Auto (Chain + auto-cast) > Force (burst gear every nuke); parts: /automb, /autonuke, /burst; /mbtier low|mid|high = autonuke tier I|III|V',
			'keys   : grave wm, Shift wm default, Ctrl def, Alt hoxne, Win mbmode (Off > Chain > Auto > Force); /gckey <key> <command>',
			'all of these work as /mss /lac fwd <command> for every box',
		};
		for _, line in ipairs(lines) do
			print(chat.header('ShaySwap'):append(chat.message(line)));
		end
	end

	-- SIRD counts only while worn when each hit lands mid-cast (BG: must be in midcast),
	-- so it is laid over the finished midcast set, never at rest.
	function gcinclude.CheckSIR()
		if (gcdisplay.GetToggle('SIR') ~= true) then return end
		local action = gData.GetAction();
		if (action == nil) then return end
		if (gcinclude.settings.SIRCombatOnly == true) and (not gcinclude.InCombat()) then return end
		local skip = gcinclude.SIRSkip or gcinclude.settings.SIRSkip; -- job file may set gcinclude.SIRSkip
		if (type(skip) == 'table') and (skip:contains(action.Name)) then return end
		local set = gcinclude.FindSet('SIR');
		if (set ~= nil) then gFunc.EquipSet(set) end
	end

	-- True when the Burst set belongs on this cast: /burst forces it; /automb wants a skillchain
	-- whose elements include the spell's, live on the spell's target, landing inside the window.
	-- Job files call it where they used to check the Burst toggle, so their own layer order holds.
	function gcinclude.BurstWanted()
		local spell = gData.GetAction();
		if (spell == nil) then return false end
		local skills = gcinclude.settings.MBSkills;
		if (type(skills) ~= 'table') or (not skills:contains(spell.Skill)) then return false end
		if (gcdisplay.GetToggle('Burst') == true) then return true end
		if (gcdisplay.GetToggle('AutoMB') ~= true) then return false end
		local target = gData.GetActionTarget();
		if (target == nil) or (gcauto == nil) or (gcauto.BurstLive == nil) then return false end
		-- Midcast runs as the cast starts, so it lands after the learned cast time (gcauto.CastTime).
		-- No cast of this skill timed yet: only ask whether a chain is live now (wearing Burst gear on a
		-- miss costs little; skipping it on a hit costs the burst).
		local landsAt = nil;
		if (spell.Resource ~= nil) then
			local t, learned = gcauto.CastTime(spell.Resource);
			if learned then landsAt = os.clock() + t end
		end
		return gcauto.BurstLive(target.Id, spell.Element, landsAt);
	end

	function gcinclude.InCombat()
		local player = gData.GetPlayer();
		if (player ~= nil) and (player.Status == 'Engaged') then return true end
		return (gcauto ~= nil) and (gcauto.InCombat ~= nil) and gcauto.InCombat();
	end

	function gcinclude.CheckMDT()
		if (gcdisplay.GetToggle('MDTset') == true) then
			local set = gcinclude.FindSet('mdt');
			if (set ~= nil) then gFunc.EquipSet(set) end
		end
		if (gcdisplay.GetToggle('Aminon') == true) then
			local set = gcinclude.FindSet('Aminon') or gcinclude.FindSet('mdt');
			if (set ~= nil) then gFunc.EquipSet(set) end
		end
	end

	function gcinclude.CheckBuffSets()
		local buffs = gcinclude.FindSet('Buffs');
		if (buffs == nil) then return end
		local order = gcinclude.BuffSetOrder;
		if (type(order) ~= 'table') then
			order = T{};
			for name, _ in pairs(buffs) do order:append(name) end
			table.sort(order);
		end
		for _, name in ipairs(order) do
			local set = buffs[name];
			if (type(set) == 'table') and (gcinclude.BuffCount(name) > 0) then
				gFunc.EquipSet(set);
			end
		end
	end

	function gcinclude.CheckWeapons()
		local set = gcinclude.BuildWeaponLayer();
		if (set ~= nil) then gFunc.EquipSet(set) end
		gcinclude.CheckMDT();
		gcinclude.CheckHoxne();
		gcinclude.CheckTH();
		gcinclude.CheckReceived();
		gcinclude.CheckBuffSets();
		gcinclude.CheckXIRoll();
	end

	function gcinclude.IsBlockedAmmo(name)
		if (type(name) ~= 'string') then return false end
		local lname = string.lower(name);
		for _, v in ipairs(gcinclude.BlockedAmmo) do
			if (string.find(lname, v, 1, true) ~= nil) then return true end
		end
		return false;
	end

	function gcinclude.BlockedAmmoName()
		local equip = gData.GetEquipment();
		if (equip == nil) or (equip.Ammo == nil) or (type(equip.Ammo.Name) ~= 'string') then return nil end
		if (gcinclude.IsBlockedAmmo(equip.Ammo.Name) == true) then return equip.Ammo.Name end
		return nil;
	end

	function gcinclude.CheckBlockedAmmo()
		local name = gcinclude.BlockedAmmoName();
		if (name == nil) then return false end
		if (gcinclude.BuffCount('Unlimited Shot') > 0) then return false end
		gcinclude.Err('Shot cancelled: ' .. name .. ' is equipped.');
		gFunc.CancelAction();
		-- SafeAmmo: a name, or a table keyed by the blocked ammo's last word, e.g. { Bullet = '...', Arrow = '...' }
		local safe = gcinclude.SafeAmmo;
		if (type(safe) == 'table') then safe = safe[string.match(name, '(%a+)%s*$') or ''] end
		if (type(safe) == 'string') then
			gcinclude.ForceUnlocked({ Ammo = safe });
		end
		return true;
	end

	function gcinclude.CheckBlockedAmmoWS(wsName)
		if (type(wsName) ~= 'string') then return false end
		if not gcinclude.DistanceWS:contains(wsName) or gcinclude.NoAmmoWS:contains(wsName) then return false end
		return gcinclude.CheckBlockedAmmo();
	end

	function gcinclude.RollActive()
		for _, name in ipairs(gcinclude.RollBuffs) do
			if (gcinclude.BuffCount(name) > 0) then return true end
		end
		return false;
	end

	function gcinclude.XIRollActive()
		if (gcauto == nil) or (gcauto.RollEleven == nil) then return false end
		return gcauto.RollEleven() and gcinclude.RollActive();
	end

	-- Idle only: never over melee (engaged) or resting gear.
	function gcinclude.CheckXIRoll()
		local player = gData.GetPlayer();
		if (player == nil) or (player.Status ~= 'Idle') then return end
		if not gcinclude.XIRollActive() then return end
		local set = gcinclude.FindSet('XIRoll') or gcinclude.settings.XIRollSet;
		if (set ~= nil) then gFunc.EquipSet(set) end
	end

	gcinclude.PairSlots = T{ ear1 = 'ear2', ear2 = 'ear1', ring1 = 'ring2', ring2 = 'ring1' };

	function gcinclude.CheckSets()
		if (gProfile == nil) or (type(gProfile.Sets) ~= 'table') then return end
		local empty = T{};
		local unknown = T{};
		local families = {};
		local pairSlots = {};
		local moon = T{};
		for name, set in pairs(gProfile.Sets) do
			if (type(set) == 'table') then
				if (next(set) == nil) then empty:append(name) end
				local worn = {};
				for slot, item in pairs(set) do
					local iname = (type(item) == 'table') and item.Name or item;
					local key = string.lower(tostring(slot));
					if (type(iname) == 'string') and gcinclude.PairSlots[key] then worn[key] = string.lower(iname) end
					if (type(iname) == 'string') and (string.lower(iname) == 'moonshade earring') and not moon:contains(name) then moon:append(name) end
				end
				for key, iname in pairs(worn) do
					if (worn[gcinclude.PairSlots[key]] ~= iname) then
						pairSlots[iname] = pairSlots[iname] or {};
						pairSlots[iname][key] = true;
					end
				end
				for slot, item in pairs(set) do
					local label = gcinclude.WeaponLabel(item);
					local iname = (type(item) == 'table') and item.Name or item;
					if (type(iname) == 'string') and not gcinclude.WeaponKeywords:contains(string.lower(iname)) then
						if (AshitaCore:GetResourceManager():GetItemByName(iname, 0) == nil) then
							unknown:append(name .. '.' .. tostring(slot) .. ': ' .. label);
						end
					end
				end
				for _, suffix in ipairs(T{'Default', 'Hybrid', 'Acc'}) do
					local base = string.match(name, '^(.+)_' .. suffix .. '$');
					if (base ~= nil) then
						families[base] = families[base] or {};
						families[base][suffix] = true;
					end
				end
			end
		end
		local drift = T{};
		for iname, seen in pairs(pairSlots) do
			if (seen.ear1 and seen.ear2) or (seen.ring1 and seen.ring2) then drift:append(iname) end
		end
		table.sort(drift);
		local gaps = T{};
		for base, seen in pairs(families) do
			if (seen['Default'] == nil) and (gcinclude.FindSet(base) == nil) then gaps:append(base .. '_Default is missing (Hybrid/Acc exist)') end
		end
		gcinclude.Say('checksets: ' .. tostring(#empty) .. ' empty, ' .. tostring(#unknown) .. ' unknown items, ' .. tostring(#gaps) .. ' gaps, ' .. tostring(#drift) .. ' slot drifts');
		for _, v in ipairs(gaps) do gcinclude.Err(v) end
		for _, v in ipairs(unknown) do gcinclude.Err('unknown item ' .. v) end
		if (#moon > 0) and ((gcinclude.settings.MoonshadeTP or 0) > 0) then
			table.sort(moon);
			gcinclude.Say('Moonshade Earring in: ' .. table.concat(moon, ', ') .. ' - not needed, the engine adds it below MoonshadeTP on every WS (see README, Moonshade)');
		end
		if (#drift > 0) then
			gcinclude.Say('in both ear/ring slots across sets (swaps it out and back): ' .. table.concat(drift, ', '));
		end
		if (#empty > 0) then
			gcinclude.Say('empty: ' .. table.concat(empty, ', '));
		end
	end

	function gcinclude.CheckCommonDebuffs()
		local weakened = gcinclude.BuffCount(1); -- Weakness (buff 1; the name is 'weakness', not 'Weakened')
		local sleep = gcinclude.BuffCount('Sleep');
		local doom = (gcinclude.BuffCount('Doom'))+(gcinclude.BuffCount('Bane'));

		if (sleep >= 1) then gFunc.EquipSet(gcinclude.sets.Sleeping) end
		if (doom >= 1) then	gFunc.EquipSet(gcinclude.sets.Doomed) end
		if (weakened >= 1) then gFunc.EquipSet(gcinclude.sets.Reraise) end
	end

	function gcinclude.CheckAbilityRecast(check)
		local res = AshitaCore:GetResourceManager():GetAbilityByName(check, 0);
		if (res == nil) then return 0 end
		local recast = AshitaCore:GetMemoryManager():GetRecast();
		for x = 0, 31 do
			if ((x == 0) or (res.RecastTimerId ~= 0)) and (recast:GetAbilityTimerId(x) == res.RecastTimerId) then
				return recast:GetAbilityTimer(x);
			end
		end
		return 0;
	end

	function gcinclude.CheckLockingRings()
		local rings = gData.GetEquipment();
		for _, slot in ipairs(T{'Ring1', 'Ring2'}) do
			local r = rings[slot];
			if (r ~= nil) and gcinclude.LockingRings:contains(r.Name) then gFunc.Equip(slot, r.Name) end
		end
	end

	function gcinclude.SetTownGear()
		local zone = gData.GetEnvironment();
		if (zone.Area ~= nil) and (gcinclude.Towns:contains(zone.Area)) then local t = gcinclude.FindSet('Town'); if (t ~= nil) then gFunc.EquipSet(t) end end
	end

	function gcinclude.SetRegenRefreshGear()
		local cfg = gcinclude.settings;
		if (cfg.AutoGear == false) then return end
		local player = gData.GetPlayer();
		if (player == nil) then return end
		local function wear(name, pct, limit)
			if ((limit or 0) <= 0) or (pct == nil) or (pct >= limit) then return end
			local set = gcinclude.FindSet(name);
			if (set ~= nil) then gFunc.EquipSet(set) end
		end
		-- Regen/Refresh only out of combat and never over a manual /dt; auto Dt any time.
		if (gcdisplay.GetToggle('DTset') ~= true) and (not gcinclude.InCombat()) then
			wear('Idle_Regen', player.HPP, cfg.RegenGearHPP);
			wear('Idle_Refresh', player.MPP, cfg.RefreshGearMPP);
		end
		wear('Dt', player.HPP, cfg.DTGearHPP);
		local pet = gData.GetPet();
		if (pet ~= nil) then wear('Pet_Dt', pet.HPP, cfg.PetDTGearHPP) end
	end


	function gcinclude.CheckWsBailout()
		local player = gData.GetPlayer();
		local ws = gData.GetAction();
		if (player == nil) or (ws == nil) or (ws.Name == nil) then return false end
		if (player.TP < 1000) then return false end
		if (gcinclude.BuffCount('Amnesia') > 0) then return false end
		for _, name in ipairs(gcinclude.HardCC) do
			if (gcinclude.BuffCount(name) > 0) then return false end
		end
		local target = gData.GetActionTarget();
		local distance = (target ~= nil) and tonumber(target.Distance) or nil;
		if gcinclude.settings.WScheck and (distance ~= nil) and (not gcinclude.DistanceWS:contains(ws.Name)) and (distance > gcinclude.settings.WSdistance) then
			gcinclude.Say('Distance to mob is too far! Move closer or /wsdistance ##');
			return false;
		end
		return true;
	end

	function gcinclude.SafeSetIdle(tries)
		local mm = AshitaCore:GetMemoryManager();
		if (mm:GetPlayer():GetIsZoning() ~= 0) or (mm:GetInventory():GetEquippedItem(0) == nil) then
			if (tries < 30) then
				local function retry()
					gcinclude.SafeSetIdle(tries + 1);
				end
				retry:once(1);
			end
			return;
		end
		AshitaCore:GetChatManager():QueueCommand(-1, '/lac set Idle');
	end

	gcinclude.TeleRings = T{ warpring = 'warp_Ring', mea = 'mea_Ring', holla = 'holla_Ring', dem = 'dem_Ring' };

	function gcinclude.UseTeleRing(key)
		local ring = gcinclude.settings[key];
		if (type(ring) ~= 'string') then return end
		AshitaCore:GetChatManager():QueueCommand(-1, '/lac equip ring2 "' .. ring .. '"');
		local function restoreIdle()
			gcinclude.SafeSetIdle(0);
		end
		local function useRing()
			AshitaCore:GetChatManager():QueueCommand(-1, '/item "' .. ring .. '" <me>');
			restoreIdle:once(11);
		end
		useRing:once(11);
	end


	function gcinclude.DoNukes(tier)
		local cast = gcdisplay.GetCycle('Element');
		if (cast == 'Light') or (cast == 'Dark') then
			gcinclude.Err('/nuke: no tiered ' .. cast .. ' nuke; use /helix or /weather');
			return;
		end
		tier = ({ ['1'] = 'I', ['2'] = 'II', ['3'] = 'III', ['4'] = 'IV', ['5'] = 'V', ['6'] = 'VI' })[tostring(tier)] or string.upper(tostring(tier or ''));
		if not ({ I = true, II = true, III = true, IV = true, V = true, VI = true })[tier] then
			gcinclude.Err('usage: /nuke <1-6>');
			return;
		end
		if tier == "I" then
			AshitaCore:GetChatManager():QueueCommand(-1, '/ma "' .. cast .. '" <t>');
		else
			AshitaCore:GetChatManager():QueueCommand(-1, '/ma "' .. cast .. ' ' .. tier .. '" <t>');
		end
	end

	function gcinclude.DoCORmsg(roll)
		if gcinclude.CORmsg == false then return end

		for n = 1, #gcinclude.Rolls do
			if gcinclude.Rolls[n][1] == roll then
				print(chat.header('GCinclude'):append('[' .. chat.warning(roll) .. ']' .. '  [Lucky: ' .. chat.success(gcinclude.Rolls[n][2]) .. ']  [Unlucky: ' .. chat.error(gcinclude.Rolls[n][3]) .. ']'));
				return;
			end
		end
	end

	-- Castable now: learned (HasSpell) and the main or sub job meets the resource's level, or its job point
	-- requirement when JobPointMask marks the spell as a gift (same test as Thorny's tHotBar).
	function gcinclude.CanCast(name)
		local res = AshitaCore:GetResourceManager():GetSpellByName(name, 0);
		if (res == nil) then return false, nil end
		local p = AshitaCore:GetMemoryManager():GetPlayer();
		if (p == nil) or (not p:HasSpell(res.Index)) then return false, res end
		local req, mask = res.LevelRequired, res.JobPointMask;
		local mj, ml, sj, sl = p:GetMainJob(), p:GetMainJobLevel(), p:GetSubJob(), p:GetSubJobLevel();
		local need = req[mj + 1];
		if (bit.band(bit.rshift(mask, mj), 1) == 1) then
			if (ml == 99) and (p:GetJobPointsSpent(mj) >= need) then return true, res end
		elseif (need ~= nil) and (need ~= -1) and (ml >= need) then
			return true, res;
		end
		need = req[sj + 1];
		if (sj ~= 0) and (bit.band(bit.rshift(mask, sj), 1) == 0) and (need ~= nil) and (need ~= -1) and (sl >= need) then return true, res end
		return false, res;
	end

	-- First spell in the list that is castable and off recast.
	function gcinclude.CastBestTier(tiers, target)
		local recast = AshitaCore:GetMemoryManager():GetRecast();
		for _, name in ipairs(tiers) do
			local ok, res = gcinclude.CanCast(name);
			if ok and (recast:GetSpellTimer(res.Index) == 0) then
				AshitaCore:GetChatManager():QueueCommand(-1, '/ma "' .. name .. '" ' .. target);
				return true;
			end
		end
		return false;
	end

	function gcinclude.DoAspir()
		gcinclude.CastBestTier(T{'Aspir III', 'Aspir II', 'Aspir'}, '<t>');
	end

	function gcinclude.DoDrain()
		gcinclude.CastBestTier(T{'Drain III', 'Drain II', 'Drain'}, '<t>');
	end

	function gcinclude.DoSCHspells(spell)
		local list, target = nil, '<me>';
		if (spell == 'helix') then list, target = gcinclude.HelixSpells, '<t>';
		elseif (spell == 'weather') then list = gcinclude.StormSpells end
		if (list == nil) then return end
		local e = gcdisplay.GetCycle('Element');
		for i, v in ipairs(gcinclude.Elements) do
			if (v == e) and (list[i] ~= nil) then
				if not gcinclude.CastBestTier(T{list[i] .. ' II', list[i]}, target) then
					gcinclude.Err(list[i] .. ': not castable or on recast');
				end
				return;
			end
		end
	end

	function gcinclude.DoSiphon()
		local recast = gcinclude.CheckAbilityRecast('Elemental Siphon');
		if recast ~= 0 then 
			print(chat.header('GCinclude'):append(chat.warning('Elemental Siphon not available yet!')));
			return;
		end
		local pet = gData.GetPet();
		local oldpet = 'none';
		local spirit = 'none';
		local spirits = {['Firesday'] = 'Fire Spirit', ['Earthsday'] = 'Earth Spirit', ['Watersday'] = 'Water Spirit', ['Windsday'] = 'Air Spirit', ['Iceday'] = 'Ice Spirit', ['Lightningday'] = 'Thunder Spirit', ['Lightsday'] = 'Light Spirit', ['Darksday'] = 'Dark Spirit'};
		local e = gData.GetEnvironment();
		
		local function release()
			AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Release" <me>');
		end
		local function siphon()
			AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Elemental Siphon" <me>');
		end
		local function castavatar()
			AshitaCore:GetChatManager():QueueCommand(-1, '/ma "' .. oldpet .. '" <me>');
		end
		local function castspirit()
			AshitaCore:GetChatManager():QueueCommand(-1, '/ma "' .. spirit .. '" <me>');
			siphon:once(4);
			release:once(6);
			if oldpet ~= 'none' then
				castavatar:once(8);
			end
		end

		if pet ~= nil then
			oldpet = pet.Name;
			release:once(1);
		end

		if (spirits[e.Day] ~= nil) then
			spirit = spirits[e.Day];
			castspirit:once(3);
		end
	end

	-- Runs the job's WS handler and records every Ear1/Ear2 value it asks for, in order, so the engine
	-- knows what each ear would hold without Moonshade.
	function gcinclude.TrackEars(fn, ...)
		local trail = { ear1 = {}, ear2 = {} };
		local function note(slot, item)
			local key = string.lower(tostring(slot));
			if (trail[key] ~= nil) then table.insert(trail[key], item) end
		end
		local equipSet, equip = gFunc.EquipSet, gFunc.Equip;
		gFunc.EquipSet = function(set, ...)
			local t = (type(set) == 'string') and gcinclude.FindSet(set) or set;
			if (type(t) == 'table') then
				for k, v in pairs(t) do note(k, v) end
			end
			return equipSet(set, ...);
		end
		gFunc.Equip = function(slot, item, ...)
			note(slot, item);
			return equip(slot, item, ...);
		end
		local ok, result = pcall(fn, ...);
		gFunc.EquipSet, gFunc.Equip = equipSet, equip;
		if not ok then error(result, 0) end
		return result, trail;
	end

	local function isMoonshade(v)
		local n = (type(v) == 'table') and v.Name or v;
		return (type(n) == 'string') and (string.lower(n) == 'moonshade earring');
	end

	-- Moonshade Earring, every WS: in settings.MoonshadeSlot below MoonshadeTP; at or above it, an ear the
	-- WS sets left on Moonshade goes back to the last other earring those sets gave it (or stays as worn).
	function gcinclude.CheckMoonshade(trail)
		local cfg = gcinclude.settings;
		local limit = cfg.MoonshadeTP or 0;
		if (limit <= 0) or (type(trail) ~= 'table') then return end
		local player, ws = gData.GetPlayer(), gData.GetAction();
		if (player == nil) or (ws == nil) then return end
		local skip = (type(cfg.MoonshadeSkip) == 'table') and cfg.MoonshadeSkip:contains(ws.Name);
		local want = (player.TP < limit) and (not skip);
		local slot = string.lower(cfg.MoonshadeSlot or 'Ear2');
		for _, ear in ipairs(T{'ear1', 'ear2'}) do
			local list = trail[ear];
			if want and (ear == slot) then
				gFunc.Equip(ear == 'ear1' and 'Ear1' or 'Ear2', 'Moonshade Earring');
			elseif (#list > 0) and isMoonshade(list[#list]) then
				local back = 'ignore';
				for i = #list, 1, -1 do
					if not isMoonshade(list[i]) then back = list[i]; break end
				end
				gFunc.Equip(ear == 'ear1' and 'Ear1' or 'Ear2', back);
			end
		end
	end


	-- Absorb spells: Absorb set for all of them, then Absorb_TP (or legacy AbsorbTP) for Absorb-TP.
	function gcinclude.CheckAbsorb()
		local spell = gData.GetAction();
		if (spell == nil) or (type(spell.Name) ~= 'string') or (string.sub(spell.Name, 1, 7) ~= 'Absorb-') then return end
		local set = gcinclude.FindSet('Absorb');
		if (set ~= nil) then gFunc.EquipSet(set) end
		if (spell.Name == 'Absorb-TP') then
			set = gcinclude.FindSet('Absorb_TP') or gcinclude.FindSet('AbsorbTP');
			if (set ~= nil) then gFunc.EquipSet(set) end
		end
	end

	function gcinclude.CheckCancels()--tossed Stoneskin in here too
		local action = gData.GetAction();
		local sneak = gcinclude.BuffCount('Sneak');
		local stoneskin = gcinclude.BuffCount('Stoneskin');
		local target = gData.GetActionTarget();
		local me = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0);
		
		local function do_jig()
			AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Spectral Jig" <me>');
		end
		local function do_sneak()
			AshitaCore:GetChatManager():QueueCommand(-1, '/ma "Sneak" <me>');
		end
		local function do_ss()
			AshitaCore:GetChatManager():QueueCommand(-1, '/ma "Stoneskin" <me>');
		end

		if (action == nil) then return end
		if (action.Name == 'Spectral Jig' and sneak ~=0) then
			gFunc.CancelAction();
			AshitaCore:GetChatManager():QueueCommand(-1, '/cancel Sneak');
			do_jig:once(2);
		elseif (action.Name == 'Sneak' and sneak ~= 0 and target ~= nil and target.Name == me) then
			gFunc.CancelAction();
			AshitaCore:GetChatManager():QueueCommand(-1, '/cancel Sneak');
			do_sneak:once(1);
		elseif (action.Name == 'Stoneskin' and stoneskin ~= 0) then
			gFunc.CancelAction();
			AshitaCore:GetChatManager():QueueCommand(-1, '/cancel Stoneskin');
			do_ss:once(1);
		end
	end

function gcinclude.CheckDefault()
    -- Self-healing check: Rebuild toggles if the memory manager updates to a new job
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    if (player ~= nil) and (gcinclude.ActiveJobId ~= nil) then
        local mainJobId = player:GetMainJob();
        if (mainJobId ~= 0) and (mainJobId ~= gcinclude.ActiveJobId) then gcinclude.SetVariables() end
    end

    -- Auto Regen/Refresh/DT/Pet_Dt and Town sets count as "your sets", so they go under the engine layers
    -- (README layer order: your sets -> weapons (+ TH weapons while /th is on) -> mdt/Aminon -> Hoxne -> TH -> received -> buffs -> XIRoll).
    gcinclude.SetRegenRefreshGear();
    gcinclude.SetTownGear();
    gcinclude.CheckWeapons();
    gcinclude.CheckCommonDebuffs();
    gcinclude.CheckLockingRings();
    for _, cmd in ipairs({'craftset', 'zeniset', 'fishset', 'rrset'}) do
        if gcinclude.UtilOn[cmd] then gFunc.EquipSet(gcinclude.sets[gcinclude.UtilSets[cmd]]) end
    end
    gcdisplay.Update();
end

	function gcinclude.Unload()
			gcinclude.ClearKeybinds();
			gcauto.Stop();
			ashita.events.unregister('d3d_present', 'gcinclude_tphold');
			if (gchud ~= nil) then gchud.Stop() end
			gcinclude.UnlockSlots(nil);
			gcinclude.UnlockWeapons();
			gcdisplay.Unload();
			gcinclude.ClearAlias();
	end

function gcinclude.PlayerReady()
    local mm = AshitaCore:GetMemoryManager();
    if (mm == nil) then return false; end

    local p = mm:GetPlayer();
    local party = mm:GetParty();
    if (p == nil) or (party == nil) then return false; end

    local mainJobId = p:GetMainJob();
    if (mainJobId == nil) or (mainJobId == 0) then return false; end
    if (p:GetMainJobLevel() == nil) or (p:GetMainJobLevel() == 0) then return false; end
    if (party:GetMemberIsActive(0) ~= 1) then return false; end

    local name = party:GetMemberName(0);
    if (name == nil) or (name == '') then return false; end

    -- Fetch expected job abbreviation directly from memory
    local mainJobStr = AshitaCore:GetResourceManager():GetString("jobs.names_abbr", mainJobId);

    -- Gate until gData exists AND has synced to match the current memory state
    local gp = gData.GetPlayer();
    if (gp == nil) or (gp.MainJob == nil) or (gp.MainJob == 'NON') or (gp.MainJob ~= mainJobStr) then
        return false;
    end

    return true;
end

	function gcinclude.InitStep(tries)
		tries = tries or 0;

		if not gcinclude.PlayerReady() then
			if (tries < 150) then
				local retry = function() gcinclude.InitStep(tries + 1); end
				retry:once(0.2);
			else
				gcinclude.Say('Init gave up waiting on player data after 30s.');
			end
			return;
		end

		gcdisplay.Initialize(gcinclude.settings);
		gcinclude.SetVariables();
		gcinclude.SetAlias();
		gcinclude.ApplyKeybinds();
		if (gcauto ~= nil) then gcauto.OnIncomingCast = gcinclude.WearReceived end
		gcinclude.ApplyLockstyle();
		gcauto.Start();
		ashita.events.register('d3d_present', 'gcinclude_tphold', gcinclude.HoldTick);
		if (gchud ~= nil) then gchud.Start() end
	end

	function gcinclude.Initialize()
		gcinclude.WrapHoldHandlers();
		gcinclude.InitStep(0);
	end

	return gcinclude;