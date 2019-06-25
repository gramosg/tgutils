# TgUtils

This is a collection of CLI utilities to easily interact with Telegram Bots. The
aim is for them to be simple and composable, as in the [Unix
way](http://wiki.c2.com/?UnixWay).

This software is in very early development, please be gentle :)


## Tools

Here is a short overview of the included tools, for full documentation check
their corresponding manual (e.g., `tgsend -h -v`).

### tgsend

`tgsend` is meant as a quick way to send a message to one or more chats from a
Bot account. The list of chats are passed as arguments, and the message is read
from standard input. For example,

    echo "Hello world!" | tgsend 12121212 34343434

will send the `Hello world!` message to chats `12121212` and `34343434`.


### tgrecv

`tgrecv` works as the dual of `tgsend`, listening for incoming updates from the
Bot and outputting them as JSON in standard output. For example,

    tgrecv | jq .[0].message

after sending `Hello bot!` from Telegram, will display

    {
      "text": "Hello bot!",
      "chat": {
        "last_name": "Ramos",
        "id": 12121212,
        "type": "private",
        "first_name": "Guillermo",
        "username": "gramos"
      },
      "message_id": 315,
      "from": {
        "last_name": "Ramos",
        "id": 12121212,
        "language_code": "en",
        "username": "gramos",
        "is_bot": false,
        "first_name": "Guillermo"
      },
      "date": 1561469046
    }

One important thing to consider is that Telegram by default does not discard any
update until it is confirmed to be read by using the
[offset](https://core.telegram.org/bots/api#getupdates) parameter on the next
call. That means that the previous example will keep receiving the same
update over and over. `tgrecv` offers two ways of dealing with this:

- When using the `--auto-offset` argument it will automatically discard every
  processed update by caching the last known offset. This is probably the
  desired behaviour if there are no more consumers connected to the Bot.
- When using the `--offset <offset>` argument it will discard the updates
  previous to the given offset.


### tgserver

`tgserver` listens for Telegram updates from the Bot, and for every update, it
runs a given program with its standard input piped to the update and having its
standard output sent back as response. This program is heavily inspired by
`tcpserver` (from D. J. Bernstein's
[ucspi-tcp](https://cr.yp.to/ucspi-tcp.html)).

For example:

    tgserver -- sort

will respond to each message with the same input with the lines sorted
alphabetically.


## Authentication

To get the Bot token, each program will check (in order):

- The `--token` CLI argument
- The `TGUTILS_TOKEN` environment variable
- The contents of `$XDG_CONFIG_HOME/tgutils_token`
  (usually `~/.config/tgutils_token`)
