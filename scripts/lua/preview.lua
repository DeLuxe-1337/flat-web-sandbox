local module = {}

function module.create()
    module.document = flat.element.create("div", "Flat.lua")

    flat.styler.new("document", {
        overflow_x = "hidden",
        position = "fixed",
        color = "rgb(255, 255, 255)",
        background_color = "rgb(20,20,20)",
        height = "93%",
        width = "48%",
        border = "none",
        left = "51%"
    })

    module.document:render()

    flat.styler.use("document", module.document)
end

function module.run(value)
    local sandbox_init = [[
        local flat = require "flat.require"
        
        flat.init()
        flat.element.page = flat.page
    
        flat.page.dom = js.global.document:getElementById(...)
        flat.page.dom.innerHTML = ""

        flat.page.load_dom = function()
            
        end
    ]]
    

    load(sandbox_init .. value)(module.document.id)
end

return module