# Manpage

## How to write a manpage?

* Check out the example [xclock.man](https://github.com/hansonchar/catclock/blob/master/xclock.man)

  ```bash
  # See the resultant manpage
  man ./xclock.man
  ```

* Read some articles on how to write manpages, such as [this](https://technicalprose.blogspot.com/2011/06/how-to-write-unix-man-page.html).
* More details

  ```bash
  man 7 man
  ```

## How to install a manpage?

An example is worth a thousand words.  Suppose we want to install the above `xclock.man` file as a `catclock` manpage.

```bash
# cd to the "catclock" github project folder containing the "xclock.man" file above
cp xclock.man catclock.man
gzip catclock.man
sudo install -m 644 catclock.man.gz /usr/local/share/man/man1/catclock.1.gz
```

That should be it!  You should now be able to see the `catclock` specific `xclock` documentation via:

```bash
man catclock
```
