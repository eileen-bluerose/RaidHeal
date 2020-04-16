local config = {}

config.Presets = {
    Grid = {
        Default = {
            Active = true,
            SpacingX = 2,
            SpacingY = 5,
            GroupAlign = "BOTTOM",
            UnitAlign = "LEFT",
            Padding = 2,
            PaddingPet = 10,
            Pos = { X = 0.4, Y = 0.59 },
            Size = { Width = 0.45, Height = 0.35 },
            MaxNumPartyMember = 36,
            ShowOwnPet = true,
            ShowWardenPet = true,
            ShowPriestPet = true,
            SoloMode = true,
            GridParent = "UIParent",
            DCAlpha = 0.3,
        }
    },
    ResourceBars = {
        HP_Default = {
            BarAlign = "LEFT",
            Padding = 2,
            Colors = {
                _preset = true,
                _presetType = "ColorSets",
                _presetID = "ClassColors_Default",
            },
            ColorIndex = "MainClass",
            Anchors = {
                [1] = { Point = "TOPLEFT", RelPoint = "TOPLEFT" },
                [2] = { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT" }
            }
        },
        MP_Default = {
            BarAlign = "LEFT",
            Padding = 0,
            Thickness = 2,
            Colors = {
                _preset = true,
                _presetType = "ColorSets",
                _presetID = "ResourceColors_Default"
            },
            ColorIndex = "MPType",
            Anchors = {
                [1] = { Point = "TOPLEFT", RelPoint = "TOPLEFT" },
                [2] = { Point = "TOPRIGHT", RelPoint = "TOPRIGHT" },
            }
        },
        SP_Default = {
            BarAlign = "LEFT",
            Padding = 0,
            Thickness = 2,
            Colors = {
                _preset = true,
                _presetType = "ColorSets",
                _presetID = "ResourceColors_Default",
            },
            ColorIndex = "SPType",
            Anchors = {
                [1] = { Point = "BOTTOMLEFT", RelPoint = "BOTTOMLEFT" },
                [2] = { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT" }
            }
        }
    },
    ColorSets = {
        ClassColors_Default = {
            -- raw copy: /run local msg="" for k,v in pairs(g_ClassColors) do msg = msg..string.format("%s = { %f, %f, %f },\n", k, v.r, v.g, v.b) end Chat_CopyToClipboard(msg)
            THIEF = { 0.000000, 0.839000, 0.773000 },
            WARRIOR = { 0.984000, 0.255000, 0.024000 },
            MAGE = { 0.988000, 0.447000, 0.067000 },
            GM = { 1.000000, 1.000000, 1.000000 },
            RANGER = { 0.647000, 0.839000, 0.011000 },
            HARPSYN = { 0.380000, 0.169000, 0.914000 },
            AUGUR = { 0.157000, 0.549000, 0.925000 },
            PSYRON = { 0.188000, 0.149000, 0.949000 },
            DRUID = { 0.380000, 0.819000, 0.378000 },
            WARDEN = { 0.757000, 0.290000, 0.819000 },
            KNIGHT = { 0.878000, 0.886000, 0.294000 },
        },
        ResourceColors_Default = {
            -- raw copy: /run local msg="" for k,v in pairs(SkillBarColor) do msg = msg..string.format("[%s] = { %f, %f, %f },\n", k, v.r, v.g, v.b) end Chat_CopyToClipboard(msg)
            [1] = { 0.000000, 0.000000, 1.000000 }, -- Mana
            [2] = { 1.000000, 1.000000, 0.000000 }, -- Rage
            [3] = { 0.000000, 1.000000, 0.000000 }, -- Focus
            [4] = { 0.500000, 0.000000, 1.000000 }, -- Energy
        }
    },
    Frames = {
        Default = {
            GridFrame = {
                Type = "frame",
            },
            UnitFrame = {
                Type = "Frame",
                Elements = {
                    Text = {
                        Name = "UnitFrameText",
                        Anchors = {
                            { Point = "TOPLEFT", RelPoint = "TOPLEFT", OffsetX = 0, OffsetY = 0 },
                            { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT", OffsetX = 0, OffsetY = 0 }
                        }
                    },
                    HealthBar = {

                    }
                }
            }
        }
    }
}

config.Profiles = {
    Default = {
        Grid = {
            _preset = true,
            _presetType = "Grid",
            _presetID = "Default",

            HealthBar = {
                _preset = true,
                _presetType = "ResourceBars",
                _presetID = "HP_Default",
            }
        },
        Actions = {
        },
        Frames = {
            _preset = true,
            _presetType = "Frames",
            _presetID = "Default"
        }
    }
}

local defaultBackDrop = { edgeFile = "", bgFile = "Interface/Tooltips/Tooltip-background", BackgroundInsets = { top = 0, left = 0, right = 0, bottom = 0 }, EdgeSize = 0, TileSize = 16 }
local defaultFont = { Path = "Fonts/DFHEIMDU.TTF", Size = 12, Weight = "NORMAL", Outline = "NORMAL" }

config.Frames = {
    GridFrame = {
        Type = "Frame",
    },
    UnitFrame = {
        Type = "Frame",
        SizeRel = { Width = 0.07, Height = 0.06 },
        Elements = {
            Text = {
                Name = "UnitFrameText",
                Anchors = {
                    { Point = "TOPLEFT", RelPoint = "TOPLEFT", OffsetX = 0, OffsetY = 0 },
                    { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT", OffsetX = 0, OffsetY = 0 }
                }
            },
            HealthBar = {
                Name = "HealthBar",
                Anchors = {
                    { Point = "TOPLEFT", RelPoint = "TOPLEFT", OffsetX = 0, OffsetY = 0 },
                    { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT", OffsetX = 0, OffsetY = 0 }
                }
            }
        },
    },
    HealthBar = {
        Type = "Frame",
        Size = { Width = 100, Height = 15 },
        FrameLevel = 1,
        Elements = {
            BarTexture = {
                Name = "HealthBarTexture",
                Anchor = { Point = "LEFT", RelPoint = "LEFT", OffsetX = 1, OffsetY = 0 },
                Layer = 2
            },
            BackgroundTexture = {
                Name = "HealthBarBackTexture",
                Anchors = {
                    { Point = "TOPLEFT", RelPoint = "TOPLEFT", OffsetX = 0, OffsetY = 0 },
                    { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT", OffsetX = 0, OffsetY = 0 }
                },
                Layer = 1
            }
        }
    },
    HealthBarTexture = {
        Type = "Texture",
        Texture = "interface/common/bar/round.tga",
        TexCoord = { Left = 0.2, Right = 0.9, Top = 0, Bottom = 0.75 },
        Color = { 1, 1, 1 }
    },
    HealthBarBackTexture = {
        Type = "Texture",
        Texture = "interface/tooltips/tooltip-background",
        TexCoord = { Left = 0, Right = 1, Top = 0, Bottom = 1 },
        Color = { 0, 0, 0 },
        Alpha = 0.5
    },
    ManaBar = {
        Type = "Frame",
        Size = { Width = 50, Height = 5 },
        FrameLevel = 3,
        Elements = {
            BarTexture = {
                Name = "ManaBarTexture",
                Anchor = { Point = "LEFT", RelPoint = "LEFT", OffsetX = 1, OffsetY = 0 },
                Layer = 2
            },
            BackgroundTexture = {
                Name = "ManaBarBackTexture",
                Anchors = {
                    { Point = "TOPLEFT", RelPoint = "TOPLEFT", OffsetX = 0, OffsetY = 0 },
                    { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT", OffsetX = 0, OffsetY = 0 }
                },
                Layer = 1
            }
        }
    },
    ManaBarTexture = {
        Type = "Texture",
        Texture = "Interface/common/bar/gloss",
        TexCoord = { Left = 0, Right = 1, Top = 0, Bottom = 0.125 },
        Color = { 0, 0, 0 }
    },
    ManaBarBackTexture = {
        Type = "Texture",
        Texture = "Interface/common/bar/gloss",
        TexCoord = { Left = 0, Right = 1, Top = 0.875, Bottom = 1 },
        Color = { 0, 0, 0 }
    },
    SkillBar = {
        Type = "Frame",
        Size = { Width = 50, Height = 5 },
        FrameLevel = 3,
        Elements = {
            BarTexture = {
                Name = "ManaBarTexture",
                Anchor = { Point = "LEFT", RelPoint = "LEFT", OffsetX = 1, OffsetY = 0 },
                Layer = 2
            },
            BackgroundTexture = {
                Name = "ManaBarBackTexture",
                Anchors = {
                    { Point = "TOPLEFT", RelPoint = "TOPLEFT", OffsetX = 0, OffsetY = 0 },
                    { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT", OffsetX = 0, OffsetY = 0 }
                },
                Layer = 1
            }
        }
    },
    UnitFrameText = {
        Type = "Frame",
        FrameLevel = 2,
        Elements = {
            Name = {
                Name = "TextName",
                Anchors = {
                    { Point = "TOPLEFT", RelPoint = "TOPLEFT", OffsetX = 0, OffsetY = 10 },
                    { Point = "TOPRIGHT", RelPoint = "TOPRIGHT", OffsetX = 0, OffsetY = 10 }
                },
                Layer = 5
            },
            Health = {
                Name = "TextHealth",
                Anchors = {
                    { Point = "BOTTOMLEFT", RelPoint = "BOTTOMLEFT", OffsetX = 0, OffsetY = -10 },
                    { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT", OffsetX = 0, OffsetY = -10 }
                },
                Layer = 5
            }
        }
    },
    TextName = {
        Type = "FontString",
        Font = defaultFont,
        Color = { 1, 1, 1 },
    },
    TextHealth = {
        Type = "FontString",
        Font = defaultFont,
        Color = { 0.8, 0.8, 0.8 },
    },
    UnitFrameBuff = {
        Type = "Frame",
        Size = { Width = 16, Height = 16 },
        FrameLevel = 4,
        Elements = {
            Icon = {
                Name = "DebuffIcon",
                Anchors = {
                    { Point = "TOPLEFT", RelPoint = "TOPLEFT", OffsetX = 0, OffsetY = 0 },
                    { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT", OffsetX = 0, OffsetY = 0 }
                },
                Layer = 1
            },
            StackCount = {
                Name = "DebuffCount",
                Anchor = { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT", OffsetX = -1, OffsetY = -1 },
                Layer = 2,
                Size = { Width = 16, Height = 12 }
            }
        }
    },
    DebuffIcon = {
        Type = "Texture",
        TexCoord = { Left = 0, Right = 1, Top = 0, Bottom = 1 },
        Size = { Width = 16, Height = 16 }
    },
    DebuffCount = {
        Type = "FontString",
        Font = defaultFont,
        Color = { 1, 0.66, 0 },
        Text = "0",
        Justify = "RIGHT"
    },
    ActionMenuListItem = {
        Type = "Frame",
        Size = { Width = 350, Height = 90 },
        BackDrop = { edgeFile = "Interface/Tooltips/Tooltip-border", bgFile = "Interface/Tooltips/Tooltip-background", BackgroundInsets = { top = 4, left = 4, right = 4, bottom = 4 }, EdgeSize = 16, TileSize = 16 },
        Elements = {
            Icon = {
                Name = "AMLI_ActionIcon",
                Anchor = { Point = "TOPLEFT", RelPoint="TOPLEFT", OffsetX = 10, OffsetY = 10 },
                Layer = 3
            },
            TextAction = {
                Name = "AMLI_Text",
                Anchor = { Point = "TOPLEFT", RelPoint = "TOPLEFT", OffsetX = 50, OffsetY = 5 },
                Layer = 2,
                Text = "AMLI_TXT_ACTION",
                Size = { Width = 50, Height = 15 }
            },
            TextKeys = {
                Name = "AMLI_Text",
                Anchor = { Point = "TOPLEFT", RelPoint = "TOPLEFT", OffsetX = 50, OffsetY = 25 },
                Layer = 2,
                Text = "AMLI_TXT_KEYS",
                Size = { Width = 50, Height = 15 }
            },
            TextExtra = {
                Name = "AMLI_Text",
                Anchor = { Point = "TOPLEFT", RelPoint = "TOPLEFT", OffsetX = 50, OffsetY = 45 },
                Layer = 2,
                Size = { Width = 50, Height = 15 },
            },
            BtnAction = {
                Name = "AMLI_Button",
                Anchor = { Point = "TOPLEFT", RelPoint = "TOPRIGHT", OffsetX = 10, OffsetY = 0, RelTo = "TextAction" },
                Size = { Width = 90, Height = 19 }
            },
            TextValueExtra = {
                Name = "AMLI_Text",
                Anchor = { Point = "TOPLEFT", RelPoint = "TOPRIGHT", OffsetX = 10, OffsetY = 0, RelTo = "TextExtra" },
                Size = { Width = 180, Height = 15 },
                Layer = 2
            },
            BtnMouseButton = {
                Name = "AMLI_Button",
                Anchor = { Point = "TOPLEFT", RelPoint = "TOPRIGHT", OffsetX = 10, OffsetY = 0, RelTo = "TextKeys" },
                Size = { Width = 90, Height = 19 }
            },
            ChkBtnCtrl = {
                Name = "AMLI_CheckButton",
                Anchor = { Point = "TOPLEFT", RelPoint = "TOPRIGHT", OffsetX = 4, OffsetY = 0, RelTo = "BtnMouseButton" },
                Size = { Width = 40, Height = 19 }
            },
            ChkBtnAlt = {
                Name = "AMLI_CheckButton",
                Anchor = { Point = "TOPLEFT", RelPoint = "TOPRIGHT", OffsetX = 4, OffsetY = 0, RelTo = "ChkBtnCtrl" },
                Size = { Width = 40, Height = 19 }
            },
            ChkBtnShift = {
                Name = "AMLI_CheckButton",
                Anchor = { Point = "TOPLEFT", RelPoint = "TOPRIGHT", OffsetX = 4, OffsetY = 0, RelTo = "ChkBtnAlt" },
                Size = { Width = 50, Height = 19 }
            },
            BtnDetails = {
                Name = "AMLI_Button",
                Anchor = { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT", OffsetX = -5, OffsetY = -5 },
                Size = { Width = 60, Height = 19 }
            },
            ChkBtnSecSave = {
                Name = "AMLI_CheckButton",
                Anchor = { Point = "BOTTOMLEFT", RelPoint = "BOTTOMLEFT", OffsetX = 50, OffsetY = -5 },
                Size = { Width = 100, Height = 19 },
            },
            BtnRemove = {
                Name = "AMLI_CloseButton",
                Anchor = { Point = "TOPRIGHT", RelPoint = "TOPRIGHT", OffsetX = -5, OffsetY = 5 },
            }
        }
    },
    AMLI_ActionIcon = {
        Type = "Texture",
        Size = { Width = 30, Height = 30 },
        Texture = "interface\buttons\quickslot-normal_noalpha"
    },
    AMLI_ActionName = {
        Type = "FontString",
        Size = { Width = 200, Height = 20 },
        Font = defaultFont
    },
    AMLI_Text = {
        Type = "FontString",
        Font = defaultFont,
        Justify = "LEFT"
    },
    AMLI_Button = {
        Type = "Frame",
        Size = { Width = 80, Height = 19 },
        Elements = {
            _normalTexture = {
                Name = "AMLI_Button_NormalTexture",
                Anchor = { Point = "CENTER", RelPoint = "CENTER", OffsetX = 0, OffsetY = 0 },
                Layer = 2,
                RelSize = { Width = 1, Height = 1 }
            },
            _pushedTexture = {
                Name = "AMLI_Button_PushedTexture",
                Anchor = { Point = "CENTER", RelPoint = "CENTER", OffsetX = 0, OffsetY = 0 },
                Layer = 2,
                RelSize = { Width = 1, Height = 1 }
            },
            _highlightTexture = {
                Name = "AMLI_Button_HighlightTexture",
                Anchor = { Point = "CENTER", RelPoint = "CENTER", OffsetX = 0, OffsetY = 0 },
                Layer = 3,
                RelSize = { Width = 1, Height = 1 }
            },
            _text = {
                Name = "AMLI_Button_Text",
                Anchor = { Point = "CENTER", RelPoint = "CENTER", OffsetX = -1, OffsetY = -1 },
                Layer = 4,
                RelSize = { Width = 0.9, Height = 0.95 }
            }
        }
    },
    AMLI_Button_PushedTexture = {
        Type = "Texture",
        Texture = "Interface/Buttons/PanelButton-Depress",
        --Size = { Width = 50, Height = 19 },
        TexCoord = { Left = 0, Right = 0.6875, Top = 0, Bottom = 0.75 }
    },
    AMLI_Button_NormalTexture = {
        Type = "Texture",
        Texture = "Interface/Buttons/PanelButton-Normal",
        --Size = { Width = 50, Height = 19 },
        TexCoord = { Left = 0, Right = 0.6875, Top = 0, Bottom = 0.75 }
    },
    AMLI_Button_HighlightTexture = {
        Type = "Texture",
        Texture = "Interface/Buttons/PanelButton-Highlight",
        --Size = { Width = 50, Height = 19 },
        TexCoord = { Left = 0, Right = 0.6875, Top = 0, Bottom = 0.75 },
        AlphaMode = "ADD"
    },
    AMLI_Button_Text = {
        Type = "FontString",
        Font = defaultFont
    },
    AMLI_CheckButton = {
        Type = "Frame",
        Size = { Width = 80, Height = 19 },
        Elements = {
            _normalTexture = {
                Name = "AMLI_CheckButton_NormalTexture",
                Anchor = { Point = "LEFT", RelPoint = "LEFT", OffsetX = 0, OffsetY = 0 },
                Layer = 2,
                Size = { Width = 16, Height = 16 }
            },
            _pushedTexture = {
                Name = "AMLI_CheckButton_PushedTexture",
                Anchor = { Point = "LEFT", RelPoint = "LEFT", OffsetX = 0, OffsetY = 0 },
                Layer = 2,
                Size = { Width = 16, Height = 16 }
            },
            _highlightTexture = {
                Name = "AMLI_CheckButton_HighlightTexture",
                Anchor = { Point = "LEFT", RelPoint = "LEFT", OffsetX = 0, OffsetY = 0 },
                Layer = 3,
                Size = { Width = 16, Height = 16 }
            },
            _checkedTexture = {
                Name = "AMLI_CheckButton_CheckedTexture",
                Anchor = { Point = "LEFT", RelPoint = "LEFT", OffsetX = 0, OffsetY = 0 },
                Layer = 4,
                Size = { Width = 16, Height = 16 }
            },
            _text = {
                Name = "AMLI_CheckButton_Text",
                Anchor = { Point = "LEFT", RelPoint = "LEFT", OffsetX = 18, OffsetY = 0 },
                Layer = 4,
                RelSize = { dWidth = -18, dHeight = -2 },
            }
        }
    },
    AMLI_CheckButton_NormalTexture = {
        Type = "Texture",
        Texture = "Interface/Buttons/CheckBox-Normal",
    },
    AMLI_CheckButton_PushedTexture = {
        Type = "Texture",
        Texture = "Interface/Buttons/CheckBox-Depress",
    },
    AMLI_CheckButton_HighlightTexture = {
        Type = "Texture",
        Texture = "Interface/Buttons/CheckBox-Highlight",
        AlphaMode = "ADD"
    },
    AMLI_CheckButton_CheckedTexture = {
        Type = "Texture",
        Texture = "Interface/Buttons/CheckBox-Checked",
    },
    AMLI_CheckButton_Text = {
        Type = "FontString",
        Font = defaultFont,
        Justify = "LEFT",
    },
    AMLI_CloseButton = {
        Type = "Frame",
        Size = { Width = 16, Height = 16 },
        Elements = {
            _pushedTexture = {
                Name = "AMLI_CloseButton_PushedTexture",
                Anchor = { Point = "CENTER", RelPoint = "CENTER", OffsetX = 0, OffsetY = 0 },
                RelSize = { },
                Layer = 2
            },
            _normalTexture = {
                Name = "AMLI_CloseButton_NormalTexture",
                Anchor = { Point = "CENTER", RelPoint = "CENTER", OffsetX = 0, OffsetY = 0 },
                RelSize = { },
                Layer = 2
            },
            _highlightTexture = {
                Name = "AMLI_CloseButton_HighlightTexture",
                Anchor = { Point = "CENTER", RelPoint = "CENTER", OffsetX = -1, OffsetY = -1 },
                RelSize = { },
                Layer = 3
            }
        }
    },
    AMLI_CloseButton_NormalTexture = {
        Type = "Texture",
        Texture = "interface/buttons/panelclosebutton-normal",
        TexCoord = { Left = 0, Right = 0.625, Top = 0, Bottom = 0.625 }
    },
    AMLI_CloseButton_PushedTexture = {
        Type = "Texture",
        Texture = "interface/buttons/panelclosebutton-depress",
        TexCoord = { Left = 0, Right = 0.625, Top = 0, Bottom = 0.625 }
    },
    AMLI_CloseButton_HighlightTexture = {
        Type = "Texture",
        Texture = "interface/buttons/panelclosebutton-highlight",
        TexCoord = { Left = 0, Right = 0.625, Top = 0, Bottom = 0.625 },
        AlphaMode = "ADD"
    },
}

config.Grid = {
    Active = true,
    SpacingX = 2,
    SpacingY = 5,
    GroupAlign = "BOTTOM",
    UnitAlign = "LEFT",
    Padding = 2,
    PaddingPet = 10,
    Pos = { X = 0.4, Y = 0.59 },
    Size = { Width = 0.45, Height = 0.35 },
    MaxNumPartyMember = 36,
    ShowOwnPet = true,
    ShowWardenPet = true,
    ShowPriestPet = true,
    SoloMode = true,
    GridParent = "UIParent",
    DCAlpha = 0.3,

    Buffs = {
        Count = 1,
        [1] = {
            Size = { Width = 16, Height = 16 },
            Anchor = { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT", OffsetX = -1, OffsetY = -1 },
            Filter = {
                Mode = "WhiteListOnly",
                Index = 1,
                Include = {
                    [500527] = 2, -- "Salbe"
                    [503816] = 1, -- "Samen der Heilung"
                }
            }
        },
        Scale = 1.0,
        Alpha = 1.0,
        StackCount = false,
        ShowCDTimer = true
    },
    Debuffs = {
        Count = 4,
        [1] = {
            Size = { Width = 16, Height = 16 },
            Anchor = { Point = "CENTER", RelPoint = "CENTER", OffsetX = -30, OffsetY = 0 },
            Filter = {
                Mode = "ParamsBlackList",
                Params = { [6] = true, [9] = true, [10] = true },
                Ignore = {},
                Include = {},
            }
        },
        [2] = {
            Size = { Width = 16, Height = 16 },
            Anchor = { Point = "CENTER", RelPoint = "CENTER", OffsetX = -10, OffsetY = 0 },
            Filter = {
                Mode = "ParamsWhiteList",
                Params = { [6] = true },
                Ignore = {},
                Include = {},
            }
        },
        [3] = {
            Size = { Width = 16, Height = 16 },
            Anchor = { Point = "CENTER", RelPoint = "CENTER", OffsetX = 10, OffsetY = 0 },
            Filter = {
                Mode = "ParamsWhiteList",
                Params = { [10] = true },
                Ignore = {},
                Include = {},
            }
        },
        [4] = {
            Size = { Width = 16, Height = 16 },
            Anchor = { Point = "CENTER", RelPoint = "CENTER", OffsetX = 30, OffsetY = 0 },
            Filter = {
                Mode = "ParamsWhiteList",
                Params = { [9] = true },
                Ignore = {},
                Include = {},
            }
        },
        Scale = 1.0,
        Alpha = 1.0,
        ShowStackCount = true,
        ShowCDTimer = true
    },
    HealthBar = {
        BarAlign = "LEFT",
        Padding = 2,
        Colors = {
            -- raw copy: /run local msg="" for k,v in pairs(g_ClassColors) do msg = msg..string.format("%s = { %f, %f, %f },\n", k, v.r, v.g, v.b) end Chat_CopyToClipboard(msg)
            THIEF = { 0.000000, 0.839000, 0.773000 },
            WARRIOR = { 0.984000, 0.255000, 0.024000 },
            MAGE = { 0.988000, 0.447000, 0.067000 },
            GM = { 1.000000, 1.000000, 1.000000 },
            RANGER = { 0.647000, 0.839000, 0.011000 },
            HARPSYN = { 0.380000, 0.169000, 0.914000 },
            AUGUR = { 0.157000, 0.549000, 0.925000 },
            PSYRON = { 0.188000, 0.149000, 0.949000 },
            DRUID = { 0.380000, 0.819000, 0.378000 },
            WARDEN = { 0.757000, 0.290000, 0.819000 },
            KNIGHT = { 0.878000, 0.886000, 0.294000 },
        },
        Anchors = {
            [1] = { Point = "TOPLEFT", RelPoint = "TOPLEFT" },
            [2] = { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT" }
        }
    },
    ManaBar = {
        BarAlign = "LEFT",
        Padding = 0,
        Thickness = 2,
        Colors = {
            -- raw copy: /run local msg="" for k,v in pairs(SkillBarColor) do msg = msg..string.format("[%s] = { %f, %f, %f },\n", k, v.r, v.g, v.b) end Chat_CopyToClipboard(msg)
            [1] = { 0.000000, 0.000000, 1.000000 },
            [2] = { 1.000000, 1.000000, 0.000000 },
            [3] = { 0.000000, 1.000000, 0.000000 },
            [4] = { 0.500000, 0.000000, 1.000000 },
        },
        Anchors = {
            [1] = { Point = "TOPLEFT", RelPoint = "TOPLEFT", OffsetX = 0, OffsetY = 0 },
            [2] = { Point = "TOPRIGHT", RelPoint = "TOPRIGHT", OffsetX = 0, OffsetY = 0 }
        }
    },
    SkillBar = {
        BarAlign = "LEFT",
        Padding = 0,
        Thickness = 2,
        Colors = {
            -- raw copy: /run local msg="" for k,v in pairs(SkillBarColor) do msg = msg..string.format("[%s] = { %f, %f, %f },\n", k, v.r, v.g, v.b) end Chat_CopyToClipboard(msg)
            [1] = { 0.000000, 0.000000, 1.000000 },
            [2] = { 1.000000, 1.000000, 0.000000 },
            [3] = { 0.000000, 1.000000, 0.000000 },
            [4] = { 0.500000, 0.000000, 1.000000 },
        },
        Anchors = {
            [1] = { Point = "BOTTOMLEFT", RelPoint = "BOTTOMLEFT", OffsetX = 0, OffsetY = 0 },
            [2] = { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT", OffsetX = 0, OffsetY = 0 }
        }
    }
}

config.Actions = {
}

config.Poison = {}

config.Harmful = {}

config.Curse = {}

config.Debuffs = {}

config.Salve = {
    [500527] = "Salbe",
    [503816] = "Samen der Heilung"
}

config.SkillDB = {
    [490280] = { IsCast = true }, -- Ritual der Wiederbelebung9
    [490294] = { IsCast = false }, -- Salbe
    [491176] = { IsCast = true }, -- Verbessertes Ritual der Wiederbelebung
    [493526] = { IsCast = true }, -- Leben wiederherstellen
    [493528] = { IsCast = true }, -- Erholung
    [493529] = { IsCast = false }, -- Quell von Mutter Erde
    [493531] = { IsCast = false }, -- Wilde Segnung
    [493533] = { IsCast = false }, -- Schutz von Mutter Erde
    [493534] = { IsCast = false }, -- Reinigen (Druide)
    [493535] = { IsCast = false }, -- Gegengift
    [493547] = { IsCast = false }, -- Samen der Heilung
    [493537] = { IsCast = true }, -- Wiedergeburt
    [493559] = { IsCast = true }, -- Verbesserte Wiedergeburt
    [494010] = { IsCast = false }, -- Kamelienblüte
    [494323] = { IsCast = true }, -- Heilende Welle
    [499573] = { IsCast = false }, -- Gestrüppschild
    [503795] = { IsCast = false }, -- Blühendes Leben
}

return config
