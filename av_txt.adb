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
    nb_coups : natural;
    nb_err : natural;
    Premier_tour : boolean;
    Play : boolean := True;
begin
        -- INIT grille
        put_line("Debut de la phase d'initialisation");
        InitPartie(Grille, Pieces);
        put_line("Initialisation terminée");
        -- Demande num config
        loop
            begin
                put_line("Entrez un numero de niveau [1-20]");
                get(num_conf);
                exit;
            exception
                when others => -- en cas de mauvaise saisie
                    skip_line;
                    put_line("Le numéro est invalide vous devez mettre un nombre");
                    put_line("entre 1 et 20");
            end;
        end loop;
        open(f, in_file, "Defis.bin");
        while Play loop -- pour verifier que l'user veut bien jouer
            nb_err := 0;
            nb_coups := 0;
            Premier_tour := True;
            -- Debut config
            put_line("Debut de la phase de configuration");
            Configurer(f, num_conf, Grille, Pieces);
            put_line("Configuration terminée");
            -- Debut partie
            while not Guerison(Grille) loop
                clr_ECRAN;
                AfficheGrille(grille);
                a_la_ligne;
                put_line("Choisissez une action :");
                put_line("  -- [p] bouger une piece");
                put_line("  -- [a] annuler le dernier mouvement");
                put_line("  -- [r] recommencer");
                put_line("  -- [q] abandonner");
                a_la_ligne;
                lire(rep);
                a_la_ligne;
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
                                if Premier_tour then Premier_tour := False; end if; -- Si on joue on met Premier_tour a false
                                    nb_coups := nb_coups + 1;
                                    a_la_ligne;
                                    exit;
                                else -- si Possible renvoie False
                                    nb_err := nb_err + 1;
                                    put_line("deplacement impossible");
                                end if;
                            elsif coul = T_coulP'last then -- message d'erreur piece blanche
                                put_line("Les pieces blanches ne peuvent pas etre deplacées");
                            elsif not checkpossible(Grille, coul) then
                                nb_err := nb_err + 1;
                                put_line("cette piece ne peut bouger nul part");
                            else -- message d'erreur piece inexistante
                                put_line("Cette piece n'existe pas dans la configuration actuelle");
                            end if;
                        end loop;
                    when 'a' => -- Undo
                        if not Premier_tour then -- pour verif qu'on a joué au moins une fois
                            oppose(dir);
                            MajGrille(Grille, coul, dir);
                            nb_coups := nb_coups + 1;
                        else
                            put_line("Vous ne pouvez rien annuler car vous n'avez pas joué !");
                        end if;
                    when 'r' => -- Restart
                        nb_err := 0;
                        nb_coups := 0;
                        InitPartie(Grille, Pieces);
                        Configurer(f, num_conf, Grille, Pieces);
                    when 'q' =>
                        put_line("=======================================");
                        put_line("---------vous avez abandonné :(--------");
                        put_line("apres" & integer'image(nb_coups) & " coups");
                        put_line("et" & integer'image(nb_err) & " erreurs");
                        put_line("=======================================");
                        Play := False;
                        exit;
                    when others =>
                        put_line("relisez bien les actions possibles celle que vous avez mis n'existe pas");
                end case;
            end loop;
            if Guerison(Grille) then -- car Possible de sortir de la boucle pour abandonner
                put_line("=======================================");
                put_line("-------------__BRAVO !!!__-------------");
                put_line("-- Vous avez gagné apres" & integer'image(nb_coups) & " coups");
                put_line("-- et" & integer'image(nb_err) & " erreurs");
                put_line("=======================================");
                put_line("Niveau suivant ? [y/n]");
                lire(rep);
                loop
                    case rep is
                        when 'y' =>
                            if num_conf < 20 then -- pour ne pas depasser le nombre max de lvl
                                num_conf := num_conf + 1;
                                InitPartie(Grille, Pieces); -- Reset grille
                                exit;
                            else
                                put_line("impossible vous avez fini le jeu !");
                                exit;
                            end if;
                        when 'n' =>
                            put_line("bonne journée pensez a repartir du niveau" & Integer'image(num_conf) & " la prochaine fois pour continuer le jeu");
                            Play := False;
                            exit;
                        when others =>
                            put_line("repondez avec 'y' ou 'n'");
                    end case;
                end loop;
            end if;
        end loop;
end av_txt;
