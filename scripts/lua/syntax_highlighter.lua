local flat = _G.flat
local module = {}

function module.highlight(hl)
    local text = module.editor.value
    local build = text

    for i,v in pairs(hl) do
        if type(v) == "table" then
            for a,g in pairs(v.children) do
                for d in string.gmatch(text, g)do
                    build = build:gsub(d, "<font color=\"" .. v.color .. "\">" .. d .. "</font>")
                end
            end
        else
            for d in string.gmatch(text, i)do
                build = build:gsub(d, "<font color=\"" .. v .. "\">" .. d .. "</font>")
            end
        end
    end

    module.visual.innerHTML = build:gsub("\n", "</br>")
end

function split_str(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end


function module.create(rules, start_code)
    start_code = start_code or "--Source here!"
    module.editor = flat.element.create("textarea", start_code)
    module.visual = flat.element.create("div", start_code)

    flat.styler.new("editor", {
        overflow_x = "hidden",
        position = "fixed",
        color = "transparent",
        background_color = "transparent",
        height = "93%",
        width = "50%",
        border = "none",
        resize = "none",
        caret_color = "white",
        z_index = 1,
        spellcheck = "false",
        margin_left = ".5%"
    })

    flat.styler.new("editor-visual", {
        overflow_x = "hidden",
        position = "fixed",
        color = "rgb(255, 255, 255)",
        background_color = "rgb(10,10,10)",
        height = "93%",
        width = "50%",
        border = "none",
        resize = "none",
        z_index = 0,
        margin_left = ".5%"
    })

    module.editor:render()
    module.visual:render()

    flat.styler.use("editor", module.editor)
    flat.styler.use("editor-visual", module.visual)

    module.highlight(rules)

    module.editor:event("input", function()
        module.highlight(rules)
    end)
end

return module
