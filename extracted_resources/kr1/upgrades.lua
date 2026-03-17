-- chunkname: @./kr1/upgrades.lua

local log = require("klua.log"):new("upgrades")
local km = require("klua.macros")
local E = require("entity_db")
local bit = require("bit")

require("constants")

local function T(name)
	return E:get_template(name)
end

local function DP(desktop, phone)
	return not (KR_TARGET ~= "phone" and KR_TARGET ~= "tablet") and phone or desktop
end

local epsilon = 1e-09
local upgrades = {}

upgrades.max_level = nil
upgrades.levels = {}
upgrades.levels.archers = 0
upgrades.levels.barracks = 0
upgrades.levels.mages = 0
upgrades.levels.engineers = 0
upgrades.levels.rain = 0
upgrades.levels.reinforcements = 0
upgrades.display_order = {
	"archers",
	"barracks",
	"mages",
	"engineers",
	"rain",
	"reinforcements"
}
upgrades.list = {
	archer_salvage = {
		refund_factor = 0.9,
		range_factor = 1.1,
		damage_factor = 1.05,
		class = "archers",
		price = 1,
		level = 1,
		icon = DP(13, 6)
	},
	archer_eagle_eye = {
		range_factor = 1.1,
		cost_reduction = 10,
		class = "archers",
		price = 1,
		level = 2,
		icon = DP(14, 7)
	},
	archer_piercing = {
		class = "archers",
		reduce_armor_factor = 0.1,
		damage_factor = 1.05,
		range_factor = 1.05,
		price = 2,
		level = 3,
		icon = DP(15, 8)
	},
	archer_far_shots = {
		range_factor = 1.1,
		range_factor_krf = 1.05,
		damage_factor = 1.1,
		burst_damage_factor = 1.1,
		sentence_chance_factor = 1.1,
		mark_damage_factor = 1.1,
		slumber_duration_factor = 1.1,
		cost_factor_krv = 0.85,
		class = "archers",
		price = 2,
		level = 4,
		icon = DP(16, 9)
	},
	archer_precision = {
		damage_factor = 2,
		damage_factor_krv = 1.1,
		class = "archers",
		chance = 0.1,
		price = 3,
		level = 5,
		icon = DP(17, 10)
	},
	barrack_survival = {
		health_factor = 1.1,
		armor_increase = 0.1,
		cost_factor = 0.9,
		class = "barracks",
		price = 1,
		level = 1,
		icon = DP(8, 1)
	},
	barrack_better_armor = {
		class = "barracks",
		armor_increase = 0.1,
		health_factor = 1.1 - epsilon,
		rally_range_factor = 1.1,
		health_factor_krv = 1.3,
		price = 1,
		level = 2,
		icon = DP(9, 2)
	},
	barrack_improved_deployment = {
		cooldown_factor = 0.8,
		rally_range_factor = 1.2,
		regen_factor = 1.2,
		armor_increase = 0.1,
		class = "barracks",
		price = 2,
		level = 3,
		icon = DP(10, 3)
	},
	barrack_survival_2 = {
		health_factor = 1.0909,
		respawn_reduction = 2,
		armor_increase = 0.1,
		cost_factor_krv = 0.85,
		class = "barracks",
		price = 2,
		level = 4,
		icon = DP(11, 4)
	},
	barrack_barbed_armor = {
		spiked_armor_factor = 0.1,
		damage_factor = 1.1,
		chance = 0.1,
		class = "barracks",
		price = 3,
		level = 5,
		icon = DP(12, 5)
	},
	mage_spell_reach = {
		range_factor = 1.1,
		range_factor2 = 1.05,
		class = "mages",
		price = 1,
		level = 1,
		icon = DP(18, 11)
	},
	mage_arcane_shatter = {
		mod = "mod_arcane_shatter",
		damage_factor = 1.15,
		class = "mages",
		price = 1,
		level = 2,
		icon = DP(19, 12)
	},
	mage_hermetic_study = {
		class = "mages",
		cost_factor = 0.9,
		damage_factor = 1.1,
		range_factor = 1.05,
		price = 2,
		level = 3,
		icon = DP(20, 13)
	},
	mage_empowered_magic = {
		damage_factor = 1.15,
		cost_factor = 0.9,
		cost_factor_krv = 0.85,
		class = "mages",
		price = 2,
		level = 4,
		icon = DP(21, 14)
	},
	mage_slow_curse = {
		mod = "mod_slow_curse",
		damage_factor_krv = 1.1,
		class = "mages",
		price = 3,
		level = 5,
		icon = DP(22, 15)
	},
	engineer_concentrated_fire = {
		damage_factor = 1.1,
		range_factor = 1.1,
		class = "engineers",
		price = 1,
		level = 1,
		icon = DP(23, 16)
	},
	engineer_range_finder = {
		range_factor = 1.1,
		damage_area_factor = 1.1,
		radius_factor_krv = 1.2,
		class = "engineers",
		price = 1,
		level = 2,
		chance = 0.1,
		icon = DP(24, 17)
	},
	engineer_field_logistics = {
		class = "engineers",
		cost_factor = 0.9,
		range_factor = 1.1,
		price = 2,
		level = 3,
		icon = DP(25, 18),
		damage_factor = 1.1
	},
	engineer_industrialization = {
		class = "engineers",
		cost_factor = 0.75,
		cooldown_factor = 0.9,
		cost_factor_krv = 0.85,
		price = 3,
		level = 4,
		icon = DP(26, 19),
		cooldown_factor = 0.9,
		chance = 0.2
	},
	engineer_efficiency = {
		price = 3,
		class = "engineers",
		damage_factor_krv = 1.1,
		chance = 0.2,
		barrel_factor = 2,
		level = 5,
		icon = DP(27, 20)
	},
	rain_blazing_skies = {
		fireball_count_increase = 2,
		class = "rain",
		damage_increase = 20,
		price = 2,
		level = 1,
		icon = DP(3, 26)
	},
	rain_scorched_earth = {
		price = 2,
		class = "rain",
		level = 2,
		icon = DP(4, 27)
	},
	rain_bigger_and_meaner = {
		range_factor = 1.25,
		cooldown_reduction = 10,
		class = "rain",
		damage_increase = 40,
		price = 3,
		level = 3,
		icon = DP(5, 28)
	},
	rain_blazing_earth = {
		cooldown_reduction = 10,
		class = "rain",
		price = 3,
		level = 4,
		icon = DP(6, 29)
	},
	rain_cataclysm = {
		class = "rain",
		damage_increase = 60,
		price = 3,
		level = 5,
		icon = DP(7, 30)
	},
	reinforcement_level_1 = {
		class = "reinforcements",
		template_name = "re_farmer_well_fed",
		price = 2,
		level = 1,
		icon = DP(28, 21)
	},
	reinforcement_level_2 = {
		class = "reinforcements",
		template_name = "re_conscript",
		price = 3,
		level = 2,
		icon = DP(29, 22)
	},
	reinforcement_level_3 = {
		class = "reinforcements",
		template_name = "re_warrior",
		price = 3,
		level = 3,
		icon = DP(30, 23)
	},
	reinforcement_level_4 = {
		class = "reinforcements",
		template_name = "re_legionnaire",
		price = 3,
		level = 4,
		icon = DP(1, 24)
	},
	reinforcement_level_5 = {
		class = "reinforcements",
		template_name = "re_legionnaire_ranged",
		price = 4,
		level = 5,
		icon = DP(2, 25)
	}
}
upgrades.stack = {
	archer_el_obsidian_heads = {
		class = "archers",
		level = 3
	},
	archer_twin_shot = {
		class = "archers",
		damage_factor = 2,
		chance = 0.1,
		level = 5
	},
	barrack_courage = {
		regen_cooldown = 1,
		regen_factor = 0.01,
		class = "barracks",
		level = 5
	},
	mage_spell_of_penetration = {
		class = "mages",
		chance = 0.1,
		level = 2
	},
	mage_runes_of_power = {
		damage_factor = 2,
		class = "mages",
		chance = 0.1,
		level = 3
	},
	mage_el_empowerment = {
		damage_factor = 3,
		class = "mages",
		chance = 0.05,
		level = 4
	},
	mage_el_alter_reality = {
		class = "mages",
		level = 5
	},
	mage_brilliance = {
		class = "mages",
		level = 5,
		damage_factors = {
			1,
			1.05,
			1.1,
			1.14,
			1.18,
			1.21,
			1.24,
			1.27,
			1.3
		}
	},
	engineer_alchemical_powder = {
		class = "engineers",
		range_factor = 1.1,
		chance = 0.1,
		level = 2
	},
	engineer_shock_and_awe = {
		class = "engineers",
		chance = 0.2,
		level = 5
	}
}
upgrades.all = table.merge(upgrades.list, upgrades.stack, true)

