local flat = _G.flat
local module = {}

function split_str(s, delimiter)
    result = {};
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match);
    end
    return result;
end

function invisible_char(d)
    return d:sub(0, #d - 1) .. "\0" .. tostring(d:sub(#d, #d))
end

function module.highlight(hl)
    local text = module.editor.value
    local build = text

    for i, v in pairs(hl) do
        if type(v) == "table" then
            for a, g in pairs(v.children) do
                for d in string.gmatch(text, g) do
                    build = build:gsub(d, "<font color=\"" .. v.color .. "\">" .. invisible_char(d) .. "</font>")
                end
            end
        else
            print(i)
            for d in string.gmatch(text, i) do
                build = build:gsub(d, "<font color=\"" .. v .. "\">" .. invisible_char(d) .. "</font>")
            end
        end
    end

    module.visual.innerHTML = build
end

function module.create(rules, start_code)
    start_code = start_code or "--Source here!"
    module.editor = flat.element.create("textarea", start_code, {
        data_gramm = "false",
        data_gramm_editor = "false",
        data_enable_grammarly = "false",
        autocomplete = "off",
        autocorrect = "off",
        autocapitalize = "off",
        spellcheck = false
    })
    module.visual = flat.element.create("div", start_code)

    flat.styler.new("editor", {
        overflow = "auto",
        position = "absolute",
        color = "transparent",
        background_color = "transparent",
        height = "93%",
        width = "50%",
        border = "0",
        resize = "none",
        caret_color = "white",
        z_index = 1,
        spellcheck = "false",
        margin_left = ".5%",
        outline = "none",
        font_size = "15pt",
        font_family = "monospace",
        line_height = "20pt",
        padding_left = 0,
        padding_right = 0,
        padding_top = 0,
        padding_bottom = 0
    })

    flat.styler.new({"editor-visual", "editor"}, {
        word_wrap = "break-word",
        color = "rgb(255, 255, 255)",
        background_color = "rgb(10,10,10)",
        z_index = 0,
        white_space = "pre-wrap",
    })

    module.editor:render()
    module.visual:render()

    flat.styler.use("editor", module.editor)
    flat.styler.use("editor-visual", module.visual)

    module.highlight(rules)

    module.editor:event("input", function()
        module.highlight(rules)
    end)

    module.editor:event("keydown", function(_, key)
        if key.key == "F5" then
            if module.debug then
                key:preventDefault()

                module.debug()
            end
        end

        if key.key == "Tab" then
            key:preventDefault()

            local ed = module.editor
            local start_s = ed.selectionStart
            local end_s = ed.selectionEnd
            
            ed.value = ed.value:sub(0, start_s) .. "\t" .. ed.value:sub(end_s)
            ed.selectionStart = start_s + 1
            ed.selectionEnd = start_s + 1
            return
        end
    end)

    module.editor:event("scroll", function()
        module.visual.scrollTop = module.editor.scrollTop
    end)
end

return module
