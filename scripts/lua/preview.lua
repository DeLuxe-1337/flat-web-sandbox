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


return module