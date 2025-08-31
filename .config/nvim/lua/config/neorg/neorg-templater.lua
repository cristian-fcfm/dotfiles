local M = {}

-- Directorio por defecto de templates (en workspace de notas)
M.templates_dir = vim.fn.expand("~/Documents/notes/3. Resources/Templates/")

-- Función para configurar el directorio de templates
function M.setup(opts)
    opts = opts or {}
    M.templates_dir = opts.templates_dir or M.templates_dir

    -- Crear directorio si no existe
    if vim.fn.isdirectory(M.templates_dir) == 0 then
        vim.fn.mkdir(M.templates_dir, "p")
    end
end

-- Función para obtener lista de templates
local function get_templates()
    local templates = {}
    local files = vim.fn.glob(M.templates_dir .. "/*.norg", false, true)

    for _, file in ipairs(files) do
        local name = vim.fn.fnamemodify(file, ":t:r")
        table.insert(templates, {
            name = name,
            path = file
        })
    end

    return templates
end

-- Función para leer contenido de un template
local function read_template(template_path)
    local file = io.open(template_path, "r")
    if not file then
        vim.notify("Error: No se pudo leer el template", vim.log.levels.ERROR)
        return nil
    end

    local content = file:read("*a")
    file:close()

    return content
end

-- Función para reemplazar contenido del buffer
function M.replace_buffer(template_path)
    local content = read_template(template_path)
    if not content then return end

    local lines = vim.split(content, '\n')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.notify("Template aplicado (reemplazado)")
end

-- Función para añadir contenido al buffer
function M.append_buffer(template_path)
    local content = read_template(template_path)
    if not content then return end

    local lines = vim.split(content, '\n')
    local current_lines = vim.api.nvim_buf_line_count(0)

    vim.api.nvim_buf_set_lines(0, current_lines, current_lines, false, lines)
    vim.notify("Template añadido al final del buffer")
end

-- Función principal para seleccionar template con fzf-lua
function M.select_template(action)
    local templates = get_templates()

    if #templates == 0 then
        vim.notify("No hay templates disponibles en: " .. M.templates_dir)
        return
    end

    local fzf = require('fzf-lua')

    local items = {}
    for _, template in ipairs(templates) do
        table.insert(items, template.name)
    end

    fzf.fzf_exec(items, {
        prompt = 'Templates > ',
        actions = {
            ['default'] = function(selected)
                if selected and #selected > 0 then
                    local template_name = selected[1]

                    -- Encontrar el template por nombre
                    for _, template in ipairs(templates) do
                        if template.name == template_name then
                            if action == 'replace' then
                                M.replace_buffer(template.path)
                            elseif action == 'append' then
                                M.append_buffer(template.path)
                            end
                            break
                        end
                    end
                end
            end
        }
    })
end

-- Funciones de conveniencia
function M.replace_with_template()
    M.select_template('replace')
end

function M.append_template()
    M.select_template('append')
end

return M
