with p_fenbase ; use p_fenbase ;
with Forms ; use Forms;

package p_vue_graph is

Fmenu : TR_fenetre;

type TV_Coul_Graph is array (T_CoulP) of FL_PD_COL;
Couleur_Bouton: TV_Coul_Graph:=(FL_RED,FL_CYAN,FL_DARKORANGE,FL_MAGENTA,FL_DARKTOMATO,FL_BLUE,FL_DARKVIOLET,FL_CHARTREUSE,FL_YELLOW,FL_WHITE);

procedure creemenu (fmenu : in out TR_fenetre);

procedure creegrille (FGrille : in out TR_fenetre, numd : in integer, nom : in string);

procedure AfficheGrille(Grille);

end p_vue_graph;
