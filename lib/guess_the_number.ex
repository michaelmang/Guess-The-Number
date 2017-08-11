defmodule GuessTheNumber do
  def main do
    "In this game, you think of a number from 1 through n and I will try to guess what it is.\n"
    <> "After each guess, enter h if my guess is too high, l if too low, or c if correct.\n"
    |> IO.puts
    |> with do
      "Please enter a number n: "
      |> IO.gets
      |> Integer.parse
      |> case do {n, _} -> n end
      |> initialize
    end
  end

  def initialize(n, games \\ 0, total \\ 0) do
    upper = n
    lower = 1
    count = 0
    games = games + 1
    guess(lower, upper, count, n, games, total)
  end

  def guess(lower, upper, count, n, games, total) do
    count = count + 1
    number = div(upper + lower, 2)
     if checkMatch(number, lower, upper) do
       endGame(number, count, n, games, total)
     else
       "Is it #{number}?\n"
       |> IO.gets
       |> case do
          "l\n" -> isLow(number, lower, upper, count, n, games, total)
          "h\n" -> isHigh(number, lower, upper, count, n, games, total)
          "c\n" -> endGame(number, count, n, games, total)
          end
     end
  end

  def checkMatch(number, lower, upper) do
    if(number == upper && number == lower && lower == upper) do
      true
    else
      false
    end
  end

  def isLow(number, lower, upper, count, n, games, total) do
    lower = number + 1
    guess(lower, upper, count, n, games, total)
  end

  def isHigh(number, lower, upper, count, n, games, total) do
    upper = number - 1
    guess(lower, upper, count, n, games, total)
  end

  def endGame(number, count, n, games, total) do
    total = total + count
    "Your number is #{number}.\n"
    <> "It took me #{count} guesses.\n"
    <> "I averaged #{total / games} guesses per game for #{games} game(s).\n"
    <> "Play again? (y/n)\n"
    |> IO.gets
    |> case do
         "y\n" -> reset(n, games, total)
         "yes\n" -> reset(n, games, total)
         _ -> "Have a good day!"
       end
  end

  def reset(n, games, total) do
    initialize(n, games, total)
  end

end
