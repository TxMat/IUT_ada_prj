with text_io; use text_io;
with p_virus; use p_virus;
with p_esiut; use p_esiut;
use p_virus.p_piece_io;
use p_virus.p_coul_io;
with sequential_io;


package p_vuetxt is

    -- Association des couleurs à leur code texte
	type TV_Code_Coul is array (T_CoulP) of String(1..10);

    --rouge, turquoise, orange, rose, marron, bleu, violet, vert, jaune, blanc
	Code_Couleur: TV_Code_Coul := ("[38;5;196m", "[38;5;033m", "[38;5;202m", "[38;5;206m", "[38;5;052m", "[38;5;021m", "[38;5;055m", "[38;5;028m", "[38;5;220m", "[38;5;231m");

    procedure AfficheGrille (Grille : in TV_Grille);
    -- {} => {la grille a été affichée selon les spécifications suivantes :
    -- * la sortie est indiquée par la lettre S
    -- * une case inactive ne contient aucun caractère
    -- * une case de couleur vide contient un point
    -- * une case de couleur blanche contient le caractère F (Fixe)
    -- * une case de la couleur d’une pièce mobile contient le chiffre correspondant à la
    -- position de cette couleur dans le type T_Coul}

end p_vuetxt;
