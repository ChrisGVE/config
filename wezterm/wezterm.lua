---------
-- SYSTEM
---------
--
-- Pull in the wezterm API
local wezterm = require("wezterm") --[[@as Wezterm]] --- this type cast invokes the LSP module for Wezterm
local mux = wezterm.mux

-- Install plugins
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local resurrect = wezterm.plugin.require("https://github.com/chrisgve/resurrect.wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

-- Update the plugins
wezterm.plugin.update_all()

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Remove confirmation when closing wezterm
config.window_close_confirmation = "NeverPrompt"

-- Change the environment path
config.set_environment_variables = {
	PATH = os.getenv("PATH") .. ":/usr/local/bin",
}

-- Enable kitty's image protocol
config.enable_kitty_graphics = true

------------
-- CONSTANTS
------------

local nerdfonts = wezterm.nerdfonts

local HARD_LEFT_ARROW = nerdfonts.pl_left_hard_divider
local SOFT_LEFT_ARROW = nerdfonts.pl_left_soft_divider
local HARD_RIGHT_ARROW = nerdfonts.pl_right_hard_divider
local SOFT_RIGHT_ARROW = nerdfonts.pl_right_soft_divider

local LOWER_LEFT_WEDGE = nerdfonts.ple_lower_left_triangle
local UPPER_LEFT_WEDGE = nerdfonts.ple_upper_left_triangle
local LOWER_RIGHT_WEDGE = nerdfonts.ple_lower_right_triangle
local UPPER_RIGHT_WEDGE = nerdfonts.ple_upper_right_triangle

local BACKSLASH_SEPARATOR = nerdfonts.ple_backslash_separator
local FORWARDSLASH_SEPARATOR = nerdfonts.ple_forwardslash_separator

local HOME = os.getenv("HOME")
local STATE = os.getenv("XDG_STATE_HOME") or HOME .. "/.local/state"

local TABSIZE = 20
local TAB_UPDATE_INTERVAL = 500 -- ms

-- Selecting the color scheme
config.color_scheme = "Catppuccin Mocha"
local scheme = wezterm.color.get_builtin_schemes()[config.color_scheme]

local process_default_icons = {
	["air"] = nerdfonts.md_language_go,
	["apt"] = nerdfonts.dev_debian,
	["bacon"] = nerdfonts.dev_rust,
	["bash"] = nerdfonts.cod_terminal_bash,
	["bat"] = nerdfonts.md_bat,
	["btm"] = nerdfonts.md_chart_donut_variant,
	["btop"] = nerdfonts.md_chart_areaspline,
	["btop4win++"] = nerdfonts.md_chart_areaspline,
	["bun"] = nerdfonts.md_hamburger,
	["cargo"] = nerdfonts.dev_rust,
	["chezmoi"] = nerdfonts.md_home_plus_outline,
	["cmd.exe"] = nerdfonts.md_console_line,
	["curl"] = nerdfonts.md_flattr,
	["debug"] = nerdfonts.cod_debug,
	["default"] = nerdfonts.md_application,
	["docker"] = nerdfonts.linux_docker,
	["docker-compose"] = nerdfonts.linux_docker,
	["dpkg"] = nerdfonts.dev_debian,
	["fish"] = nerdfonts.md_fish,
	["gh"] = nerdfonts.dev_github_badge,
	["git"] = nerdfonts.dev_git,
	["go"] = nerdfonts.md_language_go,
	["htop"] = nerdfonts.md_chart_areaspline,
	["kubectl"] = nerdfonts.linux_docker,
	["kuberlr"] = nerdfonts.linux_docker,
	["lazydocker"] = nerdfonts.linux_docker,
	["lazygit"] = nerdfonts.cod_github,
	["lua"] = nerdfonts.seti_lua,
	["make"] = nerdfonts.seti_makefile,
	["nix"] = nerdfonts.linux_nixos,
	["node"] = nerdfonts.md_nodejs,
	["npm"] = nerdfonts.md_npm,
	["nvim"] = nerdfonts.custom_neovim,
	["pacman"] = nerdfonts.md_pac_man,
	["paru"] = nerdfonts.md_pac_man,
	["pnpm"] = nerdfonts.md_npm,
	["postgresql"] = nerdfonts.dev_postgresql,
	["powershell.exe"] = nerdfonts.md_console,
	["psql"] = nerdfonts.dev_postgresql,
	["pwsh.exe"] = nerdfonts.md_console,
	["rpm"] = nerdfonts.dev_redhat,
	["redis"] = nerdfonts.dev_redis,
	["ruby"] = nerdfonts.cod_ruby,
	["rust"] = nerdfonts.dev_rust,
	["serial"] = nerdfonts.md_serial_port,
	["ssh"] = nerdfonts.md_pipe,
	["sudo"] = nerdfonts.fa_hashtag,
	["tls"] = nerdfonts.md_power_socket,
	["topgrade"] = nerdfonts.md_rocket_launch,
	["unix"] = nerdfonts.md_bash,
	["valkey"] = nerdfonts.dev_redis,
	["vim"] = nerdfonts.dev_vim,
	["yarn"] = nerdfonts.seti_yarn,
	["yay"] = nerdfonts.md_pac_man,
	["yazi"] = nerdfonts.md_duck,
	["yum"] = nerdfonts.dev_redhat,
	["zsh"] = nerdfonts.dev_terminal,
}

local process_custom_icons = {
	-- ["brew"] = nerdfonts.dev_homebrew,
	["brew"] = " ",
	["taskwarrior-tui"] = nerdfonts.fa_tasks,
	["wget"] = nerdfonts.md_arrow_down_box,
	["curl"] = nerdfonts.md_arrow_down_box,
	["gitui"] = nerdfonts.dev_github_badge,
	["kubectl"] = nerdfonts.md_kubernetes,
	["kuberlr"] = nerdfonts.md_kubernetes,
	["ssh"] = nerdfonts.md_ssh,
}

-------------------
-- HELPER FUNCTIONS
-------------------

local function tableInspect(tbl, depth, indent, currentDepth)
	depth = depth or 1 -- Limit recursion depth (optional)
	indent = indent or 0 -- Current indentation level
	currentDepth = currentDepth or 1 -- Tracks the current depth of recursion
	local result = {}
	local prefix = string.rep("  ", indent)

	if type(tbl) ~= "table" then
		return tostring(tbl) -- Handle non-table values directly
	end

	local keys = {}
	for k in pairs(tbl) do
		table.insert(keys, k)
	end

	-- Sort keys if at level 1 and their subtables contain "key"
	if currentDepth == 1 then
		table.sort(keys, function(a, b)
			local ta, tb = tbl[a], tbl[b]
			if type(ta) == "table" and type(tb) == "table" and ta["key"] and tb["key"] then
				return tostring(ta["key"]):lower() < tostring(tb["key"]):lower()
			end
			return tostring(a):lower() < tostring(b):lower()
		end)
	end

	for _, k in ipairs(keys) do
		local v = tbl[k]
		local key = tostring(k)
		if type(v) == "table" and depth > 0 then
			table.insert(result, prefix .. key .. " = {")
			table.insert(result, tableInspect(v, depth - 1, indent + 1, currentDepth + 1))
			table.insert(result, prefix .. "}")
		else
			table.insert(result, prefix .. key .. " = " .. tostring(v))
		end
	end

	return table.concat(result, "\n")
end

local function deepMerge(t1, t2)
	-- If both tables are arrays, concatenate them
	if #t1 > 0 and #t2 > 0 then
		local merged = {}
		for _, v in ipairs(t1) do
			table.insert(merged, v)
		end
		for _, v in ipairs(t2) do
			table.insert(merged, v)
		end
		return merged
	end

	-- Otherwise, merge as key-value pairs
	local merged = {}
	for k, v in pairs(t1) do
		if type(v) == "table" and type(t2[k]) == "table" then
			merged[k] = deepMerge(v, t2[k])
		else
			merged[k] = v
		end
	end

	for k, v in pairs(t2) do
		if merged[k] == nil then
			merged[k] = v
		end
	end

	return merged
end

-- Build the full table of icons
local process_icons = deepMerge(process_default_icons, process_custom_icons)

-- truncate path
local function truncate_path(path, max_chars)
	-- Reverse the path for easier processing from the lowest folder level
	local reversed_path = path:reverse()
	-- Match up to max_chars without splitting folder names (stopping at '/')
	local matched_length = 0
	local truncated_reversed = ""
	for segment in reversed_path:gmatch("[^/]+/") do
		if matched_length + #segment > max_chars then
			break
		end
		truncated_reversed = truncated_reversed .. segment
		matched_length = matched_length + #segment
	end
	-- Reverse back to get the truncated path in original order
	return truncated_reversed:reverse()
end

-- function returns the current working directory for the tab
local function get_cwd(tab)
	local result = ""
	local cwd = tab.active_pane.current_working_dir
	if cwd then
		cwd = cwd.file_path:gsub(HOME, "~")
		if #cwd > TABSIZE then
			result = nerdfonts.cod_ellipsis .. truncate_path(cwd, TABSIZE)
		else
			result = cwd
		end
	end
	return result
end

-- get the name of the process running in the foreground for the tab
local function get_process_name(tab)
	local foreground_process_name = ""
	-- get the foreground process name if available
	if tab.active_pane and tab.active_pane.foreground_process_name then
		foreground_process_name = tab.active_pane.foreground_process_name
		foreground_process_name = foreground_process_name:match("([^/\\]+)[/\\]?$") or foreground_process_name
	end
	-- fallback to the title if the foreground process name is unavailable
	-- Wezterm uses OSC 1/2 escape sequences to guess the process name and set the title
	-- see https://wezfurlong.org/wezterm/config/lua/pane/get_title.html
	-- title defaults to 'wezterm' if another name is unavailable
	if foreground_process_name == "" then
		foreground_process_name = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or tab.active_pane.title
	end
	-- if the tab active pane contains a non-local domain, use the domain name
	if foreground_process_name == "wezterm" then
		foreground_process_name = tab.active_pane.domain_name ~= "local" and tab.active_pane.domain_name or "wezterm"
	end
	return foreground_process_name
end

-- function returns the process icon for the process name
local function get_process_icon(process_name)
	local icon = ""
	for process, icn in pairs(process_icons) do
		if process_name:lower():match("^" .. process) then
			icon = icn
			break
		end
	end
	if icon == "" then
		icon = process_icons["default"]
	end
	return icon .. " "
end

-- function returns the tab icon according to its process
local function get_tab_icon(tab)
	return get_process_icon(get_process_name(tab))
end

-- function returns the current working directory by path only if the process is a shell
local function get_cwd_postfix(tab)
	local postfix = ""
	local process = get_process_name(tab)
	if string.find("|bash|zsh|fish|tmux|fish|ksh|csh|", process) then
		postfix = "(" .. get_cwd(tab) .. ")"
	end
	return postfix
end

-- function returns the attribute in case the inactive tab has unseen output
local function has_unseen_output_attribute(tab, opts)
	local result = { Foreground = { Color = "blue" } }
	for index, pane in ipairs(tab.panes) do
		if pane.has_unseen_output then
			result = { Foreground = { Color = "red" } }
		end
	end
	print(result)
	return result
end

-- function returns a bell in case the inactive tab has unseen output
local function has_unseen_output_bell(tab, opts)
	for _, pane in ipairs(tab.panes) do
		if pane.has_unseen_output then
			return "  "
		end
	end
	return ""
end

----------------
-- FONTS
----------------

config.font = wezterm.font_with_fallback({
	{
		family = "Operator Mono SSm Lig",
		weight = "Light",
		harfbuzz_features = { "liga=1", "calt=1", "clig=1" },
		assume_emoji_presentation = false,
	},
	{ family = "Symbols Nerd Font Mono" },
	{ family = "Hack Nerd Font Mono" },
})

config.use_cap_height_to_scale_fallback_fonts = true

config.font_size = 16

----------------
-- NOTIFICATIONS
----------------

-- Confirm configuration reloads
wezterm.on("window-config-reloaded", function(window, pane)
	window:toast_notification("wezterm", "configuration reloaded!", nil, 4000)
end)

-- Sending a notification when specified events occur but suppress on `periodic_save()`:
local resurrect_event_listeners = {
	"resurrect.decrypt.finished",
	"resurrect.delete_state.finished",
	"resurrect.fuzzy_load.start",
	"resurrect.load_state.start",
	"resurrect.tab_state.restore_tab.start",
	"resurrect.window_state.restore_window.start",
	"resurrect.workspace_state.restore_workspace.start",
	"resurrect.error",
	"resurrect.save_state.finished",
}

local is_periodic_save = false
wezterm.on("resurrect.periodic_save", function()
	is_periodic_save = true
end)

for _, event in ipairs(resurrect_event_listeners) do
	wezterm.on(event, function(...)
		if event == "resurrect.save_state.finished" and is_periodic_save then
			is_periodic_save = false
			return
		end
		local args = { ... }
		local msg = event
		for _, v in ipairs(args) do
			msg = msg .. " " .. tostring(v)
		end
		wezterm.gui.gui_windows()[1]:toast_notification("Wezterm - resurrect", msg, nil, 4000)
	end)
end

---------------
-- KEY BINDINGS
---------------

-- Disable default keybindings
config.disable_default_key_bindings = true

-- Define the LEADER key
config.leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1500 }

