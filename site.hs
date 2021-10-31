--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import Hakyll
import           System.FilePath(dropExtension)
import Data.String(fromString)
--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "pages/*" $ do
    -- match :: Pattern -> Rules () -> Rules ()
        route $ customRoute myRoute
        -- route :: route -> Rules ()
        -- customRoute:: (indentifer -> Filepath) -> route
        compile $ pandocCompiler
        -- compile :: Compiler () -> Rules ()
            >>= loadAndApplyTemplate "templates/default.html" (defaultContext <> linesInPages)
            >>= relativizeUrls

    tags <- buildTags "readings/*" (fromCapture "tags/*.html")
    match "readings/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/reading.html"    (postCtxWithTags tags)
            >>= relativizeUrls

    match "tag-blurb/*" $ do
        compile $ pandocCompiler 

    tagsRules tags $ \tag pattern -> do
            let title = "Readings on " ++ tag
            route idRoute
            compile $ do
                blurb <- loadBody $ fromString ("tag-blurb/"++tag++".md")
                readings <- loadAll pattern
                let ctx = constField "title" title `mappend`
                          constField "blurb" blurb
                        `mappend` listField "reading" (postCtxWithTags tags) (return readings)
                        `mappend` defaultContext
                makeItem ""
                    >>= loadAndApplyTemplate "templates/tag.html" ctx
                    >>= loadAndApplyTemplate "templates/default.html" ctx
                    >>= relativizeUrls

    match "index.html" $ do
        route idRoute
        compile $ do
            readings <- loadAll "readings/*"
            let indexCtx =
                    listField "readings" postCtx (return readings) `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler

myRoute :: (Identifier -> FilePath)
myRoute id
  | id == "pages/home.html" = "index.html"
  | otherwise = drop 6 $ dropExtension (toFilePath id) ++ ".html"

linesInPages :: Context String
linesInPages = field "n" f where
  f :: (Item String -> Compiler String)
  f i = do
   return $ show $ length $ lines $ itemBody i
--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    defaultContext

postCtxWithTags :: Tags -> Context String
postCtxWithTags tags = tagsField "tags" tags `mappend` postCtx