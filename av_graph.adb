with p_vue_graph; use p_vue_graph;
with p_esiut; use p_esiut;
with p_fenbase; use p_fenbase;
with Forms; use Forms;
with sequential_io;
with p_virus; use p_virus;
with p_score; use p_score;
use p_virus.p_piece_io;

procedure av_graph is
    Score : TR_Score;
    Grille : TV_Grille;
    Pieces : TV_Pieces;
    Bouton_select_coul : T_coulP;
    FMenu, FGrille, Ffin, FRegles : TR_fenetre;
    defichoisi : boolean := false;
    Premier_coup  : boolean := True;
    Premier_tour : boolean := True;
    numd : integer range 1..20 ; -- numero defi
    nb_coups : integer := 0;
    nom : string(1..20);
    Play : boolean := True;
    f : p_piece_io.file_type;
begin

    InitialiserFenetres;

    --------------- gestion du menu -------------------------
    CreeMenu(FMenu);-- procedure créant le Menu
    FenetreRegles(FRegles);-- procédure de création des règles
    MontrerFenetre(FMenu);--affichage du Menu

    loop
        declare
            Bouton : String := (Attendrebouton(FMenu)); -- recuperation du bouton préssé
        begin
            if bouton = "BoutonAnnuler" then --si le bouton annuler est appuié
                cacherfenetre(FMenu); -- on cache la fenetre
                bouton := "quit";
            elsif  bouton = "BoutonValider" then --si le bouton Valider est appuié
            -- ici controle de la saisie defi
                declare
                    NumDefi: string :=  ConsulterContenu(FMenu,"ChampDefi"); -- NumDefi prend la valeur de ChampDefi
                begin
                    numd := integer'value(NumDefi);-- si le defi n'est pas correct on as une erreur
                    defichoisi := true; -- variable permettant de controler la boucle
                exception
                    when others => -- l'erreur sugit quand le numero defi n'est pas valide
                        changertexte(FMenu,"mesmenu_defi","ce n'est pas un numero de defi"); --affichage d'un messsage pour l'utilisateur
                end;
              elsif bouton = "Regles" then --si le bouton règles est appuyé
                  MontrerFenetre(FRegles);
                if AttendreBouton(FRegles) = "Ok" then
                  cacherFenetre(FRegles);
                end if;
            end if;
            exit when (bouton = "BoutonValider" and defichoisi ) or bouton = "BoutonAnnuler"; -- sortie si bouton bouton valider et defi correct ou bouton annuler
        end;
    end loop;
    -- if bouton = "BoutonAnnuler" then
    --     exit;
    -- end if;
    cacherFenetre(FMenu);
    --------------- Fin du Menu -------------------------



    while Play loop
        --------------- Debut init grille ------------------
        InitPartie(Grille, Pieces);
        open(f, in_file, "Defis.bin");
        Configurer(f, numd, Grille, Pieces);
        creegrille (FGrille, numd, ConsulterContenu(FMenu, "ChampNom"),Grille);
        MontrerFenetre(FGrille);
        --------------- Fin init ---------------------------
        while not Guerison(Grille) loop
            declare
                Bouton : String := (Attendrebouton(fGrille));
                Num_col_pred, Num_col_succ : character;
                Num_lig_pred, Num_lig_succ : Integer;
                dir : T_Direction;
                temp : string(1..3);
            begin
                if Bouton /= "Quit" and Bouton /= "Annul" and Bouton /= "Reset" then
                    if Premier_coup then
                        ChangerCouleurFond(fGrille, Bouton, FL_DARKGOLD);
                        temp := Bouton(bouton'last - 1)'image;
                        Num_lig_pred := Integer'Value ((1 => temp(2))); -- ligne 1..7
                        Num_col_pred := Bouton(bouton'last); -- colonne A..G
                        Bouton_select_coul := Grille(Num_lig_pred, Num_col_pred);  -- select coul bouton cliqué
                        if checkpossible(Grille, Bouton_select_coul) then -- pour eviter de select une piece contrainte
                            Preparation_Grille(FGrille, Grille, Bouton_select_coul, Num_lig_pred, Num_col_pred);
                            Premier_coup := false; -- pour passer a la phase 2
                            ChangerTexte(FGrille, "info", "Selectionnez la direction souhaitee");
                        else
                            ChangerTexte(FGrille, "info", "La piece ne peux pas bouger, prenez en une autre");
                        end if;
                    else
                        temp := Bouton(bouton'last - 1)'image;
                        Num_lig_succ := Integer'Value ((1 => temp(2))); -- ligne 1..7
                        Num_col_succ := Bouton(bouton'last); -- colonne A..G
                        dir := Calcul_Dir(Num_lig_pred, Num_lig_succ, Num_col_pred, Num_col_succ); -- calcul dir
                        MajGrille(Grille, Bouton_select_coul, dir);
                        nb_coups := nb_coups + 1;
                        AfficheGrille(fGrille, Grille, nb_coups);
                        Premier_coup := true;
                        Premier_tour := false;
                    end if;
                elsif Bouton = "Reset" then
                    nb_coups := 0;
                    InitPartie(Grille, Pieces);
                    Configurer(f, numd, Grille, Pieces);
                    AfficheGrille(fGrille, Grille, nb_coups);
                    Premier_coup := true;
                    Premier_tour := true;
                elsif Bouton = "Annul" then
                    if not Premier_tour then
                        oppose(dir);
                        MajGrille(Grille, Bouton_select_coul, dir);
                        ChangerTexte(FGrille, "info", "Mouvement annule");
                        AfficheGrille(fGrille, Grille, nb_coups);
                    end if;
                    ChangerTexte(FGrille, "info", "Vous n'avez encore pas joue, selectionnez une piece puis sa direction");
                elsif Bouton = "Quit" then
                    exit;
                end if;
            end;
            if not Premier_tour then
              ChangerTexte(FGrille, "info", "Cliquez sur une piece a deplacer.");
            end if;
        end loop;
        if Guerison(Grille) then
            declare --Déclaration dynamique d'un string pour intégrer le nom du joueur dans un string(1..20)
                temp_string : string (1..20-ConsulterContenu(FMenu,"ChampNom")'length);
            begin
                temp_string := (others => ' ');
                nom := ConsulterContenu(FMenu,"ChampNom") & temp_string ;
            end;
            Score := (NumD,nom,13.37,nb_coups);
            creefin(FFin, Score);
            MontrerFenetre(FFin);
            declare
                bouton : String := (Attendrebouton(FFin));
            begin
                if Bouton = "Boutonnext" then
                    numd := numd + 1;
                    cacherFenetre(ffin);
                else
                    Play := False;
                    cacherFenetre(ffin);
                end if;
            end;
        else
            cacherFenetre(fGrille);
            MontrerFenetre(FMenu);
        end if;
    end loop;
end av_graph;
