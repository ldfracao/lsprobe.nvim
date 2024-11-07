-- Require the lsp_capabilities and lsp_settings modules from the lsprobe plugin
local lsp_capabilities = require("lsprobe.lsp_capabilities")
local lsp_settings = require("lsprobe.lsp_settings")

-- Create a user command called 'Lsprobe'
vim.api.nvim_create_user_command('Lsprobe', function()
    -- Get active LSP clients for the current buffer
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local client = clients[1]  -- Use the first active client

    -- Check if there is an active LSP client
    if not client then
        print("No active LSP client found.")  -- Print a message if no client is found
        return  -- Exit the command
    end

    -- Prepare buffers for each tab (Capabilities and Server Settings)
    local capability_buf = vim.api.nvim_create_buf(false, true)  -- Create a new buffer for capabilities
    local settings_buf = vim.api.nvim_create_buf(false, true)    -- Create a new buffer for server settings

    -- Fill the buffers with respective content using the module functions
    vim.api.nvim_buf_set_lines(capability_buf, 0, -1, true, lsp_capabilities.get_capabilities(client))
    vim.api.nvim_buf_set_lines(settings_buf, 0, -1, true, lsp_settings.get_server_settings(client))

    -- Creating a floating window:
    local win_height = vim.api.nvim_get_option("lines")
    local win_width = vim.api.nvim_get_option("columns")
    local height = 20
    local width = 80

    -- Define options for the floating window
    local opts = {
        relative = 'editor',
        row = math.floor((win_height - height) / 2),
        col = math.floor((win_width - width) / 2),
        width = width,
        height = height,
        style = 'minimal',
        border = 'rounded',
    }

    -- Create a floating window for the capabilities buffer
    local win = vim.api.nvim_open_win(capability_buf, true, opts)
    vim.api.nvim_buf_set_option(capability_buf, 'modifiable', false)  -- Make the buffer non-modifiable
    vim.api.nvim_buf_set_option(capability_buf, 'buftype', 'nofile')  -- Set buffer type to 'nofile'

    -- Function to switch between tabs (you would implement this)
    local function switch_tab(next_tab)
        if next_tab == "capabilities" then
            vim.api.nvim_set_current_win(win)  -- Focus the window
            vim.api.nvim_win_set_buf(win, capability_buf)  -- Set the capabilities buffer
        elseif next_tab == "settings" then
            vim.api.nvim_set_current_win(win)  -- Focus the window
            vim.api.nvim_win_set_buf(win, settings_buf)  -- Set the settings buffer
        end
    end

    -- Key mappings to switch tabs (Tab for next, Shift+Tab for previous)
    vim.keymap.set('n', '<Tab>', function()
        switch_tab("settings")  -- Switch to settings tab
    end, { noremap = true, silent = true })
    vim.keymap.set('n', '<S-Tab>', function()
        switch_tab("capabilities")  -- Switch to capabilities tab
    end, { noremap = true, silent = true })

    -- Keymap to close the window
    vim.keymap.set('n', 'q', function()
        vim.api.nvim_win_close(win, true)  -- Close the floating window
    end, { noremap = true })
end, {})
