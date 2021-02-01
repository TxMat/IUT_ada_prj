with p_virus; use p_virus;
with p_esiut; use p_esiut;
use p_virus.p_piece_io;
use p_virus.p_coul_io;
use p_virus.p_dir_io;
with p_vuetxt; use p_vuetxt;
with text_io; use text_io;


procedure testjeu is
    Grille : TV_Grille;
    Pieces : TV_Pieces;
    num_conf : integer range 1..20; -- pour la verif de saisie
    f : p_piece_io.file_type;
    package p_int_io is new integer_io(integer); use p_int_io;
    coul : T_coulP;
    dir : T_Direction;

    procedure Aff (G : in TV_Grille) is
    begin -- Aff
        put_line("Affichage des Pieces :");
        for i in Pieces'range loop -- on parcours Pieces pour afficher toutes les couleurs de la grille
            PosPiece(Grille, i);
        end loop;
        put_line("Affichage terminé");
    end Aff;

begin
    loop
        -- INIT grille
        put_line("Debut de la phase d'initialisation");
        InitPartie(Grille, Pieces);
        put_line("Initialisation terminée");
        -- Demande num config
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
        -- Debut config
        put_line("Debut de la phase de configuration");
        open(f, in_file, "Defis.bin");
        Configurer(f, num_conf, Grille, Pieces);
        put_line("Configuration terminée");
        -- Debut Affichage pieces
        new_line;
        AfficheGrille(grille);
        -- Deplacement pieces
        loop
            put_line("Choissisez la couleur d'une piece a deplacer");
            lire(coul); -- demande couleur
            if Pieces(coul) and coul /= T_coulP'last then -- si la couleur est dans la gille et n'est pas blanche on entre
                put_line("dans quelle direction voulez vous deplacer la piece ?");
                lire(dir); -- demande direction
                if Possible(Grille, coul, dir) then -- check si Possible + deplacement
                    put_line("ok");
                    MajGrille(Grille, coul, dir);
                    put_line("done");
                    exit;
                else -- si Possible renvoie False
                    put_line("deplacement impossible");
                end if;
            elsif coul = T_coulP'last then -- message d'erreur piece blanche
                put_line("Les pieces blanches ne peuvent pas etre deplacées");
            else -- message d'erreur piece inexistante
                put_line("Cette piece n'existe pas dans la configuration actuelle");
            end if;
        end loop;
        -- Affichage nouvelle Grille
        AfficheGrille(Grille);
        -- reinitialisation
            -- put_line("Debut de la phase de reinitialisation");
            -- InitPartie(Grille, Pieces);
            -- put_line("Renitialisation terminée");
            -- put_line("Debut de la phase de reconfiguration");
            -- Configurer(f, num_conf, Grille, Pieces);
            -- put_line("Reonfiguration terminée");
            -- Aff(Grille);
    end loop;
end testjeu;
