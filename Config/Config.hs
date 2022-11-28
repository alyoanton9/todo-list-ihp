module Config where

import IHP.Prelude
import IHP.Environment
import IHP.FrameworkConfig
import Katip
import Network.Wai (Middleware, rawPathInfo, requestHeaderUserAgent)
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import System.IO (stdout)

config :: ConfigBuilder
config = do
    option Development
    option (AppHostname "localhost")
    logEnv <- liftIO defaultLogEnv
    -- Add custom middleware
    option . CustomMiddleware $ katipLogger logEnv

-- | Custom @Katip@ logger to add as a middleware.
katipLogger :: LogEnv -> Middleware
katipLogger env app request responseFunc = runKatipT env $ do
  let userAgent = fromMaybe "undefined" $ requestHeaderUserAgent request
  let requestedPath = rawPathInfo request
  let msg = "raw path=" <> requestedPath <> " user agent=" <> userAgent
  logMsg "middleware" InfoS $ logStr msg
  liftIO $ app request responseFunc

defaultLogEnv :: IO LogEnv
defaultLogEnv = do
  let permitFunc = permitItem DebugS
  handleScribe <- mkHandleScribe ColorIfTerminal stdout permitFunc V2
  logEnv <- initLogEnv "todo-list-ihp" "production"
  registerScribe "stdout" handleScribe defaultScribeSettings logEnv
