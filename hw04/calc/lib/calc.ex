defmodule Calc do
  @moduledoc """
  Documentation for Calc.
  """

  @doc """
  CalcTest

  ## Examples

  iex> Calc.eval("1+1")
  2
  iex> Calc.eval("(3/22)+2*(5+1/2)/2/3")
  1

  """
  # ///////////////////////////////////////////////////////////////////////////

  def eval(exp) do
    opd_stack = []
    opr_stack = []
    parse_into_list(exp)
      |>traverse(opd_stack,opr_stack)
      |> String.to_integer()
  end

  # ///////////////////////////////////////////////////////////////////////////

  def main do
    IO.gets("\nEnter Expression Here: ")
    |> eval()
    |> IO.puts()
    main()
  end

  # ///////////////////////////////////////////////////////////////////////////

  def parse_into_list(exp) do
    String.replace(exp, ~r/[\*\/\-\+\(\)]/," \\0 ")
    |>String.trim()
    |>String.replace(~r/\s+/, "@")
    |> String.split("@")
  end

  # ///////////////////////////////////////////////////////////////////////////
  # Stack Implementation:

  def top(stack) do
    [last_in | _] = stack
    last_in
  end

  def pop(stack) do
    if length(stack)>0 do
      [last_in | rest] = stack
      {last_in, rest}
    else
      raise("Invalid Arithmetic Expression Entered.")
    end

  end

  def push(stack, item) do
    [item | stack]
  end

  # ///////////////////////////////////////////////////////////////////////////
  def compute_rest(opd_stack, opr_stack) do
    if length(opr_stack)==0 do
      {opd_stack,opr_stack}
    else
      {opd_stack, opr_stack} = compute(opd_stack, opr_stack)
      compute_rest(opd_stack, opr_stack)
    end
  end

  # ///////////////////////////////////////////////////////////////////////////

  def recursively_compute(opd_stack, opr_stack) do
    topval = top(opr_stack)
    if topval=="(" do
      {_,opr_stack}=pop(opr_stack)
      {opd_stack,opr_stack}
    else
      {opd_stack,opr_stack} = compute(opd_stack, opr_stack)
      recursively_compute(opd_stack, opr_stack)
    end
  end

  # ////////////////////////////////////////////////////////////////////////////

  def compute(opd_stack, opr_stack) do
    {opd1, opd_stack} = pop(opd_stack)
    {opr, opr_stack} = pop(opr_stack)
    {opd2, opd_stack} = pop(opd_stack)
    a = String.to_integer(opd2)
    b = String.to_integer(opd1)
    result = case opr do
      "+" -> a+b
      "*" -> a*b
      "/" -> div(a,b)
      "-" -> a-b
      _-> raise("Invalid Expression")
    end
    opd_stack = push(opd_stack, Integer.to_string(result))
    {opd_stack,opr_stack}
  end

  # ///////////////////////////////////////////////////////////////////////////

  def check_precedence(stackTop,currentVal) do
    precedence = %{"("=>1, "*"=>5,"/"=>4,"+"=>3,"-"=>2}
    precedence = case {stackTop, currentVal} do
      {"/", "*"} -> %{precedence | "/"=>5, "*"=>4}
      {"-", "+"} -> %{precedence | "-"=>3, "+"=>2}
      {_, _} -> precedence
    end
    precedence[stackTop] < precedence[currentVal]
  end

  # ///////////////////////////////////////////////////////////////////////////

  def handle_operator(opd_stack, opr_stack, this) do
    if length(opr_stack)==0 or check_precedence(top(opr_stack),this) do
      opr_stack = push(opr_stack, this)
      {opd_stack, opr_stack}
    else
      {opd_stack, opr_stack} = compute(opd_stack, opr_stack)
      handle_operator(opd_stack, opr_stack, this)
    end
  end

  # ///////////////////////////////////////////////////////////////////////////

  def traverse(exp, opd_stack, opr_stack) do
    [this | rest] = exp
    {opd_stack, opr_stack} = cond do
      # //////////////////////////////////////////
      String.match?(this, ~r/^[0-9]*$/) -> {push(opd_stack, this), opr_stack}

      # //////////////////////////////////////////
      this in ["+","/","*","-"] -> handle_operator(opd_stack, opr_stack,this)

      # //////////////////////////////////////////
      this == "(" -> {opd_stack, push(opr_stack, this)}

      # //////////////////////////////////////////
      this == ")" -> recursively_compute(opd_stack, opr_stack)

      # //////////////////////////////////////////
      true -> compute(opd_stack, opr_stack)
    end

    if length(rest)==0 do
      {opd_stack,_} = compute_rest(opd_stack, opr_stack)
      top(opd_stack)
    else
      traverse(rest, opd_stack, opr_stack)
    end
  end

  # ///////////////////////////////////////////////////////////////////////////
end
