local RED = "|cffff0000"
local GREEN = "|cff00ff00"
local WHITE = "|cffffffff"
local ENDC = "|r"

local START = WHITE .. "[RaidHeal]: " .. ENDC

local messages = {
    ERROR_GENERAL = START .. RED .. "Fehler: %s" .. ENDC,
    ERROR_IO_LOADFILE = START .. RED .. "Pfad \"%s\" konnte nicht geladen werden: %s" .. ENDC,
    ERROR_NOT_IMPLEMENTED = START .. RED .. "%s ist noch nicht implementiert" .. ENDC,
    ERROR_NOT_YET_INITIALISED = START .. RED .. "Fehler bei %s: %s ist noch nicht initialisiert" .. ENDC,
    ERROR_PASSIVE_SETSKILL = START .. RED .. "Fehler: \"%s\" ist ein passiver Setskill" .. ENDC,
    ERROR_SAME_TRIGGER = START .. RED .. "Fehler: Eine Tastenkombination kann nicht doppelt belegt werden (%s)" .. ENDC,

    MSG_SUCCESSFULLY_LOADED = START .. GREEN .. "Erfolgreich geladen" .. ENDC,
    MSG_CMD_HELP = START .. WHITE .. "  %s: " .. ENDC .. "%s",
    MSG_COMMANDS_AVAILABLE = START .. WHITE .. "Syntax: /rh [options]\n Folgende Befehle sind möglich:" .. ENDC,
    MSG_DEBUFF_LIST = "[%d] %s",

    CMD_LIST_DESC = "Listet alle verfügbaren Befehle auf",
    CMD_HELP_DESC = "Liefert Details zu einem bestimmten Befehl",
    CMD_HELP_USAGE = START .. WHITE .. "Syntax: /rh help [command]\n[command] ist dabei der Befehl, über den Details angegeben werden sollen" .. ENDC,
    CMD_ACTION_DESC = "Öffnet das Skillmenü",
    CMD_CONFIG_DESC = "Öffnet das Konfigurationsmenü",
    CMD_RELOAD_DESC = "Lädt alle Einstellungen neu (Achtung: verwirft alle Veränderungen seit dem Einloggen!)",
    CMD_RESET_DESC = "Setzt alle Einstellungen auf den Auslieferungszustand zurück (Achtung: Alle Einstellungen gehen verloren!)",

    MSG_LOADED = START .. "Version \"%s\" erfolgreich geladen",
    ADDON_DESC = "Healinterface",

    CM_RESIZE_DESC = "Ziehe das Feld, um das Grid zu verschieben\nZiehe an den Ecken um die Größe zu verändern\nDoppelklick um die Änderungen zu speichern",

    AMLI_TXT_ACTION = "Aktion:",
    AMLI_TXT_KEYS = "Hotkey:",
    AMLI_TXT_EXTRA_SKILL = "Skill:",
    AMLI_TXT_EXTRA_TARGET = "Einheit:",

    AMLI_BTNDETAILS_DESC = "Erweitert",
    AMLI_BTNDETAILS_TOOLTIP = "",
    AMLI_CHKBTNSECSAVE_DESC = "/%s",
    AMLI_CHKBTNSECSAVE_TOOLTIP = "Falls aktiv wird diese Belegung nur für %s/%s gespeichert",

    AMLI_TXT_CTRL = "Strg",
    AMLI_TXT_ALT = "Alt",
    AMLI_TXT_SHIFT = "Shift",

    AM_RELOADBUTTON_DESC = "Neu laden",
    AM_RELOADBUTTON_TOOLTIP = "Verwirft alle Änderungen",
    AM_SAVEBUTTON_DESC = "Speichern",
    AM_SAVEBUTTON_TOOLTIP = "Speichert alle Änderungen\n(Wenn Strg gedrückt ist, werden die Belegungen für alle Charaktere übernommen)",
    AM_ADDLISTITEMBUTTON_DESC = "Neu",

    AMLI_DESC_MOVERAID = "Verschieben",
    AMLI_DESC_SKILL = "Skill",
    AMLI_DESC_TARGET = "Anvisieren",
    AMLI_DESC_DROPDOWN = "Kontextmenü",
    AMLI_DESC_SETSKILL = "Setskill",
    AMLI_DESC_ACTION = "Aktion",

    AMLI_DESC_REVIVE = "Wiederbeleben",
    AMLI_DESC_REVIVE2 = "Wiederbeleben mit Amulett",
    AMLI_DESC_LBUTTON = "Linksklick",
    AMLI_DESC_RBUTTON = "Rechtsklick",
    AMLI_DESC_MBUTTON = "Mittlere Maustaste",

    CM_FF_UPBTN_TEXT = "Oben",
    CM_FF_DOWNBTN_TEXT = "Unten",
    CM_FF_ADDBTN_TEXT = "Neu...",
    CM_FF_REMOVEBTN_TEXT = "Entfernen",
    CM_FF_SHIFTRIGHT_TEXT = ">>",
    CM_FF_SHIFTLEFT_TEXT = "<<",

    CM_FF_TITLE_FILTER = "Angezeigte Debuffs",
    CM_FF_TITLE_KNOWN = "Bekannte Debuffs",
    CM_FF_TITLE_IGNORE = "Ausgeblendete Debuffs",

    CM_FF_SAVEBTN = "Speichern",

    AM_DF_BTNOK_DESC = "OK",
    AM_DF_TITLETEXT = "Details",

    AM_TDF_DEPENDING_DESC = "Von der angeklickten Einheit ausgehend:",
    AM_TDF_DEPENDING_TOOLTIP = "(Standard: aktiv)",

    AM_TDF_DROPDOWN_DESC = "Ziel:",

    AM_TDF_DESC_TARGET = "Ziel",
    AM_TDF_DESC_TARGET2 = "Ziel 2. Stufe",
    AM_TDF_DESC_TARGET3 = "Ziel 3. Stufe",
    AM_TDF_DESC_PET = "Begleiter",
    AM_TDF_DESC_UNIT = "Einheit",

    AM_SDF_ISCAST_DESC = "Hat Castzeit",
    AM_SDF_ISCAST_TOOLTIP = "Falls aktiv wird bei der Ausführung des Skill überprüft, ob der Cast angefangen wurde\nWarnung: Falls man in Bewegung ist, kann diese abgebrochen werden",

    CM_TABBTN_GENERAL_DESC = "Allgemein",
    CM_TABBTN_BARS_DESC = "Balken",
    CM_TABBTN_BUFFS_DESC = "Buffs & Debuffs",

    CM_GRID_ACTIVE_DESC = "RaidHeal aktiv",
    CM_GRID_ACTIVE_TOOLTIP = "Aktiviert oder deaktiviert RaidHeal",
    CM_GRID_SOLOMODE_DESC = "Aktiv wenn allein",
    CM_GRID_DUMMYMODE_DESC = "Dummymodus",
    CM_GRID_DUMMYMODEBUFFS_DESC = "Dummy-Buffanzeigen",
    CM_GRID_MAXNUMPARTYMEMBER_DESC = "Maximale Gruppengröße",
    CM_GRID_SHOWFAKEMOVE_DESC = "Anzeige beim Verschieben",
    CM_GRID_GROUPALIGN_DESC = "Anordnung Gruppen",
    CM_GRID_UNITALIGN_DESC = "Anordnung Mitlieder",
    CM_GRID_SPACINGX_DESC = "Horizotaler Abstand",
    CM_GRID_SPACINGY_DESC = "Vertikaler Abstand",
    CM_GRID_SHOWWARDENPET_DESC = "Bewahrerpets anzeigen",
    CM_GRID_SHOWPRIESTPET_DESC = "Priesterfeen anzeigen",
    CM_GRID_SHOWOWNPET_DESC = "Eigenes Pet anzeigen",

    CM_HEALTHBAR_TITLE_DESC = "Lebensbalken",
    CM_HEALTHBAR_BARALIGN_DESC = "Füllrichtung",
    CM_HEALTHBAR_PADDING_DESC = "Einzug",
    CM_HEALTHBAR_BACKALPHA_DESC = "Hintergrundtransparenz",

    CM_MANABAR_TITLE_DESC = "Manabalken",
    CM_MANABAR_ACTIVE_DESC = "Aktiv",
    CM_MANABAR_BARALIGN_DESC = "Füllrichtung",
    CM_MANABAR_BACKALPHA_DESC = "Hintergrundtransparenz",
    CM_MANABAR_PADDING_DESC = "Einzug",
    CM_MANABAR_THICKNESS_DESC = "Balkenbreite",

    CM_SKILLBAR_TITLE_DESC = "Skillpunktebalken",
    CM_SKILLBAR_ACTIVE_DESC = "Aktiv",
    CM_SKILLBAR_BARALIGN_DESC = "Füllrichtung",
    CM_SKILLBAR_BACKALPHA_DESC = "Hintergrundtransparenz",
    CM_SKILLBAR_PADDING_DESC = "Einzug",
    CM_SKILLBAR_THICKNESS_DESC = "Balkenbreite",

    CM_BUFFS_TITLEGENERAL_DESC = "Buffs",
    CM_BUFFS_COUNT_DESC = "Anzahl",
    CM_BUFFS_SHOWCDTIMER_DESC = "Laufzeit",
    CM_BUFFS_SHOWSTACKCOUNT_DESC = "Stackanzahl",

    CM_BUFFS_SELECTDETAILINDEX_DESC = "Zeige Details für Buff",
    CM_BUFFS_SELECTDETAILINDEX_BUFF_DESC = "Buff ",
    CM_BUFFS_SELECTDETAILINDEX_DEBUFF_DESC = "Debuff ",
    CM_BUFFS_SELECTFILTER_BUTTON_DESC = "Filter...",

    CM_BUFFS_DETAILS_ANCHOR_DESC = "Ankerpunkt",
    CM_BUFFS_DETAILS_ANCHOR_TOOLTIP = "Gültige Werte: TOPLEFT, TOP, TOPRIGHT, LEFT, CENTER, RIGHT, BOTTOMLEFT, BOTTOM, BOTTOMRIGHT",
    CM_BUFFS_DETAILS_OFFSETX_DESC = "Horizontaler Abstand",
    CM_BUFFS_DETAILS_OFFSETY_DESC = "Vertikaler Abstand",
    CM_BUFFS_DETAILS_WIDTH_DESC = "Breite",
    CM_BUFFS_DETAILS_HEIGHT_DESC = "Höhe",
    CM_BUFFS_DETAILS_SAVEBUTTON_DESC = "Speichern",
    CM_BUFFS_DETAILS_RESETBUTTON_DESC = "Verwerfen",

    CM_DEBUFFS_TITLEGENERAL_DESC = "Debuffs",
    CM_DEBUFFS_COUNT_DESC = "Anzahl",
    CM_DEBUFFS_SHOWCDTIMER_DESC = "Laufzeit",
    CM_DEBUFFS_SHOWSTACKCOUNT_DESC = "Stackanzahl",

    CM_DDM_ANCHORPOINTS_TOP_DESC = "Oben",
    CM_DDM_ANCHORPOINTS_BOTTOM_DESC = "Unten",
    CM_DDM_ANCHORPOINTS_LEFT_DESC = "Links",
    CM_DDM_ANCHORPOINTS_RIGHT_DESC = "Rechts",
    CM_DDM_ANCHORPOINTS_CENTER_DESC = "Mitte",
    CM_DDM_ANCHORPOINTS_TOPLEFT_DESC = "Oben links",
    CM_DDM_ANCHORPOINTS_TOPRIGHT_DESC = "Oben Rechts",
    CM_DDM_ANCHORPOINTS_BOTTOMLEFT_DESC = "Unten Links",
    CM_DDM_ANCHORPOINTS_BOTTOMRIGHT_DESC = "Unten Rechts",

    CM_OPENRESIZEGRIDFRAME_DESC = "Grid anpassen",
    CM_OPENRESIZEGRIDFRAME_TOOLTIP = "Grid verschieben/in der Größe verändern",
    CM_OPENACTIONMENU_DESC = "Hotkeys festlegen",

    FM_TITLETEXT_DESC = "Filtermenü",
    FM_BUFFLISTFILTER_DESC = "Filter:",
    FM_WHITELIST_DESC = "Anzeigen",
    FM_BLACKLIST_DESC = "Ausblenden",
    FM_FILTERMODESELECT_DESC = "Filtermodus",
    FM_FILTERINDEX_DESC = "Filterindex",
    FM_PARAMS_POISON_DESC = "Gifte",
    FM_PARAMS_HARMFUL_DESC = "Schädliche Effekte",
    FM_PARAMS_CURSE_DESC = "Flüche",
    FM_SAVEBUTTON_DESC = "Speichern",

    FM_CLT_ADDBUTTON_DESC = "<<",
    FM_CLT_REMOVEBUTTON_DESC = ">>",

    SM_TITLETEXT_DESC = "Skillmenü",

    SM_TEXTNONE_DESC = "(Keine)",
    SM_TEXTCTRL_DESC = "Strg",
    SM_TEXTALT_DESC = "Alt",
    SM_TEXTSHIFT_DESC = "Shift",
    SM_TEXTCTRLALT_DESC = "Strg + Alt",
    SM_TEXTCTRLSHIFT_DESC = "Strg + Shift",
    SM_TEXTALTSHIFT_DESC = "Alt + Shift",
    SM_TEXTCTRLALTSHIFT_DESC = "Strg + Alt + Shift",

    SM_TEXTREVIVE_DESC = "Wiederbeleben (ohne Amulet)",
    SM_TEXTREVIVEEXTRA_DESC = "Wiederbeleben (mit Amulet)",

    SM_TEXTRIGHT_DESC = "Rechts-\nklick",
    SM_TEXTMIDDLE_DESC = "Mittel-\nklick",
    SM_TEXTLEFT_DESC = "Links-\nklick",

    SM_TEXTMAINCLASS_DESC = "Primärklasse:",
    SM_TEXTSUBCLASS_DESC = "Sekundärklasse:",

    SM_OPTIONANY_DESC = "(unbestimmt)",

    AM_FREETARGET_DESC = "Freies Ziel:",
    AM_TARGETSELECT_DESC = "Einheit:",
    AM_EXPERTS_DESC = "Für Fortgeschrittene:",

    AM_TARGET_NONE_DESC = "Nichts",
    AM_TARGET_SELF_DESC = "Selbst",
    AM_TARGET_TARGET_DESC = "Ziel",
    AM_TARGET_TARGET2_DESC = "Ziel 2. Stufe",
    AM_TARGET_TARGET3_DESC = "Ziel 3. Stufe",
    AM_TARGET_PET_DESC = "Pet",

    AM_SAVEBUTTON_DESC = "Speichern",
    AM_ABORTBUTTON_DESC = "Abbrechen",

    AM_SELECTSKILL_DESC = "Skill",
    AM_SELECTACTION_DESC = "Aktionsleiste",
    AM_SELECTEXTRA_DESC = "Anderes",
    AM_SELECTMOVERAID_DESC = "Verschieben",
    AM_SELECTTARGET_DESC = "Anvisieren",
    AM_SELECTDROPDOWN_DESC = "Dropdownmenü",

    AM_ACTIONSLOT_DESC = "[Aktionsleistenslot #%d]",

    --------------------------------------------------

    CM_TITLE_DESC = "Configmenü",

    CM_TREE_GENERAL_DESC = "Allgemein",
    CM_TREE_GRID_DESC = "Raid-Anzeige",
    CM_TREE_FOCUS_DESC = "Focus-Anzeige",
    CM_TREE_HEALTHBAR_DESC = "LP Balken",
    CM_TREE_MANABAR_DESC = "MP Balken",
    CM_TREE_SKILLBAR_DESC = "SP Balken",
    CM_TREE_HEALTHDISPLAY_DESC = "LP Anzeige",
    CM_TREE_NAMEDISPLAY_DESC = "Name",
    CM_TREE_BUFFS_DESC = "Buffs",
    CM_TREE_DEBUFFS_DESC = "Debuffs",
    CM_TREE_BUFFNO_DESC = "Buff %d",
    CM_TREE_DEBUFFNO_DESC = "Debuff %d",
    CM_TREE_ADD = "Neu...",

    CM_PAGE_ACTIVE_DESC = "Aktiv",
    CM_PAGE_SAVEBUTTON_DESC = "Speichern",
    CM_PAGE_RESETBUTTON_DESC = "Zurücksetzen",
    CM_PAGE_BUFF_REMOVEBUTTON_DESC = "Remove",
    CM_PAGE_BUFF_FILTERBUTTON_DESC = "Filter",

    CM_RESIZEMOVE_DESC = "Resize/Move",

    CM_PAGE_CATGEN_SOLOMODE_DESC = "Solo Mode",
    CM_PAGE_CATGEN_MAXNUMUNITS_DESC = "Max. Anzahl an Einheiten",
    CM_PAGE_CATGEN_UNITSPERGROUP_DESC = "Einheiten pro Gruppe",
    CM_PAGE_CATGEN_GROUPALIGN_DESC = "Anordnung Gruppen",
    CM_PAGE_CATGEN_UNITALIGN_DESC = "Anordnung Gruppenmitglieder",
    CM_PAGE_CATGEN_SPACINGHORIZ_DESC = "Horizontaler Abstand",
    CM_PAGE_CATGEN_SPACINGVERT_DESC = "Vertikaler Abstand",
    CM_PAGE_CATGEN_DCALPHA_DESC = "DC Transparency",
    CM_PAGE_CATGEN_AGGRO_DESC = "Zeige Aggroziele",
    CM_PAGE_CATGEN_FAKEMOVE_DESC = "Zeige Einheit beim Verschieben",
    CM_PAGE_CATGEN_WARDENPET_DESC = "Zeige Bewahrergeister",
    CM_PAGE_CATGEN_PRIESTPET_DESC = "Zeige Priesterfeen",
    CM_PAGE_CATGEN_OWNPET_DESC = "Zeige eigenes Pet",
    CM_PAGE_CATGEN_DUMMYMODE_DESC = "Dummymodus",

    CM_PAGE_BUFF_HEIGHT_DESC = "Höhe",
    CM_PAGE_BUFF_WIDTH_DESC = "Breite",
    CM_PAGE_BUFF_OFFSETY_DESC = "Vertikaler Einzug",
    CM_PAGE_BUFF_OFFSETX_DESC = "Horizontaler Einzug",
    CM_PAGE_BUFF_ANCHOR_DESC = "Verankerung",

    CM_DDA_TOP_DESC = "Oben",
    CM_DDA_BOTTOM_DESC = "Unten",
    CM_DDA_LEFT_DESC = "Links",
    CM_DDA_RIGHT_DESC = "Rechts",
    CM_DDA_TOPLEFT_DESC = "Oben links",
    CM_DDA_TOPRIGHT_DESC = "Oben rechts",
    CM_DDA_BOTTOMLEFT_DESC = "Unten links",
    CM_DDA_BOTTOMRIGHT_DESC = "Unter rechts",
    CM_DDA_CENTER_DESC = "Mitte",
    CM_DDA_DOCKFILL_DESC = "Komplett",

    CM_PAGE_BAR_DOCK_DESC = "Verankerung",
    CM_PAGE_BAR_BARALIGN_DESC = "Balkenausrichtung",
    CM_PAGE_BAR_THICKNESS_DESC = "Dicke",
    CM_PAGE_BAR_PADDING_DESC = "Einzug",

    CM_COLORIZEBTN_TEXT_DESC = "Farben",
    CM_COLORIZEBTN_BUTTON_DESC = "Details",

    COLORIZER_DYNAMIC_DESC = "Farbe abhängig von",
    COLORIZER_CLS_TITLE_DESC = "Klasse",
    COLORIZER_RES_TITLE_DESC = "Resource",
    COLORIZER_SINGLE_TITLE_DESC = "(Nichts)",

    COLORIZER_CLS_INDEX_DESC = "Relevante Klasse",
    COLORIZER_CLS_MAIN_DESC = "Primäre",
    COLORIZER_CLS_SEC_DESC = "Sekundäre",

    COLORIZER_RES_INDEX_DESC = "Relevante Resource",
    COLORIZER_RES_MANATYPE_DESC = "Erste",
    COLORIZER_RES_SKILLTYPE_DESC = "Zweite",

    COLORIZER_SINGLECOLOR_DESC = "Farbe",

    COLORIZER_TITLE_DESC = "Colorizer",

    COLORIZER_MANA_DESC = "Mana",
    COLORIZER_ENERGY_DESC = "Energie",
    COLORIZER_FOCUS_DESC = "Fokus",
    COLORIZER_RAGE_DESC = "Zorn",

    COLORIZER_LOADDEFAULT_DESC = "Lade Standardfarben",
    COLORIZER_SAVE_DESC = "Speichern",
}

return messages