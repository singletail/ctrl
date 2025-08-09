--[[ ctrl - DB.lua - t@wse.nyc - 8/17/24 ]] --

---@class ctrl
local ctrl = select(2, ...)
local c, s, a = ctrl.c, ctrl.s, ctrl.a

--[[
    Priority kick entries for visual alert require:
        - kick=(spellID)

    Priority kick entries for auto-kick require:
        - kick=(spellID)
        - z=(instanceID)
        - name (for targeting)

    Colors that make sense to me:
        - Boss: pink
        - Special: cyan
        - Priority Kick: yellow striped
        - Regular kick: yellow
        - Notable debuff: blue
        - High damage/frontal/charge: orange

]]

ctrl.db = {
    npcId = {
        -- Ara'Kara 2660
        [218325] = { n='Swarming Flyer', i=s.minus, c=c.rgba.gray},
        [216336] = { n='Ravenous Crawler', i=s.collapse, c=c.rgba.o, t1='Stack', t2='Charge >8yds'},
        [214840] = { n='Engorged Crawler', i=s.biohazard, c=c.rgba.b, t1=c.y.."󰟟 8s Poison DoT"},
        [216341] = { n='Jabbing Flyer', i=s.bleed, c=c.rgba.b, t1="12s Bleed DoT", t2=c.y..'Mitigate or Dispel'},
        [216293] = { n='Trilling Attendant', kick=434793, i=s.kick, c=c.rgba.y, t1=c.r..s.warn.." Kick/Stop Resonant Barrage", t2='Kick Web Bolt if spare', z=2660},
        [217531] = { n='Ixin', kick=434802, i=s.warn, c=c.rgba.y, hex=c.c, t1=c.r..s.warn..' Kick Horrifying Shrill', t2=c.g.."て Dodge Spray Puddles", z=2660},
        [218324] = { n='Nakt', i=c.y..s.stack, c=c.rgba.o, hex=c.c, t1=c.y..'Stack for adds', t2='Mitigate'},
        [217533] = { n='Atik', i=s.biohazard, c=c.rgba.o, hex=c.c, t1='Dodge Poisonous Cloud', t2='Kick/dispel poison DoT on tank'},
        [213179] = { n='Avanoxx', i=s.boss, c=c.rgba.p, hex=c.c,  t1=c.y..s.run.." Kite/nuke fix'd adds", t2='Stack Goss puddles, Tank DoT x3'},
        [216337] = { n='Bloodworker', i=s.collapse, c=c.rgba.o, t1='Stack', t2='Charge >8yds'},
        [216333] = { n='Bloodstained Assistant', i=s.aura, c=c.rgba.b, t="Leech DoT on Tank", t2="Defensives to reduce healing"},
        [223253] = { n='Bloodstained Webmage', kick=448248, i=s.kick, c=c.rgba.y, t1=c.r..'Kick Revolting Volley', t2='AoE/Poison DoT', z=2660 },
        [228015] = { n='Hulking Bloodguard', i=s.one, c=c.rgba.c, t1=c.r..s.fallout..' Nuke: Bolsters enemies', t2='㍊ Mitigate Locust Swarm channel'},
        [216340] = { n='Sentry Stagshell', i=s.megaphone, c=c.rgba.c, t1=c.y..s.warn..' Nuke/CC/Stun Alarm Shrill', t2='10s cast = 50y summon'},
        [215405] = { n="Anub'zekt", i=s.boss, c=c.rgba.p, hex=c.c, t1=s.tank..' Face away '..s.run..' Drop Infestation away', t2=s.stack..' Stack in Eye away from tank' },
        [220599] = { n='Bloodstained Webmage', kick=442210, i=s.kick, c=c.rgba.y, t1=c.y..s.warn..' Kick Silken Restraints', z=2660},
        [216364] = { n='Blood Overseer', kick=433841, i=s.kick, c=c.rgba.y, t1=c.r..'Kick Venom Volley', t2=s.run..' Dodge Webs', z=2660},
        [216363] = { n='Reinforced Drone', i=s.warn, c=c.rgba.o, t1=c.g..s.puddle..' Black Blood puddle on aggro', t2=s.run..' Dodge webs '..s.tank..' Tank DoT'},
        [216365] = { n='Winged Carrier', i=s.warn, c=c.rgba.o, t1=c.g..s.puddle..' Black Blood puddle on aggro', t2=s.move..' Dashes to random, Mitigate'},
        [215407] = { n="Ki'katal the Harvester", i=s.boss, c=c.rgba.p, hex=c.c, t1=c.y..s.puddle..' Stand in puddle for Singularity', t2=s.stack..' Aim poison away (90 deg)'},
        [215826] = { n='Bloodworker', i=s.puddle, c=c.rgba.dkg, t1='Black Blood puddle', t2='Drop in good spot'},

        -- Floodgate 2773
        [229069] = { n='Mechadrone Sniper', kick=1214468, i=s.kick, c=c.rgba.y, hex=c.c, t1=c.y..s.warn..' Kick Trickshot', z=2773 },
        [229686] = { n='Venture Co. Surveyor', kick=462771, i=s.kick, c=c.rgba.y, hex=c.c, t1=c.y..s.warn..' Kick Surveying Beam', z=2773 },

        -- Priory 2649
        [221760] = { n='Risen Mage', kick=444743, i=s.kick, c=c.rgba.y, hex=c.c, t1=c.y..s.warn..' Kick Fireball Volley', z=2649 },

        -- Eco-Dome -- 2830
        [242209] = { n='Overgorged Mite', kick=1229474, i=s.kick, c=c.rgba.y, hex=c.c, t1=c.y..s.warn..' Kick Gorge', z=2830 },
        [234962] = { n='Wastelander Farstalker', kick=1229510, i=s.kick, c=c.rgba.y, hex=c.c, t1=c.y..s.warn..' Kick Arcing Zap', z=2830 },

        -- Halls of Attonement -- 2287
        [165529] = { n='Depraved Collector', kick=325701, i=s.kick, c=c.rgba.y, hex=c.c, t1=c.y..s.warn..' Kick Siphon Life', z=2287 },
        [164562] = { n='Depraved Houndmaster', kick=326450, i=s.kick, c=c.rgba.y, hex=c.c, t1=c.y..s.warn..' Kick Loyal Beasts', z=2287 },

        -- Tazavesh Streets -- FIX ZONE IDS
        [179334] = { n="Portalmancer Zo'honn", kick=356324, i=s.kick, c=c.rgba.y, hex=c.c, t1=c.y..s.warn..' Kick Empowered Glyph', z=2649 },
        [179841] = { n="Veteran Sparkcaster", kick=355642, i=s.kick, c=c.rgba.y, hex=c.c, t1=c.y..s.warn..' Kick Hyperlight Salvo', z=2649 },
        [180091] = { n="Ancient Core Hound", kick=355642, i=s.kick, c=c.rgba.y, hex=c.c, t1=c.y..s.warn..' Kick Ancient Dread', z=356407 },

        -- Tazavesh Gambit -- FIX ZONE IDS
        [178139] = { n="Murkbrine Shellcrusher", kick=355057, i=s.kick, c=c.rgba.y, hex=c.c, t1=c.y..s.warn..' Kick Cry of Mrrggllrrgg', z=2649 },
        [180431] = { n="Focused Ritualist", kick=357260, i=s.kick, c=c.rgba.y, hex=c.c, t1=c.y..s.warn..' Kick Unstable Rift', z=2649 },


        -- The Dawnbreaker 2662
        

        

    }
}

