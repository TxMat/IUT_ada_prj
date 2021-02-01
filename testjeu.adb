with p_virus; use p_virus;
with p_esiut; use p_esiut;
use p_virus.p_piece_io;
use p_virus.p_coul_io;
use p_virus.p_dir_io;
with text_io; use text_io;


procedure testjeu is
    Grille : TV_Grille;
    Pieces : TV_Pieces;
    num_conf : integer range 1..20; -- pour la verif de saisie
    f : p_piece_io.file_type;
    package p_int_io is new integer_io(integer); use p_int_io;
    coul : T_coulP;
    dir : T_Direction;
begin
    put_line("Debut de la phase d'initialisation");
    InitPartie(Grille, Pieces);
    put_line("Initialisation terminée");
    loop
        begin
            put_line("Entrez un numero de configuration [1-20]");
            get(num_conf);
            skip_line;
            exit;
        exception
            when others => -- en cas de mauvaise saisie
                skip_line;
                put_line("Le numéro est invalide vous devez mettre un nombre");
                put_line("entre 1 et 20");
        end;
    end loop;
    put_line("Debut de la phase de configuration");
    open(f, in_file, "Defis.bin");
    Configurer(f, num_conf, Grille, Pieces);
    put_line("Configuration terminée");
    put_line("Affichage des Pieces :");
    for i in Pieces'range loop -- on parcours Pieces pour afficher toutes les couleurs de la grille
        PosPiece(Grille, i);
    end loop;
    put_line("Affichage terminé");
    loop
        begin
            put_line("Choissisez la couleur d'une piece a deplacer");
            lire(coul);
            if Pieces(coul) and coul /= T_coulP'last then
                put_line("dans quelle direction voulez vous deplacer la piece ?");
                lire(dir);
                if Possible(Grille, coul, dir) then
                    put_line("ok");
                    exit;
                else
                    put_line("deplacement impossible");
                end if;
            else
                put_line("Cette piece n'existe pas dans la configuration actuelle");
            end if;
        exception
            when others =>
                skip_line;
                put_line("ce n'est pas une couleur");
                put_line("ressayez");
                new_line;
        end;
    end loop;
    
end testjeu;
