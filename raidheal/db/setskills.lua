
local setSkillDB = {}

local function registerSetSkill(id, texture, class, lvl, skillType)
    if not setSkillDB[class] then setSkillDB[class] = {} end
    local index = #setSkillDB[class] + 1

    setSkillDB[class][index] = {
        ID = id,
        Texture = texture,
        Lvl = lvl,
        SkillType = skillType
    }
end

-- DRUID

-- Waldbad
registerSetSkill(495566, "interface/icons/skill_panel_icons/sp_dru_003", "DRUID", 55, "ACTIVE")
-- Blendsamen
registerSetSkill(495489, "interface/icons/skill_panel_icons/sp_dru_001", "DRUID", 55, "HOSTILE")
-- Countdown-Samen
registerSetSkill(495490, "interface/icons/skill_panel_icons/sp_dru_002", "DRUID", 55, "HOSTILE")
-- Mond-Aura
registerSetSkill(495720, "interface/icons/skill_panel_icons/sp_dru_004", "DRUID", 58, "ACTIVE")
-- Grünes Saatkorn
registerSetSkill(496093, "interface/icons/skill_panel_icons/sp_dru_005", "DRUID", 60, "ACTIVE")
-- Sanfte Seele
registerSetSkill(496110, "interface/icons/skill_panel_icons/sp_dru_006", "DRUID", 65, "ACTIVE")
-- Waldverehrung
registerSetSkill(497917, "interface/icons/skill_panel_icons/sp_dru_z20_001", "DRUID", 67, "ACTIVE")
-- Kraftfeld der Natur
registerSetSkill(497796, "interface/icons/skill_panel_icons/sp_dru_z21_001", "DRUID", 70, "ACTIVE")


-- KNIGHT

-- Schlachtgebrüll des Löwenkönigs
registerSetSkill(495485, "interface/icons/skill_panel_icons/sp_kni_001", "KNIGHT", 55, "ACTIVE")
-- Vollmondspalter
registerSetSkill(495486, "interface/icons/skill_panel_icons/sp_kni_002", "KNIGHT", 55, "ACTIVE")
-- Makelloses Scharlachschwert
registerSetSkill(495564, "interface/icons/skill_panel_icons/sp_kni_003", "KNIGHT", 55, "HOSTILE")
-- Ehrenhafter Krieger
registerSetSkill(495718, "interface/icons/skill_panel_icons/sp_kni_004", "KNIGHT", 58, "PASSIVE")
-- Tyrann
registerSetSkill(496091, "interface/icons/skill_panel_icons/sp_kni_005", "KNIGHT", 60, "PASSIVE")
-- Bogenhieb
registerSetSkill(496108, "interface/icons/skill_panel_icons/sp_kni_006", "KNIGHT", 65, "ACTIVE")
-- Lanaiks Gebrüll
registerSetSkill(497915, "interface/icons/skill_panel_icons/sp_kni_z20_001", "KNIGHT", 67, "ACTIVE")
-- Starker Gegenschlag
registerSetSkill(498343, "interface/icons/skill_panel_icons/sp_kni_z21_001", "KNIGHT", 70, "PASSIVE")


-- WARRIOR

-- Unbesiegbarer König
registerSetSkill(495475, "interface/icons/skill_panel_icons/sp_war_001", "WARRIOR", 55, "ACTIVE")
-- Waffenwächter
registerSetSkill(495476, "interface/icons/skill_panel_icons/sp_war_002", "WARRIOR", 55, "PASSIVE")
-- Druckverband
registerSetSkill(495559, "interface/icons/skill_panel_icons/sp_war_003", "WARRIOR", 55, "ACTIVE")
-- Bestrafung
registerSetSkill(495713, "interface/icons/skill_panel_icons/sp_war_004", "WARRIOR", 58, "ACTIVE")
-- Schwert der Gefangenschaft
registerSetSkill(495728, "interface/icons/skill_panel_icons/sp_war_005", "WARRIOR", 60, "ACTIVE")
-- Haltung
registerSetSkill(496103, "interface/icons/skill_panel_icons/sp_war_006", "WARRIOR", 65, "ACTIVE")
-- Druckverband
registerSetSkill(497918, "interface/icons/skill_panel_icons/sp_war_z20_001", "WARRIOR", 67, "ACTIVE")
-- Angriff mit ungestümer Wildheit
registerSetSkill(498338, "interface/icons/skill_panel_icons/sp_war_z21_001", "WARRIOR", 70, "HOSTILE")


