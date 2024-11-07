local M = {}

function M.get_server_settings(client)
    local lines = {}
    table.insert(lines, "   Server Settings:")
print(vim.inspect(client.config))
    -- Check if the client has settings
    if not client.settings or next(client.settings) == nil then
        table.insert(lines, "     No settings found.")
        return lines
    end

    -- Iterate over the settings and format them
    local settings_count = 0
    local unsorted_settings = {}

    for setting, value in pairs(client.settings) do
        table.insert(unsorted_settings, string.format("       • %s: %s", setting, tostring(value)))
        settings_count = settings_count + 1
    end

    -- Sort the settings for better readability
    table.sort(unsorted_settings)
    for _, setting in ipairs(unsorted_settings) do
        table.insert(lines, setting)
    end
    table.insert(lines, string.format("     Total settings: %d", settings_count))

    return lines
end

return M
