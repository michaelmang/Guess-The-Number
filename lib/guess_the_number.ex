defmodule GuessTheNumber do
  def main do
    """
    In this game, you think of a number from 1 through n and I will try to guess what it is.\n
    After each guess, enter h if my guess is too high, l if too low, or c if correct.\n
    """
    |> IO.puts
    ask_to_play()
  end

  def ask_to_play() do
    with "y\n" <- IO.gets("Would you like to play? (y/n)\n") do
      start_game()
      |> initialize()
      |> guess()
    else
      "n\n" -> salutation()
    end
  end

  def start_game do
    """
    Great! Pick a number that you want me to guess.\n
    Just let me know what the upper limit:
    """
    |> IO.gets
    |> Integer.parse
    |> case do {n, _} -> n end
  end

  def initialize(n) do
    num = 0
    upper = n
    lower = 1
    guesses = 0
    totalGuesses = 0
    games = 1
    match = false
    params =
      %{n: n,
        num: num,
        upper: upper,
        lower: lower,
        guesses: guesses,
        totalGuesses: totalGuesses,
        games: games,
        match: match
      }
  end

  def reset(params) do
    params =
      %{params |
        upper: params.n,
        lower: 1,
        guesses: 0,
        games: params.games + 1,
        match: false
      }
    |> guess()
  end

  def guess(params) do
    params
    |> increment_guesses()
    |> calc_guess()
    |> check_match()
    |> handle_match()
  end

  def increment_guesses(params), do: params = %{params | guesses: params.guesses + 1}
  def calc_guess(params), do: params = %{params | num: div(params.upper + params.lower, 2)}

  def check_match(params) do
    if(params.num == params.upper && params.num == params.lower && params.lower == params.upper) do
      params = %{params | match: true}
    else
      params = %{params | match: false}
    end
  end

  def handle_match(params) do
    params.match
    |> case do
       true -> end_game(params)
       false -> ask(params)
       end
  end

  def ask(params) do
    "Is it #{params.num}? (h, l, c)\n"
    |> IO.gets
    |> case do
       "l\n" -> guess(%{params | lower: params.num + 1})
       "h\n" -> guess(%{params | upper: params.num - 1})
       "c\n" -> end_game(params)
       end
  end

  def end_game(params) do
    params
    |> calc_total_guesses()
    "Your number is #{params.num}.\n"
    <> "It took me #{params.guesses} guesses.\n"
    <> "I averaged #{params.totalGuesses / params.games} guesses per game for #{params.games} game(s).\n"
    <> "Play again? (y/n)\n"
    |> IO.gets
    |> case do
         "y\n" -> reset(params)
         _ -> salutation()
       end
  end

  def calc_total_guesses(params), :do params = %{params | totalGuesses: params.totalGuesses + params.guesses}

  def salutation do
    """
    Thanks for playing! Hope to see you soon.
    """
  end
end
