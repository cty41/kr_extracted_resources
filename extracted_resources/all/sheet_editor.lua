-- chunkname: @./all/sheet_editor.lua

local log = require("klua.log"):new("sheet_editor")
local class = require("middleclass")
local SU = require("screen_utils")
local V = require("klua.vector")
local G = love.graphics
local timer = require("hump.timer").new()

require("klove.kui")

local sheet_editor = {}
sheet_editor.required_sounds = {}
sheet_editor.required_textures = {}

sheet_editor.ref_w = 1920
sheet_editor.ref_h = 1080
sheet_editor.ref_res = TEXTURE_SIZE_ALIAS.fullhd

local function img_data_to_string(name, a_name, size, trim, a_size, f_quad, alias)
	local o = "\n\t" .. name .. " = {\n\t\ta_name = \"" .. a_name .. "\",\n\t\tsize = {\n\t\t\t" .. size[1] .. ",\n\t\t\t" .. size[2] .. "\n\t\t},\n\t\ttrim = {\n\t\t\t" .. trim[1] .. ",\n\t\t\t" .. trim[2] .. ",\n\t\t\t" .. trim[3] .. ",\n\t\t\t" .. trim[4] .. "\n\t\t},\n\t\ta_size = {\n\t\t\t" .. a_size[1] .. ",\n\t\t\t" .. a_size[2] .. "\n\t\t},\n\t\tf_quad = {\n\t\t\t" .. f_quad[1] .. ",\n\t\t\t" .. f_quad[2] .. ",\n\t\t\t" .. f_quad[3] .. ",\n\t\t\t" .. f_quad[4] .. "\n\t\t},\n\t\talias = {"

	if alias then
		a_len = #alias
		for i, n in ipairs(alias) do
			o = o .. "\n\t\t\t\"" .. n
			if i < a_len then
				o = o .. "\","
			else
				o = o .. "\"\n\t\t"
			end
		end
	end

	return o .. "}\n\t}"
end

local function add_selector(s, pos, size, name, a_name, e_size, trim, a_size, alias)
	local selector = KView:new(size)
	selector.pos = pos
	selector.trim = trim or {0, 0, 0, 0}

	if name then
		selector.code_name = name
		selector.a_name = a_name
		if e_size[1] ~= size.x or e_size[2] ~= size.y then
			selector.e_size = e_size
		end
		selector.a_size = a_size
		selector.alias = alias
	else
		s.selected = selector
	end

	function selector.update_info(this, silent)
		if not silent then
			sheet_editor.code_field:set_value(this.code_name or "", true)
			sheet_editor.pos_field:set_value(this.pos.x, true)
			sheet_editor.pos_field_2:set_value(this.pos.y, true)
			sheet_editor.size_field:set_value(this.size.x, true)
			sheet_editor.size_field_2:set_value(this.size.y, true)
			sheet_editor.e_size_field:set_value(this.e_size and this.e_size[1] or "", true)
			sheet_editor.e_size_field_2:set_value(this.e_size and this.e_size[2] or "", true)
			sheet_editor.trim_field:set_value(this.trim[1], true)
			sheet_editor.trim_field_2:set_value(this.trim[2], true)
			sheet_editor.trim_field_3:set_value(this.trim[3], true)
			sheet_editor.trim_field_4:set_value(this.trim[4], true)
			sheet_editor.alias_list:clear_rows()
			if this.alias then
				for i, n in ipairs(this.alias) do
					sheet_editor.alias_list:add_alias(n)
				end
			end
		end
		local size_text = this.size.x .. ",\n\t\t" .. this.size.y
		sheet_editor.info_label.text = sheet_editor.code_field.value .. " = {\n\ta_name = \"" .. sheet_editor.name_field.value .. sheet_editor.ext_field.value .. "." .. sheet_editor.ext_field_2.value .. "\",\n\tsize = {\n\t\t" .. (this.e_size and (this.e_size[1] .. ",\n\t\t" .. this.e_size[2]) or size_text) .. "\n\t},\n\ttrim = {\n\t\t" .. (this.trim and (this.trim[1] .. ",\n\t\t" .. this.trim[2] .. ",\n\t\t" .. this.trim[3] .. ",\n\t\t" .. this.trim[4]) or "0,\n\t\t0,\n\t\t0,\n\t\t0") .. "\n\t},\n\ta_size = {\n\t\t" .. s.size.x .. ",\n\t\t" .. s.size.y .. "\n\t},\n\tf_quad = {\n\t\t" .. this.pos.x .. ",\n\t\t" .. this.pos.y .. ",\n\t\t" .. size_text .. "\n\t},\n\talias = {"
		if this.alias then
			a_len = #this.alias
			for i, n in ipairs(this.alias) do
				sheet_editor.info_label.text = sheet_editor.info_label.text .. "\n\t\t\"" .. n
				if i < a_len then
					sheet_editor.info_label.text = sheet_editor.info_label.text .. "\","
				else
					sheet_editor.info_label.text = sheet_editor.info_label.text .. "\"\n\t"
				end
			end
		end
		sheet_editor.info_label.text = sheet_editor.info_label.text .. "}\n}"
	end

	function selector.draw(this)
		KView.draw(this)

		if not this.hidden then
			G.push()

			G.setColor({
				255,
				0,
				0,
				255
			})
			G.rectangle("line", -0.5, -0.5, this.size.x + 1, this.size.y + 1)

			if s.selected == this then
				local sx = this.e_size and this.e_size[1] or this.size.x
				local sy = this.e_size and this.e_size[2] or this.size.y
				local px = sx / 2 - this.trim[1]
				local py = sy / 2 - this.trim[2]

				G.setColor({
					0,
					0,
					255,
					255
				})
				G.rectangle("line", - this.trim[1] - 0.5, - this.trim[2] - 0.5, sx + 1, sy + 1)
				G.line(px, -this.trim[2], px, sy - this.trim[2])
				G.line(-this.trim[1], py, sx - this.trim[1], py)
			end

			G.pop()
		end
	end

	function selector.on_click(this)
		if s.selected == this then
			s:deselect()
		else
			s.selected = this

			this:update_info()
		end
	end

	s:add_child(selector)
