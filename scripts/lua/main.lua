local flat = require "flat.require"
flat.page.load_dom("flat-dom") -- loads the custom dom from render/index.html

local sh = require "scripts.lua.syntax_highlighter"

local run = flat.element.create("button", "Run", {
    class = "btn btn-success",
    style = "margin-bottom: .5%; margin-top: .5%; margin-left: .5%;"
})

run:render()

flat.element.create("br"):render()

sh.create({
    { -- Strings
        color = "#4a4646",
        children = {'%b""', "%b''"}
    },
    { -- keywords, pasted from lua.org
        color = "#de421f",
        children = split_str(
            ("%s(and)%s,(break),(do)%s,(else)%s,(elseif)%s,(end%s)%s,(for)%s,(function)%s,(if)%s,%s(in)%s,(local)%s,(nil),(not)%s,(repeat)%s,(return)%s,%s(then)%s,(until)%s,(while)%s"),
            ",")
    },
    ["true"] = "#63db93", -- true bool
    ["false"] = "#db636b", -- false bool
    { -- Functions
        color = "#4684f0",
        children = {"print", "render", "new", "create", "event"}
    }

}, 'flat.element.create("h1", "Hello, world"):render()')

local preview = require "scripts.lua.preview"
preview.create()

local sandbox_init = [[
    local flat = require "flat.require"
    
    flat.init()
    flat.element.page = flat.page

    flat.page.dom = js.global.document:getElementById(...)
    flat.page.dom.innerHTML = ""
]]

run:event("click", function()
    load(sandbox_init .. sh.editor.value)(preview.document.id)
end)

load(sandbox_init .. [[
flat.element.create("h1", "Hello, world"):render()
]])(preview.document.id)
