--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import qualified Data.Set as S
import           Text.Pandoc.Options
import           System.FilePath     (pathSeparator, normalise, splitPath)
--------------------------------------------------------------------------------

removeSlash [] = []
removeSlash ('/':xs) = xs
removeSlash (x:xs) = removeSlash xs

removeAllSlashes x = if removeSlash x == x then x else removeAllSlashes (removeSlash x)

removeDate = drop 11

htmlExtension xs = (takeWhile (/='.') xs) ++ ".html"

urlPosts = removeDate . removeSlash . htmlExtension

main :: IO ()
main = hakyll $ do
    match "images/**" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "js/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "lyrics/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "argentina/**" $ do
        route   idRoute
        compile copyFileCompiler

    match "static/**" $ do
        route   idRoute
        compile copyFileCompiler

    match (fromList ["robots.txt", "favicon.ico"]) $ do
        route   idRoute
        compile copyFileCompiler

    match (fromList ["cv/resume.pdf"]) $ do
        route   $ customRoute $ normalise . last . splitPath . toFilePath
        compile copyFileCompiler

    match (fromList ["about.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "posts/*" $ do
        route $ customRoute $ urlPosts . toFilePath
        compile $ pandocMathCompiler
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" teaserCtx (return posts) `mappend`
                    defaultContext
            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler

teaserCtx = teaserField "teaser" "content" `mappend` postCtx


pandocMathCompiler =
    let mathExtensions = [Ext_tex_math_double_backslash,
                          Ext_backtick_code_blocks]
        defaultExtensions = writerExtensions defaultHakyllWriterOptions
        newExtensions = foldr enableExtension defaultExtensions mathExtensions
        writerOptions = defaultHakyllWriterOptions {
                          writerExtensions = newExtensions,
                          writerHTMLMathMethod = MathJax ""
                        }
    in pandocCompilerWith defaultHakyllReaderOptions writerOptions

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext
