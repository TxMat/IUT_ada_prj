with p_virus; use p_virus;

procedure main is
    Grille : TV_Grille;
    Pieces : TV_Pieces;
begin
    put_line("Debut de la phase d'initialisation");
    InitPartie(Grille, Pieces);
    put_line("Initialisation terminée");
    put_line("Entrez un numero de configuration [1-20]");

exception

end main;
