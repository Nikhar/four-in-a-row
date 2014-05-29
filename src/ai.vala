//#define needs valac -D?
//TODO int.MIN gives error
const int NEG_INF = -100000; 
const int POS_INF = 10000;
// TODO I don't think it's a 7*7 board, it seems more like 6 * 7 board
const int BOARD_ROWS = 6; 
const int BOARD_COLUMNS = 7; 

enum Player { NONE, HUMAN, AI;}


int playgame (string fixme)
{
	var t = new DecisionTree();
	return t.playgame (fixme);
}

void board_reset ()
{
//	DecisionTree.board_reset();
//	DecisionTree.print_board();
}

public class DecisionTree
{
	/* to mantain the status of the board, to be used by the heuristic function, the top left cell is 0,0 */
	private Player[,] board = new Player [BOARD_ROWS, BOARD_COLUMNS]; 
	/* plies determine how deep would the tree be */
	private int plies = 5;
	/* determines who made the last move, AI = 1 , human = -1 */
	private Player last_move = Player.NONE;
	/* determines in which column will AI will make its next move based on the decision tree*/
	private int next_move = -1;

	public DecisionTree ()
	{
		//TODO: properly initialize on first construction
		for (int i=0; i < BOARD_ROWS; i++)
		{
			for (int j=0; j < BOARD_COLUMNS; j++)
			{
				/* 0 implies the cell is empty
				 -1 implies human has moved and 1 implies AI has moved
				 this choice used because we wish to maximize AI's score*/
				board[i,j]=Player.NONE;
			}
		}
	}

	public static void board_reset()
	{
		for (int i=0; i < BOARD_ROWS; i++)
		{
			for (int j=0; j < BOARD_COLUMNS; j++)
			{
				/* 0 implies the cell is empty
				 -1 implies human has moved and 1 implies AI has moved
				 this choice used because we wish to maximize AI's score*/
		//		board[i,j] = Player.NONE;
			}
		}

	}

	/* utility function for debugging purposes*/
	public void print_board ()
	{
		for (int i=0; i< BOARD_ROWS; i++)
		{
			for (int j = 0; j < BOARD_COLUMNS; j++)
			{
				stdout.printf("%d\t",board[i,j]);
			}
			stdout.printf("\n");
		}
		stdout.printf("\n");
	}

	private int negamax (int height)
	{
		if (height==0 || board_full()) 
		{
			if (last_move == Player.HUMAN)
				return heurist();
			else if (last_move == Player.AI)
				return -1 * heurist();
			else
				return 0;
			//return -1*last_move*heurist();
		}

		int max = NEG_INF; //TODO: replace NEG_INF by Vala equivalent of numeric_limits<int>::min

		int next = -1;

		for (int i=0; i < BOARD_COLUMNS; i++)
		{
			/* make a move into the i'th column*/
			if (move(i)) 
			{
				/* We check if making a move in this column results in a victory for someone*/

				/* is_victor is similar to heurist => is_victor ~ heurist
				   temp = -1 * negamax
				   negamax = -1 * last_move * heurist
				   temp = last_move * is_victor*/

				/* Add a height factor to avoid closer threats first */
				int temp;
				if (last_move == Player.HUMAN) 
					temp = -1 * is_victor(i) * height;
				else
					temp = is_victor(i) * height;
//				int temp = last_move * is_victor(i) * height;

				/* if making a move in this column resulted in a victory for someone, temp!=0, we do not need to go
				   further down the negamax tree*/
				if (temp == 0)
					temp = -1 * negamax(height - 1);

				if (temp >= max)
				{
					next = i;
					max = temp;
				}
				unmove(i);
			}
		}

		if (height == plies) 
			next_move = next;


		return max;
	}

	/* returns POS_INF if AI has won as a result of the last move made, NEG_INF if HUMAN has won, 0 if no one has won the game yet 
	   The argument i is the column in which the last move was made. */
	private int is_victor (int i)
	{
		int cell;
		/* board[cell,i] would now be the cell on which the last move was made */
/*		for (cell = BOARD_ROWS - 1; cell >= 0 && board[cell,i] != 0; cell -= 1);
		cell = cell + 1;*/

		for (cell = 0; cell < BOARD_ROWS && board[cell,i] == Player.NONE; cell++);

		int temp = 0;

		temp = vertical_win(cell,i);
		if (temp != 0) return temp;

		temp = horizontal_win(cell,i);
		if (temp != 0) return temp;

		temp = backward_diagonal_win(cell,i);
		if (temp != 0) return temp;
	
		temp = forward_diagonal_win(cell,i);
		return temp;

	}

	/* all the win functions that follow return 0 is no one wins, POS_INF if AI wins, -1 * POS_INF if human wins */
	private int forward_diagonal_win (int i, int j)
	{
		int count = 0;

		for (int k = i, l = j; k >= 0 && l < BOARD_COLUMNS && board[k,l] == last_move; k--, l++, count++);
		for (int k = i + 1, l = j - 1; k < BOARD_ROWS && l >= 0 && board[k,l] == last_move; k++, l--, count++);

		if (count >= 4)
		{
			if (last_move == Player.HUMAN)
				return -1 * POS_INF;
			else
				return POS_INF;
//			return last_move * POS_INF;
		}

		return 0;
	}

