local flat = require "flat.require"
flat.page.load_dom("flat-dom") -- loads the custom dom from render/index.html

local sh = require "scripts.lua.syntax_highlighter"

local topbox = flat.element.create("div", nil, {
    style = "display: flex;"
})
topbox:render()

local run = flat.element.create("button", "Run", {
    class = "btn btn-success",
    style = "margin-bottom: .5%; margin-top: .5%; margin-left: .5%;"
})

topbox:render_child(run)

flat.component.new("alert", function()
    local div = flat.element.create("div", "This is my alert!")

    flat.styler.new("alert", {
        border = "0.375rem",
        position = "absolute",
        padding = ".4% 1%",
        color = "#FFFFFF",
        background_color = "#28A745",
        border_radius = "0.375rem",
        border_left_width = "10px",
        border_left_style = "solid",
        width = "fit-content",
        left = "4%",
        margin_bottom = ".5%",
        margin_top = ".5%",
        margin_left = ".5%"
    })

    topbox:render_child(div)

    flat.styler.use("alert", div)

    local co = coroutine.create(function()
        wait(5)
        div:remove()
    end)

    coroutine.resume(co)

    return {
        text = function(update)
            div.innerHTML = update
        end
    }
end)

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
    },

}, 'flat.element.create("h1", "Hello, world"):render()')

local preview = require "scripts.lua.preview"
preview.create()

function runAlert()
    local alert1 = flat.component.create("alert")
    alert1.text("Running script!")
end

run:event("click", function()
    preview.run(sh.editor.value)
    runAlert()
end)

sh.debug = function()
    preview.run(sh.editor.value)
    runAlert()
end

preview.run('flat.element.create("h1", "Hello, world"):render()')
