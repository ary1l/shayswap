-- ShaySwap for Windower: just enough of ImGui to draw common/gchud.lua and the gcdisplay bar as Windower
-- text boxes, so those files run unchanged. Display only: buttons draw as text and never report a click
-- (use the commands). Boxes can be dragged; gchud/gcdisplay save the new position as they do on Ashita.
--
-- Layout: widths are measured in character cells (CalcTextSize = characters * CW), and the box uses a
-- monospace font, so the column positions gchud computes line up.

local I = {};
local CW, LH = 7, 14;           -- pixels per character cell / line, only used to convert gchud's positions
local ITEM_SPACING = 7;          -- SameLine() gap: one character cell (gchud pushes 4px, gcdisplay 6px)
local FONT, SIZE = 'Consolas', 10;

local windows = {};
local frame = 0;
local cur = nil;
local nextPos = nil;
local colors = {};              -- stack of { idx, col }
local mouseDown = false;

local K = {
    ImGuiCol_Text = 0, ImGuiCol_WindowBg = 2, ImGuiCol_Border = 5, ImGuiCol_Button = 21,
    ImGuiCol_ButtonHovered = 22, ImGuiCol_ButtonActive = 23,
    ImGuiCond_Always = 1,
    ImGuiStyleVar_WindowPadding = 2, ImGuiStyleVar_FramePadding = 11, ImGuiStyleVar_ItemSpacing = 13,
    ImGuiWindowFlags_NoTitleBar = 1, ImGuiWindowFlags_NoResize = 2, ImGuiWindowFlags_NoScrollbar = 8,
    ImGuiWindowFlags_AlwaysAutoResize = 64, ImGuiWindowFlags_NoFocusOnAppearing = 4096,
};

local function text_color()
    for i = #colors, 1, -1 do
        if (colors[i][1] == K.ImGuiCol_Text) then return colors[i][2] end
    end
    return nil;
end

local function new_line() cur.lines[#cur.lines + 1] = {} end

local function add_item(text, pad)
    text = tostring(text or '');
    if (cur == nil) then return end
    if cur.hasItem and not cur.same then new_line() end
    local line = cur.lines[#cur.lines];
    line[#line + 1] = { x = cur.cx, text = text, col = text_color() };
    cur.lastEnd = cur.cx + #text * CW + (pad or 0);
    cur.cx = 0;
    cur.same = false;
    cur.hasItem = true;
end

local function strip_id(label) return (string.gsub(tostring(label or ''), '##.*$', '')) end

local function channel(v) return math.max(0, math.min(255, math.floor((tonumber(v) or 1) * 255 + 0.5))) end

local function render(w)
    local out = {};
    for _, line in ipairs(w.lines) do
        table.sort(line, function(a, b) return a.x < b.x end);
        local s, pos = {}, 0;
        for _, seg in ipairs(line) do
            local col = math.floor(seg.x / CW + 0.5);
            if (col > pos) then s[#s + 1] = string.rep(' ', col - pos); pos = col end
            if (seg.col ~= nil) then
                s[#s + 1] = string.format('\\cs(%d,%d,%d)%s\\cr', channel(seg.col[1]), channel(seg.col[2]), channel(seg.col[3]), seg.text);
            else
                s[#s + 1] = seg.text;
            end
            pos = pos + #seg.text;
        end
        out[#out + 1] = table.concat(s);
    end
    return table.concat(out, '\n');
end

local imgui = setmetatable({
    Begin = function(name)
        local w = windows[name];
        if (w == nil) then
            w = { text = texts.new('', {
                pos = { x = 0, y = 0 },
                bg = { alpha = 115, red = 0, green = 0, blue = 0, visible = true },
                text = { font = FONT, size = SIZE, red = 255, green = 255, blue = 255 },
                flags = { draggable = true },
                padding = 2,
            }), shown = '' };
            windows[name] = w;
        end
        if (nextPos ~= nil) then w.text:pos(nextPos[1], nextPos[2]); nextPos = nil end
        w.frame = frame;
        w.lines = { {} };
        w.cx, w.lastEnd, w.same, w.hasItem, w.scale, w.bgAlpha = 0, 0, false, false, 1.0, nil;
        for i = #colors, 1, -1 do
            if (colors[i][1] == K.ImGuiCol_WindowBg) then w.bgAlpha = colors[i][2][4]; break end
        end
        cur = w;
        return true;
    end,
    End = function()
        local w = cur;
        cur = nil;
        if (w == nil) then return end
        local str = render(w);
        if (str ~= w.shown) then w.text:text(str); w.shown = str end
        local size = math.max(6, math.floor(SIZE * (w.scale or 1) + 0.5));
        if (size ~= w.size) then w.text:size(size); w.size = size end
        if (w.bgAlpha ~= nil) and (w.bgAlpha ~= w.alpha) then w.text:bg_alpha(channel(w.bgAlpha)); w.alpha = w.bgAlpha end
        if not w.visible then w.text:show(); w.visible = true end
    end,
    Text = function(t) add_item(t) end,
    SmallButton = function(label) add_item(strip_id(label), 2); return false end,
    Button = function(label) add_item(strip_id(label), 2); return false end,
    SameLine = function(offset, spacing)
        if (cur == nil) then return end
        cur.same = true;
        if (tonumber(offset) ~= nil) and (offset > 0) then
            cur.cx = offset;
        else
            cur.cx = cur.lastEnd + (((tonumber(spacing) ~= nil) and (spacing >= 0)) and spacing or ITEM_SPACING);
        end
    end,
    SetCursorPosX = function(x) if (cur ~= nil) then cur.cx = tonumber(x) or 0 end end,
    GetCursorPosX = function() return (cur ~= nil) and cur.cx or 0 end,
    CalcTextSize = function(t) return #tostring(t or '') * CW, LH end,
    SetNextWindowPos = function(pos) if (type(pos) == 'table') then nextPos = { pos[1] or pos.x or 0, pos[2] or pos.y or 0 } end end,
    GetWindowPos = function()
        if (cur == nil) then return 0, 0 end
        return cur.text:pos();
    end,
    IsMouseDown = function() return mouseDown end,
    IsItemHovered = function() return false end,
    SetTooltip = function() end,
    GetIO = function() return { KeyCtrl = false } end,
    PushStyleColor = function(idx, col) colors[#colors + 1] = { idx, col } end,
    PopStyleColor = function(n) for _ = 1, (tonumber(n) or 1) do colors[#colors] = nil end end,
    PushStyleVar = function() end,
    PopStyleVar = function() end,
    SetWindowFontScale = function(s) if (cur ~= nil) then cur.scale = tonumber(s) or 1 end end,
}, { __index = function() return function() end end });

function I.BeginFrame()
    frame = frame + 1;
    colors = {};
end

-- Boxes not drawn this frame are hidden (gchud/gcdisplay draw only while switched on).
function I.EndFrame()
    for _, w in pairs(windows) do
        if w.visible and (w.frame ~= frame) then w.text:hide(); w.visible = false end
    end
end

function I.SetMouseDown(v) mouseDown = v end

function I.Install()
    windows, cur, nextPos, colors = {}, nil, nil, {};
    for k, v in pairs(K) do _G[k] = v end
    gearswap.package.loaded['imgui'] = imgui;
end

return I;
