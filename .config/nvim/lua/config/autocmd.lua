-- Detectar archivos Jinja2 (solo .jinja y .jinja2)
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.jinja', '*.jinja2', '*.j2' },
  callback = function()
    vim.bo.filetype = 'jinja'
    -- Configuración específica para Jinja
    vim.bo.commentstring = '{# %s #}'
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

-- Detectar archivos SQL con diferentes extensiones
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.sql', '*.athena', '*.presto', '*.trino' },
  callback = function()
    vim.bo.filetype = 'sql'
    -- Configuraciones específicas para SQL
    vim.bo.commentstring = '-- %s'
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

-- Configuración especial para archivos de Athena/Presto
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.athena', '*.presto' },
  callback = function()
    -- Agregar palabras clave específicas de Athena/Presto
    vim.cmd([[
      syntax keyword sqlKeyword UNNEST CROSS JOIN LATERAL
      syntax keyword sqlKeyword APPROX_DISTINCT APPROX_PERCENTILE
      syntax keyword sqlKeyword CARDINALITY ELEMENT_AT
      syntax keyword sqlFunction DATE_TRUNC DATE_ADD DATE_DIFF
      syntax keyword sqlFunction JSON_EXTRACT JSON_EXTRACT_SCALAR
      syntax keyword sqlFunction SPLIT REGEXP_EXTRACT REGEXP_REPLACE
    ]])
  end,
})

-- Añadir resaltado personalizado para sintaxis Jinja
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.jinja', '*.jinja2', '*.j2' },
  callback = function()
    -- Definir resaltado personalizado para Jinja2
    vim.cmd([[
      syntax region jinjaVariable start=/{{/ end=/}}/ contains=jinjaPython
      syntax region jinjaBlock start=/{%/ end=/%}/ contains=jinjaPython
      syntax region jinjaComment start=/{#/ end=/#}/
      syntax match jinjaPython /[^{}%#]*/ contained

      highlight link jinjaVariable Special
      highlight link jinjaBlock Statement
      highlight link jinjaComment Comment
      highlight link jinjaPython Identifier
    ]])
  end,
})
