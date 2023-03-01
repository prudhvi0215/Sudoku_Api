class Api::V1::SudokuController < ApplicationController

  #Look for an unassigned cell if it exists return row and col values else return False
  def empty_cells_exist(sudoku_board)
    for i in 0..8 do
      for j in 0..8 do
        if sudoku_board[i][j] == 0
          return [i,j]
        end
      end
    end
    return false
  end

  # Check whether our choice is good or not
  def valid_number_check(sudoku_board,num,i,j)
    # Checking vertically
    for row in 0..8 do
      if sudoku_board[row][j] == num
        return false
      end
    end
    
    # Checking horizontally
    for col in 0..8 do
      if sudoku_board[i][col] == num
        return false
      end      
    end

    # Check in 3x3 grid box
    grid_row = i/3 * 3
    grid_col = j/3 * 3

    for i in 0..2 do
      for j in 0..2 do
        if sudoku_board[grid_row + i][grid_col + j] == num
          return false
        end
      end
    end

    return true
  end

  def solver(sudoku_board)
    cells_exist = empty_cells_exist(sudoku_board)

    if not cells_exist
      return true
    end

    i,j = cells_exist[0], cells_exist[1]

    for num in 1..9 do
      if valid_number_check(sudoku_board,num,i,j)
        sudoku_board[i][j] = num

        # Backtracking and checking the next step
        if solver(sudoku_board)
          return true
        else
          sudoku_board[i][j] = 0
        end
      end
    end

    return false
  end

  def create
    rawData = sudoku_params[:data]   
    currentArray = rawData.split(" ")

    sudoku_board = []

    # Cleaning & converting string to array of arrays from the postman data..
    currentArray.each do |arr|
      flatArray = arr.split(",")
      singleArray = []
      flatArray.each do |value|        
          singleArray.push(value.to_i)
      end
      sudoku_board.push(singleArray)
    end    

    # Sudoku Solving Logic

    if solver(sudoku_board)
      render json: {status: 'success', data:rawData, solution:sudoku_board}, status: :ok
    else
      render json: {status: 'success', data:"No solution available"}, status: :ok
    end    
  end

  private 
  
  def sudoku_params
    params.permit(:data)
  end
end