-- Key configuration
local standard_keys = {
	{ mods = "CMD", key = "q", action = wezterm.action.QuitApplication },
	{ mods = "CMD", key = "w", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
	{ mods = "CMD", key = "n", action = wezterm.action.SpawnWindow },
	{ mods = "CMD", key = "t", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ mods = "CMD", key = "c", action = wezterm.action.CopyTo("Clipboard") },
	{ mods = "CMD", key = "v", action = wezterm.action.PasteFrom("Clipboard") },
	{ mods = "CMD", key = "1", action = wezterm.action.ActivateTab(0) },
	{ mods = "CMD", key = "2", action = wezterm.action.ActivateTab(1) },
	{ mods = "CMD", key = "3", action = wezterm.action.ActivateTab(2) },
	{ mods = "CMD", key = "4", action = wezterm.action.ActivateTab(3) },
	{ mods = "CMD", key = "5", action = wezterm.action.ActivateTab(4) },
	{ mods = "CMD", key = "6", action = wezterm.action.ActivateTab(5) },
	{ mods = "CMD", key = "7", action = wezterm.action.ActivateTab(6) },
	{ mods = "CMD", key = "8", action = wezterm.action.ActivateTab(7) },
	{ mods = "LEADER", key = "-", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ mods = "LEADER|SHIFT", key = "_", action = wezterm.action.SplitPane({ direction = "Down", top_level = true }) },
	{ mods = "LEADER", key = "\\", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ mods = "LEADER|SHIFT", key = "|", action = wezterm.action.SplitPane({ direction = "Right", top_level = true }) },
	{ mods = "LEADER", key = "z", action = wezterm.action.TogglePaneZoomState },
	{ mods = "LEADER", key = "Space", action = wezterm.action.RotatePanes("Clockwise") },
	{ mods = "LEADER", key = "0", action = wezterm.action.PaneSelect({ mode = "SwapWithActive" }) },
	{ mods = "LEADER", key = "1", action = wezterm.action.ActivateTab(0) },
	{ mods = "LEADER", key = "2", action = wezterm.action.ActivateTab(1) },
	{ mods = "LEADER", key = "3", action = wezterm.action.ActivateTab(2) },
	{ mods = "LEADER", key = "4", action = wezterm.action.ActivateTab(3) },
	{ mods = "LEADER", key = "5", action = wezterm.action.ActivateTab(4) },
	{ mods = "LEADER", key = "6", action = wezterm.action.ActivateTab(5) },
	{ mods = "LEADER", key = "7", action = wezterm.action.ActivateTab(6) },
	{ mods = "LEADER", key = "8", action = wezterm.action.ActivateTab(7) },
	{ mods = "LEADER", key = "9", action = wezterm.action.ActivateTab(-1) },
	{ mods = "LEADER", key = "]", action = wezterm.action.ActivateTabRelative(1) },
	{ mods = "LEADER", key = "[", action = wezterm.action.ActivateTabRelative(-1) },
	{ mods = "LEADER", key = "r", action = wezterm.action.ReloadConfiguration },
	{ mods = "LEADER", key = "y", action = wezterm.action.CopyTo("Clipboard") },
	{ mods = "LEADER", key = "p", action = wezterm.action.PasteFrom("Clipboard") },
	{ mods = "LEADER", key = "Y", action = wezterm.action.CopyTo("PrimarySelection") },
	{ mods = "LEADER", key = "P", action = wezterm.action.PasteFrom("PrimarySelection") },
	{ mods = "LEADER", key = "c", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	-- { mods = "LEADER", key = "w", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
	-- { mods = "LEADER", key = "q", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	{ mods = "LEADER", key = "d", action = wezterm.action.ShowDebugOverlay },
	{ mods = "LEADER", key = "?", action = wezterm.action.ActivateCommandPalette },
	{ mods = "LEADER", key = "v", action = wezterm.action.ActivateCopyMode },
}

--**********************
-- EXTENSIONS MANAGEMENT
--**********************

--------------------------------
-- SMART WORKSPACE and RESURRECT
--------------------------------

config.default_workspace = "~"

workspace_switcher.zoxide_path = "/usr/local/bin/zoxide"

resurrect.change_state_save_dir(STATE .. "/wezterm/resurrect/")

resurrect.periodic_save({
	interval_seconds = 120, -- s
	save_workspace = true,
	save_window = true,
	save_tabs = true,
})

-- Resurrect set encryption
resurrect.set_encryption({
	enable = true,
	method = "/usr/local/bin/rage",
	private_key = HOME .. "/.secret/rage-wezterm.txt",
	public_key = "age1xvq9z8m4jn9zsff0sfls8rzk40r8fvrzdlaqnah6ttdfqfzxcyts4m88r9",
})

wezterm.on("smart_workspace_switcher.workspace_switcher.chosen", function(window, workspace)
	local gui_win = window:gui_window()
	local base_path = string.gsub(workspace, "(.*[/\\])(.*)", "%2")
	gui_win:set_right_status(wezterm.format({
		{ Foreground = { Color = "green" } },
		{ Text = base_path .. "  " },
	}))
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, workspace)
	local gui_win = window:gui_window()
	local base_path = string.gsub(workspace, "(.*[/\\])(.*)", "%2")
	gui_win:set_right_status(wezterm.format({
		{ Foreground = { Color = "green" } },
		{ Text = base_path .. "  " },
	}))
end)

-- Saves the state whenever I select a workspace
wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
	local workspace_state = resurrect.workspace_state
	resurrect.save_state(workspace_state.get_workspace_state())
end)

-- Load the state whenever I create a new workspace
wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
	local workspace_state = resurrect.workspace_state

	workspace_state.restore_workspace(resurrect.load_state(label, "workspace"), {
		window = window,
		relative = true,
		restore_text = true,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})
end)

local extended_keys = {
	-- SMART_WORKSPACE_SWITCHER
	--
	-- switch workspace
	{
		mods = "LEADER",
		key = "s",
		-- this is invoking `zoxide query -l <extra_args>`
		-- action = workspace_switcher.switch_workspace({ extra_args = " | rg -Fxf ~/.projects" }),
		-- this is the plain version of the above
		action = workspace_switcher.switch_workspace({}),
	},

	-- switch to previous workspace
	{ mods = "LEADER|SHIFT", key = "S", action = workspace_switcher.switch_to_prev_workspace() },

	-- create a new workspace
	{ -- Prompt for a name to use for a new workspace and switch to it.
		mods = "LEADER|SHIFT",
		key = "C",
		action = wezterm.action.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { Color = scheme.ansi[5] } },
				{ Text = "Enter name for the new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line and #string.gsub(line, "^%s*(.-)%s*$", "%1") ~= 0 then
					window:perform_action(wezterm.action.SwitchToWorkspace({ name = line }), pane)
				end
			end),
		}),
	},

	-- RESURRECT

	-- Save workspace
	{
		mods = "ALT",
		key = "w",
		action = wezterm.action_callback(function(win, pane)
			resurrect.save_state(resurrect.workspace_state.get_workspace_state())
		end),
	},

	-- save window state
	{ mods = "ALT|SHIFT", key = "W", action = resurrect.window_state.save_window_action() },

	-- save tab state
	{ mods = "ALT|SHIFT", key = "T", action = resurrect.tab_state.save_tab_action() },

	{
		mods = "ALT",
		key = "s",
		action = wezterm.action_callback(function(win, pane)
			resurrect.save_state(resurrect.workspace_state.get_workspace_state())
			resurrect.window_state.save_window_action()
		end),
	},

	-- Read the resurrect state file (use the fuzzy finder)
	{
		mods = "ALT",
		key = "r",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_load(win, pane, function(id)
				local type = string.match(id, "^([^/]+)") -- match before '/'
				id = string.match(id, "([^/]+)$") -- match after '/'
				id = string.match(id, "(.+)%..+$") -- remove file extension
				local opts = {
					relative = true,
					restore_text = true,
					on_pane_restore = resurrect.tab_state.default_on_pane_restore,
				}
				if type == "workspace" then
					local state = resurrect.load_state(id, "workspace")
					resurrect.workspace_state.restore_workspace(state, opts)
				elseif type == "window" then
					local state = resurrect.load_state(id, "window")
					resurrect.window_state.restore_window(pane:window(), state, opts)
				elseif type == "tab" then
					local state = resurrect.load_state(id, "tab")
					resurrect.tab_state.restore_tab(pane:tab(), state, opts)
				end
			end, {
				title = "Restore State",
				description = "Select State to Restore and press Enter = accept, Esc = cancel, / = filter",
				fuzzy_description = "Search State to Restore: ",
				is_fuzzy = true,
			})
		end),
	},
	-- Delete a saved state
	{
		mods = "ALT",
		key = "d",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_load(win, pane, function(id)
				resurrect.delete_state(id)
			end, {
				title = "Delete State",
				description = "Select State to Delete and press Enter = accept, Esc = cancel, / = filter",
				fuzzy_description = "Search State to Delete: ",
				is_fuzzy = true,
			})
		end),
	},
}