end

local function search_selector(self, name)
	local selector = nil

	for i, d in ipairs(self.children) do
		if d.code_name == name then
			selector = d
			break
		elseif d.alias then
			for j, a in ipairs(d.alias) do
				if a == name then
					selector = d
					break
				end
			end
			if selector then
				break
			end
		end
	end

	return selector
end

function sheet_editor:set_mode(mode, silent)
	local s = self.sheet.hidden and self.sprite or self.sheet

	local m = self.mode and self[self.mode .. "_mode"]

	if m then
		if not silent then
			m.unset_mode(s)
			s.mode = nil
		end

		self.mode = nil

		m.colors.background = {
			200,
			200,
			200,
			255
		}
	end

	m = mode and self[mode .. "_mode"]

	if m then
		if not silent then
			m.set_mode(s)
			s.mode = mode
		end

		self.mode = mode

		m.colors.background = {
			255,
			255,
			0,
			255
		}
	else
		director:set_cursor("cross")
	end
end

function sheet_editor:init(w, h, done_callback)
	self.done_callback = done_callback

	director:set_cursor("cross")

	local sw, sh, scale, origin = SU.clamp_window_aspect(w, h, self.ref_w, self.ref_h)

	self.sw, self.sh = sw, sh

	local window = KWindow:new(V.v(sw, sh))

	window.scale = V.v(scale, scale)
	window.origin = origin
	window.timer = timer
	self.window = window
	GGLabel.static.font_scale = scale
	GGLabel.static.ref_h = self.ref_h

	local sheet = KView:new()
	sheet.zoom_force = 0.1

	function sheet.on_scroll(this, button)
		local mx, my = nil, nil
		if love.keyboard.isDown("lctrl") then
			mx = this.mx
			my = this.my
		end
		if button == "wu" then
			this.scale.x = this.scale.x + this.zoom_force
			this.scale.y = this.scale.y + this.zoom_force
			self.scale.text = (this.scale.x * 100) .. "%"
		elseif this.scale.x > this.zoom_force then
			this.scale.x = this.scale.x - this.zoom_force
			this.scale.y = this.scale.y - this.zoom_force
			self.scale.text = (this.scale.x * 100) .. "%"
		end
		if mx then
			this.pos.x = - mx * this.scale.x + self.cmx
			this.pos.y = - my * this.scale.y + self.cmy
		end
	end

	function sheet.on_click(this, button, x, y)
		if this.can_click then
			add_selector(this, V.v(x, y), V.v(50, 50))
			this.selected:update_info()
		end
	end

	function sheet.deselect(this)
		if this.selected then
			this.selected = nil
			self.code_field:set_value("", true)
			self.pos_field:set_value("", true)
			self.pos_field_2:set_value("", true)
			self.size_field:set_value("", true)
			self.size_field_2:set_value("", true)
			self.e_size_field:set_value("", true)
			self.e_size_field_2:set_value("", true)
			self.trim_field:set_value("", true)
			self.trim_field_2:set_value("", true)
			self.trim_field_3:set_value("", true)
			self.trim_field_4:set_value("", true)
			self.alias_list:clear_rows()
			self.info_label.text = ""
		end
	end

	function sheet.draw(this)
		KView.draw(this)

		if not this.hidden then
			G.push()
			G.setColor({
				255,
				0,
				0,
				255
			})
			G.rectangle("line", -1, -1, this.size.x * this.scale.x + 1, this.size.y * this.scale.y + 1)
			G.pop()
		end
	end

	self.sheet = sheet

	local sprite = KView:new()
	sprite.zoom_force = 0.1
	sprite.hidden = true

	function sprite.on_scroll(this, button)
		local mx, my = nil, nil
		if love.keyboard.isDown("lctrl") then
			mx = this.mx
			my = this.my
		end
		if button == "wu" then
			this.scale.x = this.scale.x + this.zoom_force
			this.scale.y = this.scale.y + this.zoom_force
			self.scale.text = (this.scale.x * 100) .. "%"
		elseif this.scale.x > this.zoom_force then
			this.scale.x = this.scale.x - this.zoom_force
			this.scale.y = this.scale.y - this.zoom_force
			self.scale.text = (this.scale.x * 100) .. "%"
		end
		if mx then
			this.pos.x = - mx * this.scale.x + self.cmx
			this.pos.y = - my * this.scale.y + self.cmy
		end
	end

	function sprite.on_click(this, button, x, y)
		if this.can_click then
			add_selector(this, V.v(x, y), V.v(50, 50))
			this.selected:update_info()
		end
	end

	function sprite.deselect(this)
		if this.selected then
			this.selected = nil
			self.code_field:set_value("", true)
			self.pos_field:set_value("", true)
			self.pos_field_2:set_value("", true)
			self.size_field:set_value("", true)
			self.size_field_2:set_value("", true)
			self.e_size_field:set_value("", true)
			self.e_size_field_2:set_value("", true)
			self.trim_field:set_value("", true)
			self.trim_field_2:set_value("", true)
			self.trim_field_3:set_value("", true)
			self.trim_field_4:set_value("", true)
			self.alias_list:clear_rows()
			self.info_label.text = ""
		end
	end

	function sprite.draw(this)
		KView.draw(this)

		if not this.hidden then
			G.push()
			G.setColor({
				255,
				0,
				0,
				255
			})
			G.rectangle("line", -1, -1, this.size.x * this.scale.x + 1, this.size.y * this.scale.y + 1)
			G.pop()
		end
	end

	self.sprite = sprite

	local puzzle = KView:new()
	puzzle.zoom_force = 0.1

	function puzzle.on_scroll(this, button)
		local mx, my = nil, nil
		if love.keyboard.isDown("lctrl") then
			mx = this.mx
			my = this.my
		end
		if button == "wu" then
			this.scale.x = this.scale.x + this.zoom_force
			this.scale.y = this.scale.y + this.zoom_force
			self.scale.text = (this.scale.x * 100) .. "%"
		elseif this.scale.x > this.zoom_force then
			this.scale.x = this.scale.x - this.zoom_force
			this.scale.y = this.scale.y - this.zoom_force
			self.scale.text = (this.scale.x * 100) .. "%"
		end
		if mx then
			this.pos.x = - mx * this.scale.x + self.cmx
			this.pos.y = - my * this.scale.y + self.cmy
		end
	end

	function puzzle.draw(this)
		KView.draw(this)

		if not this.hidden then
			G.push()
			G.setColor({
				255,
				0,
				0,
				255
			})
			G.rectangle("line", -1, -1, this.size.x * this.scale.x + 1, this.size.y * this.scale.y + 1)
			G.pop()
		end
	end

	self.puzzle = puzzle

	local menu = KView:new(V.v(sw, 100))
	menu.colors.background = {
		150,
		150,
		150,
		255
	}

	local conf = KView:new(V.v(260, sh - menu.size.y))
	conf.pos = V.v(sw - conf.size.x, menu.size.y)
	conf.colors.background = {
		200,
		200,
		200,
		255
	}

	local cont = KView:new(V.v(sw - conf.size.x, sh - menu.size.y))
	cont.pos = V.v(0, menu.size.y)
	cont.colors.background = {
		100,
		100,
		100,
		255
	}

	self.cont = cont

	cont:add_child(sheet)
	cont:add_child(sprite)

	local prev = KView:new(V.vclone(cont.size))
	prev.pos = V.vclone(cont.pos)
	prev.colors.background = {
		100,
		100,
		100,
		255
	}
	prev.hidden = true

	local anim = KLabel:new()
	anim.anchor = V.v(- 15, - 15)
	anim.text_offset = V.v(- 15, - 15)
	anim.text_align = "left"
	anim.font_name = "DroidSansMono"
	anim.font_size = 12

	function anim.set_frame(this, image)
		local d = search_selector(sheet, image)

		if d then
			local data = love.image.newImageData(d.size.x, d.size.y)
			data:paste(sheet.data, 0, 0, d.pos.x, d.pos.y)
			this:set_image(love.graphics.newImage(data))
			this.image:setFilter("nearest", "nearest")
			this.image_offset = V.v(d.trim[1], d.trim[2])
			this.text = image
		else
			this.text = "Not found"
		end
	end

	prev:add_child(anim)
	prev:add_child(puzzle)

	local wind = KLabel:new(V.v(200, 200))
	wind.pos = V.v((sw - wind.size.x) / 2, (sh - wind.size.y) / 2)
	wind.font_name = "DroidSansMono"
	wind.font_size = 12
	wind.can_drag = true
	wind.colors = {
		text = {
			255,
			255,
			255,
			255
		},
		background = {
			10,
			10,
			10,
			255
		}
	}
	wind.hidden = true
	wind.queue = {}

	function wind.show(this, text)
		if this.hidden then
			this.hidden = false
			this.text = text
		else
			table.insert(this.queue, text)
		end
	end

	function wind.on_click(this)
		if this.queue[1] then
			this.text = this.queue[1]
			table.remove(this.queue, 1)
		else
			this.hidden = true
		end
	end

	local gui_data = {
		menu = {
			{
				section = {name = "Main Options", size = 4},
				name = "exit",
				action = function()
					director:set_cursor()
					self.done_callback({
						next_item_name = "map"
					})
				end
			},
			{
				name = "new",
				action = function()
					local x, y = tonumber(self.a_size_field.value), tonumber(self.a_size_field_2.value)
					if x and y then
						sheet.data = love.image.newImageData(x, y)
						sheet:set_image(love.graphics.newImage(sheet.data))
						sheet.image:setFilter("nearest", "nearest")
						sheet:remove_children()
						sheet:deselect()
					else
						wind:show("Incorrect value(s)\nNumber expected")
					end
				end
			},
			{
				name = "open",
				action = function()
					local a_name = self.name_field.value .. self.ext_field.value .. "." .. self.ext_field_2.value
					local fn = self.path_field.value .. "/" .. a_name
					local s = sheet.hidden and sprite or sheet

					local file, error = love.filesystem.load(self.path_field.value .. "/" .. self.name_field.value .. ".lua")
					if file then
						s:remove_children()
						s:deselect()
						local data = file()
						for name, image in pairs(data) do
							add_selector(s, V.v(image.f_quad[1], image.f_quad[2]), V.v(image.f_quad[3], image.f_quad[4]), name, image.a_name, image.size, image.trim, image.a_size, image.alias)
						end
						if s.mode == "select" then
							self.select_mode.set_mode(s)
						end
					else
						wind:show(error)
					end

					if love.filesystem.exists(fn) then
						s.data = love.image.newImageData(fn)
						s:set_image(love.graphics.newImage(s.data))
						s.image:setFilter("nearest", "nearest")
						self.a_size_field:set_value(s.size.x)
						self.a_size_field_2:set_value(s.size.y)
						local no_pixel = false
						for x = 0, 2 do
							for y = 0, 2 do
								local r, g, b, a = s.data:getPixel(x, y)
								if r ~= 255 or g ~= 255 or b ~= 255 or a ~= 255 then
									no_pixel = true
									break
								end
							end
							if no_pixel then
								break
							end
						end
						if no_pixel then
							self.pixel_field.checked = false
							self.pixel_field.text = ""
						else
							self.pixel_field.checked = true
							self.pixel_field.text = "X"
						end
						for i, c in ipairs(s.children) do
							c.hidden = c.a_name ~= a_name
						end
					else
						wind:show("Image not found or invalid")
					end
				end
			},
			{
				name = "save",
				action = function()
					local a_name = self.name_field.value .. self.ext_field.value .. "." .. self.ext_field_2.value
					local fn = self.name_field.value .. ".lua"
					local len = #sheet.children

					local out = "-- chunkname: @./" .. self.path_field.value .. "/" .. self.name_field.value .. ".lua\n\nreturn {"
					love.filesystem.write(fn, out)
					out = ""
					local n = 0
					for i = 1, len do
						local d = sheet.children[i]
						if not d.hidden then
							d.a_name = a_name
							d.a_size = {sheet.size.x, sheet.size.y}
						end

						out = out .. img_data_to_string(
							d.code_name and "[\"" .. d.code_name .. "\"]" or "[" .. i .."]",
							d.a_name or "",
							d.e_size or {d.size.x, d.size.y},
							d.trim,
							d.a_size or {0, 0},
							{
								d.pos.x,
								d.pos.y,
								d.size.x,
								d.size.y
							},
							d.alias
						)
						if i < len then
							out = out .. ","
						end
						n = n + 1
						if n > 50 then
							n = 0
							love.filesystem.append(fn, out)
							out = ""
						end
					end
					out = out .. "\n}\n"

					love.filesystem.append(fn, out)
					sheet.data:encode(self.ext_field_2.value, a_name)
				end
			},
			{
				section = {name = "Switch", size = 1},
				name = "sheet",
				action = function(this)
					if sheet.hidden then
						sheet.hidden = false
						sprite.hidden = true

						self.new_button:enable()
						self.erase_button:enable()
						self.delete_button:enable()
						self.pixel_field:enable()
						self.scale.text = (sheet.scale.x * 100) .. "%"
						sprite.path_value = self.path_field.value
						sprite.name_value = self.name_field.value
						sprite.sufix_value = self.ext_field.value
						sprite.ext_value = self.ext_field_2.value
						self.path_field:set_value(sheet.path_value or "", true)
						self.name_field:set_value(sheet.name_value or "", true)
						self.ext_field:set_value(sheet.sufix_value or "", true)
						self.ext_field_2:set_value(sheet.ext_value or "", true)
						self.a_size_field:set_value(sheet.size.x, true)
						self.a_size_field_2:set_value(sheet.size.y, true)
						if sheet.selected then
							sheet.selected:update_info()
						end
						self:set_mode(sheet.mode, true)
						this.text = "SHEET"
					else
						sheet.hidden = true
						sprite.hidden = false

						self.new_button:disable()
						self.erase_button:disable()
						self.delete_button:disable()
						self.pixel_field:disable()
						self.scale.text = (sprite.scale.x * 100) .. "%"
						sheet.path_value = self.path_field.value
						sheet.name_value = self.name_field.value
						sheet.sufix_value = self.ext_field.value
						sheet.ext_value = self.ext_field_2.value
						self.path_field:set_value(sprite.path_value or "", true)
						self.name_field:set_value(sprite.name_value or "", true)
						self.ext_field:set_value(sprite.sufix_value or "", true)
						self.ext_field_2:set_value(sprite.ext_value or "", true)
						self.a_size_field:set_value(sprite.size.x, true)
						self.a_size_field_2:set_value(sprite.size.y, true)
						if sprite.selected then
							sprite.selected:update_info()
						end
						self:set_mode(sprite.mode, true)
						this.text = "SPRITE"
					end
				end
			},
			{
				section = {name = "Mode", size = 5},
				name = "move",
				set_mode = function(s)
					s.can_drag = true
					director:set_cursor()
				end,
				unset_mode = function(s)
					s.can_drag = false
				end
			},
			{
				name = "select",
				set_mode = function(s)
					for i, c in ipairs(s.children) do
						c.can_drag = true
					end
					director:set_cursor()
				end,
				unset_mode = function(s)
					for i, c in ipairs(s.children) do
						c.can_drag = false
					end
				end
			},
			{
				name = "pick",
				set_mode = function(s)
					s.can_pick = true
					director:set_cursor("cross")
				end,
				unset_mode = function(s)
					s.can_pick = false
				end
			},
			{
				name = "draw",
				set_mode = function(s)
					s.can_paint = true
					director:set_cursor("cross")
				end,
				unset_mode = function(s)
					s.can_paint = false
				end
			},
			{
				section = {name = "Selector Options", size = 5, sub = true},
				name = "add",
				set_mode = function(s)
					s.can_click = true
					director:set_cursor("cross")
				end,
				unset_mode = function(s)
					s.can_click = false
				end
			},
			{
				name = "remove",
				action = function(this)
					local s = sheet.hidden and sprite or sheet
					if s.selected then
						s:remove_child(s.selected)
						s.selected = nil
					end
				end
			},
			{
				section = {name = "Image Options", size = 4},
				name = "copy",
				action = function(this)
					local s = sheet.hidden and sprite or sheet
					if s.selected then
						sheet.copy = {data = love.image.newImageData(s.selected.size.x, s.selected.size.y)}
						sheet.copy.data:paste(s.data, 0, 0, s.selected.pos.x, s.selected.pos.y)
						sheet.copy.pos = V.v(0, 0)
						sheet.copy.size = V.vclone(s.selected.size)
						sheet.copy.code_name = s.selected.code_name
						sheet.copy.e_size = s.selected.e_size and {s.selected.e_size[1], s.selected.e_size[2]}
						sheet.copy.trim = {s.selected.trim[1], s.selected.trim[2], s.selected.trim[3], s.selected.trim[4]}
						sheet.copy.alias = s.selected.alias table.clone(s.selected.alias)
					end
				end
			},
			{
				name = "paste",
				action = function(this)
					local copy = sprite.selected or sheet.copy
					if copy and sheet.selected then
						sheet.data:paste(sprite.selected and sprite.data or copy.data, sheet.selected.pos.x, sheet.selected.pos.y, copy.pos.x, copy.pos.y, copy.size.x, copy.size.y)
						sheet:set_image(love.graphics.newImage(sheet.data))
						sheet.image:setFilter("nearest", "nearest")
						sheet.selected.size = V.vclone(copy.size)
						sheet.selected.code_name = copy.code_name
						sheet.selected.e_size = copy.e_size and {copy.e_size[1], copy.e_size[2]}
						sheet.selected.trim = {copy.trim[1], copy.trim[2], copy.trim[3], copy.trim[4]}
						sheet.selected.alias = copy.alias and table.clone(copy.alias)
						if sprite.hidden then
							sheet.selected:update_info()
						end
					end
				end
			},
			{
				name = "delete",
				action = function(this)
					self.erase_button:on_click()
					self.remove_button:on_click()
				end
			},
			{
				name = "erase",
				action = function(this)
					if sheet.selected then
						local px = sheet.selected.pos.x
						local py = sheet.selected.pos.y
						local sx = sheet.selected.size.x + px
						local sy = sheet.selected.size.y + py
						sheet.data:mapPixel(function(x, y, r, g, b, a)
							if px <= x and x < sx and py <= y and y < sy then
								return 0, 0, 0, 0
							else
								return r, g, b, a
							end
						end)
						sheet:set_image(love.graphics.newImage(sheet.data))
						sheet.image:setFilter("nearest", "nearest")
					end
				end
			},
			{
				name = "preview",
				action = function(this)
					this.checked = not this.checked
					if this.checked then
						prev.hidden = false
						if sheet.selected then
							local len = tonumber(string.sub(sheet.selected.code_name, -4, -1))
							if len then
								local prefix = string.sub(sheet.selected.code_name, 1, -6)
								anim.scale = sheet.scale
								for i = 1, len do
									timer:after(i*0.1, function()
										anim:set_frame(string.format("%s_%04i", prefix, i))
									end)
								end
							end
						end
					else
						prev.hidden = true
					end
				end
			},
			{
				name = "puzzle",
				action = function(this)
					this.checked = not this.checked
					if this.checked then
						prev.hidden = false
						puzzle.pos = V.v(0, 0)
						puzzle.size = V.vclone(sheet.size)
						for i, s in ipairs(sheet.children) do
							add_selector(puzzle, V.vclone(s.pos), V.vclone(s.size))
							puzzle.selected.hidden = s.hidden
							puzzle.selected.on_click = nil
							puzzle.selected.update_info = nil
							puzzle.selected.can_drag = true
						end
						puzzle.selected = nil
					else
						local data = love.image.newImageData(sheet.size.x, sheet.size.y)
						for i, s in ipairs(sheet.children) do
							if not s.hidden then
								local x, y = puzzle.children[i].pos.x, puzzle.children[i].pos.y
								data:paste(sheet.data, x, y, s.pos.x, s.pos.y, s.size.x, s.size.y)
								s.pos.x, s.pos.y = x, y
							end
						end
						sheet.data = data
						if self.pixel_field.checked then
							self.pixel_field.checked = false
							self.pixel_field:on_click()
						end
						sheet:set_image(love.graphics.newImage(sheet.data))
						sheet.image:setFilter("nearest", "nearest")

						prev.hidden = true
						puzzle:remove_children()
					end
				end
			}
		},
		conf = {
			{name = "path", label = "Path of the folder"},
			{name = "name", label = "Name of the image (a_name prefix)",
				action = function(this)
					local s = sheet.hidden and sprite or sheet
					if s.selected then
						s.selected:update_info(true)
					end
				end
			},
			{name = "ext", label = "Sufix and extension of the image", cut = 2,
				action = function(this)
					local s = sheet.hidden and sprite or sheet
					if s.selected then
						s.selected:update_info(true)
					end
				end,
				action_2 = function(this)
					local s = sheet.hidden and sprite or sheet
					if s.selected then
						s.selected:update_info(true)
					end
				end
			},
			{name = "a_size", label = "Size of the image (a_size)", cut = 2,
				end_action = function()
					local x, y = tonumber(self.a_size_field.value), tonumber(self.a_size_field_2.value)
					if x and y then
						if sheet.data then
							local data = love.image.newImageData(x, y)
							data:paste(sheet.data, 0, 0)
							sheet.data = data
							sheet:set_image(love.graphics.newImage(sheet.data))
							sheet.image:setFilter("nearest", "nearest")
						else
							wind:show("No Sprite Sheet yet\nUse New or Open buttons")
						end
					else
						wind:show("Incorrect value(s)\nNumber expected")
					end
				end
			},
			{name = "pixel", label = "Sheet contains Entities",
				check_action = function(this)
					if sheet.data then
						this.checked = not this.checked
						if this.checked then
							this.text = "X"
							sheet.data:mapPixel(function(x, y, r, g, b, a)
								if x < 3 and y < 3 then
									return 255, 255, 255, 255
								else
									return r, g, b, a
								end
							end)
						else
							this.text = ""
							sheet.data:mapPixel(function(x, y, r, g, b, a)
								if x < 3 and y < 3 then
									return 0, 0, 0, 0
								else
									return r, g, b, a
								end
							end)
						end

						sheet:set_image(love.graphics.newImage(sheet.data))
						sheet.image:setFilter("nearest", "nearest")
					else
						wind:show("No Sprite Sheet yet\nUse New or Open buttons")
					end
				end
			},
			{name = "code", label = "Name of the selector (sprite)",
				action = function(this)
					local s = sheet.hidden and sprite or sheet
					if s.selected then
						s.selected.code_name = this.value
						s.selected:update_info(true)
					end
				end
			},
			{name = "pos", label = "Pos of the selector (quad 1 and 2)", cut = 2,
				action = function(this)
					local s = sheet.hidden and sprite or sheet
					local n = tonumber(this.value)
					if s.selected and n then
						s.selected.pos.x = n
						s.selected:update_info(true)
					end
				end,
				action_2 = function(this)
					local s = sheet.hidden and sprite or sheet
					local n = tonumber(this.value)
					if s.selected and n then
						s.selected.pos.y = n
						s.selected:update_info(true)
					end
				end
			},
			{name = "size", label = "Size of the selector (quad 3 and 4)", cut = 2,
				action = function(this)
					local s = sheet.hidden and sprite or sheet
					local n = tonumber(this.value)
					if s.selected and n then
						s.selected.size.x = n
						s.selected:update_info(true)
					end
				end,
				action_2 = function(this)
					local s = sheet.hidden and sprite or sheet
					local n = tonumber(this.value)
					if s.selected and n then
						s.selected.size.y = n
						s.selected:update_info(true)
					end
				end
			},
			{name = "e_size", label = "Virtual size (size)", cut = 2,
				action = function(this)
					local s = sheet.hidden and sprite or sheet
					local n = tonumber(this.value)
					if s.selected then
						if n then
							if s.selected.e_size then
								s.selected.e_size[1] = n
							else
								s.selected.e_size = {n, s.selected.size.y}
								self.e_size_field_2:set_value(s.selected.e_size[2] or "", true)
							end
						elseif s.selected.e_size and (s.selected.e_size[2] == s.selected.size.y or not tonumber(self.e_size_field_2.value)) then
							s.selected.e_size = nil
							self.e_size_field_2:set_value("", true)
						end
						s.selected:update_info(true)
					end
				end,
				action_2 = function(this)
					local s = sheet.hidden and sprite or sheet
					local n = tonumber(this.value)
					if s.selected then
						if n then
							if s.selected.e_size then
								s.selected.e_size[2] = n
							else
								s.selected.e_size = {s.selected.size.x, n}
								self.e_size_field:set_value(s.selected.e_size[1] or "", true)
							end
						elseif s.selected.e_size and (s.selected.e_size[1] == s.selected.size.x or not tonumber(self.e_size_field.value)) then
							s.selected.e_size = nil
							self.e_size_field:set_value("", true)
						end
						s.selected:update_info(true)
					end
				end
			},
			{name = "trim", label = "Virtual offset (trim)", cut = 4,
				action = function(this)
					local s = sheet.hidden and sprite or sheet
					local n = tonumber(this.value)
					if s.selected and n then
						s.selected.trim[1] = n
						s.selected:update_info(true)
					end
				end,
				action_2 = function(this)
					local s = sheet.hidden and sprite or sheet
					local n = tonumber(this.value)
					if s.selected and n then
						s.selected.trim[2] = n
						s.selected:update_info(true)
					end
				end,
				action_3 = function(this)
					local s = sheet.hidden and sprite or sheet
					local n = tonumber(this.value)
					if s.selected and n then
						s.selected.trim[3] = n
						s.selected:update_info(true)
					end
				end,
				action_4 = function(this)
					local s = sheet.hidden and sprite or sheet
					local n = tonumber(this.value)
					if s.selected and n then
						s.selected.trim[4] = n
						s.selected:update_info(true)
					end
				end
			},
			{name = "alias", label = "Copies names (alias)",
				end_action = function(this)
					if sheet.selected then
						if sheet.selected.alias then
							table.insert(sheet.selected.alias, this.value)
						else
							sheet.selected.alias = {this.value}
						end
						self.alias_list:add_alias(this.value)
					end
				end
			}
		}
	}

	for i, d in ipairs(gui_data.menu) do
		local b = KLabel:new(V.v(50, 50))
		b.pos = V.v(25 + 75 * (i - 1), 25)
		b.text_offset = V.v(0, 16)
		b.text = _(d.name:upper())
		b.font_name = "DroidSansMono"
		b.font_size = 14
		b.colors.background = {
			200,
			200,
			200,
			255
		}

		if d.set_mode then
			b.set_mode = d.set_mode
			b.unset_mode = d.unset_mode
			b.on_click = d.action or function()
				self:set_mode(self.mode ~= d.name and d.name)
			end
			self[d.name .. "_mode"] = b
		else
			b.on_click = d.action
			self[d.name .. "_button"] = b
		end

		if d.section then
			local t = KLabel:new(V.v(50 + 75 * (d.section.size - 1), 70))
			if d.section.sub then
				t.pos = V.v(b.pos.x, b.pos.y)
				t.text_offset = V.v(0, 55)
				t.colors.background = {
					200,
					150,
					150,
					255
				}
			else
				t.pos = V.v(b.pos.x, 5)
				t.colors.background = {
					150,
					200,
					200,
					255
				}
			end
			t.text = _(d.section.name)
			t.font_name = "DroidSansMono"
			t.font_size = 12

			menu:add_child(t)
		end

		menu:add_child(b)
	end

	for i, d in ipairs(gui_data.conf) do
		local p = 50 * (i - 1)

		local l = KLabel:new(V.v(conf.size.x, 12))
		l.pos = V.v(10, 10 + p)
		l.text = d.label
		l.text_align = "left"
		l.font_name = "DroidSansMono"
		l.font_size = 12

		conf:add_child(l)

		local num = d.cut or 1
		local size = (conf.size.x - 20) / num - (num - 1) * (10 / num)
		for n = 1, num do
			local f = nil
			if d.check_action then
				f = KButton:new(V.v(20, 20))
				f.text_offset = V.v(6, 3)
				f.on_click = d.check_action
			else
				f = KField:new(V.v(size, 20))
				f.colors.focused_outline = {
					255,
					255,
					0,
					255
				}
				f.on_change = n > 1 and d["action_" .. n] or d.action
				f.on_done = d.end_action
			end
			f.pos = V.v(10 + (size + 10) * (n - 1), 26 + p)
			f.text_align = "left"
			f.font_name = "DroidSansMono"
			f.font_size = 12
			f.colors.text = {
				255,
				255,
				255,
				255
			}
			f.colors.background = {
				88,
				57,
				39,
				100
			}

			self[n > 1 and (d.name .. "_field_" .. n) or (d.name .. "_field")] = f

			conf:add_child(f)
		end
	end

	local alias_list = KScrollList:new(V.v(conf.size.x - 20, 150))
	alias_list.pos = V.v(10, self.alias_field.pos.y + 25)

	function alias_list.add_alias(this, alias)
		local row = KLabel:new(V.v(this.size.x - 10, 15))
		row.pos.x = 10
		row.text = alias
		row.font_name = "DroidSansMono"
		row.font_size = 12

		local remove = KButton:new(V.v(10, 10))
		remove.text = "-"
		remove.font_name = "DroidSansMono"
		remove.font_size = 12

		function remove.on_click()
			table.remove(sheet.selected.alias, row:get_order())
			this:remove_child(row)
		end

		row:add_child(remove)

		this:add_row(row)
	end

	conf:add_child(alias_list)

	self.alias_list = alias_list

	local info_label = KLabel:new(V.v(conf.size.x - 20, 15))
	info_label.pos = V.v(10, 10)
	info_label.text_align = "left"
	info_label.font_name = "DroidSansMono"
	info_label.font_size = 12
	info_label.hidden = true

	self.info_label = info_label

	local nerd = KLabel:new(V.v(30, 15))
	nerd.pos = V.v(10, alias_list.pos.y + alias_list.size.y + 10)
	nerd.text = "Nerd"
	nerd.text_align = "left"
	nerd.font_name = "DroidSansMono"
	nerd.font_size = 12

	function nerd.on_click(this)
		local h = info_label.hidden
		for i, c in ipairs(conf.children) do
			c.hidden = h
		end
		info_label.hidden = not h
		this.hidden = false
	end

	conf:add_child(info_label)
	conf:add_child(nerd)

	local scale = KLabel:new(V.v(40, 15))
	scale.pos = V.v(menu.size.x - scale.size.x, menu.size.y - scale.size.y)
	scale.text_align = "left"
	scale.font_name = "DroidSansMono"
	scale.font_size = 12

	menu:add_child(scale)

	self.scale = scale

	local mouse_pos = KLabel:new(V.v(150, 15))
	mouse_pos.pos = V.v(scale.pos.x - mouse_pos.size.x, scale.pos.y)
	mouse_pos.text_align = "left"
	mouse_pos.font_name = "DroidSansMono"
	mouse_pos.font_size = 12

	menu:add_child(mouse_pos)

	self.mouse_pos = mouse_pos

	local bg_color = nil
	for i = 1, 3 do
		bg_color = KField:new(V.v(28, 15))
		bg_color.pos = V.v(mouse_pos.pos.x - (bg_color.size.x + 10) * i, scale.pos.y)
		bg_color.text_align = "left"
		bg_color.font_name = "DroidSansMono"
		bg_color.font_size = 12
		bg_color.colors = {
			text = {
				255,
				255,
				255,
				255
			},
			background = {
				0,
				0,
				0,
				255
			},
			focused_outline = {
				255,
				255,
				0,
				255
			}
		}

		menu:add_child(bg_color)

		function bg_color.on_change(this)
			local n = tonumber(this.value)
			if n and n >= 0 and n <= 255 then
				cont.colors.background[i] = n
			end
		end

		bg_color:set_value(cont.colors.background[i], true)
	end

	local reset = KLabel:new(V.v(35, 15))
	reset.pos = V.v(bg_color.pos.x - reset.size.x - 10, scale.pos.y)
	reset.text = "reset"
	reset.text_align = "left"
	reset.font_name = "DroidSansMono"
	reset.font_size = 12

	function reset.on_click()
		local s = sheet.hidden and sprite or sheet
		s.pos = V.v(0, 0)
		s.scale = V.v(1, 1)
		scale.text = (s.scale.x * 100) .. "%"
	end

	menu:add_child(reset)

	local search = KField:new(V.v(240, 15))
	search.pos = V.v(reset.pos.x - search.size.x - 10, scale.pos.y)
	search.text_align = "left"
	search.font_name = "DroidSansMono"
	search.font_size = 12
	search.colors = {
		text = {
			255,
			255,
			255,
			255
		},
		background = {
			0,
			0,
			0,
			255
		},
		focused_outline = {
			255,
			255,
			0,
			255
		}
	}

	menu:add_child(search)

	function search.on_change(this)
		local s = sheet.hidden and sprite or sheet
		local n = tonumber(this.value)
		local d = n and s.children[n] or search_selector(s, this.value)

		if d then
			if d.hidden then
				wind:show("From " .. d.a_name)
			else
				s.pos.x = - (d.pos.x + d.size.x / 2) * s.scale.x + cont.size.x / 2
				s.pos.y = - (d.pos.y + d.size.y / 2) * s.scale.y + cont.size.y / 2
				if s.selected ~= d then
					s.selected = d
					d:update_info()
				end
			end
		end
	end

	self.pixel_color = {
		255,
		0,
		0,
		255
	}

	local pixel_color = nil
	for i, color in ipairs(self.pixel_color) do
		pixel_color = KField:new(V.v(28, 15))
		pixel_color.pos = V.v(search.pos.x - (pixel_color.size.x + 10) * i, scale.pos.y)
		pixel_color.text_align = "left"
		pixel_color.font_name = "DroidSansMono"
		pixel_color.font_size = 12
		pixel_color.colors = {
			text = {
				255,
				255,
				255,
				255
			},
			background = {
				0,
				0,
				0,
				255
			},
			focused_outline = {
				255,
				255,
				0,
				255
			}
		}

		menu:add_child(pixel_color)

		function pixel_color.on_change(this)
			local n = tonumber(this.value)
			if n and n >= 0 and n <= 255 then
				self.pixel_color[i] = n
			end
		end

		pixel_color:set_value(color, true)

		self["pixel_color_" .. i] = pixel_color
	end

	window:add_child(cont)
	window:add_child(prev)
	window:add_child(menu)
	window:add_child(conf)
	window:add_child(wind)
