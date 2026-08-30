local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).client

local Client = {}

function Client.OnStart()
    DataService:init()
end

return Client