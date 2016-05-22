module Main where

import Data.Either
import Control.Monad.Eff (Eff)

import Data.Foreign.EasyFFI (unsafeForeignFunction)
import Data.Traversable (traverse)
import Graphics.D3.Base (D3, D3Eff)
import Graphics.D3.Request (csv)
import Graphics.D3.Selection (duration, delay, transition, rootSelect, attr, attr', selectAll, bindData, enter, append)
import Graphics.D3.Util ((..))
import Prelude (bind, show, Unit)

type Circle = { k :: Number, v :: Number }

coerceDatum :: forall a. a -> D3Eff Circle
coerceDatum = unsafeForeignFunction ["x", ""] "{ k: Number(x.k), v: Number(x.v) }"

main :: forall t14. Eff ( d3 :: D3| t14 ) (Unit)
main = do

  csv "sample.csv" \(Right array) -> do
      circles <- traverse coerceDatum array
      rootSelect ".chart > svg"
          .. attr "height" "400"
           .. attr "width" "400"
           .. selectAll "circle"
            .. bindData circles
           .. enter .. append "circle"
           .. attr' "cx" (\d -> show (d.k))
           .. attr' "cy" (\d -> show (d.v))
           .. attr "r" "8"
           .. transition
           .. delay 300.0
           .. duration 1000.0
           .. attr "cy" "80"
