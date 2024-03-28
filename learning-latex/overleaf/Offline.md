# How to make [Overleaf](https://www.overleaf.com) template work offline with [TeX Live](https://www.tug.org/texlive/)?

I have the latest TeX Live 2024 installed on my M2 MacBook Air.  The specific Overleaf Latex Template I successfully made it work offline was the [Kumar Pallav's One Page Resume](https://www.overleaf.com/articles/kumar-pallavs-one-page-resume/cqtggyfbyrdk).

## Clone the artifacts

Once the "Open as Template" is clicked, a project would be created in your account.  In my case the project id is "66049b695192021088965cb1", which I can use to git clone the project.

<details>
<summary>Example</summary>

```bash
# Git clone form the overleaf project, copied from the Kumar Pallav's One Page Resume
git clone https://git.overleaf.com/66049b695192021088965cb1
cd 66049b695192021088965cb1
# Compile the tex file and expect failure
lualatex main.tex
```
</details>

Initially I used `pdflatex` which failed with a message that suggested the use of `lualatex`.  You can also find this out at Overleaf at ```Menu> Settings> Compiler```.

## How to fix "file closing" failure?

The compilation failed with:

```
.lua:6: bad argument #1 to 'close' (FILE* expected, got no value)
```

To work around, I located the lua code and fixed the file closing statement to see what happened.

<details>
<summary>git diff</summary>

```
[66049b695192021088965cb1]$ git diff
diff --git a/lua/parser.lua b/lua/parser.lua
index 7fc0149..d03c842 100644
--- a/lua/parser.lua
+++ b/lua/parser.lua
@@ -3,7 +3,7 @@ require("lualibs.lua")
 function getJsonFromFile(file)
   local fileHandle = io.open(file)
   local jsonString = fileHandle:read('*a')
-  fileHandle.close()
+  fileHandle:close()
   local jsonData = utilities.json.tolua(jsonString)
   return jsonData
 end
```
</details>

Now the compilation failed with a different message related to some missing font.

## How to fix missing font?

Specifically, I saw

```
! error:  (type 1): cannot open file for reading 'ugmm8a.pfb'
```

To get round this error, I did the followings:

1. Googled on this and located the missing [garamond](https://www.ctan.org/tex-archive/fonts/urw/garamond) font.
1. [Downloaded](https://mirrors.ctan.org/fonts/urw/garamond.zip) the font package as a zip file.
1. Expanded the zip file with the directory name "garamond" in this case.
1. The compilation failure had reference to the folder `/usr/local/texlive/2024/texmf-dist/fonts/type1/public`.  So I moved the `garamond` folder to there.  (Needed `sudo` permission).

   * As it turns out, in lieu of creating the `garamond` folder under `/usr/local/texlive/2024/texmf-dist/fonts/type1/public`, the official [documentation](https://mirror.math.princeton.edu/pub/CTAN/fonts/urw/garamond/README.garamond) recommends
     1. create the directories:
        * `/usr/local/texlive/2024/texmf-dist/fonts/type1/urw/garamond/`
        * `/usr/local/texlive/2024/texmf-dist/fonts/afm/urw/garamond/`
     1. copy the `*.pfb` and `*.pfm` files from the bundle to `/usr/local/texlive/2024/texmf-dist/fonts/type1/urw/garamond/`; and
     1. copy the `*.afm` files from the bundle to `/usr/local/texlive/2024/texmf-dist/fonts/afm/urw/garamond/`
1. Needed to update the TeX Live database:

<details>
<summary>sudo mktexlsr</summary>

```bash
mktexlsr: Updating /usr/local/texlive/2024/texmf-config/ls-R...
mktexlsr: Updating /usr/local/texlive/2024/texmf-dist/ls-R...
mktexlsr: Updating /usr/local/texlive/2024/texmf-var/ls-R...
mktexlsr: Updating /usr/local/texlive/texmf-local/ls-R...
mktexlsr: Done.
```
</details>

Finally, I retried the (offline) compilation command and succeeded in generating the desired pdf!  Crucially, the generated pdf looked identical to the one generated online at Overleaf.

$\blacksquare$

## Notes

* The (offline) compilation outputs a lot of warnings.  Seems harmless to ignore.
* Online at Overleaf, if I switched to use (the then latest) `TeX Live 2023`, the compilation at Overleaf would fail!  The only version that seems to work online at Overleaf for the above template is `TeX Live 2016 (Overleaf v1)`.  Pretty saddening it would seem at first sight.
* Bottom line: managed to get this to work offline with `TeX Live 2024`!

<details>
<summary>tlmgr --version</summary>

```bash
tlmgr revision 70080 (2024-02-23 00:13:07 +0100)
tlmgr using installation: /usr/local/texlive/2024
TeX Live (https://tug.org/texlive) version 2024
```
</details>
