defmodule WordsEtc.WordFinder do
  use GenServer

  alias WordsEtc.Combinations
  alias WordsEtc.Scoring

  @type state :: %{
          dict: %{String.t() => String.t()},
          find: %{String.t() => [String.t()]}
        }

  @type sort_by ::
          :score
          | :alpha

  # ----------------------------------------------------------------------------
  # Client
  # ----------------------------------------------------------------------------
  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def solve(letters, sort \\ :score) do
    GenServer.call(__MODULE__, {:solve, letters, sort})
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
  def handle_call({:solve, letters, sort_by}, _from, state) when is_binary(letters) do
    result = do_solve(letters, sort_by, state)
    {:reply, {:ok, result}, state}
  end

  # ----------------------------------------------------------------------------
  # Internal functions
  # ----------------------------------------------------------------------------

  # ----------------------------------------------------------------------------
  # The dictionary is a text file with one word and definition per line. We
  # read the file line by line, split each line into a word and definition,
  # and then build a map of word => definition.
  # ----------------------------------------------------------------------------
  @spec build_dictionary() :: map()
  defp build_dictionary() do
    Application.fetch_env!(:words_etc, __MODULE__)[:dictionary_path]
    |> File.stream!()
    |> Enum.map(fn line ->
      [word, definition] = String.split(line, " ", parts: 2)
      {String.upcase(word), String.trim(definition)}
    end)
    |> Enum.into(%{})
  end

  # ----------------------------------------------------------------------------
  # The lookup table is built differently than the dictionary. To make looking
  # up words by scrabble tiles faster, we sort the characters in the word and
  # then build a map of sorted_word => [word, word, word].
  # ----------------------------------------------------------------------------
  @spec build_lookup_table([String.t()]) :: map()
  defp build_lookup_table(words) do
    Enum.reduce(words, %{}, fn word, acc ->
      sorted_word = sort_word(word)

      case Map.get(acc, sorted_word) do
        nil -> Map.put(acc, sorted_word, [word])
        word_list -> Map.put(acc, sorted_word, [word | word_list])
      end
    end)
  end

  # ----------------------------------------------------------------------------
  # Returns a new string with the upper-cased characters from the original
  # string sorted alphabetically. This is used to build the lookup table.
  # ----------------------------------------------------------------------------
  @spec sort_word(String.t()) :: String.t()
  defp sort_word(word) do
    word
    |> String.upcase()
    |> String.graphemes()
    |> Enum.sort()
    |> Enum.join()
  end

  # ----------------------------------------------------------------------------
  # The main solve function. We start by getting all the words that can be made
  # from the given letters. Then we score each word, and get the definition for
  # each word. Finally, we group the words by length and sort the words in each
  # group by score.
  # ----------------------------------------------------------------------------
  @spec do_solve(String.t(), state(), sort_by()) :: list()
  defp do_solve(letters, sort_by, state) do
    letters
    |> get_words(state)
    |> get_word_info(state)
    |> group_by_length()
    |> sort_grouped_words(sort_by)
    |> sort_word_groups()
  end

  defp get_word_info(words, state) do
    Enum.map(words, fn word ->
      score = Scoring.calculate(word)
      definition = word |> String.upcase() |> get_definition(state)
      {word, score, definition}
    end)
  end

  defp group_by_length(words) do
    Enum.group_by(words, fn {word, _, _} -> String.length(word) end)
  end

  defp sort_grouped_words(groups, :score) do
    Enum.map(groups, fn {key, value} ->
      {key, Enum.sort_by(value, &elem(&1, 1), :desc)}
    end)
  end

  defp sort_grouped_words(groups, :alpha) do
    Enum.map(groups, fn {key, value} ->
      {key, Enum.sort_by(value, &String.downcase(elem(&1, 0)), :asc)}
    end)
  end

  defp sort_word_groups(groups) do
    Enum.sort_by(groups, fn {count, _words} -> count end, :desc)
  end

  # ----------------------------------------------------------------------------
  # Returns a list of words that can be made from the given letters. We do this
  # by generating all permutations of the letters, expanding any wildcard
  # characters (?) to all possible letters, and then looking up each permutation
  # in the lookup table.
  # ----------------------------------------------------------------------------
  @spec get_words(String.t(), state()) :: [String.t()]
  defp get_words(letters, state) do
    letters
    |> Combinations.all()
    |> Enum.flat_map(&Map.get(state.find, String.upcase(&1), []))
    |> Enum.map(&lowercase_matches(letters, &1))
    |> Enum.sort()
    |> Enum.uniq()
  end

  # ----------------------------------------------------------------------------
  # When scoring words, we want to make sure we are not counting letters that
  # came from wildcards. To do this, we lowercase the letters in the original
  # word, and then lowercase the letters in the word matched in the dictionary
  # that do not appear in the original input. We use a frequency map to count
  # the number of times each letter appears in the original input, and then
  # decrement that count each time we use a letter from the second word.
  # ----------------------------------------------------------------------------
  @spec lowercase_matches(String.t(), String.t()) :: String.t()
  def lowercase_matches(original, second) do
    freq_map =
      original
      |> String.downcase()
      |> String.replace("?", "")
      |> freq_map()

    second
    |> String.graphemes()
    |> Enum.reduce({"", freq_map}, fn char, {acc, freq_map} ->
      downcased_char = String.downcase(char)

      case freq_map[downcased_char] do
        nil ->
          {acc <> String.downcase(char), freq_map}

        0 ->
          {acc <> String.downcase(char), freq_map}

        _ ->
          updated_freq_map = Map.put(freq_map, downcased_char, freq_map[downcased_char] - 1)
          {acc <> char, updated_freq_map}
      end
    end)
    |> elem(0)
  end

  @spec freq_map(String.t()) :: %{String.t() => non_neg_integer()}
  defp freq_map(string) do
    string
    |> String.graphemes()
    |> Enum.reduce(%{}, fn char, acc -> Map.update(acc, char, 1, &(&1 + 1)) end)
  end

  # ----------------------------------------------------------------------------
  # Returns the definition for the given word. If the word is not found in the
  # dictionary, returns "definition not found".
  # ----------------------------------------------------------------------------
  @spec get_definition(String.t(), state()) :: String.t()
  defp get_definition(word, state) do
    Map.get(state.dict, String.upcase(word), nil)
    |> parse_definition(state)
  end

  # ----------------------------------------------------------------------------
  # The definition is a string that may contain special formatting. We want to
  # parse the definition and return a string that can be printed to the user.
  #
  # This is done at runtime because it will follow links to other words in the
  # dictionary, which are incomplete at compile time.
  # ----------------------------------------------------------------------------
  @spec parse_definition(String.t() | nil, state()) :: String.t()
  defp parse_definition(nil, _state), do: "definition not found"

  defp parse_definition(input, state) do
    definition =
      input
      |> String.trim()
      |> String.replace(~r/{(\w+)=\w+}/, "\\1", global: true)

    Regex.split(~r/[\s\b\W]/, definition, trim: true, include_captures: true)
    |> Enum.reject(&(&1 == " "))
    |> case do
      # <aji=n> [n] (2018)
      ["<", word, "=", _, ">", "[", _, "]", "(", _, ")"] ->
        get_definition(word, state)

      # <advertisement=n> [n]
      ["<", word, "=", _, ">", "[", _, "]"] ->
        get_definition(word, state)

      # [n ADVERTISEMENTS]
      ["[", _, word, "]"] ->
        word

      # Otherwise, just return the cleaned up definition
      _ ->
        definition
    end
  end
end
