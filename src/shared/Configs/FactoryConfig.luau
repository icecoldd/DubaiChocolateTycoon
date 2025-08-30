-- Shared/Configs/FactoryConfig.lua
-- central registry of all factory items (droppers, conveyors, collectors, etc.)

local Workspace = game:GetService("Workspace")

-- TemplateFactoryPlot stored in ReplicatedStorage or ServerStorage
local TemplateFactoryPlotItems = Workspace.TemplateFactoryPlot.Items

local FactoryConfig = {
    ["Dropper"] = {
        ClassName = "Dropper",          -- which machine class to instantiate
        DisplayName = "Basic Chocolate Dropper",
        Cost = 100,                     -- cost to purchase
        AnchorName = "DropperAnchor",  -- where to place it on the plot
        Interval = 2.0,                 -- seconds per chocolate
        MaxQueue = 20,                  -- how many chocolates can be out at once
    },

    ["Collector"] = {
        ClassName = "Collector",
        DisplayName = "Basic Collector",
        Cost = 250,
        AnchorName = "CollectorAnchor",
        Payout = 1,    -- cash per chocolate collected
    },
}

return FactoryConfig
