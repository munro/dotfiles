import System.IO
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.LayoutHints
import XMonad.Layout.Named
import XMonad.Layout.ResizableTile 
import XMonad.ManageHook
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)
import qualified XMonad.StackSet as W


-- Program Exceptions
myManageHook  = composeAll [ resource =? "gitk"  --> doF (W.swapMaster)
                           , resource =? "meld"  --> doF (W.swapMaster)
                           , resource =? "gitg"  --> doF (W.swapMaster)
                           , resource =? "hgk"  --> doF (W.swapMaster)
                           ]
newManageHook = myManageHook <+> manageDocks <+> manageHook defaultConfig

-- Xmonad
main = do
    hXmobar <- spawnPipe "/usr/bin/xmobar"
    xmonad =<< xmobar ((withUrgencyHook NoUrgencyHook) defaultConfig
        { modMask               = mod4Mask 
        , terminal              = "gnome-terminal"
        , workspaces            = map show [1..6]
        , normalBorderColor     = colorNormalBorder
        , focusedBorderColor    = colorFocusedBorder
        , borderWidth           = 2
        , layoutHook            = avoidStruts $ wmLayout
        , manageHook            = newManageHook
        , logHook               = wmLog hXmobar 
        } `additionalKeys` wmKeys)

-- Colors
colorNormalBorder   = "#18191B"
colorFocusedBorder  = "#5C3566"

-- Layout
wmLayout = layoutHintsToCenter (wmLayoutTall ||| wmLayoutWide ||| Full ||| wmLayoutTiny ||| wmLayoutResize) 

wmLayoutTall = named "Tall" (Tall 1 (3/100) (6/10))
wmLayoutWide = named "Wide" (Mirror $ Tall 1 (3/100) (7/10))
wmLayoutTiny = named "Tiny" (Tall 1 (1/10) (7/10))
wmLayoutResize = named "Tall" (ResizableTall 1 (3/100) (1/2) [])

-- Keys
wmKeys = 
    [ ((mod4Mask, xK_z), sendMessage MirrorShrink)
    , ((mod4Mask, xK_a), sendMessage MirrorExpand)
    ]

-- Logging/Status
wmLog h = dynamicLogWithPP $ defaultPP
    { ppOutput              = hPutStrLn h
    , ppCurrent             = xmobarColor colorFocusedBorder "" . pad
    , ppVisible             = xmobarColor colorNormalBorder "" . pad
    , ppHidden              = xmobarColor "#D1C8BC" "" . pad
    , ppHiddenNoWindows     = xmobarColor "#5C5245" "" . pad
    , ppUrgent              = xmobarColor "#101010" colorFocusedBorder . xmobarStrip
    , ppWsSep               = ""
    , ppSep                 = " : "
    , ppLayout              = (\x -> case x of
        "Hinted Tall" -> "#"
        "Hinted Wide" -> "!"
        "Hinted Full" -> "*"
        "Hinted Tiny" -> "@"
        _             -> "~"
    )
    , ppTitle               = xmobarColor colorFocusedBorder "" . shorten 50
    }
