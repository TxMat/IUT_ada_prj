with p_virus; use p_virus;
with p_esiut; use p_esiut;
use p_virus.p_piece_io;
use p_virus.p_coul_io;
use p_virus.p_dir_io;
with p_vuetxt; use p_vuetxt;
with text_io; use text_io;


procedure av_txt is
    Grille : TV_Grille;
    Pieces : TV_Pieces;
    num_conf : integer range 1..20; -- pour la verif de saisie
    f : p_piece_io.file_type;
    package p_int_io is new integer_io(integer); use p_int_io;
    coul : T_coulP;
    dir : T_Direction;
    rep : character;
    nb_coups : natural := 0;
    nb_err : natural := 0;
begin
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
        -- Debut partie
        while not Guerison(Grille) loop
            clr_ECRAN;
            a_la_ligne;
            AfficheGrille(grille);
            a_la_ligne;
            put_line("Choissisez une action :");
            put_line("  -- [p] bouger une piece");
            put_line("  -- [a] annuler le dernier mouvement");
            put_line("  -- [r] recommencer");
            put_line("  -- [q] abandonner");
            a_la_ligne;
            lire(rep);
            case rep is
                when 'p' => -- Deplacement pieces
                    loop
                        put_line("Choissisez la couleur d'une piece a deplacer");
                        lire(coul); -- demande couleur
                        if Pieces(coul) and coul /= T_coulP'last and checkpossible(Grille, coul) then -- si la couleur est dans la gille et n'est pas blanche on entre
                            put_line("dans quelle direction voulez vous deplacer la piece ? [hg / bg / bd / hd]");
                            lire(dir);
                            a_la_ligne;
                            if Possible(Grille, coul, dir) then -- check si Possible + deplacement
                                MajGrille(Grille, coul, dir);
                                a_la_ligne;
                                nb_coups := nb_coups + 1;
                                exit;
                            else -- si Possible renvoie False
                                put_line("deplacement impossible");
                            end if;
                        elsif coul = T_coulP'last then -- message d'erreur piece blanche
                            put_line("Les pieces blanches ne peuvent pas etre deplacées");
                        elsif not checkpossible(Grille, coul) then
                            put_line("cette piece ne peux bouger nulle part");
                        else -- message d'erreur piece inexistante
                            put_line("Cette piece n'existe pas dans la configuration actuelle");
                        end if;
                    end loop;
                when 'a' => -- Undo
                    oppose(dir);
                    MajGrille(Grille, coul, dir);
                    nb_coups := nb_coups + 1;
                when 'r' => -- Restart
                    nb_err := 0;
                    nb_coups := 0;
                    Configurer(f, num_conf, Grille, Pieces);
                when others => exit;
            end case;
        end loop;

end av_txt;
