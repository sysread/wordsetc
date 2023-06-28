defmodule WordsEtc.WordFinder do
  use GenServer

  alias WordsEtc.Permutations
  alias WordsEtc.Scoring

  # ----------------------------------------------------------------------------
  # Client
  # ----------------------------------------------------------------------------
  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def solve(letters) do
    GenServer.call(__MODULE__, {:solve, letters})
  end

  # ----------------------------------------------------------------------------
  # Server
  # ----------------------------------------------------------------------------
  @impl true
  def init(_) do
    dict = build_dictionary()
    find = dict |> Map.keys() |> build_lookup_table()

    state = %{
      dict: dict,
      find: find
    }

    {:ok, state}
  end

  @impl true
  def handle_call({:solve, letters}, _from, state) when is_binary(letters) do
    result = solve(letters, state)
    {:reply, {:ok, result}, state}
  end

  # ----------------------------------------------------------------------------
  # Internal functions
  # ----------------------------------------------------------------------------
  defp build_dictionary() do
    Application.fetch_env!(:words_etc, __MODULE__)[:dictionary_path]
    |> File.stream!()
    |> Enum.map(fn line ->
      [word, definition] = String.split(line, " ", parts: 2)
      {String.upcase(word), String.trim(definition)}
    end)
    |> Enum.into(%{})
  end

  defp build_lookup_table(words) do
    Enum.reduce(words, %{}, fn word, acc ->
      sorted_word = sort_word(word)

      case Map.get(acc, sorted_word) do
        nil -> Map.put(acc, sorted_word, [word])
        word_list -> Map.put(acc, sorted_word, [word | word_list])
      end
    end)
  end

  defp solve(letters, state) do
    get_words(letters, state)
    |> Enum.map(fn word ->
      score = Scoring.calculate(word)
      definition = word |> String.upcase() |> get_definition(state)
      {word, score, definition}
    end)
    |> Enum.group_by(fn {word, _score, _definition} -> String.length(word) end)
    |> Enum.map(fn {key, value} ->
      {key, Enum.sort_by(value, fn {_word, score, _definition} -> score end, &>=/2)}
    end)
    |> Enum.sort_by(fn {count, _words} -> count end, &>=/2)
  end

  defp sort_word(word) do
    word
    |> String.upcase()
    |> String.graphemes()
    |> Enum.sort()
    |> Enum.join()
  end

  defp get_words(letters, state) do
    letters
    |> Permutations.all()
    |> Enum.flat_map(&Map.get(state.find, String.upcase(&1), []))
    |> Enum.map(&lowercase_matches(letters, &1))
    |> Enum.sort()
    |> Enum.uniq()
  end

  # ----------------------------------------------------------------------------
  # When scoring words, we want to make sure we are not counting letters that
  # came from wildcards. To do this, we lowercase the letters in the original
  # word (from Permutations.all), and then lowercase the letters in the word
  # that do not appear in the original input. We use a frequency map to count
  # the number of times each letter appears in the original input, and then
  # decrement that count each time we use a letter from the second word.
  # ----------------------------------------------------------------------------
  def lowercase_matches(original, second) do
    freq_map = original |> String.downcase() |> String.replace("?", "") |> freq_map()

    second
    |> String.graphemes()
    |> Enum.reduce("", fn char, acc ->
      downcased_char = String.downcase(char)

      case freq_map[downcased_char] do
        nil ->
          acc <> String.downcase(char)

        0 ->
          acc <> String.downcase(char)

        _ ->
          Map.put(freq_map, downcased_char, freq_map[downcased_char] - 1)
          acc <> char
      end
    end)
  end

  defp freq_map(string) do
    string
    |> String.graphemes()
    |> Enum.reduce(%{}, fn char, acc -> Map.update(acc, char, 1, &(&1 + 1)) end)
  end

  defp get_definition(word, state) do
    Map.get(state.dict, String.upcase(word), nil)
    |> parse_definition(state)
  end

  defp parse_definition(nil, _state), do: "definition not found"

  defp parse_definition(input, state) do
    definition =
      input
      |> String.trim()
      |> String.replace(~r/{(\w+)=\w+}/, "\\1", global: true)

    Regex.split(~r/[\s\b\W]/, definition, trim: true, include_captures: true)
    |> Enum.reject(&(&1 == " "))
    |> case do
      # <ad=n> [n]
      ["<", word, "=", _, "[", _, "]"] -> get_definition(word, state)
      # <advertisement=n> [n]
      ["<", word, "=", _, ">", "[", _, "]"] -> get_definition(word, state)
      # [n ADVERTISEMENTS]
      ["[", _, word, "]"] -> word
      # Otherwise, just return the cleaned up definition
      _ -> definition
    end
  end
end