function upgrades:set_levels(levels)
	for k, v in pairs(levels) do
		self.levels[k] = v
	end
end

function upgrades:has_upgrade(name)
	local u = self.all[name]

	return u and u.level <= self.levels[u.class] and (not self.max_level or u.level <= self.max_level)
end

function upgrades:get_upgrade(name)
	local u = self.all[name]

	if not u or u.level > self.levels[u.class] or not self.max_level or u.level > self.max_level then
		return nil
	else
		return u
	end
end

function upgrades:get_total_stars()
	local total = 0

	for k, v in pairs(self.list) do
		total = total + v.price
	end

	return total
end

function upgrades:patch_templates(max_level)
	if max_level then
		self.max_level = max_level
	end

	local u = nil
	local archer_towers = {
		"tower_archer_1",
		"tower_archer_2",
		"tower_archer_3",
		"tower_ranger",
		"tower_musketeer"
	}
	u = self.get_upgrade(self, "archer_salvage")

	if u then
		for _, n in pairs(archer_towers) do
			T(n).tower.refund_factor = u.refund_factor
		end
		for _, n in pairs({
			"tower_totem",
			"tower_crossbow",
			"tower_archer_dwarf",
			"tower_pirate_watchtower",
			"tower_hammerhold",
			"tower_archer_1_krf",
			"tower_archer_2_krf",
			"tower_archer_3_krf",
		}) do
			T(n).attacks.range = math.ceil(T(n).attacks.range * u.range_factor)
		end
		for _, n in pairs({
			"elven_arrow_1",
			"elven_arrow_2",
			"elven_arrow_3",
			"arrow_arcane",
			"arrow_arcane_burst",
			"arrow_arcane_slumber",
			"arrow_silver",
			"arrow_silver_long",
			"arrow_silver_mark",
			"arrow_silver_mark_long"
		}) do
			T(n).bullet.damage_min = math.ceil(T(n).bullet.damage_min * u.damage_factor)
			T(n).bullet.damage_max = math.ceil(T(n).bullet.damage_max * u.damage_factor)
		end
	end

	u = self.get_upgrade(self, "archer_eagle_eye")

	if u then
		for _, n in pairs(archer_towers) do
			T(n).attacks.range = T(n).attacks.range*u.range_factor
		end
		T("aura_ranger_thorn").aura.radius = T("aura_ranger_thorn").aura.radius*u.range_factor
		T("tower_musketeer").attacks.list[2].range = T("tower_musketeer").attacks.list[2].range*u.range_factor
		T("tower_musketeer").attacks.list[3].range = T("tower_musketeer").attacks.list[3].range*u.range_factor
		T("tower_musketeer").attacks.list[4].range = T("tower_musketeer").attacks.list[4].range*u.range_factor

		for _, n in pairs({
			"tower_tree_archer_1",
			"tower_tree_archer_2",
			"tower_tree_archer_3",
			"tower_arcane",
			"tower_silver"
		}) do
			T(n).attacks.range = math.ceil(T(n).attacks.range*u.range_factor)
		end
		
		for _, n in pairs({
			"tower_archer_1_krf",
			"tower_archer_2_krf",
			"tower_archer_3_krf",
		}) do
			T(n).tower.price = math.ceil(T(n).tower.price - u.cost_reduction)
		end
	end

	u = self.get_upgrade(self, "archer_piercing")

	if u then
		for _, n in pairs({
			"tower_shadow_archer",
			"tower_goblirang",
			"tower_bone_flingers"
		}) do
			T(n).attacks.range = math.ceil(T(n).attacks.range * u.range_factor)
		end
		for _, n in pairs({
			"arrow_1",
			"arrow_2",
			"arrow_3",
			"arrow_ranger",
			"shotgun_musketeer",
			"shotgun_musketeer_sniper"
		}) do
			T(n).bullet.reduce_armor = u.reduce_armor_factor
		end
		for _, n in pairs({
			"arrow_crossbow",
			"axe_totem",
			"dwarf_shotgun",
			"pirate_watchtower_shotgun",
			"arrow_hammerhold",
			"arrow_1_krf",
			"arrow_2_krf",
			"arrow_3_krf",
		}) do
			T(n).bullet.damage_min = math.ceil(T(n).bullet.damage_min * u.damage_factor)
			T(n).bullet.damage_max = math.ceil(T(n).bullet.damage_max * u.damage_factor)
		end
	end

	u = self.get_upgrade(self, "archer_far_shots")

	if u then
		for _, p in pairs({
			T("tower_shadow_archer").powers.mark,
			T("tower_shadow_archer").powers.blade,
			T("tower_shadow_archer").powers.crow,
			T("tower_goblirang").powers.bees,
			T("tower_goblirang").powers.stun,
			T("tower_goblirang").powers.big,
			T("tower_bone_flingers").powers.golem,
			T("tower_bone_flingers").powers.skeleton,
			T("tower_bone_flingers").powers.milk
		}) do
			p.price_base = math.floor(p.price_base * u.cost_factor_krv)
			p.price_inc = math.floor(p.price_inc * u.cost_factor_krv)
		end
		for _, n in pairs(archer_towers) do
			T(n).attacks.range = T(n).attacks.range*u.range_factor
		end

		T("aura_ranger_thorn").aura.radius = T("aura_ranger_thorn").aura.radius*u.range_factor
		T("tower_musketeer").attacks.list[2].range = T("tower_musketeer").attacks.list[2].range*u.range_factor
		T("tower_musketeer").attacks.list[3].range = T("tower_musketeer").attacks.list[3].range*u.range_factor
		T("tower_musketeer").attacks.list[4].range = T("tower_musketeer").attacks.list[4].range*u.range_factor

		for _, n in pairs({
			"tower_totem",
			"tower_crossbow",
			"tower_archer_dwarf",
			"tower_pirate_watchtower",
			"tower_hammerhold",
			"tower_archer_1_krf",
			"tower_archer_2_krf",
			"tower_archer_3_krf",
		}) do
			T(n).attacks.range = math.ceil(T(n).attacks.range * u.range_factor_krf)
		end

		for _, n in pairs({
			"arrow_crossbow",
			"axe_totem",
			"dwarf_shotgun",
			"pirate_watchtower_shotgun",
			"arrow_hammerhold",
			"arrow_1_krf",
			"arrow_2_krf",
			"arrow_3_krf",
		}) do
			T(n).bullet.damage_min = math.ceil(T(n).bullet.damage_min * u.damage_factor)
			T(n).bullet.damage_max = math.ceil(T(n).bullet.damage_max * u.damage_factor)
		end
		T("aura_arcane_burst").aura.damage_inc = T("aura_arcane_burst").aura.damage_inc*u.burst_damage_factor
		T("mod_arrow_arcane_slumber").modifier.duration = T("mod_arrow_arcane_slumber").modifier.duration*u.slumber_duration_factor
		for _, chance_group in pairs(T("tower_silver").powers.sentence.chances) do
			for _, chance in pairs(chance_group) do
				chance = chance*u.sentence_chance_factor
			end
		end
		T("mod_arrow_silver_mark").received_damage_factor = T("mod_arrow_silver_mark").received_damage_factor*u.mark_damage_factor
		end

	u = self.get_upgrade(self, "archer_precision")
	if u then
		for _, n in pairs({
			"arrow_shadow_tower",
			"goblirang",
			"bone_flingers_bone"
		}) do
			T(n).bullet.damage_min = math.ceil(T(n).bullet.damage_min * u.damage_factor_krv)
			T(n).bullet.damage_max = math.ceil(T(n).bullet.damage_max * u.damage_factor_krv)
		end
		for _, n in pairs({
			"elven_arrow_1",
			"elven_arrow_2",
			"elven_arrow_3",
			"arrow_arcane",
			"arrow_arcane_burst",
			"arrow_arcane_slumber",
			"arrow_silver",
			"arrow_silver_long",
			"arrow_silver_mark",
			"arrow_silver_mark_long"
		}) do
			local b = T(n).bullet

			if type(b.mod) == "table" then
				table.insert(b.mod, "mod_blood_elves")
			elseif b.mod ~= nil then
				b.mod = {
					b.mod,
					"mod_blood_elves"
				}
			else
				b.mod = "mod_blood_elves"
			end
		end
	end

	local barrack_soldiers = {
		"soldier_militia",
		"soldier_footmen",
		"soldier_knight",
		"soldier_paladin",
		"soldier_barbarian",
		"soldier_elf_kr1",
		"soldier_imperial_guard",
		"soldier_steam_troop",
		"soldier_sasquash_2"
	}
	local barrack_towers = {
		"tower_barrack_1",
		"tower_barrack_2",
		"tower_barrack_3",
		"tower_paladin",
		"tower_barbarian",
		"tower_elf_kr1",
		"tower_imperial_patrol",
		"tower_steam_troop",
		"tower_sasquash_rework"
	}
	u = self.get_upgrade(self, "barrack_survival")

	if u then
		for _, n in pairs(barrack_soldiers) do
			T(n).health.hp_max = km.round(T(n).health.hp_max*u.health_factor)
		end
		for _, n in pairs({
			"soldier_templar",
			"soldier_assassin",
			"soldier_dwarf",
			"soldier_amazona_re",
			"soldier_legionnaire",
			"soldier_djinn",
			"soldier_pirate_captain_2",
			"soldier_pirate_flamer_2",
			"soldier_pirate_anchor_2",
			"soldier_frankenstein",
			"soldier_militia_krf",
			"soldier_footmen_krf",
			"soldier_knight_krf",
		}) do
			T(n).health.armor = T(n).health.armor + u.armor_increase
		end
		for _, n in pairs({
			"tower_elven_barrack_1",
			"tower_elven_barrack_2",
			"tower_elven_barrack_3"
		}) do
			T(n).tower.price = math.ceil(T(n).tower.price*u.cost_factor)
		end
	end

	u = self.get_upgrade(self, "barrack_better_armor")

	if u then
		for _, n in pairs(barrack_soldiers) do
			T(n).health.armor = T(n).health.armor + u.armor_increase
		end
		for _, n in pairs({
			"soldier_templar",
			"soldier_assassin",
			"soldier_dwarf",
			"soldier_amazona_re",
			"soldier_legionnaire",
			"soldier_djinn",
			"soldier_pirate_captain_2",
			"soldier_pirate_flamer_2",
			"soldier_pirate_anchor_2",
			"soldier_frankenstein",
			"soldier_militia_krf",
			"soldier_footmen_krf",
			"soldier_knight_krf",
		}) do
			T(n).health.hp_max = math.ceil(T(n).health.hp_max * u.health_factor)
		end
		for _, n in pairs({
			"soldier_orc_warrior",
			"soldier_dark_knight",
			"soldier_gargoyle",
			"soldier_bone_golem",
			"soldier_elite_harasser",
			"soldier_zombie",
			"soldier_zombie_medium",
			"soldier_zombie_big",
		}) do
			T(n).health.hp_max = math.ceil(T(n).health.hp_max * u.health_factor_krv)
		end
		T("tower_orc_warriors_den").powers.promotion.hp_max = math.floor(T("tower_orc_warriors_den").powers.promotion.hp_max * u.health_factor_krv)
		for _, n in pairs({
			"tower_blade",
			"tower_forest",
			"tower_drow",
			"tower_elven_barrack_1",
			"tower_elven_barrack_2",
			"tower_elven_barrack_3",
			"tower_ewok_rework"
		}) do
			T(n).barrack.rally_range = math.ceil(T(n).barrack.rally_range*u.rally_range_factor)
		end
	end

	u = self.get_upgrade(self, "barrack_improved_deployment")

	if u then
		for _, n in pairs(barrack_soldiers) do
			T(n).health.dead_lifetime = math.floor(T(n).health.dead_lifetime*u.cooldown_factor)
		end

		for _, n in pairs(table.append({
		}, barrack_towers)) do
			T(n).barrack.rally_range = T(n).barrack.rally_range*u.rally_range_factor
		end

		for _, n in pairs({
			"soldier_templar",
			"soldier_assassin",
			"soldier_dwarf",
			"soldier_amazona_re",
			"soldier_legionnaire",
			"soldier_djinn",
			"soldier_pirate_captain_2",
			"soldier_pirate_flamer_2",
			"soldier_pirate_anchor_2",
			"soldier_frankenstein",
			"soldier_militia_krf",
			"soldier_footmen_krf",
			"soldier_knight_krf",
		}) do
			T(n).regen.health = math.ceil(T(n).regen.health * u.regen_factor)
		end

		for _, n in pairs({
			"tower_templar",
			"tower_assassin",
			"tower_barrack_dwarf",
			"tower_barrack_amazonas_re",
			"tower_barrack_pirate_captain",
			"tower_barrack_pirate_captain_2",
			"tower_barrack_pirate_flamer_2",
			"tower_barrack_pirate_anchor_2",
			"tower_barrack_mercenaries",
			"tower_barrack_1_krf",
			"tower_barrack_2_krf",
			"tower_barrack_3_krf",
		}) do
			T(n).barrack.rally_range = math.ceil(T(n).barrack.rally_range * u.rally_range_factor)
		end

		for _, n in pairs({
			"soldier_blade",
			"soldier_forest",
			"soldier_drow",
			"soldier_barrack_1",
			"soldier_barrack_2",
			"soldier_barrack_3",
			"soldier_ewok_re"
		}) do
			T(n).health.armor = T(n).health.armor + u.armor_increase
		end
	end

	u = self.get_upgrade(self, "barrack_survival_2")

	if u then
		for _, p in pairs({
			T("tower_orc_warriors_den").powers.bloodlust,
			T("tower_orc_warriors_den").powers.promotion,
			T("tower_orc_warriors_den").powers.seal,
			T("tower_dark_knights").powers.spike,
			T("tower_dark_knights").powers.shield,
			T("tower_dark_knights").powers.instakill,
			T("tower_elite_harassers").powers.fury,
			T("tower_elite_harassers").powers.arrow,
			T("tower_elite_harassers").powers.backstab,
			T("tower_grim_cemetery").powers.hands,
			T("tower_grim_cemetery").powers.big,
			T("tower_grim_cemetery").powers.pestilence,
		}) do
			p.price_base = math.floor(p.price_base * u.cost_factor_krv)
			p.price_inc = math.floor(p.price_inc * u.cost_factor_krv)
		end
		for _, n in pairs(barrack_soldiers) do
			T(n).health.hp_max = km.round(T(n).health.hp_max*u.health_factor)
		end
		
		for _, n in pairs({
			"soldier_templar",
			"soldier_assassin",
			"soldier_dwarf",
			"soldier_amazona_re",
			"soldier_legionnaire",
			"soldier_djinn",
			"soldier_pirate_captain_2",
			"soldier_pirate_flamer_2",
			"soldier_pirate_anchor_2",
			"soldier_frankenstein",
			"soldier_militia_krf",
			"soldier_footmen_krf",
			"soldier_knight_krf",
		}) do
			T(n).health.armor = T(n).health.armor + u.armor_increase
			T(n).health.dead_lifetime = T(n).health.dead_lifetime - u.respawn_reduction
		end
		T("soldier_blade").melee.attacks[1].mod = "mod_moon_forged_blades_blade"
		T("soldier_blade").melee.attacks[2].mod = "mod_moon_forged_blades_blade"
		T("soldier_blade").melee.attacks[3].mod = "mod_moon_forged_blades_blade"
		T("soldier_forest").melee.attacks[1].mod = "mod_moon_forged_blades_forest"
		T("soldier_drow").melee.attacks[1].mod = "mod_moon_forged_blades_drow"
		T("soldier_barrack_1").melee.attacks[1].mod = "mod_moon_forged_blades_barrack_1"
		T("soldier_barrack_2").melee.attacks[1].mod = "mod_moon_forged_blades_barrack_2"
		T("soldier_barrack_3").melee.attacks[1].mod = "mod_moon_forged_blades_barrack_3"
		T("soldier_ewok_re").melee.attacks[1].mod = "mod_moon_forged_blades_ewok_re"
	end

	u = self.get_upgrade(self, "barrack_barbed_armor")

	if u then
		for _, n in pairs({
			"soldier_orc_warrior",
			"soldier_dark_knight",
			"soldier_elite_harasser",
			"soldier_zombie",
			"soldier_zombie_medium",
			"soldier_zombie_big",
		}) do
			T(n).melee.attacks[1].damage_min = math.floor(T(n).melee.attacks[1].damage_min * u.damage_factor)
			T(n).melee.attacks[1].damage_max = math.floor(T(n).melee.attacks[1].damage_max * u.damage_factor)
		end
		T("arrow_elite_harasser").bullet.damage_max = math.floor(T("arrow_elite_harasser").bullet.damage_max * u.damage_factor)
		T("arrow_elite_harasser").bullet.damage_min = math.floor(T("arrow_elite_harasser").bullet.damage_min * u.damage_factor)
		T("tower_orc_warriors_den").powers.promotion.damage_min = math.floor(T("tower_orc_warriors_den").powers.promotion.damage_min * u.damage_factor)
		T("tower_orc_warriors_den").powers.promotion.damage_max = math.floor(T("tower_orc_warriors_den").powers.promotion.damage_max * u.damage_factor)
		for _, n in pairs(barrack_soldiers) do
			T(n).health.spiked_armor = u.spiked_armor_factor
		end

		for _, n in pairs({
			"soldier_elemental",
			"soldier_elf",
			"soldier_sasquash_2",
			"soldier_imperial_guard",
			"soldier_magnus_illusion",
			"soldier_ingvar_ancestor",
			"soldier_alleria_wildcat",
			"hero_alleria",
			"hero_gerald",
			"hero_bolin",
			"hero_magnus",
			"hero_ignus",
			"hero_malik",
			"hero_denas",
			"hero_ingvar",
			"hero_elora",
			"hero_oni",
			"hero_hacksaw",
			"hero_thor",
			"hero_viper",
			"hero_voltaire",
			"soldier_ancient_guardian",
			"soldier_elf_kr1"
		}) do
			T(n).health.spiked_armor = u.spiked_armor_factor
		end

		for _, n in pairs({
			"soldier_blade",
			"soldier_forest",
			"soldier_drow",
			"soldier_barrack_1",
			"soldier_barrack_2",
			"soldier_barrack_3",
			"soldier_ewok_re"
		}) do
			T(n).revive.disabled = nil
		end

		for _, n in pairs({
			"re_farmer",
			"re_farmer_well_fed",
			"re_conscript",
			"re_warrior",
			"re_legionnaire",
			"re_legionnaire_ranged"
		}) do
			for i = 1, 3, 1 do
				T(n .. "_" .. i).health.spiked_armor = u.spiked_armor_factor
			end
		end
	end

	local mage_towers = {
		"tower_mage_1",
		"tower_mage_2",
		"tower_mage_3",
		"tower_arcane_wizard",
		"tower_sorcerer",
		"tower_time_wizard",
	}
	u = self.get_upgrade(self, "mage_spell_reach")

	if u then
		for _, n in pairs(mage_towers) do
			T(n).attacks.range = T(n).attacks.range*u.range_factor
		end

		for _, n in pairs({
			"tower_archmage",
			"tower_necromancer",
			"tower_mage_1_krf",
			"tower_mage_2_krf",
			"tower_mage_3_krf",
		}) do
			T(n).attacks.range = math.ceil(T(n).attacks.range * u.range_factor)
		end
		for _, n in pairs({
			"tower_wild_magus",
			"tower_high_elven",
			"tower_faerie_dragon",
			"tower_eldritch_mage_1",
			"tower_eldritch_mage_2",
			"tower_eldritch_mage_3",
		}) do
			T(n).attacks.range = math.ceil(T(n).attacks.range*u.range_factor2)
		end
		T("soldier_baby_ashbite").ranged.attacks[1].max_range = math.ceil(T("soldier_baby_ashbite").ranged.attacks[1].max_range*u.range_factor2)
		T("soldier_baby_ashbite").ranged.attacks[2].max_range = math.ceil(T("soldier_baby_ashbite").ranged.attacks[2].max_range*u.range_factor2)
		T("soldier_baby_ashbite").ranged.attacks[3].max_range = math.ceil(T("soldier_baby_ashbite").ranged.attacks[3].max_range*u.range_factor2)
	end

	u = self.get_upgrade(self, "mage_arcane_shatter")

	if u then
		for _, n in pairs({
			"bolt_1",
			"bolt_2",
			"bolt_3",
			"bolt_sorcerer",
			"ray_arcane",
			"bolt_elora_freeze",
			"bolt_elora_slow",
			"bolt_magnus",
			"bolt_magnus_illusion",
			"bolt_time_wizard",
			"ray_sunray_mini"
		}) do
			local mods = {
				u.mod
			}
			local b = T(n).bullet

			if b.mod then
				table.insert(mods, b.mod)
			end

			if b.mods then
				table.append(mods, b.mods)
			end

			b.mod = nil
			b.mods = mods
		end
		for _, n in pairs({
			"bolt_wild_magus",
			"bolt_high_elven_strong",
			"bolt_high_elven_weak",
			"bolt_faerie_dragon",
			"fireball_baby_ashbite",
			"bolt_elves_1",
			"bolt_elves_2",
			"bolt_elves_3"
		}) do
			T(n).bullet.damage_min = math.ceil(T(n).bullet.damage_min*u.damage_factor)
			T(n).bullet.damage_max = math.ceil(T(n).bullet.damage_max*u.damage_factor)
		end
	end

	u = self.get_upgrade(self, "mage_hermetic_study")

	if u then
		for _, n in pairs(mage_towers) do
			T(n).tower.price = math.ceil(T(n).tower.price*u.cost_factor)
		end
		T("tower_sunray_mini").tower.price = math.ceil(T("tower_sunray_mini").tower.price*u.cost_factor)

		for _, n in pairs({
			"bolt_archmage",
			"bolt_necromancer",
			"bolt_1_krf",
			"bolt_2_krf",
			"bolt_3_krf",
		}) do
			T(n).bullet.damage_min = math.ceil(T(n).bullet.damage_min * u.damage_factor)
			T(n).bullet.damage_max = math.ceil(T(n).bullet.damage_max * u.damage_factor)
		end
		T("ray_neptune").bullet.damage_min_levels[1] = math.ceil(T("ray_neptune").bullet.damage_min_levels[1]*u.damage_factor)
		T("ray_neptune").bullet.damage_min_levels[2] = math.ceil(T("ray_neptune").bullet.damage_min_levels[2]*u.damage_factor)
		T("ray_neptune").bullet.damage_min_levels[3] = math.ceil(T("ray_neptune").bullet.damage_min_levels[3]*u.damage_factor)
		T("ray_neptune").bullet.damage_max_levels[1] = math.ceil(T("ray_neptune").bullet.damage_max_levels[1]*u.damage_factor)
		T("ray_neptune").bullet.damage_max_levels[2] = math.ceil(T("ray_neptune").bullet.damage_max_levels[2]*u.damage_factor)
		T("ray_neptune").bullet.damage_max_levels[3] = math.ceil(T("ray_neptune").bullet.damage_max_levels[3]*u.damage_factor)
		for _, n in pairs({
			"tower_wild_magus",
			"tower_high_elven",
			"tower_faerie_dragon",
			"tower_eldritch_mage_1",
			"tower_eldritch_mage_2",
			"tower_eldritch_mage_3",
		}) do
			T(n).attacks.range = math.ceil(T(n).attacks.range*u.range_factor)
		end
		T("soldier_baby_ashbite").ranged.attacks[1].max_range = math.ceil(T("soldier_baby_ashbite").ranged.attacks[1].max_range*u.range_factor)
		T("soldier_baby_ashbite").ranged.attacks[2].max_range = math.ceil(T("soldier_baby_ashbite").ranged.attacks[2].max_range*u.range_factor)
		T("soldier_baby_ashbite").ranged.attacks[3].max_range = math.ceil(T("soldier_baby_ashbite").ranged.attacks[3].max_range*u.range_factor)
	end

	u = self.get_upgrade(self, "mage_empowered_magic")

	if u then
		for _, p in pairs({
			T("tower_infernal_mage").powers.teleport,
			T("tower_infernal_mage").powers.curse,
			T("tower_infernal_mage").powers.fissure,
			T("tower_spectres_mausoleum").powers.garg,
			T("tower_spectres_mausoleum").powers.poss,
			T("tower_spectres_mausoleum").powers.spectral,
			T("tower_orc_shaman").powers.vines,
			T("tower_orc_shaman").powers.shock,
			T("tower_orc_shaman").powers.meteor,
		}) do
			p.price_base = math.floor(p.price_base * u.cost_factor_krv)
			p.price_inc = math.floor(p.price_inc * u.cost_factor_krv)
		end
		for _, n in pairs({
			"bolt_1",
			"bolt_2",
			"bolt_3",
			"bolt_sorcerer",
			"bolt_time_wizard",
			"ray_sunray_mini"
		}) do
			T(n).bullet.damage_min = math.ceil(T(n).bullet.damage_min*u.damage_factor)
			T(n).bullet.damage_max = math.ceil(T(n).bullet.damage_max*u.damage_factor)
		end
		T("mod_ray_arcane").dps.damage_min = math.ceil(T("mod_ray_arcane").dps.damage_min*u.damage_factor)
		T("mod_ray_arcane").dps.damage_max = math.ceil(T("mod_ray_arcane").dps.damage_max*u.damage_factor)

		for _, p in pairs({
			T("tower_archmage").powers.twister,
			T("tower_archmage").powers.blast,
			T("tower_necromancer").powers.pestilence,
			T("tower_necromancer").powers.rider,
			T("tower_neptune").powers.ray
		}) do
			p.price_base = math.floor(p.price_base * u.cost_factor)
			p.price_inc = math.floor(p.price_inc * u.cost_factor)
		end
	end

	u = self.get_upgrade(self, "mage_slow_curse")

	if u then
		for _, n in pairs({
			"bolt_infernal_mage",
			"bolt_spectres",
			"bolt_orc_shaman"
		}) do
			T(n).bullet.damage_min = math.ceil(T(n).bullet.damage_min * u.damage_factor_krv)
			T(n).bullet.damage_max = math.ceil(T(n).bullet.damage_max * u.damage_factor_krv)
		end
		for _, n in pairs({
			"bolt_1",
			"bolt_2",
			"bolt_3",
			"bolt_sorcerer",
			"ray_arcane",
			"bolt_magnus",
			"bolt_elora_freeze",
			"bolt_elora_slow",
			"bolt_magnus_illusion",
			"bolt_time_wizard",
			"ray_sunray_mini"
		}) do
			local mods = {
				u.mod
			}
			local b = T(n).bullet

			if b.mod then
				table.insert(mods, b.mod)
			end

			if b.mods then
				table.append(mods, b.mods)
			end

			b.mod = nil
			b.mods = mods
		end
	end

	local engineer_towers = {
		"tower_engineer_1",
		"tower_engineer_2",
		"tower_engineer_3",
		"tower_bfg",
		"tower_tesla"
	}
	local engineer_bombs = {
		"bomb",
		"bomb_dynamite",
		"bomb_black",
		"airstrike_steam_troop",
		"bomb_steam_troop"
	}
	u = self.get_upgrade(self, "engineer_concentrated_fire")

	if u then
		for _, n in pairs(engineer_bombs) do
			T(n).bullet.damage_min = math.ceil(T(n).bullet.damage_min*u.damage_factor)
			T(n).bullet.damage_max = math.ceil(T(n).bullet.damage_max*u.damage_factor)
		end
		T("bomb_bfg").bullet.damage_min = math.floor(T("bomb_bfg").bullet.damage_min*u.damage_factor)
		T("bomb_bfg").bullet.damage_max = math.floor(T("bomb_bfg").bullet.damage_max*u.damage_factor)
		T("ray_tesla").bounce_damage_min = math.floor(T("ray_tesla").bounce_damage_min*u.damage_factor)
		T("ray_tesla").bounce_damage_max = math.floor(T("ray_tesla").bounce_damage_max*u.damage_factor)

		for _, n in pairs({
			"tower_dwaarp",
			"tower_frankenstein",
			"tower_sandworm",
			"tower_engineer_1_krf",
			"tower_engineer_2_krf",
			"tower_engineer_3_krf",
		}) do
			T(n).attacks.range = math.ceil(T(n).attacks.range * u.range_factor)
		end
		T("soldier_mecha").attacks.list[1].max_range = T("soldier_mecha").attacks.list[1].max_range * u.range_factor
		T("soldier_mecha").attacks.list[2].max_range = T("soldier_mecha").attacks.list[2].max_range * u.range_factor
		for _, n in pairs({
			"rock_druid",
			"rock_entwood",
			"rock_1",
			"rock_2",
			"rock_3"
		}) do
			T(n).bullet.damage_min = math.ceil(T(n).bullet.damage_min*u.damage_factor)
			T(n).bullet.damage_max = math.ceil(T(n).bullet.damage_max*u.damage_factor)
		end
		T("aura_razor_edge").aura.damage_min = T("aura_razor_edge").aura.damage_min*u.damage_factor
		T("aura_razor_edge").aura.damage_max = T("aura_razor_edge").aura.damage_max*u.damage_factor
	end

	u = self.get_upgrade(self, "engineer_range_finder")

	if u then
		for _, n in pairs({
			"bomb_rr_fragment",
			"bomb_rr_nitro",
			"bomb_rr"
		}) do
			T(n).bullet.damage_radius = math.ceil(T(n).bullet.damage_radius*u.radius_factor_krv)
		end
		for _, n in pairs({
			"tower_engineer_1",
			"tower_engineer_2",
			"tower_engineer_3",
			"tower_bfg",
			"tower_tesla"
		}) do
			T(n).attacks.range = math.ceil(T(n).attacks.range*u.range_factor)
		end
		T("ray_frankenstein").bounce_damage_factor = 1
		T("ray_frankenstein").bounce_damage_factor_min = 1
		T("ray_frankenstein").bounce_damage_factor_inc = 0
		T("decal_rr_mine").radius = T("decal_rr_mine").radius*u.radius_factor_krv
		T("tower_bfg").attacks.list[1].range = math.ceil(T("tower_bfg").attacks.list[1].range*u.range_factor)
		T("tower_bfg").attacks.list[2].range_base = math.ceil(T("tower_bfg").attacks.list[2].range_base*u.range_factor)
		T("tower_tesla").attacks.list[1].range = math.ceil(T("tower_tesla").attacks.list[1].range*u.range_factor)
		for _, n in pairs({
			"bomb_mecha"
		}) do
			T(n).up_alchemical_powder_chance = u.chance
		end
		for _, n in pairs({
			"rock_druid",
			"rock_entwood",
			"rock_1",
			"rock_2",
			"rock_3"
		}) do
			T(n).bullet.damage_radius = math.ceil(T(n).bullet.damage_radius*u.damage_area_factor)
		end
		T("aura_razor_edge").aura.radius = math.ceil(T("aura_razor_edge").aura.radius*u.damage_area_factor)
	end

	u = self.get_upgrade(self, "engineer_field_logistics")

	if u then
		for _, n in pairs(engineer_towers) do
			T(n).tower.price = math.floor(T(n).tower.price*u.cost_factor)
		end

		for _, n in pairs({
			"bomb_mecha",
			"ray_frankenstein",
			"bomb_krf",
			"bomb_dynamite_krf",
			"bomb_black_krf",
			"bomb_pirate_camp"
		}) do
			T(n).bullet.damage_min = math.ceil(T(n).bullet.damage_min * u.damage_factor)
			T(n).bullet.damage_max = math.ceil(T(n).bullet.damage_max * u.damage_factor)
		end
		T("tower_dwaarp").attacks.list[1].damage_min = T("tower_dwaarp").attacks.list[1].damage_min * u.damage_factor
		T("tower_dwaarp").attacks.list[1].damage_max = T("tower_dwaarp").attacks.list[1].damage_max * u.damage_factor
		T("mod_teeth").dps.damage_min = T("mod_teeth").dps.damage_min * u.damage_factor
		T("mod_teeth").dps.damage_max = T("mod_teeth").dps.damage_max * u.damage_factor
		for _, n in pairs({
			"tower_druid",
			"tower_entwood",
			"tower_bastion",
			"tower_rock_thrower_1",
			"tower_rock_thrower_2",
			"tower_rock_thrower_3",
		}) do
			T(n).attacks.range = math.ceil(T(n).attacks.range*u.range_factor)
		end
	end

	u = self.get_upgrade(self, "engineer_industrialization")

	if u then
		for _, p in pairs({
			T("tower_rocket_riders").powers.mine,
			T("tower_rocket_riders").powers.nitro,
			T("tower_rocket_riders").powers.engine,
			T("tower_melting_furnace").powers.coal,
			T("tower_melting_furnace").powers.fuel,
			T("tower_melting_furnace").powers.heat
		}) do
			p.price_base = math.floor(p.price_base * u.cost_factor_krv)
			p.price_inc = math.floor(p.price_inc * u.cost_factor_krv)
		end
		for _, n in pairs({
			"tower_bfg",
			"tower_tesla"
		}) do
			for pk, pv in pairs(T(n).powers) do
				pv.price_base = math.floor(pv.price_base*u.cost_factor)
				pv.price_inc = math.floor(pv.price_inc*u.cost_factor)
			end
		end

		for _, a in pairs({
			T("tower_dwaarp").attacks.list[2],
			T("tower_dwaarp").attacks.list[3],
			T("soldier_mecha").attacks.list[2],
			T("soldier_mecha").attacks.list[3],
			T("tower_frankenstein").attacks.list[1],
			T("soldier_frankenstein").melee.attacks[2]
		}) do
			a.cooldown = a.cooldown * u.cooldown_factor
		end
		for _, n in pairs({
			"rock_druid",
			"rock_entwood",
			"rock_1",
			"rock_2",
			"rock_3"
		}) do
			T(n).bullet.damage_type = bit.bor(DAMAGE_TRUE, DAMAGE_FX_EXPLODE)
		end
	end

	u = self.get_upgrade(self, "engineer_efficiency")

	if u then
		T("tower_melting_furnace").attacks.list[1].damage_min = T("tower_melting_furnace").attacks.list[1].damage_min * u.damage_factor_krv
		T("tower_melting_furnace").attacks.list[1].damage_max = T("tower_melting_furnace").attacks.list[1].damage_max * u.damage_factor_krv
		T("mod_furnace_fuel").damage_min = math.floor(T("mod_furnace_fuel").damage_min * u.damage_factor_krv)
		T("mod_furnace_fuel").damage_max = math.floor(T("mod_furnace_fuel").damage_max * u.damage_factor_krv)
		for _, n in pairs({
			"bomb_rr"
		}) do
			T(n).bullet.damage_min = math.ceil(T(n).bullet.damage_min * u.damage_factor_krv)
			T(n).bullet.damage_max = math.ceil(T(n).bullet.damage_max * u.damage_factor_krv)
		end
		T("bomb").bullet.damage_min = T("bomb").bullet.damage_max
		T("bomb_dynamite").bullet.damage_min = T("bomb_dynamite").bullet.damage_max
		T("bomb_black").bullet.damage_min = T("bomb_black").bullet.damage_max
		T("bomb_bfg").bullet.damage_min = T("bomb_bfg").bullet.damage_max
		T("bomb_bfg_fragment").bullet.damage_min = T("bomb_bfg_fragment").bullet.damage_max
		T("ray_tesla").bounce_damage_factor = 1
		T("ray_tesla").bounce_damage_factor_min = 1
		T("bomb_musketeer").bullet.damage_min_inc = T("bomb_musketeer").bullet.damage_max_inc
		T("denas_catapult_rock").bullet.damage_min = T("denas_catapult_rock").bullet.damage_max
		T("bomb_mine_bolin").bullet.damage_min = T("bomb_mine_bolin").bullet.damage_max
		T("bomb_steam_troop").bullet.damage_min = T("bomb_steam_troop").bullet.damage_max
		T("airstrike_steam_troop").bullet.damage_min = T("airstrike_steam_troop").bullet.damage_max

		for _, n in pairs({
			"dwarf_barrel",
			"pirate_watchtower_bomb",
			"bomb_mecha",
			"ray_frankenstein",
			"bomb_krf",
			"bomb_dynamite_krf",
			"bomb_black_krf",
			"bomb_pirate_camp"
		}) do
			T(n).up_shock_and_awe_chance = u.chance
		end
		
		for _, n in pairs({
			"rock_druid",
			"rock_entwood",
			"rock_1",
			"rock_2",
			"rock_3"
		}) do
			T(n).bullet.mod = "mod_shocking_impact"
		end
		T("aura_razor_edge").aura.mod = "mod_shocking_impact"
	end

	T("power_fireball_control").user_power.level = self.levels.rain
	u = self.get_upgrade(self, "rain_blazing_skies")

	if u then
		T("power_fireball_control").fireball_count = T("power_fireball_control").fireball_count + u.fireball_count_increase
		T("power_fireball").bullet.damage_min = T("power_fireball").bullet.damage_min + u.damage_increase
		T("power_fireball").bullet.damage_max = T("power_fireball").bullet.damage_max + u.damage_increase
	end

	u = self.get_upgrade(self, "rain_scorched_earth")

	if u then
		T("power_fireball").scorch_earth = true
	end

	u = self.get_upgrade(self, "rain_bigger_and_meaner")

	if u then
		T("power_fireball_control").cooldown = T("power_fireball_control").cooldown - u.cooldown_reduction
		T("power_fireball").bullet.damage_radius = T("power_fireball").bullet.damage_radius*u.range_factor
		T("power_fireball").bullet.damage_min = T("power_fireball").bullet.damage_min + u.damage_increase
		T("power_fireball").bullet.damage_max = T("power_fireball").bullet.damage_max + u.damage_increase
	end

	u = self.get_upgrade(self, "rain_blazing_earth")

	if u then
		T("power_fireball_control").cooldown = T("power_fireball_control").cooldown - u.cooldown_reduction
		T("power_scorched_earth").aura.damage_min = 20
		T("power_scorched_earth").aura.damage_max = 30
		T("power_scorched_earth").aura.duration = 10
		T("power_scorched_water").aura.damage_min = 20
		T("power_scorched_water").aura.damage_max = 30
		T("power_scorched_water").aura.duration = 10
	end

	u = self.get_upgrade(self, "rain_cataclysm")

	if u then
		T("power_fireball_control").cataclysm_count = 5
		T("power_fireball").bullet.damage_min = T("power_fireball").bullet.damage_min + u.damage_increase
		T("power_fireball").bullet.damage_max = T("power_fireball").bullet.damage_max + u.damage_increase
	end

	if 0 < self.levels.reinforcements then
		local rl = math.min(self.levels.reinforcements, self.max_level)
		u = self.get_upgrade(self, "reinforcement_level_" .. rl)

		if u then
			for i = 1, 3, 1 do
				E:set_template("re_current_" .. i, T(u.template_name .. "_" .. i))
			end
		end
	end
end

return upgrades
