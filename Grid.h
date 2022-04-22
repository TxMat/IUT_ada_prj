//
// Created by ponalm on 4/22/22.
//

#ifndef IUT_ADA_PRJ_GRID_H
#define IUT_ADA_PRJ_GRID_H


class Grid {

public:
    Grid(int width, int height);

private:
    int _width;
    int _height;
    vector<vector<Cell>> _grid;






};


#endif //IUT_ADA_PRJ_GRID_H
