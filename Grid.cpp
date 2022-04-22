//
// Created by ponalm on 4/22/22.
//

#include "Grid.h"

Grid::Grid(int width, int height) :
        _width(width), _height(height) {
    // Initialize the grid with empty cells
    for (int i = 0; i < _height; i++) {
        std::vector<Cell> row;
        for (int j = 0; j < _width; j++) {
            row.push_back(Cell());
        }
        _grid.push_back(row);
    }
}