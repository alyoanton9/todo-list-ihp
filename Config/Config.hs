module Config where

import Control.Monad.Logger (logInfoN, runStdoutLoggingT)
import Data.Text (intercalate)
import Network.Wai (Middleware, pathInfo)

import IHP.Prelude
import IHP.Environment
import IHP.FrameworkConfig

config :: ConfigBuilder
config = do
    option Development
    option (AppHostname "localhost")

    -- Add custom middleware
    option . CustomMiddleware $ Config.logger

-- | Custom logger function. Extracts URL path from request,
-- and logs it with @Info@ verbosity level.
logger :: Middleware
logger app request responseFunc = do
  let requestedPath = intercalate "/" $
        pathInfo request
  let msg = "url-path=" <> requestedPath
  runStdoutLoggingT $ logInfoN msg
  app request responseFunc