-- WARDEN

-- Begleiter-Meister
registerSetSkill(495487, "interface/icons/skill_panel_icons/sp_ward_001", "WARDEN", 55, "PASSIVE")
-- Bestienkönig-Angriff
registerSetSkill(495488, "interface/icons/skill_panel_icons/sp_ward_002", "WARDEN", 55, "ACTIVE")
-- Woge des Friedens
registerSetSkill(495565, "interface/icons/skill_panel_icons/sp_ward_003", "WARDEN", 55, "ACTIVE")
-- Tanz der Verwirrung
registerSetSkill(495719, "interface/icons/skill_panel_icons/sp_ward_004", "WARDEN", 58, "HOSTILE")
-- Befreien
registerSetSkill(496092, "interface/icons/skill_panel_icons/sp_ward_005", "WARDEN", 60, "ACTIVE")
-- Finsternis der Tiergeister
registerSetSkill(496109, "interface/icons/skill_panel_icons/sp_ward_006", "WARDEN", 65, "HOSTILE")
-- Gefährte
registerSetSkill(497916, "interface/icons/skill_panel_icons/sp_ward_z20_001", "WARDEN", 67, "ACTIVE")
-- Bindender Vertrag
registerSetSkill(498344, "interface/icons/skill_panel_icons/sp_ward_z21_001", "WARDEN", 70, "PASSIVE")


-- Champion

-- Endgültige Zerstörung
registerSetSkill(850892, "interface/icons/skill_panel_icons/sp_psy_001", "PSYRON", 55, "ACTIVE")
-- Demontageschritt
registerSetSkill(850891, "interface/icons/skill_panel_icons/sp_psy_002", "PSYRON", 55, "ACTIVE")
-- Demontagemodus
registerSetSkill(850884, "interface/icons/skill_panel_icons/sp_psy_003", "PSYRON", 55, "ACTIVE")
-- Klonkonversion
registerSetSkill(850882, "interface/icons/skill_panel_icons/sp_psy_004", "PSYRON", 58, "ACTIVE")
-- Schlachtverteidigungstransfer
registerSetSkill(850880, "interface/icons/skill_panel_icons/sp_psy_005", "PSYRON", 60, "ACTIVE")
-- Runenwächter
registerSetSkill(850879, "interface/icons/skill_panel_icons/sp_psy_006", "PSYRON", 65, "ACTIVE")
-- Energieversorgung
registerSetSkill(850877, "interface/icons/skill_panel_icons/sp_psy_007", "PSYRON", 67, "ACTIVE")
-- Leistungssteigerung
registerSetSkill(850876, "interface/icons/skill_panel_icons/sp_psy_008", "PSYRON", 70, "PASSIVE")


-- THIEF

-- Phantomstich
registerSetSkill(495479, "interface/icons/skill_panel_icons/sp_thi_001", "THIEF", 55, "HOSTILE")
-- Entkommen
registerSetSkill(495480, "interface/icons/skill_panel_icons/sp_thi_002", "THIEF", 55, "ACTIVE")
-- Nachtangriff
registerSetSkill(495561, "interface/icons/skill_panel_icons/sp_thi_003", "THIEF", 55, "HOSTILE")
-- Unbekannte Entscheidung
registerSetSkill(495715, "interface/icons/skill_panel_icons/sp_thi_004", "THIEF", 58, "ACTIVE")
-- Yawakas Segen
registerSetSkill(495730, "interface/icons/skill_panel_icons/sp_thi_008", "THIEF", 60, "ACTIVE")
-- Mal der Löwenkralle
registerSetSkill(496105, "interface/icons/skill_panel_icons/sp_thi_009", "THIEF", 65, "HOSTILE")
-- Hinterhältiger Schuss
registerSetSkill(497912, "interface/icons/skill_panel_icons/sp_thi_z20_001", "THIEF", 67, "HOSTILE")
-- Kanches Reißen
registerSetSkill(498340, "interface/icons/skill_panel_icons/sp_thi_z21_001", "THIEF", 70, "HOSTILE")


