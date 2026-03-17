-- chunkname: @./kr1/balance/rebbbalanced.lua

local bit = require("bit")
local bor = bit.bor

local function fts(v)
	return v / FPS
end

return {
	aura_breath_baby_ashbite = {
		aura = {
			damage_inc = 10,
			damage_max = 5,
			damage_min = 5
		}
	},
	aura_fiery_mist_baby_ashbite = {
		aura = {
			damage_inc = 1.5625,
			damage_max = 4.6875,
			damage_min = 4.6875,
			duration = 4
		}
	},
	aura_fiery_nut = {
		aura = {
			duration = 6
		}
	},
	arrow_hammerhold = {
		bullet = {
			damage_max = 50,
			damage_min = 38
		}
	},
	aura_demon_death = {
		aura = {
			damage_max = 75,
			damage_min = 75
		}
	},
	aura_demon_mage_death = {
		aura = {
			damage_max = 300,
			damage_min = 300
		}
	},
	aura_demon_wolf_death = {
		aura = {
			damage_max = 100,
			damage_min = 100
		}
	},
	aura_flareon_death = {
		aura = {
			damage_max = 60,
			damage_min = 60
		}
	},
	aura_goblin_zapper_death = {
		aura = {
			damage_max = 100,
			damage_min = 100
		}
	},
	aura_gulaemon_death = {
		aura = {
			damage_max = 300,
			damage_min = 300
		}
	},
	aura_ingvar_bear_regenerate = {
		regen = {
			cooldown = 0.1,
			health = 5
		}
	},
	aura_malik_fissure = {
		aura = {
			damage_radius = 80
		}
	},
	aura_razor_edge = {
		aura = {
			radius = 75
		}
	},
	aura_teleport_arcane = {
		aura = {
			radius = 50
		}
	},
	aura_tesla_overcharge = {
		aura = {
			damage_max = 15,
			damage_min = 5,
			damage_inc = 5
		}
	},
	axe_barbarian = {
		bullet = {
			damage_inc = 16
		}
	},
	bolt_faerie_dragon = {
		bullet = {
			damage_max = 45,
			damage_min = 25,
			damage_type = DAMAGE_MAGICAL
		}
	},
	bolt_necromancer = {
		bullet = {
			damage_max = 55,
			damage_min = 35,
			max_speed = 300
		}
	},
	bomb_bfg = {
		bullet = {
			damage_max = 132,
			damage_min = 66,
			damage_radius = 85
		}
	},
	bomb_bfg_cluster = {
		bullet = {
			fragment_node_spread = 7
		}
	},
	bomb_bfg_fragment = {
		bullet = {
			damage_radius = 60
		}
	},
	bomb_mine_bolin = {
		bullet = {
			damage_radius = 55
		}
	},
	dagger_drow = {
		bullet = {
			damage_max = 40,
			damage_min = 20
		}
	},
	decal_bolin_mine = {
		radius = 55
	},
	death_rider_aura = {
		render = {
			sprites = {
				{
					z = 3000
				}
			}
		},
		aura = {
			allowed_templates = {
				"soldier_skeleton",
				"soldier_skeleton_knight",
				"soldier_frankenstein",
				"soldier_ingvar_ancestor",
				"soldier_magnus_illusion",
				"soldier_spectral_knight_pos",
				"soldier_skeleton_knight_pos",
				"soldier_skeleton_pos",
				"soldier_bone_golem",
				"soldier_flingers_skeleton",
				"soldier_flingers_skeleton_warrior",
				"soldier_zombie",
				"soldier_zombie_medium",
				"soldier_zombie_big"
			}
		}
	},
	druid_shooter_nature = {
		attacks = {
			list = {
				{
					cooldown = 12,
				}
			}
		}
	},
	druid_shooter_sylvan = {
		attacks = {
			list = {
				{
					cooldown = 10,
					excluded_templates = {
						"enemy_ogre_magi",
						"enemy_goblin",
						"enemy_fat_orc",
						"enemy_zombie",
						"enemy_skeleton",
						"enemy_wolf_small",
						"enemy_halloween_zombie",
						"enemy_spider_tiny",
						"enemy_spider_rotten_tiny"
					}
				}
			}
		}
	},
	dwarf_barrel = {
		bullet = {
			damage_radius = 80,
			damage_radius_inc = 0
		}
	},
	hero_10yr = {
		hero = {
			level_stats = {
				armor = {
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0
				},
			},
		},
	},
	hero_alleria = {
		hero = {
			level_stats = {
				armor = {
					0.10000000000000001,
					0.14999999999999999,
					0.14999999999999999,
					0.14999999999999999,
					0.20000000000000001,
					0.20000000000000001,
					0.20000000000000001,
					0.25,
					0.25,
					0.29999999999999999
				},
				hp_max = {
					320,
					340,
					360,
					380,
					400,
					420,
					440,
					460,
					480,
					500
				},
				melee_damage_max = {
					13,
					15,
					18,
					20,
					22,
					25,
					27,
					30,
					34,
					38
				},
				melee_damage_min = {
					9,
					10,
					12,
					13,
					14,
					16,
					17,
					19,
					21,
					24
				},
				ranged_damage_max = {
					13,
					15,
					18,
					20,
					22,
					25,
					27,
					30,
					34,
					38
				},
				ranged_damage_min = {
					9,
					10,
					12,
					13,
					14,
					16,
					17,
					19,
					21,
					24
				},
				regen_health = {
					80,
					85,
					90,
					95,
					100,
					105,
					110,
					115,
					120,
					125
				}
			},
			skills = {
				callofwild = {
					damage_inc = 5,
					damage_max_base = 20,
					damage_min_base = 10,
					hp_base = 200
				},
				multishot = {
					count_base = 2,
					count_inc = 3,
					xp_gain = {
						50,
						100,
						150
					}
				}
			}
		},
		melee = {
			attacks = {
				{
					cooldown = 0.69999999999999996,
					xp_gain_factor = 1.8
				}
			}
		},
		ranged = {
			attacks = {
				{
					cooldown = 0.69999999999999996,
					max_range = 180
				},
				{
					max_range = 180
				}
			}
		},
		timed_attacks = {
			list = {
				{
					cooldown = 10
				}
			}
		}
	},
	hero_bolin = {
		hero = {
			skills = {
				mines = {
					damage_max = {
						nil,
						120,
						180
					},
					damage_min = {
						60,
						120,
						180
					}
				},
				tar = {
					duration = {
						10,
						15,
						20
					},
				}
			}
		},
		melee = {
			attacks = {
				{
					xp_gain_factor = 2.25
				}
			},
			range = 45
		},
		motion = {
			max_speed = 57
		},
		timed_attacks = {
			list = {
				{
					min_range = 45,
					xp_gain_factor = 1.2
				},
				{
					cooldown = 24.899999999999999,
					max_range = 80,
					min_range = 10
				},
				{
					count = 8.9999999999999999e+099,
					max_range = 45,
					node_offset = {
						-6,
						6
					}
				}
			}
		}
	},
	hero_denas = {
		hero = {
			level_stats = {
				melee_damage_max = {
					28,
					33,
					37,
					41,
					45,
					50,
					54,
					58,
					62,
					67
				},
				melee_damage_min = {
					20,
					25,
					29,
					33,
					36,
					39,
					42,
					46,
					50,
					55
				},
				ranged_damage_max = {
					28,
					33,
					37,
					41,
					45,
					50,
					54,
					58,
					62,
					67
				},
				ranged_damage_min = {
					20,
					25,
					29,
					33,
					36,
					39,
					42,
					46,
					50,
					55
				}
			},
			skills = {
				catapult = {
					count = {
						4,
						8,
						12
					},
					damage_min = {
						30,
						40,
						50
					},
					xp_gain = {
						50,
						100,
						150
					}
				},
				tower_buff = {
					duration = {
						11,
						11
					},
					xp_gain = {
						25,
						50,
						75
					}
				}
			}
		},
		timed_attacks = {
			list = {
				{
					cooldown = 0.67000000000000004,
					max_range = 180
				}
			}
		}
	},
	hero_elora = {
		hero = {
			level_stats = {
				ranged_damage_max = {
					36,
					39,
					43,
					46,
					50,
					54,
					57,
					61,
					64,
					67
				},
				ranged_damage_min = {
					25,
					27,
					30,
					33,
					36,
					38,
					41,
					44,
					46,
					49
				}
			},
		},
		melee = {
			attacks = {
				damage_type = DAMAGE_PHYSICAL
			}
		}
	},
	hero_gerald = {
		dodge = {
			low_chance_factor = 0.5
		},
		melee = {
			attacks = {
				{
					xp_gain_factor = 2
				},
				{
					xp_gain_factor = 2
				}
			},
			range = 55
		}
	},
	hero_hacksaw = {
		hero = {
			level_stats = {
				armor = {
					nil,
					nil,
					0.55000000000000004,
					0.55000000000000004,
					nil,
					nil,
					0.65000000000000002,
					0.65000000000000002,
					0.65000000000000002,
					0.69999999999999996
				},
				melee_damage_max = {
					22,
					24,
					26,
					28,
					30,
					32,
					34,
					36,
					38,
					40
				},
				melee_damage_min = {
					15,
					16,
					18,
					19,
					20,
					21,
					22,
					23,
					24,
					25
				}
			},
			skills = {
				sawblade = {
					xp_gain = {
						75,
						150,
						225
					}
				},
				timber = {
					xp_gain = {
						300,
						600,
						1000
					}
				}
			}
		},
		melee = {
			range = 55
		}
	},
	hero_ingvar = {
		hero = {
			level_stats = {
				armor = {
					[9] = 0.25,
					[10] = 0.29999999999999999
				},
				hp_max = {
					440,
					480,
					520,
					560,
					600,
					640,
					680,
					720,
					760,
					800
				},
				regen_health = {
					110,
					120,
					130,
					140,
					150,
					160,
					170,
					180,
					190,
					200
				}
			},
			skills = {
				ancestors_call = {
					count = {
						2,
						3,
						4
					},
					damage_max = {
						20,
						25,
						30
					},
					damage_min = {
						10,
						15,
						20
					},
					hp_max = {
						200,
						300,
						400
					}
				},
				bear = {
					damage_max = {
						60,
						75,
						90
					},
					damage_min = {
						40,
						50,
						60
					}
				}
			}
		},
		melee = {
			range = 55
		},
		timed_attacks = {
			list = {
				{
					cooldown = 17.333333333333332
				},
				{
					transform_health_factor = 0.75
				}
			}
		}
	},
	hero_magnus = {
		hero = {
			level_stats = {
				ranged_damage_max = {
					nil,
					nil,
					35,
					38,
					40,
					43,
					46,
					49,
					52,
					56
				},
				ranged_damage_min = {
					16,
					18,
					20,
					22,
					24,
					25,
					28,
					30,
					33,
					35
				}
			},
			skills = {
				arcane_rain = {
					count = {
						12,
						18,
						24
					}
				},
				mirage = {
					damage_factor = 0.5
				}
			}
		},
		ranged = {
			attacks = {
				{
					max_range = 165
				}
			}
		},
		teleport = {
			min_distance = 50
		},
		timed_attacks = {
			list = {
				nil,
				{
					max_range = 150
				}
			}
		}
	},
	hero_malik = {
		hero = {
			level_stats = {
				armor = {
					nil,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0
				}
			},
			skills = {
				fissure = {
					damage_max = {
						20,
						30,
						40
					},
					damage_min = {
						20,
						30,
						40
					},
					xp_gain = {
						100,
						200,
						300
					}
				},
				smash = {
					damage_max = {
						nil,
						65,
						90
					},
					damage_min = {
						40,
						65,
						90
					}
				}
			}
		},
		melee = {
			attacks = {
				{
					xp_gain_factor = 3
				},
				{
					xp_gain_factor = 3
				},
				{
					min_count = 1
				},
				{
					damage_radius = 50
				}
			},
			range = 55
		}
	},
	hero_oni = {
		hero = {
			level_stats = {
				armor = {
					0.20000000000000001,
					0.20000000000000001,
					0.20000000000000001,
					0.29999999999999999,
					0.29999999999999999,
					0.29999999999999999,
					0.40000000000000002,
					0.40000000000000002,
					0.5,
					0.5
				},
				melee_damage_max = {
					26,
					30,
					36,
					38,
					41,
					45,
					49,
					53,
					56,
					60
				},
				melee_damage_min = {
					18,
					20,
					24,
					26,
					28,
					30,
					33,
					36,
					38,
					40
				}
			},
			skills = {
				death_strike = {
					chance = {
						0,
						0,
						0
					},
					damage = {
						200,
						400,
						600
					},
					xp_gain = {
						150,
						250,
						350
					}
				}
			}
		},
		melee = {
			range = 55
		}
	},
	hero_thor = {
		health = {
			magic_armor = 0.25
		},
		hero = {
			skills = {
				chainlightning = {
					count = {
						1,
						2,
						3
					},
					xp_gain = {
						nil,
						50,
						50
					}
				},
				thunderclap = {
					damage_max = {
						nil,
						90
					},
					secondary_damage_max = {
						60,
						90,
						120
					},
					stun_duration = {
						[3] = 5
					},
					xp_gain = {
						100,
						200,
						300
					}
				}
			}
		},
		melee = {
			attacks = {
				{
					xp_gain_factor = 2.5
				},
				{
					chance = 0.5
				}
			},
			range = 55
		},
		ranged = {
			attacks = {
				{
					cooldown = 12.933333333333334
				}
			}
		}
	},
	high_elven_sentinel = {
		charge_time = 5,
		ranged = {
			attacks = {
				{
					max_range = 300
				}
			}
		},
		wait_time = 4
	},
	missile_bfg = {
		bullet = {
			damage_min = 50,
			damage_radius = 65
		}
	},
	missile_mecha = {
		bullet = {
			damage_max = 80,
			damage_min = 20
		},
	},
	mod_arrow_arcane = {
		damage_max = 0.1,
		damage_min = 0.1
	},
	mod_arrow_arcane_slumber = {
		modifier = {
			duration = 6
		}
	},
	mod_druid_sylvan = {
		attack = {
			max_range = 120
		},
		modifier = {
			duration = 7
		}
	},
	mod_dwarf_beer = {
		hps = {
			heal_every = 0.5,
			heal_max = 5,
			heal_min = 5
		},
		modifier = {
			duration_inc = 3
		}
	},
	mod_faerie_dragon_l0 = {
		modifier = {
			duration = 2
		}
	},
	mod_faerie_dragon_l1 = {
		modifier = {
			duration = 4
		}
	},
	mod_faerie_dragon_l2 = {
		modifier = {
			duration = 6
		}
	},
	mod_fiery_nut = {
		dps = {
			damage_inc = 3
		},
		modifier = {
			duration = 2
		}
	},
	mod_forest_circle = {
		modifier = {
			duration = 7
		}
	},
	mod_gerald_courage = {
		courage = {
			damage_max_inc = 4,
			damage_min_inc = 4,
			heal_once_factor = 0.25
		}
	},
	mod_hero_thor_thunderclap = {
		thunderclap = {
			damage = 100,
			secondary_damage_type = 1
		}
	},
	mod_life_drain_drow = {
		heal_factor = 0.5
	},
	mod_ray_arcane = {
		dps = {
			damage_max = 148,
			damage_min = 87
		}
	},
	mod_ray_frankenstein = {
		dps = {
			damage_inc = 11,
			damage_max = 66,
			damage_min = 44
		}
	},
	mod_ray_hero_thor = {
		dps = {
			damage_type = 1
		}
	},
	mod_rocketeer_speed_buff = {
		fast = {
			factor = 3.6000000000000001
		}
	},
	mod_slow_baby_ashbite = {
		slow = {
			factor = 0.40000000000000002,
			factor_inc = 0
		}
	},
	mod_teleport_arcane = {
		max_times_applied = 4
	},
	mod_timelapse = {
		damage_levels = {
			300,
			300,
			300
		},
		damage_type = 1
	},
	mod_troll_rage = {
		extra_speed = 30.72000000000001
	},
	multishot_crossbow = {
		bullet = {
			damage_min = 40
		}
	},
	pestilence = {
		aura = {
			duration = 2,
			duration_inc = 2,
			radius = 75
		}
	},
	pirate_watchtower_parrot = {
		custom_attack = {
			min_range = 40,
			damage_type = DAMAGE_EXPLOSIVE
		}
	},
	ray_frankenstein = {
		bounce_damage_factor_min = 1,
		bounce_range = 100,
		bounces_lvl = {
			[0] = 1
		}
	},
	ray_high_elven_sentinel = {
		bullet = {
			damage_max = 25,
			damage_min = 25
		}
	},
	ray_neptune = {
		bullet = {
			damage_max_levels = {
				500,
				1000,
				1500
			},
			damage_min_levels = {
				400,
				800,
				1200
			},
			damage_radius = 65
		}
	},
	ray_sunray_mini = {
		bullet = {
			damage_inc = 100
		}
	},
	ray_tesla = {
		bounce_damage_factor = 1,
		bounce_damage_factor_inc = -0.25,
		bounces_lvl = {
			4,
			5,
			[0] = 3
		}
	},
	rock_druid = {
		bullet = {
			damage_max = 55,
			damage_min = 35,
			damage_radius = 60
		}
	},
	rock_entwood = {
		bullet = {
			damage_radius = 65
		}
	},
	rock_firey_nut = {
		bullet = {
			damage_max = 150,
			damage_max_inc = 0,
			damage_min = 150,
			damage_min_inc = 0
		}
	},
	shotgun_bolin = {
		bullet = {
			damage_min = 45
		}
	},
	shotgun_musketeer = {
		bullet = {
			damage_min = 45
		}
	},
	soldier_alleria_wildcat = {
		melee = {
			attacks = {
				{
					cooldown = 0.59999999999999998
				}
			}
		},
		vis = {
			bans = bor(F_SKELETON, F_CANNIBALIZE, F_LYCAN, F_POLYMORPH)
		}
	},
	soldier_assassin = {
		melee = {
			attacks = {
				nil,
				{
					chance = 0.14999999999999999
				}
			}
		},
		pickpocket = {
			chance = 0,
			chance_inc = 0.29999999999999999,
			steal_max = 5,
			steal_min = 3
		}
	},
	soldier_baby_ashbite = {
		health = {
			armor = 0,
			dead_lifetime = 30,
			hp_max = 500
		},
		ranged = {
			attacks = {
				{
					cooldown = 2.3999999999999999,
					max_range = 150
				},
				{
					cooldown = 10
				},
				{
					cooldown = 12
				}
			}
		},
		regen = {
			cooldown = 1,
			health = 30
		},
		vis = {
			bans = bor(F_EAT, F_NET, F_POISON, F_POLYMORPH)
		}
	},
	soldier_barbarian = {
		health = {
			dead_lifetime = 9
		},
		melee = {
			attacks = {
				nil,
				{
					chance = 0.15,
					damage_inc = 20
				}
			}
		},
		motion = {
			max_speed = 85
		},
		ranged = {
			attacks = {
				{
					cooldown = 2.4666666666666668
				}
			}
		},
		regen = {
			health = 50
		}
	},
	soldier_blade = {
		melee = {
			attacks = {
				{
					cooldown_inc = -0.15
				},
				{
					cooldown_inc = -0.15
				},
				{
					cooldown_inc = -0.15
				}
			}
		}
	},
	soldier_death_rider = {
		melee = {
			attacks = {
				{
					damage_inc = 10,
					damage_max = 20
				}
			}
		},
		motion = {
			max_speed = 100
		}
	},
	soldier_djinn = {
		unit = {
			price = 350
		}
	},
	soldier_drow = {
		health = {
			armor = 0.6,
			hp_max = 180
		},
		melee = {
			attacks = {
				{
					damage_max = 40,
					damage_min = 20
				},
				{
					cooldown = 6,
					damage_inc = 50,
					damage_type = 1
				}
			},
			range = 65
		},
		powers = {
			blade_mail = {
				spiked_armor = {
					0.2,
					0.4,
					0.6
				}
			}
		},
		regen = {
			health = 35
		}
	},
	soldier_druid_bear = {
		health = {
			armor = 0.4,
			dead_lifetime = 10
		},
		regen = {
			health = 50
		}
	},
	soldier_dwarf = {
		beer = {
			hp_trigger_factor = 0.8
		},
		health = {
			armor = 0.25,
			armor_inc = 0.2
		},
		melee = {
			attacks = {
				{
					damage_inc = 6
				}
			}
		}
	},
	soldier_frankenstein = {
		melee = {
			attacks = {
				nil,
				{
					damage_radius = 100,
					damage_type = 1
				}
			}
		}
	},
	soldier_ingvar_ancestor = {
		melee = {
			range = 80
		},
		reinforcement = {
			duration = 16
		}
	},
	soldier_mecha = {
		attacks = {
			list = {
				{
					cooldown = 1.2
				},
				{
					cooldown = 8
				}
			}
		}
	},
	soldier_paladin = {
		melee = {
			attacks = {
				[3] = {
					chance = 0.2,
					damage_type = 1
				}
			}
		}
	},
	soldier_pirate_anchor = {
		melee = {
			attacks = {
				{
					damage_max = 40,
					damage_min = 20
				}
			}
		},
		regen = {
			cooldown = 1,
			health = 90
		}
	},
	soldier_templar = {
		health = {
			hp_inc = 75
		},
		melee = {
			attacks = {
				nil,
				{
					chance = 0.2,
					damage_max = 50,
					damage_min = 50,
					damage_inc = 50
				}
			},
			cooldown = 1.9333333333333333
		},
		regen = {
			health = 50
		},
		revive = {
			chance = 0.2,
			chance_inc = 0.1,
			health_recover = 0.2,
			health_recover_inc = 0.1
		}
	},
	soldier_sasquash_2 = {
		health = {
			hp_max = 1500,
			dead_lifetime = 30
		},
		melee = {
			attacks = {
				{
					damage_max = 150
				}
			}
		},
		regen = {
			cooldown = fts(10),
			health = 50
		}
	},
	soldier_imperial_guard = {
		health = {
			dead_lifetime = 16,
			hp_max = 200
		},
		melee = {
			attacks = {
				{
					damage_max = 20
				},
				{
					damage_max = 20
				}
			}
		},
		motion = {
			max_speed = 50
		},
		regen = {
			health = 15
		}
	},
	totem_silence = {
		aura = {
			radius = 90
		}
	},
	tower_arcane = {
		attacks = {
			list = {
				{
					cooldown = 0.9
				}
			}
		},
	},
	tower_archer_dwarf = {
		attacks = {
			list = {
				nil,
				{
					cooldown = 6
				}
			}
		},
		powers = {
			extra_damage = {
				price_base = 200,
				price_inc = 200
			}
		},
		tower = {
			price = 230
		}
	},
	tower_archmage = {
		attacks = {
			list = {
				{
					payload_chance = 1
				}
			}
		},
		powers = {
			twister = {
				price_base = 300,
				price_inc = 200
			}
		}
	},
	tower_baby_ashbite = {
		barrack = {
			rally_range = 250
		},
		powers = {
			fiery_mist = {
				price_base = 220,
				price_inc = 150
			}
		},
		tower = {
			price = 475
		}
	},
	tower_barbarian = {
		powers = {
			dual = {
				price_base = 150,
				price_inc = 150
			},
			twister = {
				price_inc = 150
			}
		}
	},
	tower_barrack_dwarf = {
		powers = {
			armor = {
				price_base = 150,
				price_inc = 225
			},
			beer = {
				price_base = 175,
				price_inc = 100
			},
			hammer = {
				price_base = 75,
				price_inc = 75
			}
		},
		tower = {
			price = 180
		}
	},
	tower_bastion = {
		attacks = {
			range = 225
		}
	},
	tower_bfg = {
		attacks = {
			list = {
				nil,
				{
					cooldown_flying = 6
				},
				{
					cooldown = 15
				}
			}
		},
		powers = {
			missile = {
				damage_inc = 50,
				range_inc_factor = 0.25
			},
			cluster = {
				fragment_count_base = 1,
				fragment_count_inc = 3
				}
		}
	},
	tower_blade = {
		powers = {
			perfect_parry = {
				price_base = 200,
				price_inc = 200
			},
			blade_dance = {
				price_base = 200,
				price_inc = 200
			},
			swirling = {
				price_base = 150
			}
		}
	},
	tower_crossbow = {
		attacks = {
			list = {
				{
					critical_chance_inc = 0.1
				},
				{
					shots = 1,
					shots_inc = 3
				},
				{
					range = 198.40000000000001
				}
			}
		},
		powers = {
			multishot = {
				price_base = 220,
				price_inc = 165
			}
		}
	},
	tower_drow = {
		powers = {
			blade_mail = {
				price_base = 200,
				price_inc = 200
			},
			double_dagger = {
				price_inc = 150
			},
			life_drain = {
				price_inc = 150
			}
		},
		tower = {
			price = 300
		}
	},
	tower_druid = {
		powers = {
			nature = {
				price_base = 200,
				price_inc = 200,
				max_level = 3
			}
		}
	},
	tower_dwaarp = {
		powers = {
			drill = {
				price_base = 350
			}
		}
	},
	tower_entwood = {
		attacks = {
			list = {
				nil,
				{
					cooldown = 22
				},
				{
					damage_radius = 240,
					range = 210,
					stun_chances = {
						[3] = 1,
						[4] = 1
					}
				}
			}
		},
		powers = {
			clobber = {
				stun_durations = {
					nil,
					1.5,
					2
				}
			},
		}
	},
	tower_ewok_rework = {
		barrack = {
			max_soldiers = 5,
			rally_range = 160
		},
		tower = {
			price = 230
		}
	},
	tower_faerie_dragon = {
		attacks = {
			list = {
				{
					cooldown = 2.5
				}
			},
			range = 175
		},
		powers = {
			more_dragons = {
				price_base = 0,
				price_inc = 75
			}
		},
		tower = {
			price = 125
		}
	},
	tower_forest = {
		powers = {
			oak = {
				price_base = 300
			}
		},
		tower = {
			price = 250
		}
	},
	tower_frankenstein = {
		attacks = {
			range = 220
		},
		powers = {
			frankie = {
				price_base = 250
			},
			lightning = {
				price_base = 150
			}
		},
		tower = {
			price = 300
		}
	},
	tower_necromancer = {
		powers = {
			pestilence = {
				price_base = 200
			},
			rider = {
				price_inc = 100
			}
		},
		tower = {
			price = 350
		}
	},
	tower_pirate_watchtower = {
		powers = {
			parrot = {
				price_base = 250,
				price_inc = 250
			}
		},
		tower = {
			price = 115
		}
	},
	tower_pixie = {
		powers = {
			cream = {
				price_base = 200,
				price_inc = 200
			}
		},
		tower = {
			price = 230
		}
	},
	tower_ranger = {
		powers = {
			poison = {
				price_base = 200,
				price_inc = 200
			},
			thorn = {
				price_base = 250,
				price_inc = 250
			}
		}
	},
	tower_silver = {
		attacks = {
			list = {
				{
					critical_chances = {
						0.03
					}
				}
			}
		},
		powers = {
			sentence = {
				chances = {
					{
						0.025,
						0.05,
						0.075
					},
					{
						0.05,
						0.1,
						0.15
					}
				},
				price_base = 400,
				price_inc = 400
			}
		}
	},
	tower_sorcerer = {
		tower = {
			price = 400
		}
	},
	tower_templar = {
		powers = {
			blood = {
				price_base = 150
			}
		}
	},
	tower_totem = {
		attacks = {
			list = {
				nil,
				{
					cooldown = 9
				},
				{
					cooldown = 4
				},
			}
		}
	},
	tower_sunray_mini = {
		tower = {
			price = 260
		},
		powers = {
			ray = {
				price_base = 0
			}
		}
	},
	tower_wild_magus = {
		powers = {
			ward = {
				price_base = 175,
				price_inc = 175
			}
		}
	},
	twister = {
		damage_inc = 100,
		damage_max = 0,
		damage_min = 0,
		damage_type = 2,
		enemies_inc = 3,
		enemies_max = 1,
		pickup_range = 65
	},
	tower_shadow_archer = {
		attacks = {
			range = 220,
			list = {
				nil,
				{
					cooldowns = {
						30,
						25,
						20
					}
				},
				{
					cooldown = 9
				}
			}
		},
		tower = {
			price = 250
		},
		powers = {
			crow = {
				damage_min = 12,
				damage_max = 12
			},
			mark = {
				price_base = 200,
				price_inc = 200
			}
		}
	},
	arrow_shadow_tower = {
		bullet = {
			damage_max = 36,
			damage_min = 24
		}
	},
	arrow_shadow_mark = {
		bullet = {
			damage_max = 36,
			damage_min = 24
		}
	},
	mod_arrow_shadow_mark = {
		modifier = {
			durations = {
				6,
				6,
				6
			}
		}
	},
	shadow_crow = {
		custom_attack = {
			damage_min = 6,
			damage_max = 6,
			damage_type = DAMAGE_TRUE
		}
	},
	tower_orc_warriors_den = {
		barrack = {
			rally_range = 175
		},
		powers = {
			promotion = {
				hp_max = 200,
				armor = 0.6,
				damage_min = 20,
				damage_max = 25,
				price_base = 130
			},
			seal = {
				price_base = 180,
				price_inc = 180
			},
			bloodlust = {
				damage_factor = {
					1.5,
					2.0
				}
			}
		}
	},
	soldier_orc_warrior = {
		health = {
			dead_lifetime = 9,
			armor = 0.4
		},
		melee = {
			attacks = {
				{
					damage_min = 10,
					damage_max = 13
				}
			}
		}
	},
	tower_infernal_mage = {
		attacks = {
			range = 200,
			list = {
				nil,
				{
					range = 200
				},
				{
					cooldown = 15,
					range = 200
				},
				{
					vis_bans = F_FREEZE,
					range = 200
				}
			}
		},
		powers = {
			curse = {
				price_base = 150,
				price_inc = 150
			},
			teleport = {
				max_count = {
					3,
					6
				}
			}
		},
	},
	bolt_infernal_mage = {
		bullet = {
			damage_max = 119,
			damage_min = 79
		}
	},
	aura_lava_fissure = {
		aura = {
			radius = 45
		}
	},
	mod_teleport_infernal = {
		nodes_offset_min = -30,
		nodes_offset_max = -30
	},
	tower_rocket_riders = {
		attacks = {
			min_cooldown = 3,
			range = 250,
			list = {
				{
					cooldown = 3,
					range = 250
				},
				nil,
				nil,
				{
					cooldown = 9,
					range = 275
				}
			}
		},
		tower = {
			price = 300
		},
		powers = {
			mine = {
				price_base = 200,
				price_inc = 200
			},
			nitro = {
				price_base = 225,
				price_inc = 200,
				damage_inc = {
					130,
					180
				}
			},
			engine = {
				price_base = 250,
				price_inc = 250,
				fragment_count = {
					7,
					10
				},
			}
		}
	},
	bomb_rr = {
		bullet = {
			damage_max = 88,
			damage_min = 60,
			damage_radius = 60
		}
	},
	rr_mine_box = {
		attacks = {
			list = {
				cooldown = 5
			}
		}
	},
	bomb_rr_mine = {
		bullet = {
			damage_inc = {
				35,
				70,
				105
			},
			damage_radius = 60
		}
	},
	decal_rr_mine = {
		radius = 60
	},
	bomb_rr_cluster = {
		bullet = {
			damage_inc = {
				40,
				80
			}
		}
	},
	bomb_rr_fragment = {
		bullet = {
			damage_radius = 80
		}
	},
	tower_dark_knights = {
		barrack = {
			rally_range = 175
		},
		tower = {
			price = 270
		},
		powers = {
			instakill = {
				price_base = 220,
				price_inc = 220
			},
			spike = {
				price_base = 200,
				price_inc = 200
			}
		}
	},
	soldier_dark_knight = {
		melee = {
			attacks = {
				{
					cooldown = 1.2,
					damage_max = 35,
					damage_min = 20
				}
			}
		},
		health = {
			hp_max = 180,
			armor = 0.8,
			dark_damage_type = DAMAGE_TRUE
		},
		powers = {
			spike = {
				dark_spiked_armor = {
					12,
					24,
					36
				}
			}
		},
		dodge = {
			shield = {
				cooldown = 20
			}
		}
	},
	tower_melting_furnace = {
		attacks = {
			range = 200,
			list = {
				{
					cooldown = 3,
					reduce_armor = 0,
					damage_type = DAMAGE_EXPLOSION,
					damage_min = 49,
					damage_max = 54
				},
				nil,
				{
					range = 200
				},
				nil,
				{
					cooldown = 24
				}
			}
		},
		tower = {
			price = 400
		}
	},
	mod_lava_furnace = {
		dps = {
			damage_min = 0,
			damage_max = 0,
			damage_inc = 5
		}
	},
	lava_furnace = {
		aura = {
			radius = 40
		}
	},
	mod_furnace_fuel = {
		cooldown = 1.5
	},
	mod_furnace_stun = {
		modifier = {
			duration = 0.8
		}
	},
	tower_spectres_mausoleum = {
		tower = {
			price = 240
		},
		powers = {
			garg = {
				price_base = 275,
				price_inc = 275
			},
			spectral = {
				price_base = 70,
				price_inc = 70
			},
			poss = {
				price_base = 300
			}
		},
	},
	bolt_spectres = {
		bullet = {
			damage_min = 50,
			damage_max = 72
		}
	},
	soldier_gargoyle = {
		melee = {
			attacks = {
				{
					damage_max = 12,
					damage_min = 8
				}
			}
		},
		health = {
			hp_max = 210,
			dead_lifetime = 12
		}
	},
	tower_goblirang = {
		tower = {
			price = 280
		},
		attacks = {
			range = 180,
			list = {
				nil,
				{
					cooldown = 13
				},
				{
					range = 158,
					vis_bans = F_FRIEND
				}
			}
		},
		powers = {
			big = {
				damage_min = {
					52,
					63,
					88
				},
				damage_max = {
					78,
					91,
					105
				}
			},
			stun = {
				mod_chance = {
					0.15,
					0.2,
					0.25
				},
				price_base = 150,
				price_inc = 150,
				max_level = 1
			}
		}
	},
	goblirang = {
		bullet = {
			damage_min = 23,
			damage_max = 41
		}
	},
	mod_goblirang_stun = {
		modifier = {
			duration = 1.5
		}
	},
	mod_goblirang_slow = {
		modifier = {
			duration = 0.1
		}
	},
	mod_honey_bees = {
		dps = {
			damage_min = 1,
			damage_max = 1,
			damage_inc = 6
		}
	},
	honey_bees_aura = {
		aura = {
			radius = 55,
			vis_bans = F_FRIEND
		}
	},
	tower_bone_flingers = {
		attacks = {
			range = 160
		},
		powers = {
			skeleton = {
				cooldown = {
					12,
					16
				}
			},
			milk = {
				price_base = 140,
				price_inc = 140,
				damage_inc = {
					4,
					8,
					12
				}
			},
			golem = {
				max_level = 2
			}
		}
	},
	bone_flingers_bone = {
		bullet = {
			damage_min = 18,
			damage_max = 26
		}
	},
	soldier_flingers_skeleton = {
		health = {
			hp_max = 60
		}
	},
	soldier_flingers_skeleton_warrior = {
		health = {
			hp_max = 200,
			armor = 0.3
		},
		melee = {
			attacks = {
				{
					damage_max = 40,
					damage_min = 20
				}
			}
		}
	},
	soldier_bone_golem = {
		melee = {
			attacks = {
				{
					damage_max = 45,
					damage_min = 25
				}
			}
		},
		ranged = {
			attacks = {
				{
					cooldown = 0.6
				}
			}
		}
	},
	bone_golem_bone = {
		bullet = {
			damage_min = 18,
			damage_max = 9
		}
	},
	aura_demon_death_pos = {
		aura = {
			damage_max = 75,
			damage_min = 75
		}
	},
	aura_demon_mage_death_pos = {
		aura = {
			damage_max = 300,
			damage_min = 300
		}
	},
	aura_demon_wolf_death_pos = {
		aura = {
			damage_max = 100,
			damage_min = 100
		}
	},
	aura_flareon_death_pos = {
		aura = {
			damage_max = 60,
			damage_min = 60
		}
	},
	aura_goblin_zapper_death_pos = {
		aura = {
			damage_max = 100,
			damage_min = 100
		}
	},
	aura_gulaemon_death_pos = {
		aura = {
			damage_max = 300,
			damage_min = 300
		}
	},
	bolt_high_elven_strong = {
		bullet = {
			damage_max = 60,
			damage_min = 40
		}
	},
	bolt_high_elven_weak = {
		bullet = {
			damage_max = 15,
			damage_min = 10
		}
	},
	mod_slow_oil = {
		slow = {
			factor = 0.5
		}
	},
	tower_sasquash_rework = {
		tower = {
			price = 500
		}
	},
	soldier_amazona_re = {
		melee = {
			attacks = {
				{
					damage_min = 24
				},
				{
					damage_min = 24
				}
			}
		}
	},
	arrow_silver_long = {
		bullet = {
			hit_distance = 9e+99
		}
	},
	arrow_silver_mark_long = {
		bullet = {
			hit_distance = 9e+99
		}
	},
	aura_arcane_burst = {
		aura = {
			radius = 67.5
		}
	},
	soldier_pirate_captain_2 = {
		health = {
			armor = 0.2
		},
		regen = {
			cooldown = 1
		}
	},
	bomb_molotov_2 = {
		bullet = {
			mod = "mod_pirate_burn"
		}
	},
	soldier_pirate_flamer_2 = {
		melee = {
			attacks = {
				{
					mod = "mod_pirate_burn"
				}
			}
		}
	},
	soldier_pirate_anchor_2 = {
		regen = {
			health = 90,
			cooldown = 1
		},
		melee = {
			attacks = {
				nil,
				{
					chance = 0.3
				}
			}
		}
	},
	tower_elite_harassers = {
		barrack = {
			rally_range = 187.5
		},
		tower = {
			price = 280
		},
		powers = {
			arrow = {
				price_base = 175,
				price_inc = 175
			}
		}
	},
	soldier_elite_harasser = {
		health = {
			dead_lifetime = 9,
			hp_max = 320
		},
		ranged = {
			attacks = {
				{
					cooldown = 1.4
				},
				{
					cooldown = 10,
					loops = 4
				}
			}
		},
		dodge = {
			chance = 0.4,
			chance_inc = 0.15,
			counter_attack = {
				damage_inc_min = {
					30,
					50
				},
				damage_inc_max = {
					40,
					60
				}
			}
		},
		melee = {
			attacks = {
				{
					damage_min = 22,
					damage_max = 32
				}
			}
		},
		powers = {
			fury = {
				chance = 1,
				health = 325,
				damage_min = 25,
				damage_max = 35,
				duration = 8
			}
		}
	},
	arrow_elite_harasser = {
		bullet = {
			damage_min = 30,
			damage_max = 40
		}
	},
	arrow_elite_harasser_barrage = {
		bullet = {
			damage_min_inc = 17,
			damage_max_inc = 21
		}
	},
	bolt_orc_shaman = {
		bullet = {
			mod = nil,
			damage_min = 85,
			damage_max = 110
		}
	},
	bolt_shock = {
		bullet = {
			damage_radius = 55,
			damage_inc_min = {
				85,
				110
			},
			damage_inc_max = {
				110,
				160
			}
		}
	},
	tower_orc_shaman = {
		attacks = {
			list = {
				{
					cooldown = 3
				},
				{
					cooldown = 20,
					min_health = 0.8
				},
				{
					shoot_time = 0.4,
					wait = 0.15
				}
			},
			range = 210
		},
		tower = {
			price = 370
		},
		powers = {
			shock = {
				price_base = 0,
				price_inc = 225,
				max_level = 2,
				level = 1
			}
		}
	},
	aura_orc_shaman_vines = {
		aura = {
			duration = 15
		}
	},
	orc_shaman_meteor = {
		bullet = {
			damage_type = DAMAGE_PHYSICAL,
			flight_time = 0.2
		}
	},
	mod_orc_shaman_stun = {
		modifier = {
			duration = 0,
			vis_bans = F_ALL
		}
	},
	bolt_blast = {
		bullet = {
			damage_min = 5,
			damage_max = 5,
			damage_inc = 15
		}
	},
	soldier_elemental = {
		health = {
			dead_lifetime = 12
		}
	},
	grim_cemetery_aura = {
		max_skeletons_tower = 8,
		spawn_cooldown = 10,
		entity_small = "soldier_zombie_medium",
		entity_medium = "soldier_zombie",
		min_health_for_knight = 1,
		pestilence_cooldown = 0
	},
	tower_grim_cemetery = {
		attacks = {
			range = 175,
			list = {
				{
					range = 175,
					max_spread = 60
				}
			}
		},
		tower = {
			price = 200
		},
		powers = {
			hands = {
				price_base = 150,
				price_inc = 150,
				count = {
					35,
					35
				}
			},
			big = {
				price_base = 125
			},
			pestilence = {
				price_base = 140,
				price_inc = 140
			}
		}
	},
	soldier_zombie = {
		melee = {
			attacks = {
				{
					cooldown = 1.5,
					damage_max = 13,
					damage_min = 8
				}
			}
		},
		health = {
			hp_max = 110
		}
	},
	soldier_zombie_medium = {
		health = {
			hp_max = 165
		},
		melee = {
			attacks = {
				{
					damage_max = 13,
					damage_min = 8
				}
			}
		},
	},
	aura_grim_cemetery_hand = {
		aura = {
			radius = 30
		}
	},
	soldier_zombie_big = {
		health = {
			hp_max = 195
		},
	},
	mod_grim_cemetery_explode = {
		explode_damage = {
			30,
			60
		},
		explode_damage_type = DAMAGE_TRUE,
		explode_range = 35
	},
	mod_grim_cemetery_poison = {
		dps = {
			damage_min = 0,
			damage_max = 0,
			damage_inc = 1.66,
			damage_type = bor(DAMAGE_TRUE)
		}
	},
}
