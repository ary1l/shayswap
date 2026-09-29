local gchud = {};

local imgui = require('imgui');

local inc = nil;
local disp = nil;
local nextWrite = 0;
local nextRead = 0;
local lastLine = nil;
local lastWriteTime = 0;
local rows = {};
local visible = false;
local expanded = {};
local placed = false;


local STALE = 15;

gchud.CycleCommands = {
    MeleeSet = 'meleeset',
    Weapons = 'wm',
    Main = 'mainset',
    Sub = 'subset',
    Range = 'rangeset',
    Ammo = 'ammoset',
    Weapon = 'weapon',
    NukeSet = 'nukeset',
    Element = 'elecycle',
    TankSet = 'tankset',
    Hoxne = 'hoxne',
    PupMode = 'pupmode',
    MBTier = 'mbtier',
};

gchud.ToggleCommands = {
    DTset = 'dt',
    MDTset = 'mdt',
    Aminon = 'aminon',
    TH = 'th',
    Kite = 'kite',
    SIR = 'sir',
    PROC = 'proc',
    AutoFood = 'autofood',
    AutoSoda = 'autosoda',
    Burst = 'burst',
    AutoMB = 'automb',
    AutoNuke = 'autonuke',
    String = 'forcestring',
    SongLock = 'songlock',
    Death = 'death',
};

gchud.CycleOrder = { 'Weapons', 'MeleeSet', 'Main', 'Sub', 'Range', 'Ammo' };
gchud.ToggleOrder = { 'DTset', 'MDTset', 'Aminon', 'SIR', 'TH', 'Kite', 'AutoFood', 'AutoSoda' };

-- Column header glyphs. Override any with settings.HUDLabels = { Main = 'mn' }.
local SHORT = {
    DTset = 'dt', MDTset = 'md', Aminon = 'am', SIR = 'si', TH = 'th', Kite = 'kt',
    AutoFood = 'fd', AutoSoda = 'sd', PROC = 'pr',
    Burst = 'bs', AutoMB = 'mb', AutoNuke = 'an', String = 'hp', SongLock = 'sl', Death = 'dh',
    Def = 'def', MB = 'mb', MBTier = 'tier',
    Weapons = 'wpn', MeleeSet = 'ml', Main = 'm', Sub = 's', Range = 'r', Ammo = 'a',
    NukeSet = 'nk', Element = 'el', TankSet = 'tk', Hoxne = 'hx', PupMode = 'pp', Weapon = 'w',
};

-- Full names, hover tooltips only.
local FULL = {
    DTset = 'DT set', MDTset = 'MDT set', Aminon = 'Aminon', SIR = 'Spell interrupt', TH = 'Treasure Hunter',
    Kite = 'Kite', AutoFood = 'Auto food', AutoSoda = 'Auto soda', PROC = 'Proc',
    Burst = 'Burst (force)', AutoMB = 'Auto MB', AutoNuke = 'Auto nuke', String = 'Harp (force string)', SongLock = 'Song lock (songs keep main/sub)',
    Death = 'Death', Weapons = 'Weapon set',
    Def = 'Defense (click = /def: DT > MDT > Aminon > SIRD > none)',
    MB = 'Magic burst mode (click = /mbmode: Off > Chain > Auto > Force); Auto shows its nuke tier',
    MBTier = 'Autonuke tier (click = /mbtier: Low I > Mid III > High V)', MeleeSet = 'Melee set', Main = 'Main', Sub = 'Sub',
    Range = 'Range', Ammo = 'Ammo', NukeSet = 'Nuke set', Element = 'Element', TankSet = 'Tank set',
    Hoxne = 'Hoxne', PupMode = 'Pup mode', Weapon = 'Weapon',
};

-- Cycle values drawn as '-'. A cycle column empty on every box is hidden from the grid.
local EMPTY = { none = true, off = true, unknown = true };