-- MAGE

-- Mama Fortuna
registerSetSkill(495482, "interface/icons/skill_panel_icons/sp_mag_003", "MAGE", 55, "ACTIVE")
-- Erholungsmagie
registerSetSkill(495481, "interface/icons/skill_panel_icons/sp_mag_001", "MAGE", 55, "ACTIVE")
-- Steinschuppenklinge
registerSetSkill(495562, "interface/icons/skill_panel_icons/sp_mag_002", "MAGE", 55, "HOSTILE")
-- Unverletzt
registerSetSkill(495716, "interface/icons/skill_panel_icons/sp_mag_004", "MAGE", 58, "ACTIVE")
-- Erdsturz
registerSetSkill(495731, "interface/icons/skill_panel_icons/sp_mag_005", "MAGE", 60, "ACTIVE")
-- Zaubertricks
registerSetSkill(496106, "interface/icons/skill_panel_icons/sp_mag_006", "MAGE", 65, "ACTIVE")
-- Weisheit
registerSetSkill(497913, "interface/icons/skill_panel_icons/sp_mag_z20_001", "MAGE", 67, "PASSIVE")
-- Schwert der Göttlichkeit
registerSetSkill(498341, "interface/icons/skill_panel_icons/sp_mag_z21_001", "MAGE", 70, "ACTIVE")


-- Hexer

-- Essenz der Dunklen Seele
registerSetSkill(850867, "interface/icons/skill_panel_icons/sp_har_001", "HARPSYN", 55, "ACTIVE")
-- Verschiebung der Leere
registerSetSkill(850868, "interface/icons/skill_panel_icons/sp_har_002", "HARPSYN", 55, "ACTIVE")
-- Dunkle Aura
registerSetSkill(850869, "interface/icons/skill_panel_icons/sp_har_003", "HARPSYN", 55, "ACTIVE")
-- Schritte in der Tiefe
registerSetSkill(850870, "interface/icons/skill_panel_icons/sp_har_004", "HARPSYN", 58, "ACTIVE")
-- Barriere der Seelenabsorption
registerSetSkill(850871, "interface/icons/skill_panel_icons/sp_har_005", "HARPSYN", 60, "ACTIVE")
-- Terror der Gebrochenen Seelen
registerSetSkill(850872, "interface/icons/skill_panel_icons/sp_har_006", "HARPSYN", 65, "ACTIVE")
-- Selbstverzerrung
registerSetSkill(850873, "interface/icons/skill_panel_icons/sp_har_007", "HARPSYN", 67, "ACTIVE")
-- Ätzende Anzapfung
registerSetSkill(850874, "interface/icons/skill_panel_icons/sp_har_008", "HARPSYN", 70, "ACTIVE")


-- AUGUR

-- Mana-Runenstein
registerSetSkill(495483, "interface/icons/skill_panel_icons/sp_aug_001", "AUGUR", 55, "ACTIVE")
-- Schild der heiligen Kerze
registerSetSkill(495484, "interface/icons/skill_panel_icons/sp_aug_002", "AUGUR", 55, "ACTIVE")
-- Frostnarben
registerSetSkill(495563, "interface/icons/skill_panel_icons/sp_aug_003", "AUGUR", 55, "HOSTILE")
-- Reinigen
registerSetSkill(495717, "interface/icons/skill_panel_icons/sp_aug_004", "AUGUR", 58, "ACTIVE")
-- Altar von Shadoj
registerSetSkill(495732, "interface/icons/skill_panel_icons/sp_aug_005", "AUGUR", 60, "HOSTILE")
-- Vergeltung des Magiers
registerSetSkill(496107, "interface/icons/skill_panel_icons/sp_aug_007", "AUGUR", 65, "ACTIVE")
-- Frosttod
registerSetSkill(497914, "interface/icons/skill_panel_icons/sp_aug_z20_001", "AUGUR", 67, "HOSTILE")
-- Heldenhafte Wache
registerSetSkill(498342, "interface/icons/skill_panel_icons/sp_aug_z21_001", "AUGUR", 70, "ACTIVE")


