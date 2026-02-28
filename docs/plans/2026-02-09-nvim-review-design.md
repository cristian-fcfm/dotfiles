# Neovim Config Review - Performance & Plugin Improvements

**Fecha**: 2026-02-09
**Contexto**: Revisión de la configuración de Neovim (0.11.5) para un flujo de trabajo Python + Zettelkasten

## Cambios Implementados

### Rendimiento

1. **`updatetime` 500ms -> 250ms** (`options.lua`)
   - Respuesta más rápida para CursorHold (LSP highlights via Snacks.words, gitsigns, diagnostics)
   - 250ms es el sweet spot entre responsividad y carga de CPU

2. **`redrawtime = 1500`** (`options.lua`)
   - Limita el tiempo máximo de re-render de syntax para archivos pesados (default era 2000ms)

3. **Autocmds combinados** (`autocmd.lua`)
   - `number_toggle` + `cursorcolumn_toggle` fusionados en `insert_ui_toggle`
   - Reduce de 4 autocmds a 2, mismo comportamiento

4. **Eliminado autocmd `lsp_document_highlight`** (`lsp.lua`)
   - Era redundante con `Snacks.words` que ya estaba habilitado
   - Snacks.words tiene debounce inteligente; el autocmd manual disparaba en cada `CursorMoved` sin debounce

5. **Colorizer: `event` -> `ft`** (`colorizer.lua`)
   - Antes: se cargaba en todos los buffers y filtraba internamente
   - Ahora: solo se carga para filetypes relevantes (css, html, lua, etc.)
   - Agregados `conf` y `toml` a la lista de filetypes

6. **LSP `debounce_text_changes = 150ms`** (`lsp.lua`)
   - Aplicado globalmente via `vim.lsp.config["*"]`
   - Reduce la frecuencia de `textDocument/didChange` notificaciones al LSP
   - Impacto significativo en archivos grandes donde se escribe rápido

### Limpieza

7. **Eliminado Neorg** (código muerto)
   - Archivos eliminados: `plugins/neorg.lua`, `whichkey/neorg.lua`
   - Limpiadas referencias en: `plugins.lua`, `whichkey.lua`, `completion.lua`
   - Estaba deshabilitado por incompatibilidad con treesitter main branch

### Plugins Nuevos

8. **bullets.vim** (`plugins/bullets.lua`)
   - Auto-continuación inteligente de listas en Markdown/ZK
   - Soporta: listas numeradas, checkboxes, listas anidadas, outline levels
   - Carga: solo en `ft = { "markdown", "zk", "text" }`
   - Impacto en startup: cero

## Archivos Modificados

| Archivo | Tipo de cambio |
|---------|---------------|
| `lua/config/options.lua` | updatetime, redrawtime |
| `lua/config/autocmd.lua` | Autocmds combinados |
| `lua/config/plugins/lsp.lua` | Eliminado document_highlight, agregado debounce |
| `lua/config/plugins/colorizer.lua` | event -> ft loading |
| `lua/config/plugins/completion.lua` | Limpiada referencia neorg |
| `lua/config/plugins/whichkey.lua` | Limpiada referencia neorg |
| `lua/plugins.lua` | Eliminado neorg, agregado bullets |
| `lua/config/plugins/bullets.lua` | **NUEVO** |
| `lua/config/plugins/neorg.lua` | **ELIMINADO** |
| `lua/config/whichkey/neorg.lua` | **ELIMINADO** |

## Mejoras Futuras Consideradas (No Implementadas)

Estas mejoras fueron discutidas pero no seleccionadas para esta iteración:

- **nvim-dap + dap-python + dap-ui**: Framework de debugging para Python
- **neotest + neotest-python**: Testing framework con output inline
- **harpoon2**: Navegación determinística entre archivos frecuentes
- **flash.nvim**: Navegación por saltos con labels
- **persistence.nvim**: Restauración automática de sesiones
- **Migrar LuaSnip a snippets nativos de blink.cmp**: Evaluar si friendly-snippets aporta valor

## Redundancias Documentadas (Conscientes)

- **Oil + Snacks Explorer**: Ambos activos, usados para propósitos distintos (Oil = edición buffer-based, Snacks = navegación lateral)
- **5 colorschemes**: Todos lazy-loaded, se mantienen para alternar según preferencia
