local presets = {}

local defaultFont = { Path = "Fonts/DFHEIMDU.TTF", Size = 12, Weight = "NORMAL", Outline = "NORMAL" }

presets.ClassColors = {
    RoM = {
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
        DUELIST = { 1, 0, 0 } -- extra
    },
    WoW = {
        -- ...
    }
}

presets.ResourceColors = {
    RoM = {
        -- raw copy: /run local msg="" for k,v in pairs(SkillBarColor) do msg = msg..string.format("[%s] = { %f, %f, %f },\n", k, v.r, v.g, v.b) end Chat_CopyToClipboard(msg)
        [1] = { 0.000000, 0.000000, 1.000000 }, -- MANA
        [2] = { 1.000000, 1.000000, 0.000000 }, -- RAGE
        [3] = { 0.000000, 1.000000, 0.000000 }, -- FOCUS
        [4] = { 0.500000, 0.000000, 1.000000 }, -- ENERGY
    },
    WoW = {
        -- ...
    }
}

presets.FrameTemplates = {
    BarTemplate = {
        Type = "Frame",
        Elements = {
            Background = {
                Type = "Texture",
                Texture = "",
                Anchors = {
                    { Point = "TOPLEFT", RelPoint = "TOPLEFT", OffsetX = 0, OffsetY = 0 },
                    { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT", OffsetX = 0, OffsetY = 0 },
                },
                Layer = 1
            },
            Bar = {
                Type = "Texture",
                Texture = "",
                Layer = 2
            }
        }
    },
    HealthBarTemplate = {
        _preset = { Type = "FrameTemplates", ID = "BarTemplate" },
        Elements = {
            Background = {
                Texture = "interface/tooltips/tooltip-background"
            },
            Bar = {
                Texture = "interface/common/bar/round.tga",
                TexCoord = { Left = 0.2, Right = 0.9, Top = 0, Bottom = 0.75 },
            }
        },
        FrameLevel = 1
    },
    ManaBarTemplate = {
        _preset = { Type = "FrameTemplates", ID = "BarTemplate" },
        Elements = {
            Background = {
                Texture = "Interface/common/bar/gloss",
                TexCoord = { Left = 0, Right = 1, Top = 0.875, Bottom = 1 },
                Alpha = 0
            },
            Bar = {
                Texture = "Interface/common/bar/gloss",
                TexCoord = { Left = 0, Right = 1, Top = 0, Bottom = 0.125 },
            }
        },
        dSize = { fHeight = 0, dHeight = 3, fWidth = 1, dWidth = 0 },
        FrameLevel = 2
    },
    TextDisplay = {
        Type = "Frame",
        dSize = { dWidth = -4, fWidth = 1, dHeight = 20, fHeight = 0 },
        Elements = {
            Text = {
                Type = "FontString",
                Text = "",
                Font = defaultFont,
                Anchors = {
                    { Point = "TOPLEFT", RelPoint = "TOPLEFT" },
                    { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT" }
                },
                Layer = 3
            }
        }
    },
    UnitFrameTemplate = {
        Type = "Frame"
    },
    BuffIconTemplate = {
        Type = "Frame",
        Size = { Width = 16, Height = 16 },
        FrameLevel = 3,
        Elements = {
            Icon = {
                Type = "Texture",
                Anchors = {
                    { Point = "TOPLEFT", RelPoint = "TOPLEFT" },
                    { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT" }
                },
                Layer = 2
            },
            StackCount = {
                Type = "FontString",
                Font = defaultFont,
                Color = { 1, 0.75, 0 },
                Anchors = {
                    { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT", OffsetX = -2, OffsetY = -2 }
                },
                Layer = 3
            }
        }
    }
}

presets.BarSettings = {
    HP = {
        BarAlign = "LEFT",
        Padding = 0,
        Colors = {
            _preset = { Type = "ClassColors", ID = "RoM" }
        },
        ColorIndex = "MainClass",
        ParamCur = "HP",
        ParamMax = "HPMax",
        Template = {
            _preset = { Type = "FrameTemplates", ID = "HealthBarTemplate" },
            Anchors = {
                { Point = "TOPLEFT", RelPoint = "TOPLEFT" },
                { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT" }
            },
        }
    },
    MP = {
        BarAlign = "LEFT",
        Padding = 0,
        Colors = {
            _preset = { Type = "ResourceColors", ID = "RoM" }
        },
        ColorIndex = "MPType",
        ParamCur = "MP",
        ParamMax = "MPMax",
        Template = {
            _preset = { Type = "FrameTemplates", ID = "ManaBarTemplate" },
            Anchors = {
                { Point = "TOPLEFT", RelPoint = "TOPLEFT" },
                { Point = "TOPRIGHT", RelPoint = "TOPRIGHT" }
            },
        }
    },
    SP = {
        _preset = { Type = "BarSettings", ID = "MP" },
        ColorIndex = "SPType",
        ParamCur = "SP",
        ParamMax = "SPMax",
        Template = {
            Anchors = {
                { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT" },
                { Point = "BOTTOMLEFT", RelPoint = "BOTTOMLEFT"}
            }
        }
    }
}

presets.DisplaySettings = {
    Name = {
        MaxLength = -1, -- -1 == full length
        Color = { 1, 1, 1 },
        Param = "Name",
        Template = {
            _preset = { Type = "FrameTemplates", ID = "TextDisplay" },
            Anchors = {
                { Point = "TOP", RelPoint = "TOP", OffsetX = 0, OffsetY = 5 }
            },
            FrameLevel = 5
        }
    },
    Health = {
        MaxLength = -1,
        Color = { 0.7, 0.7, 0.7 },
        FormatFunc = {
            Args = { "HP", "HPMax" },
            Type = "Numbers",
            Mode = "Simple"
        },
        Template = {
            _preset = { Type = "FrameTemplates", ID = "TextDisplay" },
            Anchors = {
                { Point = "BOTTOM", RelPoint = "BOTTOM", OffsetX = 0, OffsetY = -5 }
            },
            FrameLevel = 4
        }
    }
}

presets.HighlightSettings = {
    Border = {
        MinAlpha = 0.1,
        MaxAlpha = 0.6,
        Timeout = 2,
        Param = "HasAggro",
        Template = {
            Type = "Frame",
            Anchors = {
                { Point = "TOPLEFT", RelPoint = "TOPLEFT", OffsetX = -3, OffsetY = -3 },
                { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT", OffsetX = 3, OffsetY = 3 }
            },
            Elements = {
                _texture = {
                    Type = "Texture",
                    Anchors = {
                        { Point = "TOPLEFT", RelPoint = "TOPLEFT" },
                        { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT" }
                    },
                    Layer = 5,
                    Texture = "interface/addons/raidheal/graphics/highlight.tga"
                }
            },
            FrameLevel = 0,
            Alpha = 0.7
        }
    }
}

presets.BuffSettings = {
    Default = {
        Filter = {
            Mode = "WhiteListOnly",
            Index = 1,
            Include = {}
        },
        Template = {
            _preset = { Type = "FrameTemplates", ID = "BuffIconTemplate" }
        }
    }
}

return presets
