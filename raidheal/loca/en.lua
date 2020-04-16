local RED = "|cffff0000"
local GREEN = "|cff00ff00"
local WHITE = "|cffffffff"
local ENDC = "|r"

local START = WHITE .. "[RaidHeal]: " .. ENDC

local messages = {
    ERROR_GENERAL = START .. RED .. "Error: %s" .. ENDC,
    ERROR_IO_LOADFILE = START .. RED .. "Could not load path \"%s\": %s" .. ENDC,
    ERROR_NOT_IMPLEMENTED = START .. RED .. "%s is not yet implemented" .. ENDC,
    ERROR_NOT_YET_INITIALISED = START .. RED .. "Error in %s: %s is not yet initialised" .. ENDC,
    ERROR_PASSIVE_SETSKILL = START .. RED .. "Error: \"%s\" is a passive set skill" .. ENDC,
    ERROR_SAME_TRIGGER = START .. RED .. "Error: Cannot assign 2 actions to the same hotkey (%s)" .. ENDC,

    MSG_SUCCESSFULLY_LOADED = START .. GREEN .. "Loaded successfully" .. ENDC,
    MSG_CMD_HELP = START .. WHITE .. "  %s: " .. ENDC .. "%s",
    MSG_COMMANDS_AVAILABLE = START .. WHITE .. "Syntax: /rh [options]\n You have the following options available:" .. ENDC,
    MSG_DEBUFF_LIST = "[%d] %s",

    CMD_LIST_DESC = "Lists all possible commands",
    CMD_HELP_DESC = "Gives a description what the command does",
    CMD_HELP_USAGE = START .. WHITE .. "Syntax: /rh help [command]\n[command] represents the command you need help with" .. ENDC,
    CMD_ACTION_DESC = "Opens the Action Menu",
    CMD_CONFIG_DESC = "Opens the Config Menu",
    CMD_RELOAD_DESC = "Reloads all settings (WARNING: Discards all changes since login)",
    CMD_RESET_DESC = "Resets all settings to default (WARNING: all changes will be lost)",

    MSG_LOADED = START .. "Version %s successfully loaded",
    ADDON_DESC = "Healing Grid",

    CM_RESIZE_DESC = "Drag to move around\nDrag corners to resize\nDouble click to save changes",

    AMLI_TXT_ACTION = "Action:",
    AMLI_TXT_KEYS = "Hotkey:",
    AMLI_TXT_EXTRA_SKILL = "Skill:",
    AMLI_TXT_EXTRA_TARGET = "Target:",

    AMLI_BTNDETAILS_DESC = "Details",
    AMLI_BTNDETAILS_TOOLTIP = "(Not yet implemented)",
    AMLI_CHKBTNSECSAVE_DESC = "/%s",
    AMLI_CHKBTNSECSAVE_TOOLTIP = "If checked this action will be saved for %s/%s only",

    AMLI_TXT_CTRL = "Ctrl",
    AMLI_TXT_ALT = "Alt",
    AMLI_TXT_SHIFT = "Shift",

    AM_RELOADBUTTON_DESC = "Reload",
    AM_RELOADBUTTON_TOOLTIP = "Discards any changes",
    AM_SAVEBUTTON_DESC = "Save",
    AM_SAVEBUTTON_TOOLTIP = "Saves any changes\n(Press Ctrl to save globally)",
    AM_ADDLISTITEMBUTTON_DESC = "Add",

    AMLI_DESC_MOVERAID = "Move",
    AMLI_DESC_SKILL = "Skill",
    AMLI_DESC_TARGET = "Target",
    AMLI_DESC_DROPDOWN = "Menu",
    AMLI_DESC_SETSKILL = "Setskill",
    AMLI_DESC_ACTION = "Action",

    AMLI_DESC_REVIVE = "Revive (Basic)",
    AMLI_DESC_REVIVE2 = "Revive (w/ Amulet)",
    AMLI_DESC_LBUTTON = "Left Click",
    AMLI_DESC_RBUTTON = "Right Click",
    AMLI_DESC_MBUTTON = "Middle Click",

    CM_FF_UPBTN_TEXT = "Up",
    CM_FF_DOWNBTN_TEXT = "Down",
    CM_FF_ADDBTN_TEXT = "New...",
    CM_FF_REMOVEBTN_TEXT = "Remove",
    CM_FF_SHIFTRIGHT_TEXT = ">>",
    CM_FF_SHIFTLEFT_TEXT = "<<",

    CM_FF_TITLE_FILTER = "Shown Debuffs",
    CM_FF_TITLE_KNOWN = "Known Debuffs",
    CM_FF_TITLE_IGNORE = "Hidden Debuffs",

    CM_FF_SAVEBTN = "Save",

    AM_DF_BTNOK_DESC = "OK",
    AM_DF_TITLETEXT = "Details",

    AM_TDF_DEPENDING_DESC = "Going from clicked unit?",
    AM_TDF_DEPENDING_TOOLTIP = "(Default: active)",

    AM_TDF_DROPDOWN_DESC = "Target:",

    AM_TDF_DESC_TARGET = "Target",
    AM_TDF_DESC_TARGET2 = "2. level Target",
    AM_TDF_DESC_TARGET3 = "3. level Target",
    AM_TDF_DESC_PET = "Pet",
    AM_TDF_DESC_UNIT = "Unit",

    AM_SDF_ISCAST_DESC = "Is Cast",
    AM_SDF_ISCAST_TOOLTIP = "If active there will be a check if the cast started\nWarning: If you're moving, you might be stopped",

    CM_TABBTN_GENERAL_DESC = "General",
    CM_TABBTN_BARS_DESC = "Bars",
    CM_TABBTN_BUFFS_DESC = "Buffs & Debuffs",

    CM_GRID_ACTIVE_DESC = "RaidHeal active",
    CM_GRID_ACTIVE_TOOLTIP = "(De-)Activates RaidHeal",
    CM_GRID_SOLOMODE_DESC = "Solomode active",
    CM_GRID_DUMMYMODE_DESC = "Dummymode active",
    CM_GRID_DUMMYMODEBUFFS_DESC = "Show Buffs in Dummymode",
    CM_GRID_MAXNUMPARTYMEMBER_DESC = "Max Raid Size",
    CM_GRID_SHOWFAKEMOVE_DESC = "Drag unit",
    CM_GRID_GROUPALIGN_DESC = "Party alignment",
    CM_GRID_UNITALIGN_DESC = "Party member alignment",
    CM_GRID_SPACINGX_DESC = "Horizotal spacing",
    CM_GRID_SPACINGY_DESC = "Vertical spacing",
    CM_GRID_SHOWWARDENPET_DESC = "Show Warden Pets",
    CM_GRID_SHOWPRIESTPET_DESC = "Show Priest Pets",
    CM_GRID_SHOWOWNPET_DESC = "Show own Pet",

    CM_HEALTHBAR_TITLE_DESC = "Health Bar",
    CM_HEALTHBAR_BARALIGN_DESC = "Filling Bar from",
    CM_HEALTHBAR_PADDING_DESC = "Padding",
    CM_HEALTHBAR_BACKALPHA_DESC = "Background Opacity",
    CM_HEALTHBAR_BACKALPHA_TOOLTIP = "Possible Values ranging from 0.0 to 1.0, with 0.0 meaning fully transparent and 1.0 meaning fully visible",

    CM_MANABAR_TITLE_DESC = "Mana Bar",
    CM_MANABAR_ACTIVE_DESC = "Active",
    CM_MANABAR_BARALIGN_DESC = "Filling Bar from",
    CM_MANABAR_BACKALPHA_DESC = "Background Opacity",
    CM_MANABAR_BACKALPHA_TOOLTIP = "Possible Values ranging from 0.0 to 1.0, with 0.0 meaning fully transparent and 1.0 meaning fully visible",
    CM_MANABAR_PADDING_DESC = "Padding",
    CM_MANABAR_THICKNESS_DESC = "Thickness",

    CM_SKILLBAR_TITLE_DESC = "Skill Bar",
    CM_SKILLBAR_ACTIVE_DESC = "Active",
    CM_SKILLBAR_BARALIGN_DESC = "Filling Bar from",
    CM_SKILLBAR_BACKALPHA_DESC = "Background Opacity",
    CM_SKILLBAR_BACKALPHA_TOOLTIP = "Possible Values ranging from 0.0 to 1.0, with 0.0 meaning fully transparent and 1.0 meaning fully visible",
    CM_SKILLBAR_PADDING_DESC = "Padding",
    CM_SKILLBAR_THICKNESS_DESC = "Thickness",

    CM_BUFFS_TITLEGENERAL_DESC = "Buffs",
    CM_BUFFS_COUNT_DESC = "Count",
    CM_BUFFS_SHOWCDTIMER_DESC = "Show duration",
    CM_BUFFS_SHOWSTACKCOUNT_DESC = "show # of stacks",
    CM_BUFFS_SELECTFILTER_BUTTON_DESC = "Filter...",

    CM_BUFFS_SELECTDETAILINDEX_DESC = "Show details for",
    CM_BUFFS_SELECTDETAILINDEX_BUFF_DESC = "Buff #",
    CM_BUFFS_SELECTDETAILINDEX_DEBUFF_DESC = "Debuff #",

    CM_BUFFS_DETAILS_ANCHOR_DESC = "Anchor",
    CM_BUFFS_DETAILS_OFFSETX_DESC = "Horizontal offset",
    CM_BUFFS_DETAILS_OFFSETY_DESC = "Vertical offset",
    CM_BUFFS_DETAILS_WIDTH_DESC = "Width",
    CM_BUFFS_DETAILS_HEIGHT_DESC = "Height",
    CM_BUFFS_DETAILS_SAVEBUTTON_DESC = "Save",
    CM_BUFFS_DETAILS_RESETBUTTON_DESC = "Discard",

    CM_DEBUFFS_TITLEGENERAL_DESC = "Debuffs",
    CM_DEBUFFS_COUNT_DESC = "Count",
    CM_DEBUFFS_SHOWCDTIMER_DESC = "Show duration",
    CM_DEBUFFS_SHOWSTACKCOUNT_DESC = "Show # of stacks",

    CM_DDM_ANCHORPOINTS_TOP_DESC = "Top",
    CM_DDM_ANCHORPOINTS_BOTTOM_DESC = "Bottom",
    CM_DDM_ANCHORPOINTS_LEFT_DESC = "Left",
    CM_DDM_ANCHORPOINTS_RIGHT_DESC = "Right",
    CM_DDM_ANCHORPOINTS_CENTER_DESC = "Center",
    CM_DDM_ANCHORPOINTS_TOPLEFT_DESC = "Top Left",
    CM_DDM_ANCHORPOINTS_TOPRIGHT_DESC = "Top Right",
    CM_DDM_ANCHORPOINTS_BOTTOMLEFT_DESC = "Bottom Left",
    CM_DDM_ANCHORPOINTS_BOTTOMRIGHT_DESC = "Bottom Right",

    CM_OPENRESIZEGRIDFRAME_DESC = "Move/Resize Grid",
    CM_OPENACTIONMENU_DESC = "Assign Hotkeys",

    FM_TITLETEXT_DESC = "Filtermenu",
    FM_BUFFLISTFILTER_DESC = "Filter:",
    FM_WHITELIST_DESC = "Whitelist",
    FM_BLACKLIST_DESC = "Blacklist",
    FM_FILTERMODESELECT_DESC = "Filtermode",
    FM_FILTERINDEX_DESC = "Filterindex",
    FM_PARAMS_POISON_DESC = "Poisons",
    FM_PARAMS_HARMFUL_DESC = "Harmful Effects",
    FM_PARAMS_CURSE_DESC = "Curses",
    FM_SAVEBUTTON_DESC = "Save",

    FM_CLT_ADDBUTTON_DESC = "<<",
    FM_CLT_REMOVEBUTTON_DESC = ">>",

    SM_TITLETEXT_DESC = "SkillMenu",

    SM_TEXTNONE_DESC = "(None)",
    SM_TEXTCTRL_DESC = "Ctrl",
    SM_TEXTALT_DESC = "Alt",
    SM_TEXTSHIFT_DESC = "Shift",
    SM_TEXTCTRLALT_DESC = "Ctrl + Alt",
    SM_TEXTCTRLSHIFT_DESC = "Ctrl + Shift",
    SM_TEXTALTSHIFT_DESC = "Alt + Shift",
    SM_TEXTCTRLALTSHIFT_DESC = "Ctrl + Alt + Shift",

    SM_TEXTREVIVE_DESC = "Revive (w/o amulet)",
    SM_TEXTREVIVEEXTRA_DESC = "Revive (w/ amulet)",

    SM_TEXTRIGHT_DESC = "Right\nClick",
    SM_TEXTMIDDLE_DESC = "Middle\nClick",
    SM_TEXTLEFT_DESC = "Left\nClick",

    SM_TEXTMAINCLASS_DESC = "Main class:",
    SM_TEXTSUBCLASS_DESC = "Sub class:",

    SM_OPTIONANY_DESC = "(Any)",

    AM_FREETARGET_DESC = "Free targeting:",
    AM_TARGETSELECT_DESC = "Selected target:",
    AM_EXPERTS_DESC = "For experts:",

    AM_TARGET_NONE_DESC = "None",
    AM_TARGET_SELF_DESC = "Self",
    AM_TARGET_TARGET_DESC = "Target",
    AM_TARGET_TARGET2_DESC = "2nd target",
    AM_TARGET_TARGET3_DESC = "3rd target",
    AM_TARGET_PET_DESC = "Pet",

    AM_SAVEBUTTON_DESC = "Save",
    AM_ABORTBUTTON_DESC = "Abort",

    AM_SELECTSKILL_DESC = "Skill",
    AM_SELECTACTION_DESC = "Action",
    AM_SELECTEXTRA_DESC = "Other",
    AM_SELECTMOVERAID_DESC = "Move...",
    AM_SELECTTARGET_DESC = "Target",
    AM_SELECTDROPDOWN_DESC = "Dropdownmenu",

    AM_ACTIONSLOT_DESC = "[Action bar slot #%d]",

    --------------------------------------------------

    CM_TITLE_DESC = "ConfigMenu",

    CM_TREE_GENERAL_DESC = "General",
    CM_TREE_GRID_DESC = "Raid",
    CM_TREE_FOCUS_DESC = "Focus",
    CM_TREE_HEALTHBAR_DESC = "Health Bar",
    CM_TREE_MANABAR_DESC = "Mana Bar",
    CM_TREE_SKILLBAR_DESC = "Skill Bar",
    CM_TREE_HEALTHDISPLAY_DESC = "Health Display",
    CM_TREE_NAMEDISPLAY_DESC = "Name",
    CM_TREE_BUFFS_DESC = "Buffs",
    CM_TREE_DEBUFFS_DESC = "Debuffs",
    CM_TREE_BUFFNO_DESC = "Buff %d",
    CM_TREE_DEBUFFNO_DESC = "Debuff %d",
    CM_TREE_ADD = "Add...",

    CM_PAGE_ACTIVE_DESC = "Active",
    CM_PAGE_SAVEBUTTON_DESC = "Save",
    CM_PAGE_RESETBUTTON_DESC = "Reset",
    CM_PAGE_BUFF_REMOVEBUTTON_DESC = "Remove",
    CM_PAGE_BUFF_FILTERBUTTON_DESC = "Filter",

    CM_RESIZEMOVE_DESC = "Resize/Move",

    CM_PAGE_CATGEN_SOLOMODE_DESC = "Solo Mode",
    CM_PAGE_CATGEN_MAXNUMUNITS_DESC = "Max # of units",
    CM_PAGE_CATGEN_UNITSPERGROUP_DESC = "Units per group",
    CM_PAGE_CATGEN_GROUPALIGN_DESC = "Group alignment",
    CM_PAGE_CATGEN_UNITALIGN_DESC = "Group member alignment",
    CM_PAGE_CATGEN_SPACINGHORIZ_DESC = "Horizontal spacing",
    CM_PAGE_CATGEN_SPACINGVERT_DESC = "Vertical spacing",
    CM_PAGE_CATGEN_DCALPHA_DESC = "DC Transparency",
    CM_PAGE_CATGEN_AGGRO_DESC = "Highlight Aggro",
    CM_PAGE_CATGEN_FAKEMOVE_DESC = "Show moving unit",
    CM_PAGE_CATGEN_WARDENPET_DESC = "Show Warden Pet",
    CM_PAGE_CATGEN_PRIESTPET_DESC = "Show Priest Pet",
    CM_PAGE_CATGEN_OWNPET_DESC = "Show own Pet",
    CM_PAGE_CATGEN_DUMMYMODE_DESC = "Dummy mode",

    CM_PAGE_BUFF_HEIGHT_DESC = "Height",
    CM_PAGE_BUFF_WIDTH_DESC = "Width",
    CM_PAGE_BUFF_OFFSETY_DESC = "Vertical Offset",
    CM_PAGE_BUFF_OFFSETX_DESC = "Horizontal Offset",
    CM_PAGE_BUFF_ANCHOR_DESC = "Anchor",

    CM_DDA_TOP_DESC = "Top",
    CM_DDA_BOTTOM_DESC = "Bottom",
    CM_DDA_LEFT_DESC = "Left",
    CM_DDA_RIGHT_DESC = "Right",
    CM_DDA_TOPLEFT_DESC = "Top Left",
    CM_DDA_TOPRIGHT_DESC = "Top Right",
    CM_DDA_BOTTOMLEFT_DESC = "Bottom Left",
    CM_DDA_BOTTOMRIGHT_DESC = "Bottom Right",
    CM_DDA_CENTER_DESC = "Center",
    CM_DDA_DOCKFILL_DESC = "Fill",

    CM_PAGE_BAR_DOCK_DESC = "Anchor",
    CM_PAGE_BAR_BARALIGN_DESC = "Orientation",
    CM_PAGE_BAR_THICKNESS_DESC = "Thickness",
    CM_PAGE_BAR_PADDING_DESC = "Padding",

    CM_COLORIZEBTN_TEXT_DESC = "Colors",
    CM_COLORIZEBTN_BUTTON_DESC = "Details",

    COLORIZER_DYNAMIC_DESC = "Colorization Mode",
    COLORIZER_CLS_TITLE_DESC = "Class",
    COLORIZER_RES_TITLE_DESC = "Resource",
    COLORIZER_SINGLE_TITLE_DESC = "None",

    COLORIZER_CLS_INDEX_DESC = "Relevant Class",
    COLORIZER_CLS_MAIN_DESC = "Main class",
    COLORIZER_CLS_SEC_DESC = "Sec class",

    COLORIZER_RES_INDEX_DESC = "Relevant Resource",
    COLORIZER_RES_MANATYPE_DESC = "First",
    COLORIZER_RES_SKILLTYPE_DESC = "Second",

    COLORIZER_SINGLECOLOR_DESC = "Color",

    COLORIZER_TITLE_DESC = "Colorizer",

    COLORIZER_MANA_DESC = "Mana",
    COLORIZER_ENERGY_DESC = "Energy",
    COLORIZER_FOCUS_DESC = "Focus",
    COLORIZER_RAGE_DESC = "Rage",

    COLORIZER_LOADDEFAULT_DESC = "Load Default",
    COLORIZER_SAVE_DESC = "Save",
}

return messages