local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
  -- Snippet básico de función
  s("def", {
    t("def "),
    i(1, "function_name"),
    t("("),
    i(2, "args"),
    t({ "):", "    " }),
    i(3, "pass"),
    i(0),
  }),

  -- Snippet de clase
  s("class", {
    t("class "),
    i(1, "ClassName"),
    t({ ":", "    def __init__(self" }),
    i(2),
    t({ "):", "        " }),
    i(3, "pass"),
    i(0),
  }),

  -- Snippet de if __name__ == "__main__"
  s("ifmain", {
    t({ 'if __name__ == "__main__":', "    " }),
    i(0),
  }),

  -- Snippet de try-except
  s("try", {
    t({ "try:", "    " }),
    i(1, "# código"),
    t({ "", "except " }),
    i(2, "Exception"),
    t({ " as e:", "    " }),
    i(3, "print(e)"),
    i(0),
  }),

  -- Snippet de docstring
  s("doc", {
    t({ '"""', "" }),
    i(1, "Descripción breve."),
    t({ "", "", "Args:", "    " }),
    i(2, "arg: Descripción del argumento"),
    t({ "", "", "Returns:", "    " }),
    i(3, "Descripción del retorno"),
    t({ "", '"""' }),
    i(0),
  }),

  -- Snippet de for loop
  s("for", {
    t("for "),
    i(1, "item"),
    t(" in "),
    i(2, "items"),
    t({ ":", "    " }),
    i(0),
  }),

  -- Snippet de list comprehension
  s("lc", {
    t("["),
    i(1, "expr"),
    t(" for "),
    i(2, "item"),
    t(" in "),
    i(3, "items"),
    t("]"),
    i(0),
  }),

  -- Snippet de print con f-string
  s("pf", {
    t('print(f"'),
    i(1, "texto {variable}"),
    t('")'),
    i(0),
  }),

  -- Snippet de dataclass
  s("dataclass", {
    t({ "from dataclasses import dataclass", "", "", "@dataclass" }),
    t({ "", "class " }),
    i(1, "ClassName"),
    t({ ":", "    " }),
    i(2, "field: str"),
    i(0),
  }),

  -- Snippet de property
  s("prop", {
    t({ "@property", "def " }),
    i(1, "name"),
    t({ "(self):", "    return self._" }),
    f(function(args)
      return args[1][1]
    end, { 1 }),
    t({ "", "", "@" }),
    f(function(args)
      return args[1][1]
    end, { 1 }),
    t({ ".setter", "def " }),
    f(function(args)
      return args[1][1]
    end, { 1 }),
    t({ "(self, value):", "    self._" }),
    f(function(args)
      return args[1][1]
    end, { 1 }),
    t(" = value"),
    i(0),
  }),

  -- Snippet de async function
  s("async", {
    t("async def "),
    i(1, "function_name"),
    t("("),
    i(2, "args"),
    t({ "):", "    " }),
    i(3, "pass"),
    i(0),
  }),

  -- Snippet de pytest fixture
  s("fixture", {
    t({ "@pytest.fixture", "def " }),
    i(1, "fixture_name"),
    t({ "():", "    " }),
    i(2, "return None"),
    i(0),
  }),

  -- Snippet de test
  s("test", {
    t("def test_"),
    i(1, "function_name"),
    t({ "():", "    " }),
    i(2, "assert True"),
    i(0),
  }),

  -- Snippet de sección comentada con centrado dinámico
  s("sec", {
    t("###########################################################"),
    t({ "", "" }),
    f(function(args)
      local text = args[1][1] or "NOMBRE DE LA SECCIÓN"
      local total_width = 59 -- Ancho total de la línea
      local text_with_spaces = " " .. text .. " " -- Espacios antes y después del texto
      local total_hashes = total_width - #text_with_spaces
      local left_hashes = math.floor(total_hashes / 2)
      return string.rep("#", left_hashes)
    end, { 1 }),
    t(" "),
    i(1, "NOMBRE DE LA SECCIÓN"),
    t(" "),
    f(function(args)
      local text = args[1][1] or "NOMBRE DE LA SECCIÓN"
      local total_width = 59
      local text_with_spaces = " " .. text .. " "
      local total_hashes = total_width - #text_with_spaces
      local left_hashes = math.floor(total_hashes / 2)
      local right_hashes = total_hashes - left_hashes
      return string.rep("#", right_hashes)
    end, { 1 }),
    t({ "", "###########################################################", "" }),
    i(0),
  }),

  -- Snippet de sección comentada con línea extra al final
  s("section", {
    t("###########################################################"),
    t({ "", "" }),
    f(function(args)
      local text = args[1][1] or "NOMBRE DE LA SECCIÓN"
      local total_width = 59
      local text_with_spaces = " " .. text .. " "
      local total_hashes = total_width - #text_with_spaces
      local left_hashes = math.floor(total_hashes / 2)
      return string.rep("#", left_hashes)
    end, { 1 }),
    t(" "),
    i(1, "NOMBRE DE LA SECCIÓN"),
    t(" "),
    f(function(args)
      local text = args[1][1] or "NOMBRE DE LA SECCIÓN"
      local total_width = 59
      local text_with_spaces = " " .. text .. " "
      local total_hashes = total_width - #text_with_spaces
      local left_hashes = math.floor(total_hashes / 2)
      local right_hashes = total_hashes - left_hashes
      return string.rep("#", right_hashes)
    end, { 1 }),
    t({ "", "###########################################################", "", "" }),
    i(0),
  }),
}
