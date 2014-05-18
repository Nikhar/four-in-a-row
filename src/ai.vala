/*int playgame(string fixme) 
  {
  stdout.printf("%s\n",fixme);
  return 2; 
  }*/


//#define needs valac -D?
const int NEG_INF = -10000; 
const int BOARD_ROWS = 7; 
const int BOARD_COLUMNS = 7; 

public class DecisionTree
{
	/* to mantain the status of the board, to be used by the heuristic function, the top left cell is 0,0 */
	private int[,] board = new int [BOARD_ROWS, BOARD_COLUMNS]; 
	/* plies determine how deep would the tree be */
	private int plies = 3;
	/* determines who made the last move, AI = 1 , human = -1 */
	private int lastMove = 0;
	/* determines in which column will AI will make its next move based on the decision tree*/
	private int nextMove = -1;

	public DecisionTree()
	{
		for (int i=0; i < BOARD_ROWS; i++)
		{
			for (int j=0; j < BOARD_COLUMNS; j++)
			{
				/* 0 implies the cell is empty
				 -1 implies human has moved and 1 implies AI has moved
				 this choice used because we wish to maximize AI's score*/
				board[i,j]=0;
			}
		}
	}

	private int negamax(int height)
	{
		if (height==0 || boardFull()) 
			return -1*lastMove*heurist();

		int max = NEG_INF; //TODO: replace NEG_INF by Vala equivalent of numeric_limits<int>::min

		int next = -1;

		for (int i=0; i < BOARD_ROWS; i++)
		{
			/* make a move into the i'th column*/
			if (move(i)) 
			{
				int temp = -1 * negamax(height - 1);
				if (temp >= max)
				{
					next = i;
					max = temp;
				}
				unmove(i);
			}
		}

		if (height == plies) 
			nextMove = next;

		return max;
	}

	private bool boardFull()
	{
		return board[0,0]!=0 && board[0,1]!=0 && board[0,2]!=0 && board[0,3]!=0 && board[0,4]!=0 && board[0,5]!=0 && board[0,6]!=0;
	}

	private bool move(int i)
	{
		int cell;

		for(cell = BOARD_ROWS - 1; cell >= 0 && board[cell,i] != 0; cell -= 1);

		if(cell <= 0)
			return false;
		
		/*if it is AI's first move or the last move was made by human */
		if (lastMove == 0 || lastMove == -1)
		{
			board[cell,i] = 1;
			lastMove = 1;
		}
		else
		{
			board[cell,i] = -1;
			lastMove = -1;
		}

		return true;
	}

	private void unmove(int i)
	{
		int cell;

		for (cell = BOARD_ROWS - 1; cell >= 0 && board[cell,i] != 0; cell -= 1);

		board[cell + 1,i] = 0;

		lastMove = -1 * lastMove;

	}

	private void updateBoard(string vstr)
	{
		/*second last letter tells the latest move of human 
		 odd length => human first move*/
		nextMove = -1;

		if (vstr.length == 2) return; // AI will make the first move, nothing to add to the board

		int cell;

		int column = vstr[vstr.length - 2] - 48;

		for(cell = BOARD_ROWS - 1; cell >= 0 && board[cell,column] != 0; cell -= 1);

		board[cell,column] = -1;

		lastMove = -1;
	}

	public int playgame(string vstr)
	{
		updateBoard(vstr);

		negamax(plies);

		move(nextMove);

		return nextMove;

	}

	private int heurist()
	{

		int temp = Random.int_range(1,49);
		return temp;
	}
}

