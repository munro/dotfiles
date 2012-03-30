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

-- Colors
colorNormalBorder  = "#111111"
colorFocusedBorder = "#FFC469"

-- Layout
wmLayout       = layoutHintsToCenter (   wmLayoutTall ||| wmLayoutWide ||| Full
                                     ||| wmLayoutTiny ||| wmLayoutResize
                                     )

wmLayoutTall   = named "Tall" (Tall          1 (3/100) (6/10))
wmLayoutWide   = named "Wide" (Mirror $ Tall 1 (3/100) (7/10))
wmLayoutTiny   = named "Tiny" (Tall          1 (1/10)  (7/10))
wmLayoutResize = named "Tall" (ResizableTall 1 (3/100) (1/2)  [])

-- Keys
wmKeys = [ ((mod4Mask, xK_z), sendMessage MirrorShrink)
         , ((mod4Mask, xK_a), sendMessage MirrorExpand)
         ]

-- Xmonad
main = do
    hNodeDzen <- spawnPipe "/home/ryan/node-dzen"
    xmonad $ (withUrgencyHook NoUrgencyHook) defaultConfig
        { modMask            = mod4Mask
        , terminal           = "urxvt -name foobar"
        , workspaces         = map show [1..6]
        , normalBorderColor  = colorNormalBorder
        , focusedBorderColor = colorFocusedBorder
        , borderWidth        = 2
        , layoutHook         = avoidStruts $ wmLayout
        , manageHook         = newManageHook
        , logHook            = dynamicLogWithPP $ defaultPP { ppOutput = hPutStrLn hNodeDzen }
        } `additionalKeys` wmKeys
