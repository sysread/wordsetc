defmodule WordsEtc.WordFinder do
  use GenServer

  alias WordsEtc.Permutations

  # ----------------------------------------------------------------------------
  # Client
  # ----------------------------------------------------------------------------
  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def define(word) do
    GenServer.call(__MODULE__, {:define, word})
  end

  def words(letters) do
    GenServer.call(__MODULE__, {:words, letters})
  end

  # ----------------------------------------------------------------------------
  # Server
  # ----------------------------------------------------------------------------
  @impl true
  def init(_) do
    dict = build_dictionary()
    find = dict |> Map.keys() |> build_lookup_table()

    {:ok, %{dict: dict, find: find}}
  end

  @impl true
  def handle_call({:define, word}, _from, state) when is_binary(word) do
    definition =
      Map.get(state.dict, word, nil)
      |> case do
        nil -> {:error, :not_found}
        definition -> {:ok, definition}
      end

    {:reply, definition, state}
  end

  @impl true
  def handle_call({:words, letters}, _from, state) when is_binary(letters) do
    words =
      Permutations.all(letters)
      |> Enum.map(&Map.get(state.find, &1, []))
      |> List.flatten()
      |> Enum.sort()
      |> case do
        [] -> {:error, :not_found}
        words -> {:ok, words}
      end

    {:reply, words, state}
  end

  # ----------------------------------------------------------------------------
  # Internal functions
  # ----------------------------------------------------------------------------
  defp build_dictionary() do
    Application.fetch_env!(:words_etc, __MODULE__)[:dictionary_path]
    |> File.stream!()
    |> Enum.map(fn line ->
      [word, definition] = String.split(line, " ", parts: 2)
      {String.downcase(word), String.trim(definition)}
    end)
    |> Enum.into(%{})
  end

  defp build_lookup_table(words) do
    Enum.reduce(words, %{}, fn word, acc ->
      sorted_word = sort_word(word)

      case Map.get(acc, sorted_word) do
        nil ->
          Map.put(acc, sorted_word, [word])

        word_list ->
          Map.put(acc, sorted_word, [word | word_list])
      end
    end)
  end

  defp sort_word(word) do
    word
    |> String.downcase()
    |> String.graphemes()
    |> Enum.sort()
    |> Enum.join()
  end
end
