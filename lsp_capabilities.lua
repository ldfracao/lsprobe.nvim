local M = {}

function M.get_capabilities(client)
    local lines = {}
    table.insert(lines, "   Capabilities:")

    local capability_count = 0
    local unsorted_capabilities = {}
    for capability, value in pairs(client.server_capabilities) do
        table.insert(unsorted_capabilities, string.format("       • %s: %s", capability, tostring(value)))
        capability_count = capability_count + 1
    end
    table.sort(unsorted_capabilities)
    for _, capability in ipairs(unsorted_capabilities) do
        table.insert(lines, capability)
    end
    table.insert(lines, string.format("     Total capabilities: %d", capability_count))

    return lines
end

return M
