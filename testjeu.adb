with p_virus; use p_virus;
with text_io; use text_io;

procedure testjeu is
    Grille : TV_Grille;
    Pieces : TV_Pieces;
    num_conf : integer range 1..20; -- pour la verif de saisie
begin
    put_line("Debut de la phase d'initialisation");
    InitPartie(Grille, Pieces);
    put_line("Initialisation terminée");
    loop
        begin
            put_line("Entrez un numero de configuration [1-20]");
            get(num_conf);
            exit;
        exception
            when CONSTRAINT_ERROR => -- en cas de mauvaise saisie
                put_line("Le numéro est invalide vous devez mettre un nombre");
                put_line("entre 1 et 20");
        end;
    end loop;
    put_line("Debut de la phase de configuration");
    Configurer(Defis.bin num_conf, Grille, Pieces);
    put_line("Configuration terminée");
    put_line("Affichage des Pieces :");
    for i in Pieces'range loop -- on parcours Pieces pour afficher toutes les couleurs de la grille
        PosPiece(Grille, i);
    end loop;
    put_line("Affichage terminé");
end testjeu;