end

function sheet_editor:destroy()
	timer:clear()

	self.window.timer = nil

	self.window:destroy()

	self.window = nil

	SU.remove_references(self, KView)
end

function sheet_editor:update(dt)
	self.window:update(dt)
	timer:update(dt)

	local mx, my, any_button_down = self.window:get_mouse_position()
	local v = self.sheet.hidden and self.sprite or self.sheet

	local wx, wy = v:screen_to_view(mx, my)
	v.mx, v.my = wx, wy
	self.cmx, self.cmy = self.cont:screen_to_view(mx, my)
	self.mouse_pos.text = "x : " .. wx .. " y : " .. wy

	local s = v.selected
	if any_button_down then
		if s and s.can_drag then
			local wx, wy = s:screen_to_view(mx, my)

			if V.is_inside(V.v(wx, wy), V.r(s.size.x, 0, 5, s.size.y)) then
				s.size.x = wx - 2
				s:update_info()
			elseif V.is_inside(V.v(wx, wy), V.r(0, s.size.y, s.size.x, 5)) then
				s.size.y = wy - 2
				s:update_info()
			end
		elseif v.can_pick and v.data and V.is_inside(V.v(wx, wy), V.r(0, 0, v.size.x, v.size.y)) then
			local r, g, b, a = v.data:getPixel(wx, wy)
			self.pixel_color_1:set_value(r)
			self.pixel_color_2:set_value(g)
			self.pixel_color_3:set_value(b)
			self.pixel_color_4:set_value(a)
		elseif v.can_paint and v.data and V.is_inside(V.v(wx, wy), V.r(0, 0, v.size.x, v.size.y)) then
			v.data:setPixel(wx, wy, self.pixel_color[1], self.pixel_color[2], self.pixel_color[3], self.pixel_color[4])
			v:set_image(love.graphics.newImage(v.data))
			v.image:setFilter("nearest", "nearest")
		end
	end
end

function sheet_editor:draw()
	self.window:draw()
end

function sheet_editor:keypressed(key, isrepeat)
	if self.window.responder then
		self.window.responder:on_keypressed(key)
	end
end

function sheet_editor:keyreleased(key)
	return
end

function sheet_editor:mousepressed(x, y, button)
	self.window:mousepressed(x, y, button)
end

function sheet_editor:mousereleased(x, y, button)
	self.window:mousereleased(x, y, button)
end

function sheet_editor:textinput(t)
	self.window:textinput(t)
end

function sheet_editor:wheelmoved(dx, dy)
	self.window:wheelmoved(dx, dy)
end

return sheet_editor
