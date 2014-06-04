int main()
{
	int easy = 0;
	int draw = 0;
	int medium =0;
	int hard = 0;
	for(int i = 0; i< 20;i++)
	{
		var e = new StringBuilder();
		e.append("b0");
		var m = new StringBuilder();
		m.append("c0");
		int count = 0;
		while(true)
		{
			count++;
			int move;
			DecisionTree t= new DecisionTree();
			move = t.playandcheck(e.str);
			if (move == 0)
			{
				stdout.printf("DRAW!\n");
				draw++;
				break;
			}
			if (move == 1000)
			{
				easy++;
				break;
			}
			e.insert(e.str.length - 1, move.to_string());
			m.insert(m.str.length - 1, move.to_string());
			DecisionTree d = new DecisionTree();
			move = d.playandcheck(m.str);
			if (move == 0)
			{
				stdout.printf("DRAW!\n");
				draw++;
				break;
			}
			if (move == 1000)
			{
				medium++;
				break;
			}
			e.insert(e.str.length - 1, move.to_string());
			m.insert(m.str.length - 1, move.to_string());
//			stdout.printf("%s\n",e.str);
		}
		DecisionTree t = new DecisionTree();
		t.update_board(e.str);
		t.print_board();
		stdout.printf("moves: %d\n",count);
		stdout.printf("medium: %d\thard: %d\t draw: %d\t\n",easy,medium,draw);
	}
	return 0;
}