-- Short value: first word (whole if <= 4 letters, else 3), initial of each later word, '+N' kept.
-- 'Death Penalty' / 'DeathPenalty' -> DeaP, 'Anarchy +2' -> Ana+2, 'RostamB' -> RosB, 'Gleti's Knife' -> GleK.
-- Override any with settings.HUDAbbr = { ['CarnwenhanAcc'] = 'CarnA' } (case-insensitive).
local abbrCache = {};
local function abbr(value)
    value = tostring(value or '');
    if (value == '') then return '' end
    local hit = abbrCache[value]; -- cleared by gchud.Start, so HUDAbbr edits apply on reload
    if (hit ~= nil) then return hit end
    local user = inc.settings.HUDAbbr;
    if (type(user) == 'table') then
        local lv = string.lower(value);
        for k, v in pairs(user) do
            if (string.lower(tostring(k)) == lv) then abbrCache[value] = tostring(v); return abbrCache[value] end
        end
    end
    local t = string.gsub(value, "['%.]", '');
    t = string.gsub(t, '[^%w%+]', ' ');
    t = string.gsub(t, '(%l)(%u)', '%1 %2');
    t = string.gsub(t, '(%w)(%+)', '%1 %2');
    local out = {};
    for tok in string.gmatch(t, '%S+') do
        if (#out == 0) then
            local w = (#tok <= 4) and tok or string.sub(tok, 1, 3);
            out[1] = string.upper(string.sub(w, 1, 1)) .. string.sub(w, 2);
        elseif string.match(tok, '^%+?%d+$') then
            out[#out + 1] = tok;
        else
            out[#out + 1] = string.upper(string.sub(tok, 1, 1));
        end
    end
    hit = (#out > 0) and table.concat(out) or value;
    abbrCache[value] = hit;
    return hit;
end

-- Once per load: warn if two of this box's weapon choices shorten to the same text.
local abbrChecked = false;
local function check_abbr()
    abbrChecked = true;
    if (type(inc.WeaponCycleList) ~= 'function') then return end
    for _, cname in ipairs({ 'Weapons', 'Main', 'Sub', 'Range', 'Ammo' }) do
        local list = inc.WeaponCycleList(cname);
        if (type(list) == 'table') then
            local seen = {};
            for _, v in ipairs(list) do
                local full = (type(inc.WeaponLabel) == 'function') and inc.WeaponLabel(v) or v;
                if (type(full) == 'string') and (EMPTY[string.lower(full)] ~= true) then
                    local a = abbr(full);
                    if (seen[a] ~= nil) and (seen[a] ~= full) then
                        print(chat.header('GCHUD'):append(chat.error(string.format(
                            '%s: "%s" and "%s" both show as %s. Set settings.HUDAbbr.', cname, seen[a], full, a))));
                    else
                        seen[a] = full;
                    end
                end
            end
        end
    end
end

local COL_CLEAR = { 0.0, 0.0, 0.0, 0.0 };
local COL_HOVER = { 1.0, 1.0, 1.0, 0.12 };
-- bright = changed since load, dim = still at load default
local COL_ON = { 0.35, 0.95, 0.45, 1.0 };      -- on, changed
local COL_ON_DEF = { 0.30, 0.70, 0.38, 0.85 }; -- on, default
local COL_OFF = { 0.40, 0.40, 0.45, 0.70 };    -- off, default
local COL_OFF_CHG = { 1.00, 0.55, 0.25, 1.0 }; -- off, changed (turned off something that loads on)
local COL_VAL = { 0.95, 0.85, 0.35, 1.0 };     -- cycle, changed
local COL_VAL_DEF = { 0.75, 0.68, 0.35, 0.85 };-- cycle, default
local COL_EMPTY = { 0.45, 0.45, 0.50, 0.60 };  -- cycle at None/Off
local COL_NAME = { 0.75, 0.85, 1.00, 1.0 };
local COL_JOB = { 0.60, 0.65, 0.75, 1.0 };
local COL_KEY = { 0.55, 0.58, 0.65, 1.0 };

local function dir()
    return string.format('%sconfig\\addons\\luashitacast\\hud\\', AshitaCore:GetInstallPath());
end

local function listing()
    local base = dir();
    local trimmed = string.sub(base, 1, string.len(base) - 1);
    local tries = {
        { base, '.*%.txt' }, { base, '.*' }, { base },
        { trimmed, '.*%.txt' }, { trimmed, '.*' }, { trimmed },
    };
    for _, t in ipairs(tries) do
        local ok, files = pcall(ashita.fs.get_directory, t[1], t[2]);
        if (ok == true) and (type(files) == 'table') then
            local n = 0;
            for _, _ in pairs(files) do n = n + 1 end
            if (n > 0) then return files, t[1], (t[2] or 'nil') end
        end
    end
    return nil, base, 'none matched';
end

local function me()
    local player = gData.GetPlayer();
    if (player == nil) then return nil end
    if (player.Name == nil) or (player.Name == '') then return nil end
    return player;
end

local function encode(map, order)
    local parts = {};
    for _, k in ipairs(order) do
        if (map[k] ~= nil) then
            parts[#parts + 1] = k .. '=' .. tostring(map[k]);
            map[k] = nil;
        end
    end
    for k, v in pairs(map) do
        parts[#parts + 1] = k .. '=' .. tostring(v);
    end
    return table.concat(parts, ',');
end

local function decode(text)
    local map = {};
    local order = {};
    for pair in string.gmatch(text or '', '[^,]+') do
        local k, v = string.match(pair, '^([^=]+)=(.*)$');
        if (k ~= nil) then
            map[k] = v;
            order[#order + 1] = k;
        end
    end
    return map, order;
end

local function write_state()
    local player = me();
    if (player == nil) then return end
    -- '~' marks a value still at its load default, so readers can hide it.
    local tmap, cmap = disp.GetToggles(), disp.GetCycles();
    for k, v in pairs(tmap) do tmap[k] = (disp.IsDefault('toggle', k) and '~' or '') .. tostring(v) end
    for k, v in pairs(cmap) do
        if (k ~= 'Weapons') and disp.IsDefault('cycle', k) then cmap[k] = '~' .. tostring(v) end
    end
    local toggles = encode(tmap, gchud.ToggleOrder);
    local cycles = encode(cmap, gchud.CycleOrder);
    local line = table.concat({
        player.Name,
        tostring(player.MainJob or '?') .. '/' .. tostring(player.SubJob or '-'),
        toggles,
        cycles,
    }, '\t');
    local now = os.time();
    if (line == lastLine) and ((now - lastWriteTime) < 3) then return end
    local d = dir();
    if not ashita.fs.exists(d) then ashita.fs.create_directory(d) end
    local f = io.open(d .. player.Name .. '.txt', 'w');
    if (f == nil) then return end
    f:write(line .. '\t' .. tostring(now));
    f:close();
    lastLine = line;
    lastWriteTime = now;
end

local function read_all()
    local files = listing();
    if (type(files) ~= 'table') then return end
    local now = os.time();
    local out = {};
    for _, entry in pairs(files) do
        local fname = (type(entry) == 'string') and string.match(entry, '([^\\/]+)$') or nil;
        if (fname ~= nil) and (string.sub(fname, -4) == '.txt') then
            local f = io.open(dir() .. fname, 'r');
            if (f ~= nil) then
                local text = f:read('*a');
                f:close();
                local parts = {};
                local rest = text or '';
                while true do
                    local at = string.find(rest, '\t', 1, true);
                    if (at == nil) then parts[#parts + 1] = rest; break end
                    parts[#parts + 1] = string.sub(rest, 1, at - 1);
                    rest = string.sub(rest, at + 1);
                end
                local stamp = tonumber(parts[5]);
                if (parts[1] ~= nil) and (parts[1] ~= '') and (stamp ~= nil) and ((now - stamp) <= STALE) then
                    local tmap, torder = decode(parts[3]);
                    local cmap, corder = decode(parts[4]);
                    out[#out + 1] = {
                        Name = parts[1],
                        Job = parts[2],
                        Toggles = tmap, ToggleOrder = torder,
                        Cycles = cmap, CycleOrder = corder,
                    };
                end
            end
        end
    end
    table.sort(out, function (a, b) return a.Name < b.Name end);
    rows = out;
end

local savedX, savedY = nil, nil;

local function pos_file()
    local player = me();
    if (player == nil) then return nil end
    return string.format('%sconfig\\addons\\luashitacast\\gcbar\\', AshitaCore:GetInstallPath()), player.Name .. '_hud.txt';
end

local function save_pos()
    local d, f = pos_file();
    if (d == nil) then return end
    if not ashita.fs.exists(d) then ashita.fs.create_directory(d) end
    local h = io.open(d .. f, 'w');
    if (h == nil) then return end
    h:write(string.format('%d,%d', inc.settings.HUDX or 300, inc.settings.HUDY or 40));
    h:close();
    savedX, savedY = inc.settings.HUDX, inc.settings.HUDY;
end

local function load_pos()
    local d, f = pos_file();
    if (d == nil) then return end
    local h = io.open(d .. f, 'r');
    if (h == nil) then return end
    local x, y = string.match(h:read('*a') or '', '^(%-?%d+),(%-?%d+)');
    h:close();
    if (x == nil) then return end
    inc.settings.HUDX, inc.settings.HUDY = tonumber(x), tonumber(y);
    savedX, savedY = inc.settings.HUDX, inc.settings.HUDY;
end

local function track_drag()
    local x, y = imgui.GetWindowPos();
    if (type(x) == 'table') then x, y = x[1] or x.x, x[2] or x.y end
    x, y = tonumber(x), tonumber(y);
    if (x == nil) or (y == nil) or imgui.IsMouseDown(0) then return end
    x, y = math.floor(x + 0.5), math.floor(y + 0.5);
    if (x ~= savedX) or (y ~= savedY) then
        inc.settings.HUDX, inc.settings.HUDY = x, y;
        save_pos();
    end
end

local function send(name, command)
    nextRead = 0;
    local player = me();
    if (player ~= nil) and (string.lower(player.Name) == string.lower(name)) then
        AshitaCore:GetChatManager():QueueCommand(-1, '/lac fwd ' .. command);
    else
        AshitaCore:GetChatManager():QueueCommand(-1, '/ms sendto ' .. name .. ' /lac fwd ' .. command);
    end
end

local function label(key)
    local user = inc.settings.HUDLabels;
    if (type(user) == 'table') and (user[key] ~= nil) then return tostring(user[key]) end
    return SHORT[key] or string.lower(key);
end

local function tip(text)
    if imgui.IsItemHovered() then
        imgui.SetTooltip((string.gsub(text, '%%', '%%%%')));
    end
end

local function strip_default(value)
    value = value or '';
    if (string.sub(value, 1, 1) == '~') then return string.sub(value, 2), true end
    return value, false;
end

-- Grid: one header line, one line per box, columns aligned by measured text width.
-- Cycle columns first (weapon set leads), then toggle columns. Clicking a cell drives that box.
-- Hidden to save width: cycle columns None/Off on every box; toggle columns at load default on
-- every box, unless pinned (settings.HUDPinned). They show up as soon as any box changes them.
-- DT/MDT/Aminon/SIR merge into one 'def' column (/def), AutoMB/AutoNuke/Burst into 'mb' (/mbmode).
-- Clicking a name adds a detail line under it: job + that box's hidden cycles and toggles.
local PADX = 1; -- matches the FramePadding x pushed in render()

local function textw(t)
    local w = imgui.CalcTextSize(t);
    if (type(w) == 'table') then w = w[1] or w.x end
    return tonumber(w) or 0;
end

local function toggle_cell(row, key)
    local raw = row.Toggles[key];
    if (raw == nil) then return nil end
    local value, def = strip_default(raw);
    local on = (value == 'true');
    local cmd = gchud.ToggleCommands[key];
    return {
        -- off + default = '.', anything else shows the glyph so changes read at a glance
        text = (on or not def) and label(key) or '.',
        def = def,
        col = on and (def and COL_ON_DEF or COL_ON) or (def and COL_OFF or COL_OFF_CHG),
        cmd = cmd,
        tip = row.Name .. '  ' .. (FULL[key] or key) .. ': ' .. (on and 'on' or 'off')
            .. (def and ' (default)' or '') .. ((cmd ~= nil) and ('  /' .. cmd) or ''),
    };
end

local function cycle_cell(row, key)
    local raw = row.Cycles[key];
    if (raw == nil) then return nil end
    local value, def = strip_default(raw);
    local empty = (EMPTY[string.lower(value)] == true);
    local cmd = gchud.CycleCommands[key];
    return {
        text = empty and '-' or abbr(value),
        col = empty and COL_EMPTY or (def and COL_VAL_DEF or COL_VAL),
        cmd = cmd,
        empty = empty,
        tip = row.Name .. '  ' .. (FULL[key] or key) .. ': ' .. value
            .. (def and ' (default)' or '') .. ((cmd ~= nil) and ('  /' .. cmd) or ''),
    };
end

-- Merged columns: several toggles shown as one mode, clicked through the command that cycles them.
local DEF_PARTS = { { 'DTset', 'DT' }, { 'MDTset', 'MDT' }, { 'Aminon', 'Amin' }, { 'SIR', 'SIR' } };
local MB_TEXT = {
    Off = 'normal nuke set, nothing casts by itself',
    Chain = 'Burst set only when the nuke lands in a live skillchain of its element (/automb)',
    Auto = 'Chain + casts into live skillchains by itself (/automb + /autonuke)',
    Force = 'Burst set on every nuke, no skillchain check (/burst)',
};
local GROUP_PART = { DTset = true, MDTset = true, Aminon = true, SIR = true, AutoMB = true, AutoNuke = true, Burst = true };
local GROUP_ORDER = { 'Def', 'MB' };

local function part(row, key)
    local raw = row.Toggles[key];
    if (raw == nil) then return nil end
    local value, def = strip_default(raw);
    return (value == 'true'), def;
end

local function group_cell(row, key)
    if (key == 'Def') then
        local on, alldef, any = {}, true, false;
        for _, p in ipairs(DEF_PARTS) do
            local v, d = part(row, p[1]);
            if (v ~= nil) then
                any = true;
                if v then on[#on + 1] = p[2] end
                if not d then alldef = false end
            end
        end
        if not any then return nil end
        local text = (#on == 0) and '-' or (on[1] .. ((#on > 1) and '+' or ''));
        return {
            text = text,
            col = (#on > 0) and (alldef and COL_ON_DEF or COL_ON) or (alldef and COL_EMPTY or COL_OFF_CHG),
            cmd = 'def',
            def = alldef,
            tip = row.Name .. '  Defense: ' .. ((#on == 0) and 'none' or table.concat(on, ', '))
                .. (alldef and ' (default)' or '') .. '  /def',
        };
    end
    if (key == 'MB') then
        local auto, d1 = part(row, 'AutoMB');
        if (auto == nil) then return nil end
        local nuke, d2 = part(row, 'AutoNuke');
        local burst, d3 = part(row, 'Burst');
        local tier, d4 = strip_default(row.Cycles.MBTier);
        if (row.Cycles.MBTier == nil) then d4 = true end
        local roman = ({ Low = 'I', Mid = 'III', High = 'V' })[tier] or '';
        local alldef = (d1 ~= false) and (d2 ~= false) and (d3 ~= false) and d4;
        -- same names as /mbmode; a mix /mbmode never makes (e.g. /autonuke alone) gets a '*'
        local gear = (burst and 'Force') or (auto and 'Chain') or 'Off';
        local mode = gear;
        if nuke then mode = (gear == 'Chain') and 'Auto' or (gear .. '*') end
        local text = MB_TEXT[mode] or (gear .. ' + auto-cast: ' .. MB_TEXT[gear]);
        return {
            text = nuke and (mode .. roman) or mode,
            col = (mode == 'Off') and (alldef and COL_EMPTY or COL_OFF_CHG) or (alldef and COL_VAL_DEF or COL_VAL),
            cmd = 'mbmode',
            ctrlCmd = nuke and 'mbtier' or nil, -- Ctrl+click cycles the autonuke tier while in Auto
            def = alldef,
            tip = row.Name .. '  MB mode ' .. mode .. (alldef and ' (default)' or '') .. ': ' .. text
                .. ((roman ~= '') and ('  |  autonuke tier ' .. roman .. ' (' .. tier .. ', /mbtier)') or '')
                .. '  |  click /mbmode -> ' .. ((burst and 'Off') or (nuke and 'Force') or (auto and 'Auto') or 'Chain')
                .. (nuke and '  |  Ctrl+click /mbtier' or ''),
        };
    end
    return nil;
end

local function draw_cell(row, key, c)
    imgui.PushStyleColor(ImGuiCol_Text, c.col);
    local clicked = false;
    if (c.cmd == nil) then
        imgui.Text(c.text);
    else
        clicked = imgui.SmallButton(c.text .. '##' .. row.Name .. key);
    end
    imgui.PopStyleColor();
    tip(c.tip);
    if clicked then
        local ok, ctrl = pcall(function() return imgui.GetIO().KeyCtrl end);
        send(row.Name, (ok and ctrl and c.ctrlCmd) or c.cmd);
    end
end

-- Keys present on any box: canonical order first, then the rest as they appear.
local function columns(orderKey, canonical)
    local out, seen, present = {}, {}, {};
    for _, row in ipairs(rows) do
        for _, k in ipairs(row[orderKey]) do
            if (orderKey ~= 'ToggleOrder') or not GROUP_PART[k] then present[k] = true end
        end
    end
    for _, k in ipairs(canonical) do
        if present[k] and not seen[k] then seen[k] = true; out[#out + 1] = k end
    end
    for _, row in ipairs(rows) do
        for _, k in ipairs(row[orderKey]) do
            if present[k] and not seen[k] then seen[k] = true; out[#out + 1] = k end
        end
    end
    return out;
end

local function body()
    if (#rows == 0) then
        imgui.Text('no characters reporting');
        track_drag();
        return;
    end

    -- build cells, pick visible cycle columns
    local ccols = columns('CycleOrder', gchud.CycleOrder);
    local tcols = columns('ToggleOrder', gchud.ToggleOrder);
    local cells = {};
    local shown = {};
    for i, row in ipairs(rows) do
        cells[i] = { c = {}, t = {} };
        for _, k in ipairs(ccols) do
            local c = cycle_cell(row, k);
            cells[i].c[k] = c;
            if (c ~= nil) and not c.empty and (k ~= 'MBTier') then shown[k] = true end -- MBTier: in mb cell + detail line
        end
        for _, k in ipairs(tcols) do cells[i].t[k] = toggle_cell(row, k) end
        cells[i].g = {};
        for _, k in ipairs(GROUP_ORDER) do cells[i].g[k] = group_cell(row, k) end
    end
    local vis = {};
    for _, k in ipairs(ccols) do
        if shown[k] then vis[#vis + 1] = k end
    end
    local pinned = {};
    for _, k in ipairs(inc.settings.HUDPinned or {}) do pinned[k] = true end
    local gvis, gshown = {}, {};
    for _, k in ipairs(GROUP_ORDER) do
        local present, keep = false, (pinned[k] == true) or (pinned[label(k)] == true);
        for i = 1, #rows do
            local c = cells[i].g[k];
            if (c ~= nil) then
                present = true;
                if not c.def then keep = true end
            end
        end
        if present and keep then gvis[#gvis + 1] = k; gshown[k] = true end
    end
    local tvis, tshown = {}, {};
    for _, k in ipairs(tcols) do
        local keep = (pinned[k] == true) or (pinned[label(k)] == true);
        for i = 1, #rows do
            local c = cells[i].t[k];
            if (c ~= nil) and not c.def then keep = true end
        end
        if keep then tvis[#tvis + 1] = k; tshown[k] = true end
    end

    -- measure
    local gap = textw(' ');
    local x0 = imgui.GetCursorPosX();
    local nameW = 0;
    for _, row in ipairs(rows) do nameW = math.max(nameW, textw(string.sub(row.Name, 1, 4)) + PADX * 2) end
    local cols = {};
    local x = x0 + nameW + gap;
    local function add(key, kind, center)
        local w = textw(label(key));
        for i = 1, #rows do
            local c = cells[i][kind][key];
            if (c ~= nil) then c.w = textw(c.text); w = math.max(w, c.w) end -- reused when the row is drawn
        end
        w = w + PADX * 2;
        cols[#cols + 1] = { key = key, kind = kind, x = x, w = w, center = center };
        x = x + w + gap;
    end
    for _, k in ipairs(vis) do add(k, 'c', false) end
    x = x + gap; -- group gap
    for _, k in ipairs(gvis) do add(k, 'g', false) end
    for _, k in ipairs(tvis) do add(k, 't', true) end
    local function at(col, textWidth, first)
        local cx = col.x;
        if col.center then cx = cx + math.floor((col.w - textWidth) / 2) end
        if first then imgui.SetCursorPosX(cx) else imgui.SameLine(cx) end
    end

    -- header
    imgui.PushStyleColor(ImGuiCol_Text, COL_KEY);
    for i, col in ipairs(cols) do
        local l = label(col.key);
        at(col, textw(l), i == 1);
        if not col.center then imgui.SetCursorPosX(imgui.GetCursorPosX() + PADX) end
        imgui.Text(l);
        tip(FULL[col.key] or col.key);
    end
    imgui.PopStyleColor();

    -- rows
    for i, row in ipairs(rows) do
        local open = (expanded[row.Name] == true);
        imgui.SetCursorPosX(x0);
        imgui.PushStyleColor(ImGuiCol_Text, COL_NAME);
        local clicked = imgui.SmallButton(string.sub(row.Name, 1, 4) .. '##' .. row.Name .. 'row');
        imgui.PopStyleColor();
        tip(row.Name .. '  ' .. tostring(row.Job) .. '  (click: ' .. (open and 'hide' or 'show') .. ' details)');
        for _, col in ipairs(cols) do
            local c = cells[i][col.kind][col.key];
            if (c ~= nil) then
                at(col, c.w + PADX * 2, false);
                draw_cell(row, col.key, c);
            end
        end
        if open then
            local first = cols[1];
            imgui.SetCursorPosX((first ~= nil) and first.x or x0);
            imgui.PushStyleColor(ImGuiCol_Text, COL_JOB);
            imgui.Text(tostring(row.Job));
            imgui.PopStyleColor();
            for _, k in ipairs(ccols) do
                local c = cells[i].c[k];
                if (c ~= nil) and not shown[k] then
                    imgui.SameLine();
                    imgui.PushStyleColor(ImGuiCol_Text, COL_KEY);
                    imgui.Text(label(k));
                    imgui.PopStyleColor();
                    imgui.SameLine(0, 0);
                    draw_cell(row, k, c);
                end
            end
            for _, k in ipairs(GROUP_ORDER) do
                local c = cells[i].g[k];
                if (c ~= nil) and not gshown[k] then
                    imgui.SameLine();
                    imgui.PushStyleColor(ImGuiCol_Text, COL_KEY);
                    imgui.Text(label(k));
                    imgui.PopStyleColor();
                    imgui.SameLine(0, 0);
                    draw_cell(row, k, c);
                end
            end
            for _, k in ipairs(tcols) do
                local c = cells[i].t[k];
                if (c ~= nil) and not tshown[k] then
                    local l = label(k);
                    imgui.SameLine();
                    draw_cell(row, k, { text = l, col = c.col, cmd = c.cmd, tip = c.tip });
                end
            end
        end
        if clicked then expanded[row.Name] = not open end
    end
    track_drag();
end

local fontPushed = false;
local function inner()
    -- Ashita < 4.3: SetWindowFontScale. Ashita 4.3 (ImGui 1.92) removed it: PushFont(nil, size).
    local scale = tonumber(inc.settings.HUDScale) or 1.0;
    if (imgui.SetWindowFontScale ~= nil) then
        imgui.SetWindowFontScale(scale);
    elseif (scale ~= 1.0) and (imgui.PushFont ~= nil) and (imgui.GetFontSize ~= nil) then
        imgui.PushFont(nil, imgui.GetFontSize() * scale);
        fontPushed = true;
    end
    body();
end

local function render()
    if not visible then return end
    if (not placed) then
        -- Always: after /gchud pos ImGui would otherwise keep the old position
        imgui.SetNextWindowPos({ inc.settings.HUDX or 300, inc.settings.HUDY or 40 }, ImGuiCond_Always);
        placed = true;
    end
    local flags = bit.bor(ImGuiWindowFlags_AlwaysAutoResize, ImGuiWindowFlags_NoFocusOnAppearing,
        ImGuiWindowFlags_NoTitleBar, ImGuiWindowFlags_NoScrollbar, ImGuiWindowFlags_NoResize);
    imgui.PushStyleVar(ImGuiStyleVar_WindowPadding, { 4, 2 });
    imgui.PushStyleVar(ImGuiStyleVar_FramePadding, { 1, 0 });
    imgui.PushStyleVar(ImGuiStyleVar_ItemSpacing, { 4, 1 });
    imgui.PushStyleColor(ImGuiCol_Button, COL_CLEAR);
    imgui.PushStyleColor(ImGuiCol_ButtonHovered, COL_HOVER);
    imgui.PushStyleColor(ImGuiCol_ButtonActive, COL_HOVER);
    imgui.PushStyleColor(ImGuiCol_WindowBg, { 0.0, 0.0, 0.0, inc.settings.HUDAlpha or 0.45 });
    imgui.PushStyleColor(ImGuiCol_Border, COL_CLEAR);
    local ok, err = true, nil;
    if imgui.Begin('GC##gchud', true, flags) then
        -- any error between Begin and End must not skip PopFont/End/Pop*, or ImGui asserts every frame after
        ok, err = pcall(inner);
        if fontPushed then imgui.PopFont(); fontPushed = false; end
    end
    imgui.End();
    imgui.PopStyleColor(5);
    imgui.PopStyleVar(3);
    if (ok ~= true) then error(err, 0) end
end

local function present()
    if (inc == nil) or (disp == nil) then return end
    if (abbrChecked ~= true) then pcall(check_abbr) end
    local now = os.clock();
    if (now >= nextWrite) then
        nextWrite = now + 0.25;
        pcall(write_state);
    end
    if visible then
        if (now >= nextRead) then
            nextRead = now + 0.5;
            local ok, err = pcall(read_all);
            if (ok ~= true) and (gchud.Errors ~= true) then
                gchud.Errors = true;
                print(chat.header('GCHUD'):append(chat.error('read failed: ' .. tostring(err))));
            end
        end
        local ok, err = pcall(render);
        if (ok ~= true) and (gchud.Errors ~= true) then
            gchud.Errors = true;
            print(chat.header('GCHUD'):append(chat.error('draw failed: ' .. tostring(err))));
        end
    end
end

function gchud.Bind(gcinclude, gcdisplay)
    inc = gcinclude;
    disp = gcdisplay;
end

function gchud.Start()
    pcall(load_pos);
    abbrChecked = false;
    abbrCache = {};
    placed = false;
    ashita.events.register('d3d_present', 'gchud_present', present);
    local player = me();
    local owners = inc.settings.HUDOwners;
    if (player ~= nil) and (type(owners) == 'table') then
        for _, n in ipairs(owners) do
            if (string.lower(n) == string.lower(player.Name)) then visible = true end
        end
    end
end

function gchud.Stop()
    ashita.events.unregister('d3d_present', 'gchud_present');
    visible = false;
end

function gchud.Debug()
    local files, path, mask = listing();
    print(chat.header('GCHUD'):append(chat.message('path: ' .. path)));
    print(chat.header('GCHUD'):append(chat.message('mask used: ' .. tostring(mask))));
    if (type(files) ~= 'table') then
        print(chat.header('GCHUD'):append(chat.error('get_directory returned nothing')));
    else
        for _, entry in pairs(files) do
            print(chat.header('GCHUD'):append(chat.message('file: ' .. tostring(entry))));
        end
    end
    read_all();
    print(chat.header('GCHUD'):append(chat.message('rows parsed: ' .. tostring(#rows))));
    for _, row in ipairs(rows) do
        print(chat.header('GCHUD'):append(chat.message(row.Name .. ' ' .. row.Job)));
    end
end

function gchud.HandleCommand(args)
    local arg = (args[2] ~= nil) and string.lower(args[2]) or nil;
    if (arg == 'debug') then
        gchud.Debug();
        return;
    end
    if (arg == 'pos') and (tonumber(args[3]) ~= nil) and (tonumber(args[4]) ~= nil) then
        inc.settings.HUDX = tonumber(args[3]);
        inc.settings.HUDY = tonumber(args[4]);
        placed = false;
        save_pos();
        return;
    end
    if (arg == 'on') then
        visible = true;
    elseif (arg == 'off') then
        visible = false;
    else
        visible = not visible;
    end
    nextRead = 0;
end

return gchud;
