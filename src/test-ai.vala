/* -*- Mode: vala; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 *
 * Copyright © 2014 Michael Catanzaro
 * Copyright © 2014 Nikhar Agrawal
 *
 * This file is part of Four-in-a-row.
 *
 * Four-in-a-row is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * Four-in-a-row is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Four-in-a-row.  If not, see <http://www.gnu.org/licenses/>.
 */

private void test_horizontal_win ()
{
    assert (playgame ("a172737") == 4);
}

public int main (string[] args)
{
    Test.init (ref args);
    Test.add_func ("/AI/Take Win/Horizontal Win", test_horizontal_win);
/*
    Test.add_func ("/AI/Take Win/Vertical Win", test_vertical_win);
    Test.add_func ("/AI/Take Win/Forward Diagonal Win", test_forward_diagonal_win);
    Test.add_func ("/AI/Take Win/Backward Diagonal Win", test_backward_diagonal_win);

    Test.add_func ("/AI/Avoid Loss/Horizontal Loss", test_avoid_horizontal_loss);
    Test.add_func ("/AI/Avoid Loss/Vertical Loss", test_avoid_vertical_loss);
    Test.add_func ("/AI/Avoid Loss/Forward Diagonal Loss", test_avoid_forward_diagonal_loss);
    Test.add_func ("/AI/Avoid Loss/Backward Diagonal Loss", test_avoid_backward_diagonal_loss);
*/
    return Test.run ();
}