-- finalized all the keybindings
config.keys = deepMerge(standard_keys, extended_keys)

-- AUGMENT COMMAND PALETTE
-- TODO: Work on the augment command palette as the palette is currently unusable
-- wezterm.on("augment-command-palette", function(window, pane)
-- 	local workspace_state = resurrect.workspace_state
-- 	return {
-- 		{
-- 			brief = "Window | Workspace: Switch Workspace",
-- 			icon = "md_briefcase_arrow_up_down",
-- 			action = workspace_switcher.switch_workspace(),
-- 		},
-- 		{
-- 			brief = "Window | Workspace: Rename Workspace",
-- 			icon = "md_briefcase_edit",
--			action = wezterm.action.PromptInputLine({
-- 				description = "Enter new name for workspace",
-- 				action = wezterm.action_callback(function(window, pane, line)
-- 					if line then
-- 						wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
-- 						resurrect.save_state(workspace_state.get_workspace_state())
-- 					end
-- 				end),
-- 			}),
-- 		},
-- 	}
-- end)

----------------
-- TAB BAR
----------------

-- Initial setup to map the color_scheme to the tab_line scheme
tabline.setup({
	options = {
		theme = config.color_scheme,
	},
})

-- Retrieval of the color scheme
local tabline_scheme = tabline.get_colors()

