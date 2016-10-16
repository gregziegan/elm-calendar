# Elm Calendar

![](https://travis-ci.org/thebritican/elm-calendar.svg?branch=master)

A work in progress towards a reusable calendar widget.

![demo](http://g.recordit.co/SDcRoAudo1.gif)


## Contributing

I'm using [elm-live](https://github.com/tomekwi/elm-live) for development, it's great!

Install elm-live:

`npm i -g elm-live`


Install the calendar dependencies
`elm-package install`

Install the dependencies for the examples

`cd examples`
`elm-package install`

Go back to the root directory

`cd ..`

And run `elm-live examples/src/<WhicheverExample>.elm --output=examples/elm.js --open --dir=examples`

Then edit any of the files, and you should have some nice hot reloading!

PRs welcome 😄
