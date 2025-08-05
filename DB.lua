--[[ ctrl - DB.lua - t@wse.nyc - 8/17/24 ]] --

---@class ctrl
local ctrl = select(2, ...)
local c, s, a = ctrl.c, ctrl.s, ctrl.a

ctrl.db = {
    npcId = {
        -- Ara'Kara 2660
        [218325] = { n='Swarming Flyer', i=s.minus, c=c.rgba.gray},
        [216336] = { n='Ravenous Crawler', i=s.collapse, c=c.rgba.o, t1='Stack', t2='Charge >8yds'},
        [214840] = { n='Engorged Crawler', i=s.biohazard, c=c.rgba.dkg, t1=c.y.."󰟟 8s Poison DoT"},
        [216341] = { n='Jabbing Flyer', i=s.bleed, c=c.rgba.dkr, t1="12s Bleed DoT", t2=c.y..'Mitigate or Dispel'},
        [216293] = { n='Trilling Attendant', kick=434793, i=s.kick, c=c.rgba.b, t1=c.y..s.warn.." Kick/Stop Resonant Barrage", t2='Kick Web Bolt if spare', z=2660},
        [217531] = { n='Ixin', kick=434802, i=s.warn, c=c.rgba.p, hex=c.c, t1=c.y..s.warn..' Kick Horrifying Shrill', t2=c.g.."て Dodge Spray Puddles", z=2660},
        [218324] = { n='Nakt', i=c.y..s.stack, c=c.rgba.p, hex=c.c, t1=c.y..'Stack for adds', t2='Mitigate'},
        [217533] = { n='Atik', i=s.biohazard, c=c.rgba.p, hex=c.c, t1='Dodge Poisonous Cloud', t2='Kick/dispel poison DoT on tank'},
        [213179] = { n='Avanoxx', i=s.boss, c=c.rgba.p, hex=c.c,  t1=c.y..s.run.." Kite/nuke fix'd adds", t2='Stack Goss puddles, Tank DoT x3'},
        [216337] = { n='Bloodworker', i=s.collapse, c=c.rgba.o, t1='Stack', t2='Charge >8yds'},
        [216333] = { n='Bloodstained Assistant', i=s.aura, c=c.rgba.o, t="Leech DoT on Tank", t2="Defensives to reduce healing"},
        [223253] = { n='Bloodstained Webmage', kick=448248, i=s.kick, c=c.rgba.b, t1=c.y..'Kick Revolting Volley', t2='AoE/Poison DoT', z=2660 },
        [228015] = { n='Hulking Bloodguard', i=s.one, c=c.rgba.p, t1=c.y..s.fallout..' Nuke: Bolsters enemies', t2='㍊ Mitigate Locust Swarm channel'},
        [216340] = { n='Sentry Stagshell', i=s.megaphone, c=c.rgba.p, t1=c.y..s.warn..' Nuke/CC/Stun Alarm Shrill', t2='10s cast = 50y summon'},
        [215405] = { n="Anub'zekt", i=s.boss, c=c.rgba.p, hex=c.c, t1=s.tank..' Face away '..s.run..' Drop Infestation away', t2=s.stack..' Stack in Eye away from tank' },
        [220599] = { n='Bloodstained Webmage', kick=442210, i=s.kick, c=c.rgba.b, t1=c.y..s.warn..' Kick Silken Restraints', z=2660},
        [216364] = { n='Blood Overseer', kick=433841, i=s.kick, c=c.rgba.p, t1=c.y..'Kick Venom Volley', t2=s.run..' Dodge Webs', z=2660},
        [216363] = { n='Reinforced Drone', i=s.warn, c=c.rgba.o, t1=c.g..s.puddle..' Black Blood puddle on aggro', t2=s.run..' Dodge webs '..s.tank..' Tank DoT'},
        [216365] = { n='Winged Carrier', i=s.warn, c=c.rgba.o, t1=c.g..s.puddle..' Black Blood puddle on aggro', t2=s.move..' Dashes to random, Mitigate'},
        [215407] = { n="Ki'katal the Harvester", i=s.boss, c=c.rgba.p, hex=c.c, t1=c.y..s.puddle..' Stand in puddle for Singularity', t2=s.stack..' Aim poison away (90 deg)'},
        [215826] = { n='Bloodworker', i=s.puddle, c=c.rgba.dkg, t1='Black Blood puddle', t2='Drop in good spot'},
        -- Test
        [111446] = { n='Duskwatch Shroud', kick=111111, i=s.kick, c=c.rgba.y, t1=c.y..s.warn..' Kick Test' },
        -- The Dawnbreaker 2662
        [213892] = { n='Nightfall Shadowmage', kick=431303, i=s.kick, c=c.rgba.b, t1=c.y..s.warn..' Kick Night Bolt', z=2662 }, -- Nightfall Shadowmage 1
        [223994] = { n='Nightfall Shadowmage', kick=431303, i=s.kick, c=c.rgba.b, t1=c.y..s.warn..' Kick Night Bolt', z=2662 }, -- Nightfall Shadowmage 2
        [228540] = { n='Nightfall Shadowmage', kick=431303, i=s.kick, c=c.rgba.b, t1=c.y..s.warn..' Kick Night Bolt', z=2662 }, -- Nightfall Shadowmage 3
    
    }
}

