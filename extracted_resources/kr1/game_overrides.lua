-- chunkname: @./kr1/game_overrides.lua

local E = require("entity_db")
local i18n = require("i18n")

function KWindow:set_responder(v)
	local c = self.responder

	if c then
		self.responder = nil

		if c.on_responded then
			c:on_responded()
		end
	end

	if v then
		self.responder = v

		if v.on_respond then
			v:on_respond()
		end
	end
end

function E:patch_templates(balance)
	self.balance = {}
	if balance then
		self:balance_templates(require("balance." .. balance))
	end
end

function E:balance_templates(balance)
	if balance then
		for name, template in pairs(self.entities) do
			if balance[name] then
				if not self.balance[name] then
					self.balance[name] = table.deepclone(template)
				end
				table.deepmerge(template, balance[name])
			end
		end
	else
		table.deepmerge(self.entities, self.balance)
	end
end

function i18n:ft(name, ...)
	self.msgs[self.current_locale][name] = string.format(self.msgs[self.current_locale][name], ...)
end

function i18n:patch_strings()
	package.loaded["strings." .. self.current_locale] = nil

	for n, s in pairs(require("strings." .. self.current_locale)) do
		self.msgs[self.current_locale][n] = string.gsub(s, "%%{(.-)}", function(f)
			local t = E.entities
			for k in string.gmatch(f, "[%w_]+") do
				k = tonumber(k) or k
				if t[k] then
					t = t[k]
				else
					t = ""
					break
				end
			end
			return t
		end)
	end

	local tt = E:get_template("mod_ranger_poison")
	self:ft("TOWER_RANGERS_POISON_DESCRIPTION", tt.dps.damage_max + tt.dps.damage_inc)
	self:ft("TOWER_RANGERS_POISON_DESCRIPTION_1", tt.dps.damage_max + tt.dps.damage_inc)
	self:ft("TOWER_RANGERS_POISON_DESCRIPTION_2", tt.dps.damage_max + tt.dps.damage_inc * 2)
	self:ft("TOWER_RANGERS_POISON_DESCRIPTION_3", tt.dps.damage_max + tt.dps.damage_inc * 3)
	tt = E:get_template("aura_ranger_thorn")
	local tt2 = E:get_template("mod_thorn")
	self:ft("TOWER_RANGERS_THORNS_DESCRIPTION", tt.aura.max_count + tt.aura.max_count_inc, tt2.modifier.duration + tt2.modifier.duration_inc, math.ceil(tt.aura.cooldown * 1))
	self:ft("TOWER_RANGERS_THORNS_DESCRIPTION_1", tt.aura.max_count + tt.aura.max_count_inc, tt2.modifier.duration + tt2.modifier.duration_inc, math.ceil(tt.aura.cooldown * 1))
	self:ft("TOWER_RANGERS_THORNS_DESCRIPTION_2", tt.aura.max_count + tt.aura.max_count_inc * 2, tt2.modifier.duration + tt2.modifier.duration_inc * 2)
	self:ft("TOWER_RANGERS_THORNS_DESCRIPTION_3", tt.aura.max_count + tt.aura.max_count_inc * 3, tt2.modifier.duration + tt2.modifier.duration_inc * 3)

	tt = E:get_template("tower_bfg")
	tt2 = E:get_template("missile_bfg")
	self:ft("TOWER_BFG_MISSILE_DESCRIPTION", tt2.bullet.damage_min + tt.powers.missile.damage_inc, tt2.bullet.damage_max + tt.powers.missile.damage_inc, math.floor(tt.attacks.list[2].cooldown * 1))
	self:ft("TOWER_BFG_MISSILE_DESCRIPTION_1", tt2.bullet.damage_min + tt.powers.missile.damage_inc, tt2.bullet.damage_max + tt.powers.missile.damage_inc, math.floor(tt.attacks.list[2].cooldown * 1))
	self:ft("TOWER_BFG_MISSILE_DESCRIPTION_2", tt2.bullet.damage_min + tt.powers.missile.damage_inc * 2, tt2.bullet.damage_max + tt.powers.missile.damage_inc * 2, tt.powers.missile.range_inc_factor * 100)
	self:ft("TOWER_BFG_MISSILE_DESCRIPTION_3", tt2.bullet.damage_min + tt.powers.missile.damage_inc * 3, tt2.bullet.damage_max + tt.powers.missile.damage_inc * 3, tt.powers.missile.range_inc_factor * 100)
	self:ft("TOWER_BFG_CLUSTER_DESCRIPTION", tt.powers.cluster.fragment_count_base + tt.powers.cluster.fragment_count_inc)
	self:ft("TOWER_BFG_CLUSTER_DESCRIPTION_1", tt.powers.cluster.fragment_count_base + tt.powers.cluster.fragment_count_inc)
	self:ft("TOWER_BFG_CLUSTER_DESCRIPTION_2", tt.powers.cluster.fragment_count_base + tt.powers.cluster.fragment_count_inc * 2)
	self:ft("TOWER_BFG_CLUSTER_DESCRIPTION_3", tt.powers.cluster.fragment_count_base + tt.powers.cluster.fragment_count_inc * 3)

	tt = E:get_template("tower_arcane_wizard")
	self:ft("TOWER_ARCANE_TELEPORT_DESCRIPTION", tt.powers.teleport.max_count_base + tt.powers.teleport.max_count_inc)
	self:ft("TOWER_ARCANE_TELEPORT_DESCRIPTION_1", tt.powers.teleport.max_count_base + tt.powers.teleport.max_count_inc)
	self:ft("TOWER_ARCANE_TELEPORT_DESCRIPTION_2", tt.powers.teleport.max_count_base + tt.powers.teleport.max_count_inc * 2)
	self:ft("TOWER_ARCANE_TELEPORT_DESCRIPTION_3", tt.powers.teleport.max_count_base + tt.powers.teleport.max_count_inc * 3)
	self:ft("TOWER_ARCANE_DESINTEGRATE_DESCRIPTION", tt.powers.disintegrate.cooldown_base + tt.powers.disintegrate.cooldown_inc)
	self:ft("TOWER_ARCANE_DESINTEGRATE_DESCRIPTION_1", tt.powers.disintegrate.cooldown_base + tt.powers.disintegrate.cooldown_inc)
	self:ft("TOWER_ARCANE_DESINTEGRATE_DESCRIPTION_2", tt.powers.disintegrate.cooldown_base + tt.powers.disintegrate.cooldown_inc * 2)
	self:ft("TOWER_ARCANE_DESINTEGRATE_DESCRIPTION_3", tt.powers.disintegrate.cooldown_base + tt.powers.disintegrate.cooldown_inc * 3)

	tt = E:get_template("soldier_paladin")
	self:ft("TOWER_PALADINS_HOLY_STRIKE_DESCRIPTION", tt.melee.attacks[3].chance * 100, tt.melee.attacks[3].damage_min + tt.melee.attacks[3].damage_min_inc, tt.melee.attacks[3].damage_max + tt.melee.attacks[3].damage_max_inc)
	self:ft("TOWER_PALADINS_HOLY_STRIKE_DESCRIPTION_1", tt.melee.attacks[3].chance * 100, tt.melee.attacks[3].damage_min + tt.melee.attacks[3].damage_min_inc, tt.melee.attacks[3].damage_max + tt.melee.attacks[3].damage_max_inc)
	self:ft("TOWER_PALADINS_HOLY_STRIKE_DESCRIPTION_2", tt.melee.attacks[3].damage_min + tt.melee.attacks[3].damage_min_inc * 2, tt.melee.attacks[3].damage_max + tt.melee.attacks[3].damage_max_inc * 2)
	self:ft("TOWER_PALADINS_HOLY_STRIKE_DESCRIPTION_3", tt.melee.attacks[3].damage_min + tt.melee.attacks[3].damage_min_inc * 3, tt.melee.attacks[3].damage_max + tt.melee.attacks[3].damage_max_inc * 3)
	self:ft("TOWER_PALADINS_SHIELD_DESCRIPTION", tt.health.armor_inc * 100)
	self:ft("TOWER_PALADINS_SHIELD_DESCRIPTION_1", tt.health.armor_inc * 100)
	tt = E:get_template("mod_healing_paladin")
	self:ft("TOWER_PALADINS_HEALING_DESCRIPTION", tt.hps.heal_min + tt.hps.heal_min_inc, tt.hps.heal_max + tt.hps.heal_max_inc)
	self:ft("TOWER_PALADINS_HEALING_DESCRIPTION_1", tt.hps.heal_min + tt.hps.heal_min_inc, tt.hps.heal_max + tt.hps.heal_max_inc)
	self:ft("TOWER_PALADINS_HEALING_DESCRIPTION_2", tt.hps.heal_min + tt.hps.heal_min_inc * 2, tt.hps.heal_max + tt.hps.heal_max_inc * 2)
	self:ft("TOWER_PALADINS_HEALING_DESCRIPTION_3", tt.hps.heal_min + tt.hps.heal_min_inc * 3, tt.hps.heal_max + tt.hps.heal_max_inc * 3)

	tt = E:get_template("aura_tesla_overcharge")
	self:ft("TOWER_TESLA_OVERCHARGE_DESCRIPTION", tt.aura.damage_min + tt.aura.damage_inc, tt.aura.damage_max + tt.aura.damage_inc)
	self:ft("TOWER_TESLA_OVERCHARGE_DESCRIPTION_1", tt.aura.damage_min + tt.aura.damage_inc, tt.aura.damage_max + tt.aura.damage_inc)
	self:ft("TOWER_TESLA_OVERCHARGE_DESCRIPTION_2", tt.aura.damage_min + tt.aura.damage_inc * 2, tt.aura.damage_max + tt.aura.damage_inc * 2)
	self:ft("TOWER_TESLA_OVERCHARGE_DESCRIPTION_3", tt.aura.damage_min + tt.aura.damage_inc * 3, tt.aura.damage_max + tt.aura.damage_inc * 3)

	tt = E:get_template("soldier_barbarian")
	tt2 = E:get_template("axe_barbarian")
	self:ft("TOWER_BARBARIANS_THROWING_AXES_DESCRIPTION", tt2.bullet.damage_min + tt2.bullet.damage_inc, tt2.bullet.damage_max + tt2.bullet.damage_inc, math.floor(tt.ranged.attacks[1].cooldown * 1))
	self:ft("TOWER_BARBARIANS_THROWING_AXES_DESCRIPTION_1", tt2.bullet.damage_min + tt2.bullet.damage_inc, tt2.bullet.damage_max + tt2.bullet.damage_inc, math.floor(tt.ranged.attacks[1].cooldown * 1))
	self:ft("TOWER_BARBARIANS_THROWING_AXES_DESCRIPTION_2", math.ceil(tt.ranged.attacks[1].range_inc / math.ceil((tt.ranged.attacks[1].max_range + tt.ranged.attacks[1].range_inc) / 100)), tt2.bullet.damage_min + tt2.bullet.damage_inc * 2, tt2.bullet.damage_max + tt2.bullet.damage_inc * 2)
	self:ft("TOWER_BARBARIANS_THROWING_AXES_DESCRIPTION_3", math.ceil(tt.ranged.attacks[1].range_inc / math.ceil((tt.ranged.attacks[1].max_range + tt.ranged.attacks[1].range_inc) / 100)), tt2.bullet.damage_min + tt2.bullet.damage_inc * 3, tt2.bullet.damage_max + tt2.bullet.damage_inc * 3)
	self:ft("TOWER_BARBARIANS_TWISTER_DESCRIPTION", (tt.melee.attacks[2].chance + tt.melee.attacks[2].chance_inc) * 100, tt.melee.attacks[2].damage_min + tt.melee.attacks[2].damage_inc, tt.melee.attacks[2].damage_max + tt.melee.attacks[2].damage_inc)
	self:ft("TOWER_BARBARIANS_TWISTER_DESCRIPTION_1", (tt.melee.attacks[2].chance + tt.melee.attacks[2].chance_inc) * 100, tt.melee.attacks[2].damage_min + tt.melee.attacks[2].damage_inc, tt.melee.attacks[2].damage_max + tt.melee.attacks[2].damage_inc)
	self:ft("TOWER_BARBARIANS_TWISTER_DESCRIPTION_2", (tt.melee.attacks[2].chance + tt.melee.attacks[2].chance_inc * 2) * 100, tt.melee.attacks[2].damage_min + tt.melee.attacks[2].damage_inc * 2, tt.melee.attacks[2].damage_max + tt.melee.attacks[2].damage_inc * 2)
	self:ft("TOWER_BARBARIANS_TWISTER_DESCRIPTION_3", (tt.melee.attacks[2].chance + tt.melee.attacks[2].chance_inc * 3) * 100, tt.melee.attacks[2].damage_min + tt.melee.attacks[2].damage_inc * 3, tt.melee.attacks[2].damage_max + tt.melee.attacks[2].damage_inc * 3)
	tt = E:get_template("mod_barbarian_net")
	self:ft("TOWER_BARBARIANS_HUNTING_NETS_DESCRIPTION_1", (1 - tt.slow.factor[1]) * 100)
	self:ft("TOWER_BARBARIANS_HUNTING_NETS_DESCRIPTION_2", (1 - tt.slow.factor[2]) * 100)
	self:ft("TOWER_BARBARIANS_HUNTING_NETS_DESCRIPTION_3", (1 - tt.slow.factor[3]) * 100)

	tt = E:get_template("tower_sorcerer")
	self:ft("TOWER_SORCERER_POLIMORPH_DESCRIPTION", tt.powers.polymorph.cooldown_base + tt.powers.polymorph.cooldown_inc)
	self:ft("TOWER_SORCERER_POLIMORPH_DESCRIPTION_1", tt.powers.polymorph.cooldown_base + tt.powers.polymorph.cooldown_inc)
	self:ft("TOWER_SORCERER_POLIMORPH_DESCRIPTION_2", tt.powers.polymorph.cooldown_base + tt.powers.polymorph.cooldown_inc * 2)
	self:ft("TOWER_SORCERER_POLIMORPH_DESCRIPTION_3", tt.powers.polymorph.cooldown_base + tt.powers.polymorph.cooldown_inc * 3)
	tt = E:get_template("mod_sorcerer_curse_armor")
	tt2 = E:get_template("mod_sorcerer_curse_dps")
	self:ft("TOWER_SORCERER_DESCRIPTION", tt.armor_buff.factor * -100, math.ceil(tt2.dps.damage_max / tt2.dps.damage_every))
	self:ft("TOWER_SORCERER_EXTRA", tt.armor_buff.factor * -100, math.ceil(tt2.dps.damage_max / tt2.dps.damage_every))
	self:ft("TOWER_SORCERER_SMALL_DESCRIPTION", tt.armor_buff.factor * -100, math.ceil(tt2.dps.damage_max / tt2.dps.damage_every))
	tt = E:get_template("soldier_elemental")
	self:ft("TOWER_SORCERER_ELEMENTAL_DESCRIPTION_2", tt.health.hp_max + tt.health.hp_inc * 2, (tt.health.armor + tt.health.armor_inc * 2) * 100, tt.melee.attacks[1].damage_min + tt.melee.attacks[1].damage_inc * 2, tt.melee.attacks[1].damage_max + tt.melee.attacks[1].damage_inc * 2)
	self:ft("TOWER_SORCERER_ELEMENTAL_DESCRIPTION_3", tt.health.hp_max + tt.health.hp_inc * 3, (tt.health.armor + tt.health.armor_inc * 3) * 100, tt.melee.attacks[1].damage_min + tt.melee.attacks[1].damage_inc * 3, tt.melee.attacks[1].damage_max + tt.melee.attacks[1].damage_inc * 3)

	tt = E:get_template("soldier_elf_kr1")
	self:ft("SPECIAL_ELF_KR1_UPGRADE2_DESCRIPTION", tt.health.armor_inc * 100)
	self:ft("SPECIAL_ELF_KR1_UPGRADE2_DESCRIPTION_1", tt.health.armor_inc * 100)
	self:ft("SPECIAL_ELF_KR1_UPGRADE2_DESCRIPTION_2", tt.health.armor_inc * 100)
	self:ft("SPECIAL_ELF_KR1_UPGRADE2_DESCRIPTION_3", tt.health.armor_inc * 100)
	self:ft("SPECIAL_ELF_KR1_UPGRADE3_DESCRIPTION", math.ceil(tt.ranged.attacks[1].range_inc / math.ceil(tt.ranged.attacks[1].max_range / 100)))
	self:ft("SPECIAL_ELF_KR1_UPGRADE3_DESCRIPTION_1", math.ceil(tt.ranged.attacks[1].range_inc / math.ceil(tt.ranged.attacks[1].max_range / 100)))
	self:ft("SPECIAL_ELF_KR1_UPGRADE3_DESCRIPTION_2", math.ceil(tt.ranged.attacks[1].range_inc / math.ceil(tt.ranged.attacks[1].max_range / 100)))
	self:ft("SPECIAL_ELF_KR1_UPGRADE3_DESCRIPTION_3", math.ceil(tt.ranged.attacks[1].range_inc / math.ceil(tt.ranged.attacks[1].max_range / 100)))

	tt = E:get_template("tower_musketeer")
	tt2 = E:get_template("bomb_musketeer")
	self:ft("TOWER_MUSKETEERS_SHRAPNEL_DESCRIPTION", (tt2.bullet.damage_min + tt2.bullet.damage_min_inc) * tt.attacks.list[4].loops, (tt2.bullet.damage_max + tt2.bullet.damage_max_inc) * tt.attacks.list[4].loops)
	self:ft("TOWER_MUSKETEERS_SHRAPNEL_DESCRIPTION_1", (tt2.bullet.damage_min + tt2.bullet.damage_min_inc) * tt.attacks.list[4].loops, (tt2.bullet.damage_max + tt2.bullet.damage_max_inc) * tt.attacks.list[4].loops)
	self:ft("TOWER_MUSKETEERS_SHRAPNEL_DESCRIPTION_2", (tt2.bullet.damage_min + tt2.bullet.damage_min_inc * 2) * tt.attacks.list[4].loops, (tt2.bullet.damage_max + tt2.bullet.damage_max_inc * 2) * tt.attacks.list[4].loops)
	self:ft("TOWER_MUSKETEERS_SHRAPNEL_DESCRIPTION_3", (tt2.bullet.damage_min + tt2.bullet.damage_min_inc * 3) * tt.attacks.list[4].loops, (tt2.bullet.damage_max + tt2.bullet.damage_max_inc * 3) * tt.attacks.list[4].loops)
	self:ft("TOWER_MUSKETEERS_SNIPER_DESCRIPTION", tt.powers.sniper.instakill_chance_inc * 100, tt.powers.sniper.damage_factor_inc * 100)
	self:ft("TOWER_MUSKETEERS_SNIPER_DESCRIPTION_1", tt.powers.sniper.instakill_chance_inc * 100, tt.powers.sniper.damage_factor_inc * 100)
	self:ft("TOWER_MUSKETEERS_SNIPER_DESCRIPTION_2", tt.powers.sniper.instakill_chance_inc * 2 * 100, tt.powers.sniper.damage_factor_inc * 2 * 100)
	self:ft("TOWER_MUSKETEERS_SNIPER_DESCRIPTION_3", tt.powers.sniper.instakill_chance_inc * 3 * 100, tt.powers.sniper.damage_factor_inc * 3 * 100)

	tt = E:get_template("tower_sunray_mini")
	tt2 = E:get_template("ray_sunray_mini")
	self:ft("SPECIAL_SUNRAY_MINI_UPGRADE_DESCRIPTION_1", tt2.bullet.damage_min + tt2.bullet.damage_inc, tt2.bullet.damage_max + tt2.bullet.damage_inc, tt.attacks.list[1].cooldown_base + tt.attacks.list[1].cooldown_inc)
	self:ft("SPECIAL_SUNRAY_MINI_UPGRADE_DESCRIPTION_2", tt2.bullet.damage_min + tt2.bullet.damage_inc * 2, tt2.bullet.damage_max + tt2.bullet.damage_inc * 2, tt.attacks.list[1].cooldown_base + tt.attacks.list[1].cooldown_inc * 2)
	self:ft("SPECIAL_SUNRAY_MINI_UPGRADE_DESCRIPTION_3", tt2.bullet.damage_min + tt2.bullet.damage_inc * 3, tt2.bullet.damage_max + tt2.bullet.damage_inc * 3, tt.attacks.list[1].cooldown_base + tt.attacks.list[1].cooldown_inc * 3)
	self:ft("SPECIAL_SUNRAY_MINI_UPGRADE_DESCRIPTION_4", tt2.bullet.damage_min + tt2.bullet.damage_inc * 4, tt2.bullet.damage_max + tt2.bullet.damage_inc * 4, tt.attacks.list[1].cooldown_base + tt.attacks.list[1].cooldown_inc * 4)

	tt = E:get_template("totem_silence")
	self:ft("TOWER_TOTEM_SPIRITS_DESCRIPTION", tt.aura.duration + tt.aura.duration_inc)
	self:ft("TOWER_TOTEM_SPIRITS_DESCRIPTION_1", tt.aura.duration + tt.aura.duration_inc)
	self:ft("TOWER_TOTEM_SPIRITS_DESCRIPTION_2", tt.aura.duration + tt.aura.duration_inc * 2)
	self:ft("TOWER_TOTEM_SPIRITS_DESCRIPTION_3", tt.aura.duration + tt.aura.duration_inc * 3)
	tt = E:get_template("totem_weakness")
	tt2 = E:get_template("mod_weakness_totem")
	self:ft("TOWER_TOTEM_WEAKNESS_DESCRIPTION", (tt2.received_damage_factor - 1) * 100, tt2.inflicted_damage_factor * 100, tt.aura.duration + tt.aura.duration_inc)
	self:ft("TOWER_TOTEM_WEAKNESS_DESCRIPTION_1", (tt2.received_damage_factor - 1) * 100, tt2.inflicted_damage_factor * 100, tt.aura.duration + tt.aura.duration_inc)
	self:ft("TOWER_TOTEM_WEAKNESS_DESCRIPTION_2", tt.aura.duration + tt.aura.duration_inc * 2)
	self:ft("TOWER_TOTEM_WEAKNESS_DESCRIPTION_3", tt.aura.duration + tt.aura.duration_inc * 3)

	tt = E:get_template("dwarf_barrel")
	self:ft("SPECIAL_DWARF_TOWER1_UPGRADE_1_DESCRIPTION", tt.bullet.damage_min + tt.bullet.damage_min_inc, tt.bullet.damage_max + tt.bullet.damage_max_inc)
	self:ft("SPECIAL_DWARF_TOWER1_UPGRADE_1_DESCRIPTION_1", tt.bullet.damage_min + tt.bullet.damage_min_inc, tt.bullet.damage_max + tt.bullet.damage_max_inc)
	self:ft("SPECIAL_DWARF_TOWER1_UPGRADE_1_DESCRIPTION_2", tt.bullet.damage_min + tt.bullet.damage_min_inc * 2, tt.bullet.damage_max + tt.bullet.damage_max_inc * 2)
	self:ft("SPECIAL_DWARF_TOWER1_UPGRADE_1_DESCRIPTION_3", tt.bullet.damage_min + tt.bullet.damage_min_inc * 3, tt.bullet.damage_max + tt.bullet.damage_max_inc * 3)

	tt = E:get_template("tower_pirate_watchtower")
	self:ft("SPECIAL_PIRATES_WATCHTOWER_UPGRADE_1_DESCRIPTION", math.ceil((tt.attacks.list[1].cooldown - tt.powers.reduce_cooldown.values[1] / (tt.attacks.list[1].cooldown / 100))) * -1)
	self:ft("SPECIAL_PIRATES_WATCHTOWER_UPGRADE_1_DESCRIPTION_1", math.ceil((tt.attacks.list[1].cooldown - tt.powers.reduce_cooldown.values[1] / (tt.attacks.list[1].cooldown / 100))) * -1)
	self:ft("SPECIAL_PIRATES_WATCHTOWER_UPGRADE_1_DESCRIPTION_2", math.ceil((tt.powers.reduce_cooldown.values[1] - tt.powers.reduce_cooldown.values[2] / (tt.powers.reduce_cooldown.values[1] / 100))) * -1)
	self:ft("SPECIAL_PIRATES_WATCHTOWER_UPGRADE_1_DESCRIPTION_3", math.ceil((tt.powers.reduce_cooldown.values[2] - tt.powers.reduce_cooldown.values[3] / (tt.powers.reduce_cooldown.values[2] / 100))) * -1)

	tt = E:get_template("soldier_dwarf")
	self:ft("SPECIAL_DWARF_BARRACKS_UPGRADE_2_DESCRIPTION", (tt.health.armor + tt.health.armor_inc) * 100)
	self:ft("SPECIAL_DWARF_BARRACKS_UPGRADE_2_DESCRIPTION_1", (tt.health.armor + tt.health.armor_inc) * 100)
	self:ft("SPECIAL_DWARF_BARRACKS_UPGRADE_2_DESCRIPTION_2", (tt.health.armor + tt.health.armor_inc * 2) * 100)
	tt2 = E:get_template("mod_dwarf_beer")
	self:ft("SPECIAL_DWARF_BARRACKS_UPGRADE_3_DESCRIPTION", tt2.hps.heal_max / tt2.hps.heal_every, tt2.modifier.duration + tt2.modifier.duration_inc, tt.beer.hp_trigger_factor * 100)
	self:ft("SPECIAL_DWARF_BARRACKS_UPGRADE_3_DESCRIPTION_1", tt2.hps.heal_max / tt2.hps.heal_every, tt2.modifier.duration + tt2.modifier.duration_inc, tt.beer.hp_trigger_factor * 100)
	self:ft("SPECIAL_DWARF_BARRACKS_UPGRADE_3_DESCRIPTION_2", tt2.modifier.duration + tt2.modifier.duration_inc * 2)
	self:ft("SPECIAL_DWARF_BARRACKS_UPGRADE_3_DESCRIPTION_3", tt2.modifier.duration + tt2.modifier.duration_inc * 3)

	tt = E:get_template("soldier_frankenstein")
	self:ft("SPECIAL_TOWER_FRANKENSTEIN_UPGRADE_2_DESCRIPTION_2", tt.health.armor_lvls[2] * 100)
	self:ft("SPECIAL_TOWER_FRANKENSTEIN_UPGRADE_2_DESCRIPTION_3", tt.health.armor_lvls[3] * 100)

	tt = E:get_template("tower_crossbow")
	self:ft("TOWER_CROSSBOW_BARRAGE_DESCRIPTION", tt.attacks.list[2].shots + tt.attacks.list[2].shots_inc)
	self:ft("TOWER_CROSSBOW_BARRAGE_DESCRIPTION_1", tt.attacks.list[2].shots + tt.attacks.list[2].shots_inc)
	self:ft("TOWER_CROSSBOW_BARRAGE_DESCRIPTION_2", tt.attacks.list[2].shots + tt.attacks.list[2].shots_inc * 2)
	self:ft("TOWER_CROSSBOW_BARRAGE_DESCRIPTION_3", tt.attacks.list[2].shots + tt.attacks.list[2].shots_inc * 3)
	tt2 = E:get_template("mod_crossbow_eagle")
	self:ft("TOWER_CROSSBOW_FALCONER_DESCRIPTION", (tt.attacks.list[1].critical_chance + tt.attacks.list[1].critical_chance_inc) * 100, (tt2.range_factor + tt2.range_factor_inc - 1) * 100)
	self:ft("TOWER_CROSSBOW_FALCONER_DESCRIPTION_1", (tt.attacks.list[1].critical_chance + tt.attacks.list[1].critical_chance_inc) * 100, (tt2.range_factor + tt2.range_factor_inc - 1) * 100)
	self:ft("TOWER_CROSSBOW_FALCONER_DESCRIPTION_2", (tt.attacks.list[1].critical_chance + tt.attacks.list[1].critical_chance_inc * 2) * 100, (tt2.range_factor + tt2.range_factor_inc * 2 - 1) * 100)
	self:ft("TOWER_CROSSBOW_FALCONER_DESCRIPTION_3", (tt.attacks.list[1].critical_chance + tt.attacks.list[1].critical_chance_inc * 3) * 100, (tt2.range_factor + tt2.range_factor_inc * 2 - 1) * 100)

	tt = E:get_template("tower_dwaarp")
	self:ft("TOWER_DWAARP_DRILL_DESCRIPTION_1", tt.attacks.list[3].cooldown + tt.attacks.list[3].cooldown_inc)
	self:ft("TOWER_DWAARP_DRILL_DESCRIPTION_2_NOFMT", tt.attacks.list[3].cooldown + tt.attacks.list[3].cooldown_inc * 2)
	self:ft("TOWER_DWAARP_DRILL_DESCRIPTION_3_NOFMT", tt.attacks.list[3].cooldown + tt.attacks.list[3].cooldown_inc * 3)
	tt = E:get_template("lava")
	tt2 = E:get_template("mod_lava")
	self:ft("TOWER_DWAARP_BLAST_DESCRIPTION", math.ceil(((tt2.dps.damage_max + tt2.dps.damage_inc) / tt2.dps.damage_every) * (tt2.modifier.duration + tt.aura.duration)))
	self:ft("TOWER_DWAARP_BLAST_DESCRIPTION_1", math.ceil(((tt2.dps.damage_max + tt2.dps.damage_inc) / tt2.dps.damage_every) * (tt2.modifier.duration + tt.aura.duration)))
	self:ft("TOWER_DWAARP_BLAST_DESCRIPTION_2", math.ceil(((tt2.dps.damage_max + tt2.dps.damage_inc * 2) / tt2.dps.damage_every) * (tt2.modifier.duration + tt.aura.duration)))
	self:ft("TOWER_DWAARP_BLAST_DESCRIPTION_3", math.ceil(((tt2.dps.damage_max + tt2.dps.damage_inc * 3) / tt2.dps.damage_every) * (tt2.modifier.duration + tt.aura.duration)))
	tt = E:get_template("mod_slow_dwaarp")
	self:ft("TOWER_DWAARP_DESCRIPTION", (1 - tt.slow.factor) * 100, math.ceil(tt.modifier.duration * 10) / 10)
	self:ft("TOWER_DWAARP_EXTRA", (1 - tt.slow.factor) * 100, tt.modifier.duration * 1)

	tt = E:get_template("soldier_templar")
	tt2 = E:get_template("mod_blood")
	self:ft("TOWER_TEMPLAR_ARTERIAL_DESCRIPTION", tt.melee.attacks[2].chance * 100, tt.melee.attacks[2].damage_min + tt.melee.attacks[2].damage_inc, tt.melee.attacks[2].damage_max + tt.melee.attacks[2].damage_inc, math.ceil((tt2.dps.damage_max + tt2.dps.damage_inc) / tt2.dps.damage_every))
	self:ft("TOWER_TEMPLAR_ARTERIAL_DESCRIPTION_1", tt.melee.attacks[2].chance * 100, tt.melee.attacks[2].damage_min + tt.melee.attacks[2].damage_inc, tt.melee.attacks[2].damage_max + tt.melee.attacks[2].damage_inc, math.ceil((tt2.dps.damage_max + tt2.dps.damage_inc) / tt2.dps.damage_every))
	self:ft("TOWER_TEMPLAR_ARTERIAL_DESCRIPTION_2", tt.melee.attacks[2].damage_min + tt.melee.attacks[2].damage_inc * 2, tt.melee.attacks[2].damage_max + tt.melee.attacks[2].damage_inc * 2, math.ceil((tt2.dps.damage_max + tt2.dps.damage_inc * 2) / tt2.dps.damage_every))
	self:ft("TOWER_TEMPLAR_ARTERIAL_DESCRIPTION_3", tt.melee.attacks[2].damage_min + tt.melee.attacks[2].damage_inc * 3, tt.melee.attacks[2].damage_max + tt.melee.attacks[2].damage_inc * 3, math.ceil((tt2.dps.damage_max + tt2.dps.damage_inc * 3) / tt2.dps.damage_every))
	self:ft("TOWER_TEMPLAR_HOLY_DESCRIPTION", (tt.revive.chance + tt.revive.chance_inc) * 100, (tt.revive.health_recover + tt.revive.health_recover_inc) * 100)
	self:ft("TOWER_TEMPLAR_HOLY_DESCRIPTION_1", (tt.revive.chance + tt.revive.chance_inc) * 100, (tt.revive.health_recover + tt.revive.health_recover_inc) * 100)
	self:ft("TOWER_TEMPLAR_HOLY_DESCRIPTION_2", (tt.revive.chance + tt.revive.chance_inc * 2) * 100, (tt.revive.health_recover + tt.revive.health_recover_inc * 2) * 100)
	self:ft("TOWER_TEMPLAR_HOLY_DESCRIPTION_3", (tt.revive.chance + tt.revive.chance_inc * 3) * 100, (tt.revive.health_recover + tt.revive.health_recover_inc * 3) * 100)

	tt = E:get_template("soldier_assassin")
	self:ft("TOWER_ASSASSIN_COUNTER_DESCRIPTION", (tt.dodge.chance + tt.dodge.chance_inc) * 100, tt.dodge.counter_attack.damage_min + tt.dodge.counter_attack.damage_inc, tt.dodge.counter_attack.damage_max + tt.dodge.counter_attack.damage_inc)
	self:ft("TOWER_ASSASSIN_COUNTER_DESCRIPTION_1", (tt.dodge.chance + tt.dodge.chance_inc) * 100, tt.dodge.counter_attack.damage_min + tt.dodge.counter_attack.damage_inc, tt.dodge.counter_attack.damage_max + tt.dodge.counter_attack.damage_inc)
	self:ft("TOWER_ASSASSIN_COUNTER_DESCRIPTION_2", (tt.dodge.chance + tt.dodge.chance_inc * 2) * 100, tt.dodge.counter_attack.damage_min + tt.dodge.counter_attack.damage_inc * 2, tt.dodge.counter_attack.damage_max + tt.dodge.counter_attack.damage_inc * 2)
	self:ft("TOWER_ASSASSIN_COUNTER_DESCRIPTION_3", (tt.dodge.chance + tt.dodge.chance_inc * 3) * 100, tt.dodge.counter_attack.damage_min + tt.dodge.counter_attack.damage_inc * 3, tt.dodge.counter_attack.damage_max + tt.dodge.counter_attack.damage_inc * 3)
	self:ft("TOWER_ASSASSIN_DESCRIPTION", tt.dodge.chance * 100)
	self:ft("TOWER_ASSASSINS_DESCRIPTION", tt.dodge.chance * 100)
	self:ft("TOWER_ASSASSIN_EXTRA", tt.dodge.chance * 100)
	self:ft("TOWER_ASSASSIN_PICK_DESCRIPTION", (tt.pickpocket.chance + tt.pickpocket.chance_inc) * 100)
	self:ft("TOWER_ASSASSIN_PICK_DESCRIPTION_1", (tt.pickpocket.chance + tt.pickpocket.chance_inc) * 100)
	self:ft("TOWER_ASSASSIN_PICK_DESCRIPTION_2", (tt.pickpocket.chance + tt.pickpocket.chance_inc * 2) * 100)
	self:ft("TOWER_ASSASSIN_PICK_DESCRIPTION_3", (tt.pickpocket.chance + tt.pickpocket.chance_inc * 3) * 100)
	self:ft("TOWER_ASSASSIN_SNEAK_DESCRIPTION", (tt.melee.attacks[2].chance + tt.melee.attacks[2].chance_inc) * 100, tt.melee.attacks[2].damage_min + tt.melee.attacks[2].damage_inc, tt.melee.attacks[2].damage_max + tt.melee.attacks[2].damage_inc, (tt.melee.attacks[3].chance + tt.melee.attacks[3].chance_inc) * 100)
	self:ft("TOWER_ASSASSIN_SNEAK_DESCRIPTION_1", (tt.melee.attacks[2].chance + tt.melee.attacks[2].chance_inc) * 100, tt.melee.attacks[2].damage_min + tt.melee.attacks[2].damage_inc, tt.melee.attacks[2].damage_max + tt.melee.attacks[2].damage_inc, (tt.melee.attacks[3].chance + tt.melee.attacks[3].chance_inc) * 100)
	self:ft("TOWER_ASSASSIN_SNEAK_DESCRIPTION_2", (tt.melee.attacks[2].chance + tt.melee.attacks[2].chance_inc * 2) * 100, tt.melee.attacks[2].damage_min + tt.melee.attacks[2].damage_inc * 2, tt.melee.attacks[2].damage_max + tt.melee.attacks[2].damage_inc * 2, (tt.melee.attacks[3].chance + tt.melee.attacks[3].chance_inc * 2) * 100)
	self:ft("TOWER_ASSASSIN_SNEAK_DESCRIPTION_3", (tt.melee.attacks[2].chance + tt.melee.attacks[2].chance_inc * 3) * 100, tt.melee.attacks[2].damage_min + tt.melee.attacks[2].damage_inc * 3, tt.melee.attacks[2].damage_max + tt.melee.attacks[2].damage_inc * 3, (tt.melee.attacks[3].chance + tt.melee.attacks[3].chance_inc * 3) * 100)

	tt = E:get_template("soldier_mecha")
	self:ft("TOWER_MECH_MISSILE_DESCRIPTION", tt.attacks.list[2].burst + tt.attacks.list[2].burst_inc, math.ceil(tt.attacks.list[2].cooldown * 1))
	self:ft("TOWER_MECH_MISSILE_DESCRIPTION_1", tt.attacks.list[2].burst + tt.attacks.list[2].burst_inc, math.ceil(tt.attacks.list[2].cooldown * 1))
	self:ft("TOWER_MECH_MISSILE_DESCRIPTION_2", tt.attacks.list[2].burst + tt.attacks.list[2].burst_inc)
	tt = E:get_template("mod_slow_oil")
	tt2 = E:get_template("oil_mecha")
	self:ft("TOWER_MECH_WASTE_DESCRIPTION_1_NOFMT", (1 - tt.slow.factor) * 100, tt2.aura.duration + tt2.aura.duration_inc)
	self:ft("TOWER_MECH_WASTE_DESCRIPTION_2_NOFMT", tt2.aura.duration + tt2.aura.duration_inc * 2)
	self:ft("TOWER_MECH_WASTE_DESCRIPTION_3_NOFMT", tt2.aura.duration + tt2.aura.duration_inc * 3)

	tt = E:get_template("tower_archmage")
	tt2 = E:get_template("bolt_blast")
	self:ft("TOWER_ARCHMAGE_CRITICAL_DESCRIPTION", tt.attacks.list[1].payload_chance * 100, tt2.bullet.damage_max + tt2.bullet.damage_inc)
	self:ft("TOWER_ARCHMAGE_CRITICAL_DESCRIPTION_1", tt.attacks.list[1].payload_chance * 100, tt2.bullet.damage_max + tt2.bullet.damage_inc)
	self:ft("TOWER_ARCHMAGE_CRITICAL_DESCRIPTION_2", tt2.bullet.damage_max + tt2.bullet.damage_inc * 2, math.ceil(tt2.bullet.damage_radius_inc / (tt2.bullet.damage_radius / 100)))
	self:ft("TOWER_ARCHMAGE_CRITICAL_DESCRIPTION_3", tt2.bullet.damage_max + tt2.bullet.damage_inc * 3, math.ceil(tt2.bullet.damage_radius_inc / (tt2.bullet.damage_radius / 100)))
	tt = E:get_template("twister")
	self:ft("TOWER_ARCHMAGE_TWISTER_DESCRIPTION", tt.enemies_max + tt.enemies_inc, tt.damage_max + tt.damage_inc)
	self:ft("TOWER_ARCHMAGE_TWISTER_DESCRIPTION_1", tt.enemies_max + tt.enemies_inc, tt.damage_max + tt.damage_inc)
	self:ft("TOWER_ARCHMAGE_TWISTER_DESCRIPTION_2", tt.enemies_max + tt.enemies_inc * 2, tt.damage_max + tt.damage_inc * 2, math.ceil(tt.nodes_inc / (tt.nodes / 100)))
	self:ft("TOWER_ARCHMAGE_TWISTER_DESCRIPTION_3", tt.enemies_max + tt.enemies_inc * 3, tt.damage_max + tt.damage_inc * 3, math.ceil(tt.nodes_inc / (tt.nodes / 100)))

	tt = E:get_template("pestilence")
	tt2 = E:get_template("mod_pestilence")
	self:ft("TOWER_NECROMANCER_PESTILENCE_DESCRIPTION", tt.aura.duration + tt.aura.duration_inc, math.ceil(tt2.dps.damage_max / tt2.dps.damage_every))
	self:ft("TOWER_NECROMANCER_PESTILENCE_DESCRIPTION_1", tt.aura.duration + tt.aura.duration_inc, math.ceil(tt2.dps.damage_max / tt2.dps.damage_every))
	self:ft("TOWER_NECROMANCER_PESTILENCE_DESCRIPTION_2", tt.aura.duration + tt.aura.duration_inc * 2)
	self:ft("TOWER_NECROMANCER_PESTILENCE_DESCRIPTION_3", tt.aura.duration + tt.aura.duration_inc * 3)
	tt = E:get_template("mod_death_rider")
	self:ft("TOWER_NECROMANCER_RIDER_DESCRIPTION", (tt.inflicted_damage_factor - 1) * 100, tt.extra_armor * 100)
	self:ft("TOWER_NECROMANCER_RIDER_DESCRIPTION_1", (tt.inflicted_damage_factor - 1) * 100, tt.extra_armor * 100)
	tt = E:get_template("soldier_death_rider")
	self:ft("TOWER_NECROMANCER_RIDER_DESCRIPTION_2", tt.health.armor_inc * 100)
	self:ft("TOWER_NECROMANCER_RIDER_DESCRIPTION_3", tt.health.armor_inc * 100)

	tt = E:get_template("soldier_pirate_captain_2")
	self:ft("TOWER_BARRACK_PIRATES_BUY_CAPTAIN_DESCRIPTION", tt.pickpocket.chance * 100)

	tt = E:get_template("soldier_amazona_re")
	self:ft("TOWER_BARRACK_AMAZONAS_DESCRIPTION", tt.melee.attacks[2].chance * 100)
	self:ft("TOWER_BARRACK_AMAZONAS_RE_DESCRIPTION", tt.melee.attacks[2].chance * 100)
	self:ft("TOWER_BARRACK_AMAZONAS_RE_EXTRA", tt.melee.attacks[2].chance * 100)

	tt = E:get_template("tower_hammerhold")
	tt2 = E:get_template("arrow_hammerhold_split")
	self:ft("HAMMERHOLD_ARCHER_UPGRADE2_DESCRIPTION", tt.powers.split.extra_arrows[1] + 1, tt2.bullet.damage_max + tt2.bullet.damage_inc)
	self:ft("HAMMERHOLD_ARCHER_UPGRADE2_DESCRIPTION_1", tt.powers.split.extra_arrows[1] + 1, tt2.bullet.damage_max + tt2.bullet.damage_inc)
	self:ft("HAMMERHOLD_ARCHER_UPGRADE2_DESCRIPTION_2", tt.powers.split.extra_arrows[2] + 1)
	self:ft("HAMMERHOLD_ARCHER_UPGRADE2_DESCRIPTION_3", tt.powers.split.extra_arrows[3] + 1)
	tt = E:get_template("mod_legion_burn")
	self:ft("HAMMERHOLD_ARCHER_UPGRADE1_DESCRIPTION", math.floor((tt.dps.damage_percent / tt.dps.damage_every) * 1000) / 10, tt.health_cap[1] * 100, math.ceil(tt.dps.damage_flat[1] / tt.dps.damage_every))
	self:ft("HAMMERHOLD_ARCHER_UPGRADE1_DESCRIPTION_1", math.floor((tt.dps.damage_percent / tt.dps.damage_every) * 1000) / 10, tt.health_cap[1] * 100, math.ceil(tt.dps.damage_flat[1] / tt.dps.damage_every))
	self:ft("HAMMERHOLD_ARCHER_UPGRADE1_DESCRIPTION_2", math.ceil(tt.dps.damage_flat[2] / tt.dps.damage_every), tt.health_cap[2] * 100)

	tt = E:get_template("aura_breath_baby_ashbite")
	self:ft("ELVES_BABY_ASHBITE_FIREBREATH_SMALL_DESCRIPTION_1", math.ceil((math.ceil(tt.aura.damage_max + tt.aura.damage_inc) / tt.aura.cycle_time) * tt.aura.duration))
	self:ft("ELVES_BABY_ASHBITE_FIREBREATH_SMALL_DESCRIPTION_2", math.ceil((math.ceil(tt.aura.damage_max + tt.aura.damage_inc * 2) / tt.aura.cycle_time) * tt.aura.duration))
	self:ft("ELVES_BABY_ASHBITE_FIREBREATH_SMALL_DESCRIPTION_3", math.ceil((math.ceil(tt.aura.damage_max + tt.aura.damage_inc * 3) / tt.aura.cycle_time) * tt.aura.duration))
	tt = E:get_template("mod_slow_baby_ashbite")
	tt2 = E:get_template("aura_fiery_mist_baby_ashbite")
	self:ft("ELVES_BABY_ASHBITE_SMOKEBREATH_SMALL_DESCRIPTION_1", (1 - (tt.slow.factor + tt.slow.factor_inc)) * 100, math.ceil((tt2.aura.damage_max + tt2.aura.damage_inc) / tt2.aura.cycle_time), tt2.aura.duration)

	tt = E:get_template("tower_entwood")
	self:ft("TOWER_ENTWOOD_CLOBBER_DESCRIPTION_1", tt.attacks.list[3].stun_chances[4] * 100)
	tt2 = E:get_template("rock_firey_nut")
	local tt3 = E:get_template("mod_fiery_nut")
	self:ft("TOWER_FIERY_NUTS_DESCRIPTION_1", tt2.bullet.damage_max + tt2.bullet.damage_max_inc, math.ceil((tt3.dps.damage_max + tt3.dps.damage_inc) / tt3.dps.damage_every), math.ceil(tt.attacks.list[2].cooldown * 1))
	self:ft("TOWER_FIERY_NUTS_DESCRIPTION_2", tt2.bullet.damage_max + tt2.bullet.damage_max_inc * 2, math.ceil((tt3.dps.damage_max + tt3.dps.damage_inc * 2) / tt3.dps.damage_every))
	self:ft("TOWER_FIERY_NUTS_DESCRIPTION_3", tt2.bullet.damage_max + tt2.bullet.damage_max_inc * 3, math.ceil((tt3.dps.damage_max + tt3.dps.damage_inc * 3) / tt3.dps.damage_every))

	tt = E:get_template("aura_razor_edge")
	self:ft("ELVES_TOWER_BASTION_RAZOR_EDGE_SMALL_DESCRIPTION_1", math.ceil((tt.aura.damage_min + tt.aura.damage_inc) / tt.aura.cycle_time) * tt.aura.duration, math.ceil((tt.aura.damage_max + tt.aura.damage_inc) / tt.aura.cycle_time) * tt.aura.duration)
	self:ft("ELVES_TOWER_BASTION_RAZOR_EDGE_SMALL_DESCRIPTION_2", math.ceil((tt.aura.damage_min + tt.aura.damage_inc * 2) / tt.aura.cycle_time) * tt.aura.duration, math.ceil((tt.aura.damage_max + tt.aura.damage_inc * 2) / tt.aura.cycle_time) * tt.aura.duration)

	tt = E:get_template("soldier_drow")
	self:ft("ELVES_TOWER_DROW_BLADE_MAIL_SMALL_DESCRIPTION_1", tt.powers.blade_mail.spiked_armor[1] * 100)
	self:ft("ELVES_TOWER_DROW_BLADE_MAIL_SMALL_DESCRIPTION_2", tt.powers.blade_mail.spiked_armor[2] * 100)
	self:ft("ELVES_TOWER_DROW_BLADE_MAIL_SMALL_DESCRIPTION_3", tt.powers.blade_mail.spiked_armor[3] * 100)
	tt2 = E:get_template("mod_life_drain_drow")
	self:ft("ELVES_TOWER_DROW_LIFE_DRAIN_SMALL_DESCRIPTION_1", tt.melee.attacks[2].damage_max + tt.melee.attacks[2].damage_inc, tt2.heal_factor * 100)
	self:ft("ELVES_TOWER_DROW_LIFE_DRAIN_SMALL_DESCRIPTION_2", tt.melee.attacks[2].damage_max + tt.melee.attacks[2].damage_inc * 2)
	self:ft("ELVES_TOWER_DROW_LIFE_DRAIN_SMALL_DESCRIPTION_3", tt.melee.attacks[2].damage_max + tt.melee.attacks[2].damage_inc * 3)

	tt = E:get_template("tower_pixie")
	self:ft("ELVES_TOWER_PIXIE_LONG_DESCRIPTION", tt.attacks.list[4].chance * 100, tt.attacks.list[3].chance * 100)
	self:ft("ELVES_TOWER_PIXIE_UPGRADE2_DESCRIPTION_1", tt.powers.total.chances[2][1] * 100, tt.powers.total.chances[4][1] * 100, tt.powers.total.chances[3][1] * 100)
	self:ft("ELVES_TOWER_PIXIE_UPGRADE2_DESCRIPTION_2", tt.powers.total.chances[2][2] * 100, tt.powers.total.chances[5][2] * 100, tt.powers.total.chances[4][2] * 100, tt.powers.total.chances[3][2] * 100)
	self:ft("ELVES_TOWER_PIXIE_UPGRADE2_DESCRIPTION_3", tt.powers.total.chances[2][3] * 100, tt.powers.total.chances[5][3] * 100, tt.powers.total.chances[1][3] * 100, tt.powers.total.chances[4][3] * 100, tt.powers.total.chances[3][3] * 100)

	tt = E:get_template("mod_druid_sylvan")
	self:ft("TOWER_STONE_DRUID_SYLVAN_DESCRIPTION_1", tt.attack.damage_factor[1] * 100)
	self:ft("TOWER_STONE_DRUID_SYLVAN_DESCRIPTION_2", tt.attack.damage_factor[2] * 100)
	self:ft("TOWER_STONE_DRUID_SYLVAN_DESCRIPTION_3", tt.attack.damage_factor[3] * 100)

	tt = E:get_template("high_elven_sentinel")
	self:ft("TOWER_MAGE_HIGH_ELVEN_SENTINEL_DESCRIPTION_1", tt.wait_time - tt.wait_spent_time)

	tt = E:get_template("tower_arcane")
	self:ft("TOWER_ARCANE_SLUMBER_DESCRIPTION_1", tt.attacks.list[3].cooldown + tt.attacks.list[3].cooldown_inc)
	self:ft("TOWER_ARCANE_SLUMBER_DESCRIPTION_2", tt.attacks.list[3].cooldown + tt.attacks.list[3].cooldown_inc * 2)
	self:ft("TOWER_ARCANE_SLUMBER_DESCRIPTION_3", tt.attacks.list[3].cooldown + tt.attacks.list[3].cooldown_inc * 3)
	tt = E:get_template("aura_arcane_burst")
	self:ft("TOWER_ARCANE_BURST_DESCRIPTION_2", tt.aura.damage_inc * 2)
	self:ft("TOWER_ARCANE_BURST_DESCRIPTION_3", tt.aura.damage_inc * 3)
	tt = E:get_template("mod_arrow_arcane")
	self:ft("TOWER_ARCANE_DESCRIPTION", tt.damage_max * 100)
	self:ft("TOWER_ARCANE_SMALL_DESCRIPTION", tt.damage_max * 100)

	tt = E:get_template("tower_silver")
	self:ft("TOWER_SILVER_DESCRIPTION", tt.attacks.list[1].critical_chances[2] * 100, tt.attacks.list[1].critical_chances[1] * 100)
	self:ft("TOWER_SILVER_EXTRA", tt.attacks.list[1].critical_chances[2] * 100, tt.attacks.list[1].critical_chances[1] * 100)
	self:ft("TOWER_SILVER_SENTENCE_DESCRIPTION_1", tt.powers.sentence.chances[2][1] * 100, tt.powers.sentence.chances[1][1] * 100)
	self:ft("TOWER_SILVER_SENTENCE_DESCRIPTION_2", tt.powers.sentence.chances[2][2] * 100, tt.powers.sentence.chances[1][2] * 100)
	self:ft("TOWER_SILVER_SENTENCE_DESCRIPTION_3", tt.powers.sentence.chances[2][3] * 100, tt.powers.sentence.chances[1][3] * 100)
	tt = E:get_template("mod_arrow_silver_mark")
	self:ft("TOWER_SILVER_MARK_DESCRIPTION_1", tt.received_damage_factor * 100)

	tt = E:get_template("soldier_forest")
	tt2 = E:get_template("mod_forest_circle")
	self:ft("TOWER_FOREST_KEEPERS_CIRCLE_DESCRIPTION_1", math.ceil(((tt2.hps.heal_max + tt2.hps.heal_inc) / tt2.hps.heal_every) * tt2.modifier.duration), tt.timed_attacks.list[1].trigger_hp_factor * 100)
	self:ft("TOWER_FOREST_KEEPERS_CIRCLE_DESCRIPTION_2", math.ceil(((tt2.hps.heal_max + tt2.hps.heal_inc * 2) / tt2.hps.heal_every) * tt2.modifier.duration))
	self:ft("TOWER_FOREST_KEEPERS_CIRCLE_DESCRIPTION_3", math.ceil(((tt2.hps.heal_max + tt2.hps.heal_inc * 3) / tt2.hps.heal_every) * tt2.modifier.duration))
	tt2 = E:get_template("aura_forest_eerie")
	tt3 = E:get_template("mod_forest_eerie_slow")
	local tt4 = E:get_template("mod_forest_eerie_dps")
	self:ft("TOWER_FOREST_KEEPERS_EERIE_DESCRIPTION_1", (1 - tt3.slow.factor) * 100, math.ceil((tt4.dps.damage_max + tt4.dps.damage_inc) / tt4.dps.damage_every), tt2.aura.duration + tt2.aura.duration_inc)
	self:ft("TOWER_FOREST_KEEPERS_EERIE_DESCRIPTION_2", math.ceil((tt4.dps.damage_max + tt4.dps.damage_inc * 2) / tt4.dps.damage_every), tt2.aura.duration + tt2.aura.duration_inc * 2, math.ceil(tt2.roots_count_inc / (tt2.roots_count / 100)), math.ceil(tt.timed_attacks.list[2].max_range_inc / (tt.timed_attacks.list[2].max_range / 100)))
	tt = E:get_template("spear_forest_oak")
	self:ft("TOWER_FOREST_KEEPERS_OAK_DESCRIPTION_1", tt.bullet.damage_max + tt.bullet.damage_inc)
	self:ft("TOWER_FOREST_KEEPERS_OAK_DESCRIPTION_2", tt.bullet.damage_max + tt.bullet.damage_inc * 2)
	self:ft("TOWER_FOREST_KEEPERS_OAK_DESCRIPTION_3", tt.bullet.damage_max + tt.bullet.damage_inc * 3)

	tt = E:get_template("soldier_blade")
	self:ft("TOWER_BLADE_PERFECT_PARRY_DESCRIPTION_1", (tt.dodge.chance + tt.dodge.chance_inc) * 100, math.ceil(tt.dodge.counter_attack.damage_max / tt.dodge.counter_attack.damage_every))
	self:ft("TOWER_BLADE_PERFECT_PARRY_DESCRIPTION_2", (tt.dodge.chance + tt.dodge.chance_inc * 2) * 100)
	self:ft("TOWER_BLADE_PERFECT_PARRY_DESCRIPTION_3", (tt.dodge.chance + tt.dodge.chance_inc * 3) * 100)
	self:ft("TOWER_BLADE_SWIRLING_EDGE_DESCRIPTION_1", math.ceil((tt.melee.attacks[1].cooldown_inc * -1) / (tt.melee.attacks[1].cooldown / 100)))

	tt = E:get_template("soldier_ewok_re")
	self:ft("ELVES_EWOK_TOWER_BROKEN_DESCRIPTION", tt.dodge.threshold * 100)
	self:ft("ELVES_EWOK_TOWER_RE_DESCRIPTION", tt.dodge.threshold * 100)
	self:ft("ELVES_EWOK_TOWER_RE_EXTRA", tt.dodge.threshold * 100)

	tt = E:get_template("mod_arrow_shadow_mark")
	self:ft("TOWER_SHADOW_MARK_DESCRIPTION_1", (tt.modifier.received_damage_factor[1] - 1) * 100)
	self:ft("TOWER_SHADOW_MARK_DESCRIPTION_2", (tt.modifier.received_damage_factor[2] - 1) * 100)
	self:ft("TOWER_SHADOW_MARK_DESCRIPTION_3", (tt.modifier.received_damage_factor[3] - 1) * 100)
	tt = E:get_template("shadow_crow")
	self:ft("TOWER_SHADOW_CROW_DESCRIPTION_1", tt.custom_attack.damage_max / tt.custom_attack.cooldown)

	tt = E:get_template("tower_orc_warriors_den")
	self:ft("TOWER_ORC_WARRIORS_DEN_CAPTAIN_DESCRIPTION_1", tt.powers.promotion.armor * 100)
	self:ft("TOWER_ORC_WARRIORS_DEN_BLOODLUST_DESCRIPTION_1", (tt.powers.bloodlust.damage_factor[1] - 1) * 100)
	self:ft("TOWER_ORC_WARRIORS_DEN_BLOODLUST_DESCRIPTION_2", (tt.powers.bloodlust.damage_factor[2] - 1) * 100)

	tt = E:get_template("mod_infernal_curse_armor")
	self:ft("TOWER_INFERNAL_MAGE_CURSE_DESCRIPTION_1", tt.extra_armor[1] * 100)
	self:ft("TOWER_INFERNAL_MAGE_CURSE_DESCRIPTION_2", tt.extra_armor[2] * 100)

	tt = E:get_template("soldier_dark_knight")
	self:ft("TOWER_DARK_KNIGHTS_INSTAKILL_DESCRIPTION_1", (tt.melee.attacks[3].chance + tt.melee.attacks[3].chance_inc) * 100)
	self:ft("TOWER_DARK_KNIGHTS_INSTAKILL_DESCRIPTION_2", (tt.melee.attacks[3].chance + tt.melee.attacks[3].chance_inc * 2) * 100)
	self:ft("TOWER_DARK_KNIGHTS_INSTAKILL_DESCRIPTION_3", (tt.melee.attacks[3].chance + tt.melee.attacks[3].chance_inc * 3) * 100)

	tt = E:get_template("tower_melting_furnace")
	self:ft("TOWER_MELTING_FURNACE_DESCRIPTION", tt.attacks.list[1].reduce_armor * 100)
	self:ft("TOWER_MELTING_FURNACE_EXTRA", tt.attacks.list[1].reduce_armor * 100)
	tt2 = E:get_template("mod_furnace_fuel")
	self:ft("TOWER_MELTING_FURNACE_FUEL_DESCRIPTION_1", math.ceil(tt2.cooldown / (tt.attacks.list[1].cooldown / 100)))
	tt2 = E:get_template("mod_lava_furnace")
	self:ft("TOWER_MELTING_FURNACE_COAL_DESCRIPTION_1", tt.powers.coal.fragment_count_base + tt.powers.coal.fragment_count_inc, math.ceil((tt2.dps.damage_max + tt2.dps.damage_inc) / tt2.dps.damage_every))
	self:ft("TOWER_MELTING_FURNACE_COAL_DESCRIPTION_2", tt.powers.coal.fragment_count_base + tt.powers.coal.fragment_count_inc * 2, math.ceil((tt2.dps.damage_max + tt2.dps.damage_inc * 2) / tt2.dps.damage_every))
	tt = E:get_template("mod_furnace_buff")
	self:ft("TOWER_MELTING_FURNACE_BUFF_DESCRIPTION_1", tt.extra_damage * 100)
	self:ft("TOWER_MELTING_FURNACE_BUFF_DESCRIPTION_2", tt.extra_damage * 2 * 100)

	tt = E:get_template("tower_spectres_mausoleum")
	self:ft("TOWER_SPECTRES_MAUSOLEUM_POSSESSION_DESCRIPTION_1", tt.attacks.list[2].cooldown + tt.attacks.list[2].cooldown_inc)
	self:ft("TOWER_SPECTRES_MAUSOLEUM_POSSESSION_DESCRIPTION_2", tt.attacks.list[2].cooldown + tt.attacks.list[2].cooldown_inc * 2)
	self:ft("TOWER_SPECTRES_MAUSOLEUM_POSSESSION_DESCRIPTION_3", tt.attacks.list[2].cooldown + tt.attacks.list[2].cooldown_inc * 3)

	tt = E:get_template("tower_goblirang")
	self:ft("TOWER_GOBLIRANGS_STUN_DESCRIPTION_1", tt.powers.stun.mod_chance[1] * 100)
	self:ft("TOWER_GOBLIRANGS_STUN_DESCRIPTION_2", tt.powers.stun.mod_chance[2] * 100)
	self:ft("TOWER_GOBLIRANGS_STUN_DESCRIPTION_3", tt.powers.stun.mod_chance[3] * 100)
	tt = E:get_template("mod_honey_bees")
	self:ft("TOWER_GOBLIRANGS_BEES_DESCRIPTION_1", math.ceil((tt.dps.damage_max + tt.dps.damage_inc) / tt.dps.damage_every))
	self:ft("TOWER_GOBLIRANGS_BEES_DESCRIPTION_2", math.ceil((tt.dps.damage_max + tt.dps.damage_inc * 2) / tt.dps.damage_every))
	self:ft("TOWER_GOBLIRANGS_BEES_DESCRIPTION_3", math.ceil((tt.dps.damage_max + tt.dps.damage_inc * 3) / tt.dps.damage_every))
	tt = E:get_template("mod_goblirang_slow")
	self:ft("TOWER_GOBLIRANG_DESCRIPTION", (1 - tt.slow.factor) * 100)
	self:ft("TOWER_GOBLIRANG_EXTRA", (1 - tt.slow.factor) * 100)
	
	tt = E:get_template("soldier_elite_harasser")
	self:ft("TOWER_ELITE_HARASSERS_FURY_DESCRIPTION_1", tt.powers.fury.chance * 100)
	self:ft("TOWER_ELITE_HARASSERS_EXTRA", tt.dodge.chance * 100)
	self:ft("TOWER_ELITE_HARASSERS_BACKSTAB_DESCRIPTION_1", tt.dodge.chance_inc * 100)
	self:ft("TOWER_ELITE_HARASSERS_BACKSTAB_DESCRIPTION_2", tt.dodge.chance_inc * 100)
	self:ft("TOWER_ELITE_HARASSERS_DESCRIPTION", tt.dodge.chance * 100)
	tt = E:get_template("arrow_elite_harasser_barrage")
	self:ft("TOWER_HARASSERS_ARROW_DESCRIPTION_1", tt.bullet.damage_min + tt.bullet.damage_min_inc, tt.bullet.damage_max + tt.bullet.damage_max_inc)
	self:ft("TOWER_HARASSERS_ARROW_DESCRIPTION_2", tt.bullet.damage_min + (tt.bullet.damage_min_inc * 2), tt.bullet.damage_max + (tt.bullet.damage_max_inc * 2))
	self:ft("TOWER_HARASSERS_ARROW_DESCRIPTION_3", tt.bullet.damage_min + (tt.bullet.damage_min_inc * 3), tt.bullet.damage_max + (tt.bullet.damage_max_inc * 3))
	
	tt = E:get_template("tower_orc_shaman")
	tt2 = E:get_template("mod_orc_shaman_heal")
	self:ft("TOWER_ORC_SHAMAN_VINES_DESCRIPTION_1", tt2.hps.heal_inc / tt2.hps.heal_every, tt.attacks.list[2].min_health * 100)
	self:ft("TOWER_ORC_SHAMAN_VINES_DESCRIPTION_2", (tt2.hps.heal_inc * 2) / tt2.hps.heal_every)
	self:ft("TOWER_ORC_SHAMAN_VINES_DESCRIPTION_3", (tt2.hps.heal_inc * 3) / tt2.hps.heal_every)
	tt2 = E:get_template("orc_shaman_meteor")
	self:ft("TOWER_ORC_SHAMAN_METEOR_DESCRIPTION_1", tt.attacks.list[3].loops + tt.attacks.list[3].loops_inc, tt2.bullet.damage_min + tt2.bullet.damage_min_inc, tt2.bullet.damage_max + tt2.bullet.damage_max_inc)
	self:ft("TOWER_ORC_SHAMAN_METEOR_DESCRIPTION_2", tt.attacks.list[3].loops + tt.attacks.list[3].loops_inc * 2, tt2.bullet.damage_min + tt2.bullet.damage_min_inc * 2, tt2.bullet.damage_max + tt2.bullet.damage_max_inc * 2)
	self:ft("TOWER_ORC_SHAMAN_METEOR_DESCRIPTION_3", tt.attacks.list[3].loops + tt.attacks.list[3].loops_inc * 3, tt2.bullet.damage_min + tt2.bullet.damage_min_inc * 3, tt2.bullet.damage_max + tt2.bullet.damage_max_inc * 3)

	tt = E:get_template("tower_time_wizard")
	tt2 = E:get_template("mod_sandstorm_slow")
	tt3 = E:get_template("mod_sandstormtw")
	self:ft("TOWER_TIME_WIZARD_SANDSTORM_DESCRIPTION", (1 - tt2.slow.factor) * 100, math.ceil((tt3.dps.damage_max + tt3.dps.damage_inc) / tt3.dps.damage_every), tt.powers.sandstorm.cooldown_base + tt.powers.sandstorm.cooldown_inc)
	self:ft("TOWER_TIME_WIZARD_SANDSTORM_DESCRIPTION_1", (1 - tt2.slow.factor) * 100, math.ceil((tt3.dps.damage_max + tt3.dps.damage_inc) / tt3.dps.damage_every), tt.powers.sandstorm.cooldown_base + tt.powers.sandstorm.cooldown_inc)
	self:ft("TOWER_TIME_WIZARD_SANDSTORM_DESCRIPTION_2", tt.powers.sandstorm.cooldown_base + tt.powers.sandstorm.cooldown_inc * 2, math.ceil((tt3.dps.damage_max + tt3.dps.damage_inc * 2) / tt3.dps.damage_every))
	self:ft("TOWER_TIME_WIZARD_SANDSTORM_DESCRIPTION_3", tt.powers.sandstorm.cooldown_base + tt.powers.sandstorm.cooldown_inc * 3, math.ceil((tt3.dps.damage_max + tt3.dps.damage_inc * 3) / tt3.dps.damage_every))
	tt = E:get_template("mod_time_wizard_bolt_slow")
	self:ft("TOWER_TIME_WIZARD_DESCRIPTION", (1 - tt.slow.factor) * 100)
	self:ft("TOWER_TIME_WIZARD_EXTRA", (1 - tt.slow.factor) * 100)
	self:ft("TOWER_TIME_WIZARD_SMALL_DESCRIPTION", (1 - tt.slow.factor) * 100)
	tt = E:get_template("soldier_ancient_guardian")
	tt2 = E:get_template("mod_ancient_guardian")
	self:ft("TOWER_TIME_WIZARD_ANCIENT_GUARDIAN_DESCRIPTION_2", tt.health.armor_inc * 100)
	self:ft("TOWER_TIME_WIZARD_ANCIENT_GUARDIAN_DESCRIPTION_3", tt.health.armor_inc * 100)
	
	tt = E:get_template("mod_grim_cemetery_slow")
	self:ft("TOWER_GRIM_CEMETERY_HANDS_DESCRIPTION_1", (1 - tt.slow.factor) * 100)
	tt = E:get_template("mod_grim_cemetery_poison")
	self:ft("TOWER_GRIM_CEMETERY_PESTILENCE_DESCRIPTION_1", math.ceil((tt.dps.damage_max + tt.dps.damage_inc) / tt.dps.damage_every))

	tt = E:get_template("soldier_steam_troop")
	self:ft("TOWER_STEAM_TROOP_LEAK_DESCRIPTION_1", tt.melee.attacks[2].chance_inc * 100)
	self:ft("TOWER_STEAM_TROOP_LEAK_DESCRIPTION_2", tt.melee.attacks[2].chance_inc * 2 * 100)
	self:ft("TOWER_STEAM_TROOP_LEAK_DESCRIPTION_3", tt.melee.attacks[2].chance_inc * 3 * 100)
	self:ft("TOWER_STEAM_TROOP_BALL_DESCRIPTION_1", math.ceil(tt.melee.attacks[3].cooldown / (tt.melee.attacks[1].cooldown / 100)))
	tt2 = E:get_template("airstrike_steam_troop")
	self:ft("TOWER_STEAM_TROOP_AIRSTRIKE_DESCRIPTION_1", tt2.bullet.damage_min + tt2.bullet.damage_min_inc, tt2.bullet.damage_max + tt2.bullet.damage_max_inc)
	self:ft("TOWER_STEAM_TROOP_AIRSTRIKE_DESCRIPTION_2", tt2.bullet.damage_min + tt2.bullet.damage_min_inc * 2, tt2.bullet.damage_max + tt2.bullet.damage_max_inc * 2, math.ceil(tt.ranged.attacks[2].range_inc / ((tt.ranged.attacks[2].max_range + tt.ranged.attacks[2].range_inc) / 100)))
	self:ft("TOWER_STEAM_TROOP_AIRSTRIKE_DESCRIPTION_3", tt2.bullet.damage_min + tt2.bullet.damage_min_inc * 3, tt2.bullet.damage_max + tt2.bullet.damage_max_inc * 3, math.ceil(tt.ranged.attacks[2].range_inc / ((tt.ranged.attacks[2].max_range + tt.ranged.attacks[2].range_inc) / 100)))
end
