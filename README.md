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

To start the Words, Etc. application:

  - Install dependencies with 'mix deps.get'
  - Create and migrate your database with 'mix ecto.setup'
  - Install Node.js dependencies with 'npm install' inside the 'assets' directory
  - Start Phoenix endpoint with 'mix phx.server'

Now you can visit 'localhost:4000' from your browser.

## Using Docker

As an alternative to the above steps, you can also run the application using
Docker. Build the Docker image using:

```
docker build -t words_etc .
```

And then run the application:

```
docker run -p 4000:4000 -d words_etc
```

Now you can visit 'localhost:4000' from your browser.

## Usage

Just enter your letters in the provided input field and press 'Submit'. The
application will return a list of possible words, each grouped by the number of
letters. For each word, the application provides its definition and Scrabble
score.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to
discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
