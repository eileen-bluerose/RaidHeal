local profiles = {}

profiles.Default = {
    Grid = {
        Unit = {
            HealthBar = {
                _preset = { Type = "BarSettings", ID = "HP"},
            },
            NameDisplay = {
                _preset = { Type = "DisplaySettings", ID = "Name" },
            },
            HealthDisplay = {
                _preset = { Type = "DisplaySettings", ID = "Health" },
            },
            ManaBar = {
                _preset = { Type = "BarSettings", ID = "MP" }
            },
            SkillBar = {
                _preset = { Type = "BarSettings", ID = "SP" }
            },
            Highlight = {
                _preset = { Type = "HighlightSettings", ID = "Border" }
            },
            Buffs = {
                Count = 1,
                ShowCDTimer = true,
                ShowStackCount = false,

                [1] = {
                    _preset = { Type = "BuffSettings", ID = "Default" },
                    Filter = {
                        Include = {
                            [500527] = 2, -- "Salbe"
                            [503816] = 1, -- "Samen der Heilung"
                        }
                    },
                    Template = {
                        Anchors = {
                            { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT", OffsetX = -1, OffsetY = -1 }
                        }
                    }
                }
            },
            Debuffs = {
                Count = 4,
                ShowCDTimer = true,
                ShowStackCount = true,

                [1] = {
                    _preset = { Type = "BuffSettings", ID = "Default" },
                    Filter = {
                        Mode = "ParamsBlackList",
                        Index = 1,
                        Params = { [6] = true, [9] = true, [10] = true },
                        Ignore = {}
                    },
                    Template = {
                        Anchors = {
                            { Point = "CENTER", RelPoint = "CENTER", OffsetX = -30, OffsetY = 0 }
                        }
                    }
                },
                [2] = {
                    _preset = { Type = "BuffSettings", ID = "Default" },
                    Filter = {
                        Mode = "ParamsWhiteList",
                        Params = { [6] = true }
                    },
                    Template = {
                        Anchors = {
                            { Point = "CENTER", RelPoint = "CENTER", OffsetX = -10, OffsetY = 0 }
                        }
                    }
                },
                [3] = {
                    _preset = { Type = "BuffSettings", ID = "Default" },
                    Filter = {
                        Mode = "ParamsWhiteList",
                        Params = { [10] = true }
                    },
                    Template = {
                        Anchors = {
                            { Point = "CENTER", RelPoint = "CENTER", OffsetX = 10, OffsetY = 0 }
                        }
                    }
                },
                [4] = {
                    _preset = { Type = "BuffSettings", ID = "Default" },
                    Filter = {
                        Mode = "ParamsWhiteList",
                        Params = { [9] = true }
                    },
                    Template = {
                        Anchors = {
                            { Point = "CENTER", RelPoint = "CENTER", OffsetX = 30, OffsetY = 0 }
                        }
                    }
                }
            }
        },
        MaxNumUnits = 36,
        UnitsPerGroup = 6,
        Parent = "UIParent",
        UnitAlign = "LEFT",
        GroupAlign = "BOTTOM",

        Size = { Width = 0.5, Height = 0.35 },
        Anchor = { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT", OffsetX = -0.2, OffsetY = -0.15 },
        Spacing = { Vertical = 1, Horizontal = 1 },

        SoloMode = true,
        Active = true
    },
    Focus = {
        Unit = {
            HealthBar = {
                _preset = { Type = "BarSettings", ID = "HP" }
            },
            NameDisplay = {
                _preset = { Type = "DisplaySettings", ID = "Name" }
            },
            HealthDisplay = {
                _preset = { Type = "DisplaySettings", ID = "Health" }
            }
        },
        MaxNumUnits = 12,
        UnitsPerGroup = 6,
        Parent = "UIParent",
        UnitAlign = "TOP",
        GroupAlign = "LEFT",

        Size = { Width = 0.15, Height = 0.4 },
        Anchor = { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT", OffsetX = -0.02, OffsetY = -0.2 },
        Spacing = { Vertical = 5, Horizontal = 2 }
    }
}

return profiles