-- RANGER

-- Glorie des Schützen
registerSetSkill(495477, "interface/icons/skill_panel_icons/sp_ran_001", "RANGER", 55, "ACTIVE")
-- Splitterstern-Sturm
registerSetSkill(495478, "interface/icons/skill_panel_icons/sp_ran_002", "RANGER", 55, "ACTIVE")
-- Starker Wille
registerSetSkill(495560, "interface/icons/skill_panel_icons/sp_ran_003", "RANGER", 55, "PASSIVE")
-- Pfeilschild
registerSetSkill(495714, "interface/icons/skill_panel_icons/sp_ran_004", "RANGER", 58, "ACTIVE")
-- Ranken erschaffen
registerSetSkill(495729, "interface/icons/skill_panel_icons/sp_ran_005", "RANGER", 60, "ACTIVE")
-- Vorteil des Jägers
registerSetSkill(496104, "interface/icons/skill_panel_icons/sp_ran_006", "RANGER", 65, "PASSIVE")
-- Fokusverbesserung
registerSetSkill(497911, "interface/icons/skill_panel_icons/sp_ran_z20_001", "RANGER", 67, "PASSIVE")
-- Schatten einer Tausendfeder
registerSetSkill(498339, "interface/icons/skill_panel_icons/sp_ran_z21_001", "RANGER", 70, "ACTIVE")


-- COMMON

-- Götterkraut-Essenz
registerSetSkill(495491, "interface/icons/skill_panel_icons/sp_goods_001", "COMMON", 51, "ACTIVE")
-- Elementargeist-Steinessenz
registerSetSkill(495492, "interface/icons/skill_panel_icons/sp_goods_002", "COMMON", 51, "ACTIVE")
-- Energie-Erholung
registerSetSkill(495494, "interface/icons/skill_panel_icons/sp_goods_003", "COMMON", 51, "ACTIVE")
-- Erhöhte Sammelgeschwindigkeit
registerSetSkill(495774, "interface/icons/skill_life_skills_01", "COMMON", 60, "ACTIVE")
-- Erhöhte Sammelerfahrung
registerSetSkill(495775, "interface/icons/skill_life_skills_02", "COMMON", 60, "ACTIVE")
-- Erhöhte Fertigungsgeschwindigkeit
registerSetSkill(495776, "interface/icons/skill_life_skills_03", "COMMON", 60, "ACTIVE")
-- Erhöhte Fertigungserfahrung
registerSetSkill(495777, "interface/icons/skill_life_skills_04", "COMMON", 60, "ACTIVE")
-- Essenz der Kräuter der Allmacht
registerSetSkill(496099, "interface/icons/skill_panel_icons/sp_goods_004", "COMMON", 62, "ACTIVE")
-- Essenz des Elementarsteins der Allmacht
registerSetSkill(496100, "interface/icons/skill_panel_icons/sp_goods_005", "COMMON", 62, "ACTIVE")
-- Osalontal-Transportportal
registerSetSkill(496101, "interface/icons/skill_panel_icons/sp_battlefield_001", "COMMON", 60, "ACTIVE")
-- Graben von Bolinthya-Transportportal
registerSetSkill(496102, "interface/icons/skill_panel_icons/sp_battlefield_002", "COMMON", 60, "ACTIVE")
-- Mysteriöse Kräuteressenz
registerSetSkill(497797, "interface/icons/skill_panel_icons/sp_goods_006", "COMMON", 72, "ACTIVE")
-- Mysteriöse Magische Steinessenz
registerSetSkill(497798, "interface/icons/skill_panel_icons/sp_goods_007", "COMMON", 72, "ACTIVE")

return setSkillDB
