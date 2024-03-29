with p_fenbase ; use p_fenbase ;
with Forms ; use Forms;
with p_virus; use p_virus;
with p_esiut; use p_esiut;
with p_score; use p_score;
with sequential_io;



package p_vue_graph is

    Fmenu : TR_fenetre;

    type TV_Coul_Graph is array (T_CoulP) of FL_PD_COL;
    Couleur_Bouton: TV_Coul_Graph:=(FL_RED,FL_CYAN,FL_DARKORANGE,FL_MAGENTA,FL_DARKTOMATO,FL_BLUE,FL_DARKVIOLET,FL_CHARTREUSE,FL_YELLOW,FL_WHITE);

    -- création des menus
    procedure creemenu (fmenu : in out TR_fenetre);

    --Création pop up règles
    procedure FenetreRegles(FRegles : in out TR_Fenetre);

    -- création de la grille
    procedure creegrille (FGrille : in out TR_fenetre; numd : in integer; nom : in string; grille : in tv_grille);

    -- affiche & màj la grille
    procedure AfficheGrille(FGrille : in out TR_fenetre; grille : in tv_grille; nbcoups: in integer);

    -- création des resultats
    procedure creefin (Ffin : in out TR_fenetre; score : in out TR_Score );

    procedure Preparation_Grille(FGrille : in out TR_Fenetre; Grille : in TV_Grille; coul : in T_CoulP; lig : in integer; col : in character);

end p_vue_graph;