	private int backward_diagonal_win (int i, int j)
	{
		int count = 0;

		for (int k = i, l = j; k >= 0 && l >= 0 && board[k,l] == last_move; k--, l--, count++);
		for (int k = i + 1, l = j + 1; k < BOARD_ROWS && l < BOARD_COLUMNS && board[k,l] == last_move; k++, l++, count++);

		if (count >= 4)
		{
			if (last_move == Player.HUMAN)
				return -1 * POS_INF;
			else
				return POS_INF;
		//	return last_move * POS_INF;
		}

		return 0;
	}

	private int horizontal_win (int i, int j)
	{
		int count = 0;

		for (int k = j; k >= 0 && board[i,k] == last_move; k--, count++);
		for (int k = j+1; k < BOARD_COLUMNS && board[i,k] == last_move; k++, count++);

		if (count >= 4)
		{
			if (last_move == Player.HUMAN)
				return -1 * POS_INF;
			else
				return POS_INF;
		//	return last_move * POS_INF;
		}

		return 0;
	}

	private int vertical_win (int i, int j)
	{
		int count = 0;

		for (int k = i; k < BOARD_ROWS && board[k,j] == last_move; k++ , count++);

		if (count >= 4) 
		{
			if (last_move == Player.HUMAN)
				return -1 * POS_INF;
			else
				return POS_INF;
		//	return last_move * POS_INF;
		}

		return 0;
	}

	private bool board_full ()
	{
		//TODO Use a for loop that uses BOARD_COLUMNS 
		bool empty = false;
		for (int i = 0 ; i < BOARD_COLUMNS ; i++)
		{
			if (board[0,i] == Player.NONE)
			{
				empty = true;
				break;
			}
		}
		return !empty;
		//return board[0,0]!=0 && board[0,1]!=0 && board[0,2]!=0 && board[0,3]!=0 && board[0,4]!=0 && board[0,5]!=0 && board[0,6]!=0;
	}

	private bool move (int i)
	{
		int cell;

		for(cell = BOARD_ROWS - 1; cell >= 0 && board[cell,i] != Player.NONE; cell -= 1);

		if(cell < 0)
			return false;
		
		/*if it is AI's first move or the last move was made by human */
		if (last_move == Player.NONE || last_move == Player.HUMAN)
		{
			board[cell,i] = Player.AI;
			last_move = Player.AI;
		}
		else
		{
			board[cell,i] = Player.HUMAN;
			last_move = Player.HUMAN;
		}

	//	print_board();

		return true;
	}

	private void unmove (int i)
	{
		int cell;

		for (cell = BOARD_ROWS - 1; cell >= 0 && board[cell,i] != Player.NONE; cell -= 1);

		board[cell + 1,i] = Player.NONE;

/*		int temp = -1 * last_move;

		last_move = (Player)temp;*/

		if (last_move == Player.AI)
			last_move = Player.HUMAN;
		else if (last_move == Player.HUMAN)
			last_move = Player.AI;

	}

	private void update_board (string vstr)
	{
		/*second last letter tells the latest move of human 
		 odd length => human first move*/
		/*stdout.printf("%s\n",vstr);
		next_move = -1;

		if (vstr.length == 2) return; // AI will make the first move, nothing to add to the board

		int cell;

		int column = int.parse(vstr[vstr.length - 2].to_string()) -1;

		for (cell = BOARD_ROWS - 1; cell >= 0 && board[cell,column] != 0; cell -= 1);

		board[cell,column] = Player.HUMAN;

		last_move = Player.HUMAN;*/

		next_move = -1;

		if (vstr.length == 2) return; // AI will make the first move, nothing to add to the board

		Player move;

		if (vstr.length % 2 == 0) 
			move = Player.AI;
		else 
			move = Player.HUMAN;

		for (int i = 1; i < vstr.length - 1; i++)
		{
			int column = int.parse(vstr[i].to_string()) -1;

			int cell;

			for (cell = BOARD_ROWS - 1; cell >= 0 && board[cell,column] != Player.NONE; cell -= 1);

			board[cell, column] = move;

			if (move == Player.HUMAN)
				move = Player.AI;
			else
				move = Player.HUMAN;
		}

		last_move = Player.HUMAN;
		//print_board();
	}

	/* check for immediate win of AI/HUMAN */
	private int immediate_win (Player p)
	{
		Player old_last_moved = last_move;

		if (p == Player.AI)
			last_move = Player.HUMAN;
		else
			last_move = Player.AI;

		for (int i = 0; i < BOARD_COLUMNS; i++)
		{
			if (move(i))
			{
				if (is_victor(i) != 0) 
				{
					unmove(i);
					last_move = old_last_moved;
					return i;
				}	

				unmove(i);
			}
		}

		last_move = old_last_moved;

		/* returns -1 if no immediate win for Player p*/
		return -1;
	}

	public int playgame (string vstr)
	{
		update_board(vstr);

		int temp = immediate_win (Player.AI);

		if (temp != -1) 
			return temp + 1;

		temp = immediate_win (Player.HUMAN);

		if (temp != -1) 
			return temp + 1;

		negamax(plies);

		move(next_move);

		//old c code begins indexing from 1
		return next_move + 1;

	}

	private int heurist ()
	{

		int temp = Random.int_range(1,49);
		return temp;
	}
}