-- Actual setup of the tab_line
tabline.setup({
	options = {

		-- THEME

		theme = config.color_scheme,
		color_overrides = {
			tab = {
				inactive = {
					fg = scheme.tab_bar.inactive_tab.fg_color,
					bg = scheme.tab_bar.inactive_tab.bg_color,
				},
				inactive_hover = {
					fg = scheme.tab_bar.inactive_tab_hover.fg_color,
					bg = scheme.tab_bar.inactive_tab_hover.bg_color,
				},
			},
		},
		section_separators = {
			left = HARD_LEFT_ARROW,
			right = HARD_RIGHT_ARROW,
		},
		component_separators = {
			left = SOFT_LEFT_ARROW,
			right = SOFT_RIGHT_ARROW,
		},
		tab_separators = {
			left = "",
			right = "",
		},
	},

	-- SECTIONS DEFINITIONS

	sections = {

		-- LEFT SECTION

		tabline_a = { {
			"mode",
			fmt = function(str)
				return str:sub(1, 1)
			end,
		} },
		tabline_b = {
			function()
				local workspace = mux.get_active_workspace()
				if workspace == config.default_workspace then
					return ""
				else
					return nerdfonts.cod_terminal_tmux .. " " .. string.match(workspace, "[^/\\]+$")
				end
			end,
		},
		tabline_c = { " " },

		-- ACTIVE TAB

		tab_active = {
			{ Attribute = { Intensity = "Bold" } },
			{ Foreground = { Color = scheme.tab_bar.active_tab.fg_color } },
			{ Background = { Color = scheme.selection_fg } },
			UPPER_LEFT_WEDGE,
			"index",
			{ Foreground = { Color = scheme.selection_fg } },
			{ Background = { Color = tabline_scheme.tab.active.bg } },
			UPPER_LEFT_WEDGE,
			"ResetAttributes",
			get_tab_icon,
			{ Attribute = { Intensity = "Bold" } },
			" ",
			function(tab)
				return get_cwd(tab)
			end,
			" ",
			{ "zoomed", padding = 0 },
			" ",
			{ Foreground = { Color = tabline_scheme.tab.active.bg } },
			{ Background = { Color = tabline_scheme.tab.inactive.bg } },
			UPPER_LEFT_WEDGE,
			" ",
		},

		-- INACTIVE TAB

		tab_inactive = {
			{ Attribute = { Italic = true } },
			{ Foreground = { Color = scheme.selection_bg } },
			{ Background = { Color = scheme.tab_bar.active_tab.fg_color } },
			LOWER_RIGHT_WEDGE,
			{ Foreground = { Color = scheme.tab_bar.inactive_tab.fg_color } },
			{ Foreground = { Color = scheme.tab_bar.inactive_tab.fg_color } },
			{ Background = { Color = scheme.selection_bg } },
			"index",
			{ Foreground = { Color = scheme.selection_bg } },
			{ Background = { Color = tabline_scheme.tab.inactive.bg } },
			UPPER_LEFT_WEDGE,
			"ResetAttributes",
			-- has_unseen_output_attribute,
			has_unseen_output_bell,
			"ResetAttributes",
			get_tab_icon,
			{ Attribute = { Italic = true } },
			get_process_name,
			" ",
			get_cwd_postfix,
			{ Foreground = { Color = tabline_scheme.tab.inactive.bg } },
			{ Background = { Color = tabline_scheme.tab.inactive.bg } },
			UPPER_LEFT_WEDGE,
			" ",
		},

		-- RIGHT SECTIONS

		-- Removed this section to gain some space
		-- tabline_x = { "ram", { "cpu", throttle = 3 } },
		tabline_x = {},
		tabline_y = {
			{
				"datetime",
				-- style = "%a, %d-%b-%y %H:%M",
				style = " %d-%b %H:%M",
				hour_to_icon = {
					["00"] = nerdfonts.md_clock_time_twelve_outline,
					["01"] = nerdfonts.md_clock_time_one_outline,
					["02"] = nerdfonts.md_clock_time_two_outline,
					["03"] = nerdfonts.md_clock_time_three_outline,
					["04"] = nerdfonts.md_clock_time_four_outline,
					["05"] = nerdfonts.md_clock_time_five_outline,
					["06"] = nerdfonts.md_clock_time_six_outline,
					["07"] = nerdfonts.md_clock_time_seven_outline,
					["08"] = nerdfonts.md_clock_time_eight_outline,
					["09"] = nerdfonts.md_clock_time_nine_outline,
					["10"] = nerdfonts.md_clock_time_ten_outline,
					["11"] = nerdfonts.md_clock_time_eleven_outline,
					["12"] = nerdfonts.md_clock_time_twelve,
					["13"] = nerdfonts.md_clock_time_one,
					["14"] = nerdfonts.md_clock_time_two,
					["15"] = nerdfonts.md_clock_time_three,
					["16"] = nerdfonts.md_clock_time_four,
					["17"] = nerdfonts.md_clock_time_five,
					["18"] = nerdfonts.md_clock_time_six,
					["19"] = nerdfonts.md_clock_time_seven,
					["20"] = nerdfonts.md_clock_time_eight,
					["21"] = nerdfonts.md_clock_time_nine,
					["22"] = nerdfonts.md_clock_time_ten,
					["23"] = nerdfonts.md_clock_time_eleven,
				},
			},
		},
		tabline_z = { "hostname" },
	},
	extensions = { "resurrect", "smart_workspace_switcher" },
})

tabline.apply_to_config(config)
config.tab_bar_at_bottom = true
config.status_update_interval = TAB_UPDATE_INTERVAL

---------------
-- TITLE BAR
---------------

-- TODO: work on the title bar which is very bare

-- Title bar
config.window_decorations = "RESIZE|TITLE"

---------------
-- SMART_SPLIT
---------------

smart_splits.apply_to_config(config, {
	direction_keys = {
		move = { "h", "j", "k", "l" },
		resize = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
	},
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "CTRL", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
})

-- and finally, return the configuration to weztermp
return config
