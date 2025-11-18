# ZK Habits Tracker

Sistema de seguimiento de hábitos para notas zk en Neovim, generando tablas automáticas basadas en el frontmatter de notas diarias.

## 📁 Estructura

```
lua/zktools/
├── init.lua          # Módulo principal
├── frontmatter.lua   # Utilidades para parsear YAML usando zk CLI
├── habits.lua        # Generación de tablas de hábitos
├── utils.lua         # Funciones de utilidad
└── README.md         # Esta documentación
```

## 🚀 Características

- **Actualización automática**: La tabla se actualiza al guardar o salir del buffer
- **Cálculo de rachas**: Calcula streaks y records desde el inicio del año
- **Integración con zk CLI**: Usa comandos de zk para acceder eficientemente al frontmatter
- **Soporte semanal y mensual**: Funciona con formato `YYYY-Www` y `YYYY-Mmm`

## 📝 Uso

### 1. En el template

El template `weekly.md` ya incluye el marcador necesario:

```markdown
### Tabla de seguimiento

<!-- habits-tracker -->
```

Al crear una nota semanal nueva, este marcador estará presente.

### 2. Actualización automática

Cuando abras una nota de revisión semanal/mensual y la guardes (`:w`), si el marcador `<!-- habits-tracker -->` está presente, la tabla se generará/actualizará automáticamente.

### 3. Comandos manuales

En archivos zk de revisión:

- `:ZkHabitsUpdate` - Actualiza la tabla existente
- `:ZkHabitsInsert` - Inserta marcador y tabla en la posición del cursor

### 4. Formato esperado

#### Notas diarias (`0.reviews/4.daily/YYYY-MM-DD.md`)

```yaml
---
meditar: true
entrenar: false
leer: 45
escribir: true
dormir: 7
---
```

#### Notas semanales (`0.reviews/3.weekly/YYYY-Www.md`)

```yaml
---
daily_target_read: 30
daily_target_sleep: 6
---
```

## 📊 Tabla generada

La tabla incluye:

- **Filas de datos**: Una por cada día del periodo
- **Iconos**: 🧘 Meditar, 💪🏼 Entrenar, 📖 Leer, ✍🏼 Escribir, 🛌 Dormir
- **Estado**: ✅ Completado, 🟥 No completado
- **Streak**: Racha actual (días consecutivos desde el más reciente)
- **Record**: Racha más larga desde inicio del año

Ejemplo:

```markdown
| Date | 🧘 | 💪🏼 | 📖 | ✍🏼 | 🛌 |
|------|-----|-----|-----|-----|-----|
| [[2025-11-11]] | ✅ | ✅ | ✅ | 🟥 | ✅ |
| [[2025-11-12]] | ✅ | 🟥 | ✅ | ✅ | ✅ |
| [[2025-11-13]] | ✅ | ✅ | 🟥 | ✅ | ✅ |
|  |  |  |  |  |  |
| **Streak** | 3 | 1 | 0 | 2 | 3 |
| **Record** | 15 | 8 | 12 | 10 | 14 |
```

## 🔧 Lógica de hábitos

### Hábitos booleanos

- `meditar`, `entrenar`, `escribir`: Se consideran completados si el valor es `true`

### Hábitos con metas

- `leer`: Completado si minutos >= `daily_target_read` (default: 30)
- `dormir`: Completado si horas >= `daily_target_sleep` (default: 6)

Los targets se leen del frontmatter de la nota semanal correspondiente.

## ⚙️ Configuración

### Autocmds

Los autocmds se configuran automáticamente en `after/ftplugin/zktools.lua`:

- **BufWritePost**: Se ejecuta al guardar (`:w`)
- **BufLeave**: Se ejecuta al salir del buffer (opcional, puede deshabilitarse)

### Rutas esperadas

```
$ZK_NOTEBOOK_DIR/
├── 0.reviews/
│   ├── 2.monthly/    # YYYY-Mmm.md
│   ├── 3.weekly/     # YYYY-Www.md
│   └── 4.daily/      # YYYY-MM-DD.md
```

## 🛠️ API de módulos

### `zktools.frontmatter`

```lua
-- Obtener campos específicos usando zk CLI
local data = require("zktools.frontmatter").get_fields(file_path, {"meditar", "leer"})

-- Obtener un campo
local valor = require("zktools.frontmatter").get_field(file_path, "meditar")

-- Obtener todo el frontmatter
local all = require("zktools.frontmatter").get_all(file_path)

-- Actualizar un campo
require("zktools.frontmatter").update_field(file_path, "meditar", true)
```

### `zktools.habits`

```lua
-- Generar tabla (retorna array de strings)
local lines = require("zktools.habits").generate_table()

-- Actualizar tabla en buffer actual
require("zktools.habits").update_table_in_buffer()

-- Insertar en cursor
require("zktools.habits").insert_marker_and_table()
```

### `zktools.utils`

```lua
local utils = require("zktools.utils")

-- Parsear fechas
local date = utils.parse_date("2025-11-18")
local timestamp = utils.date_to_timestamp(date)

-- Obtener límites de semana/mes
local start, end_time = utils.get_week_bounds(2025, 47)

-- Parsear nombre de archivo
local type, year, num = utils.parse_filename("2025-W47")

-- Rutas
local daily_dir = utils.get_daily_dir()
local weekly_dir = utils.get_weekly_dir()
```

## 🐛 Troubleshooting

### La tabla no se actualiza

1. Verifica que el marcador `<!-- habits-tracker -->` esté presente
2. Revisa que el nombre del archivo sea formato `YYYY-Www` o `YYYY-Mmm`
3. Verifica que `$ZK_NOTEBOOK_DIR` esté definido
4. Comprueba que las notas diarias existan en `0.reviews/4.daily/`

### Valores incorrectos

1. Verifica el frontmatter de las notas diarias
2. Revisa que los valores sean del tipo correcto (boolean, number)
3. Comprueba los targets en la nota semanal (`daily_target_read`, `daily_target_sleep`)

### Errores de sintaxis Lua

1. Asegúrate de que todos los módulos estén en `lua/zktools/`
2. Verifica que no haya errores de sintaxis con `:messages`
3. Prueba cargar manualmente: `:lua require("zk").habits.generate_table()`

## 📚 Referencias

- [zk Frontmatter Documentation](https://zk-org.github.io/zk/notes/note-frontmatter.html)
- [zk CLI Documentation](https://zk-org.github.io/zk/)
- [Neovim Lua Guide](https://neovim.io/doc/user/lua-guide.html)

## 🎯 Mejoras futuras

- [ ] Soporte para hábitos personalizados
- [ ] Gráficos de progreso en ASCII
- [ ] Exportar estadísticas a JSON
- [ ] Dashboard interactivo con Telescope
- [ ] Sincronización con calendarios externos
