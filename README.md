# Words, Etc.

Words, Etc. is a simple, stateless Scrabble solver built with Phoenix and
Elixir. It allows users to input a set of letters and provides possible word
solutions, each grouped by the number of letters, complete with definitions and
Scrabble scores.

## Prerequisites

- Elixir 1.15.0
- OTP 26.0.1
- Node.js (for asset compilation)
- Docker (optional)

## Setup

Clone the repository:

```
git clone https://github.com/sysread/wordsetc.git
```

To start the Words, Etc. application:

```
mix ecto.setup
mix phx.server
```

Or using the `Makefile` and `docker`:

```
make PORT=4000
```

Now you can visit 'localhost:4000' from your browser.

## Usage

Just enter your letters in the provided input field and press `Solve!`. The
application will return a list of possible words, each grouped by the number of
letters. For each word, the application provides its definition and Scrabble
score.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to
discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
