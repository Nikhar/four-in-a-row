/*int playgame(string fixme) 
  {
  stdout.printf("%s\n",fixme);
  return 2; 
  }*/


//#define needs valac -D?
const int NEG_INF = -10000; 

public class Tree
{
	// need a function board_update that updates board with moves made by human

	// to mantain the status of the board, to be used by the heuristic function
	public int[,] board = new int [7,7]; // the top left cell would be 0,0
	public int plies;
	public int lastMove;
	public int nextMove;

	public Tree()
	{
		for (int i=0; i<=7; i++)
		{
			for (int j=0; j<=7; j++)
			{
				board[i,j]=0; // 0 implies the cell is empty
				// -1 implies human has moved and 1 implies AI has moved
				// this choice used because we're building a negamax tree
			}
		}

		plies = 3; // random number atm

		lastMove = 0; //no one's made a move yet.

		nextMove = -1; // next move to no place in general
	}

	public int negamax(int height)
	{
		if(height==0 || boardFull()) return -1*lastMove*heurist();

		int max = NEG_INF; // replace NEG_INF by Vala equivalent of numeric_limits<int>::min
		int next = -1;
		for(int i=0; i<7; i++)
		{
			if(move(i)) // make a move into the i'th column
			{
				int temp = -1 * negamax(height - 1);
				if(temp >= max)
				{
					next = i;
					max = temp;
				}
				unmove(i);
			}
		}
		if(height==plies) nextMove = next;
		return max;
	}

	public bool boardFull()
	{
		if (board[0,0]!=0 && board[0,1]!=0 && board[0,2]!=0 && board[0,3]!=0 && board[0,4]!=0 && board[0,5]!=0 && board[0,6]!=0)
			return true;
		else return false;
	}

	public bool move(int i)
	{
		int cell;

		for(cell = 6; cell >= 0 && board[cell,i]!=0; cell-=1);

		if(cell <= 0)
			return false;
		
		// if it is AI's first move or the last move was made by human
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

	public void unmove(int i)
	{
		int cell;

		for(cell = 6; cell >= 0 && board[cell,i]!=0; cell-=1);

		board[cell + 1,i] = 0;

		lastMove = -1 * lastMove;

	}

	public void updateBoard(string vstr)
	{
		//second last letter tells the latest move of human 
		// odd length => human first move
		nextMove = -1;
		if (vstr.length == 2) return; // AI will make the first move, nothing to add to the board

		int cell;

		int column = vstr[vstr.length - 2] - 48;

		for(cell = 6; cell >= 0 && board[cell,column]!=0; cell-=1);

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

	public int heurist()
	{

		int temp = Random.int_range(1,49);
		return temp;
	}
}


/*int[,] board = new int[7,7];

  void display()
  {

  for(int i=0;i<7;i++) {
  for(int j=0;j<7;j++) {
  stdout.printf("%d ",board[i,j]);
  }
  stdout.printf("\n");
  }
  stdout.printf("\n");
  }


  public bool move(int i,int w)
  {
  int cell;

  for(cell = 7; cell >= 0 && board[cell,i]!=0; cell-=1);

  if(cell <= 0)
  return false;

// if it is AI's first move or the last move was made by human

board[cell,i] = w;

return true;
}*/

int main()
{
	int[,] board = new int[8,8];
	Tree tree = new Tree();	
	int cell;
	for(int i=0;i<7;i++)
		for(int j=0;j<7;j++)
			board[i,j]=0;
	while(true)
	{
		//	display();


		string input = stdin.read_line();
//		stdout.printf("just read\n");
//		stdout.printf("just read %s\n",input);
		if(input=="q") 
		{
			break;
		}
//		input="1";
		//	move(input[0]-48,1);	

		for(cell = 6; cell >= 0 && board[cell,input[0]-48]!=0; cell-=1);
		board[cell,input[0]-48] = 1;


		//	display();
		for(int i=0;i<7;i++) {
			for(int j=0;j<7;j++) {
				stdout.printf("%d \t",board[i,j]);
			}
			stdout.printf("\n");
		}
		stdout.printf("\n");


//			stdout.printf("did not evenr each here\n");

		//string temp="abcd"+input[0]+"a";
		var builder = new StringBuilder();
		builder.append("abc");
		builder.append_unichar(input[0]);
		builder.append("a");

		stdout.printf("builder %s\n",builder.str);
		//	move(tree.playgame(builder.str),-1);
		int temp = tree.playgame(builder.str);
		for(cell = 6; cell >= 0 && board[cell,temp]!=0; cell-=1);
		board[cell,temp] = -1;
		for(int i=0;i<7;i++) {
			for(int j=0;j<7;j++) {
				stdout.printf("%d \t",board[i,j]);
			}
			stdout.printf("\n");
		}
		stdout.printf("\n");
	}
	return 0;
}
