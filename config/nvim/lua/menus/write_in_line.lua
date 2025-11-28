---@param message string|table
function write_in_line(message)
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1  -- línea actual (1-indexed)

    -- Detectar tipo de message
    if type(message) == "string" then
        -- Si es string, lo insertamos como una sola línea
        vim.api.nvim_buf_set_lines(0, line, line, false, {message})
    elseif type(message) == "table" then
        -- Si es table, asumimos que es array de strings y escribimos cada elemento como línea
        vim.api.nvim_buf_set_lines(0, line, line, false, message)
    else
        error("write_in_line: argumento debe ser string o table de strings")
    end
end

