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
  # evaluates the given string and returns an integer value
  def eval(exp) do
    opd_stack = []
    opr_stack = []
    parse_into_list(exp)
    |>traverse(opd_stack,opr_stack)
    |> String.to_integer()
  end

  # ///////////////////////////////////////////////////////////////////////////
  # loop to keep the program endlessly running, waiting each time for user input.
  def main do
    IO.gets("> ")
    |> eval()
    |> IO.puts()
    main()
  end

  # ///////////////////////////////////////////////////////////////////////////
  # Converts given Arithmetic Expression in string form into a list.
  def parse_into_list(exp) do
    String.replace(exp, ~r/[\*\/\-\+\(\)]/," \\0 ")
    |>String.trim()
    |>String.replace(~r/\s+/, "@")
    |> String.split("@")
  end

  # ///////////////////////////////////////////////////////////////////////////
  # Stack Implementation:
  # Returns the top value of the stack
  def top(stack) do
    if length(stack)>0 do
      [last_in | _] = stack
      last_in
    else
      raise("Invalid Arithmetic Expression Entered.")
    end
  end
  # Returns a stack without it's top value along with the removed top value.
  def pop(stack) do
    if length(stack)>0 do
      [last_in | rest] = stack
      {last_in, rest}
    else
      raise("Invalid Arithmetic Expression Entered.")
    end
  end
  # returns a stack containing item as the top and the input stack as
  # the rest of the stack.
  def push(stack, item) do
    [item | stack]
  end

  # ///////////////////////////////////////////////////////////////////////////
  # Computes the leftover stack elements after the whole Expression is traversed.
  def compute_rest(opd_stack, opr_stack) do
    if length(opr_stack)==0 do
      {opd_stack,opr_stack}
    else
      {opd_stack, opr_stack} = compute(opd_stack, opr_stack)
      compute_rest(opd_stack, opr_stack)
    end
  end

  # ///////////////////////////////////////////////////////////////////////////
  # Computes the value inside any parentheses, and returns the updated
  # operator and operand stacks.
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
  # Computes a sub Expression containing two the popped out operands from
  # operator stack and a popped out operator from the operator stack.
  # Pushes the new value into the operand stack and returns both the stacks.
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
  # Checks for precedence of operators and parentheses.
  # Returns true if precedence of stack top is less than the precedence of the
  # current value in focus.
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
  # Handles the operation, when an operator is found while traversing the
  # Expression.
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
  # Traverses through the whole Arithmetic Expression and returns the
  # top of the operand stack at the end when there is only one value left
  # in operator stack.
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
      if length(opd_stack)==1 do
        top(opd_stack)
      else
        raise "Invalid Arithmetic Expression Entered"
      end
    else
      traverse(rest, opd_stack, opr_stack)
    end
  end

  # ///////////////////////////////////////////////////////////////////////////
end
