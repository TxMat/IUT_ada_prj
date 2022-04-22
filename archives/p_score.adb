with sequential_io;
with p_esiut; use p_esiut;
package body p_score is

    procedure permut(i,j : in out TR_Score) is
    --{} =>{Permute les éléments i et j}
        tmp : TR_Score;
    begin
        tmp := i;
        i := j;
        j := tmp;
    end permut;

    -- ouverture du fichier score, création sinon
    procedure ouvrir_fichier(io_option : in io_type) is --Permet d'accéder au fichier même si l'utilisateur le supprime en pleine partie
    begin
        case io_option is
        when lecture =>
            open(f, in_file, NOM_FICHIER);
        when ecriture =>
            open(f, out_file, NOM_FICHIER);
        when append =>
            open(f, append_file, NOM_FICHIER);
        when others => -- Impossible, en théorie
            null;
        end case;
        exception
            when NAME_ERROR => -- Si le fichier n'existe pas
                create(f, out_file, NOM_FICHIER);
                close(f);
                case io_option is
                when lecture =>
                    open(f, in_file, NOM_FICHIER);
                when ecriture =>
                    open(f, out_file, NOM_FICHIER);
                when append =>
                    open(f, append_file, NOM_FICHIER);
                when others => -- Impossible, en théorie
                    null;
                end case;
            end ouvrir_fichier;

    -- fermeture du fichier (nécessaire car infaisable depuis l'extérieur)
    procedure fermer_fichier is
    begin
        close(f);
    end fermer_fichier;

    -- fonction privée (à rendre privée) Récupère les scores *relevant*
    function analyse_fichier(mode: in get_type; defi : in integer; nom : in string; tableau_score : in out TV_Score) return integer is
        tmp : TR_Score;
        i : integer := 0;
    begin
        ouvrir_fichier(lecture);
        while not end_of_file(f) loop
            read(f,tmp);
            if  (mode = ajout and then ((tmp.nom /= nom) and (tmp.defi = defi))) or -- ajout_score
            (mode = tous_defi and then (tmp.defi = defi)) or --Tous scores pour défi
            (mode = tous_joueur and then (tmp.nom = nom)) or --Tous scores pour joueur
            (mode = joueur_defi and then ((tmp.nom = nom) and (tmp.defi = defi))) then -- score du joueur pour ce défi
                i := i + 1;
                tableau_score(i) := tmp;
            end if;
        end loop;
        close(f);
        return i;
    end analyse_fichier;

    -- Écriture du score dans le fichier (un UNIQUE score par joueur par défi)
    procedure ajout_score(score : in TR_Score) is
        scores_existants : TV_Score(1..NB_SCORE_MAX);
        i : integer;
    begin
        i := analyse_fichier(ajout, score.defi, score.nom, scores_existants); -- Tous les scores sauf celui du joueur pour ce défi
        i := i + 1;
        scores_existants(i) := score; -- Ajout $score à la fin du fichier
        ouvrir_fichier(ecriture); --Vide le fichier
        for j in 1..i loop
            write(f, scores_existants(j));
        end loop;
        close(f);
    exception
        when CONSTRAINT_ERROR => null; --Histoire d'acknolwedge la possibilité, même si le fichier sera jamais plein, en théorie.
    end ajout_score;

    -- Recupére les scores enregistrés pour ce défi
    function recup_score(defi : in integer) return TV_Score is
        scores_existants : TV_Score(1..NB_SCORE_MAX);
        i : integer; -- vestige du temps où j'avais l'espoir de pouvoir return un tableau de la bonne taille. Je garde espoir.
    begin
        i := analyse_fichier(tous_defi,defi,"",scores_existants);
        return scores_existants;
    end recup_score;

    -- Récupére les scores enregistrés pour ce joueur
    function recup_score(nom : in string) return TV_Score is
        scores_existants : TV_Score(1..NB_SCORE_MAX);
        i : integer;
    begin
        i := analyse_fichier(tous_joueur,0,nom,scores_existants);
        return scores_existants;
    end recup_score;

    -- Récupére le score du joueur pour ce défi
    function recup_score(infos : in TR_Score) return TR_Score is
        scores_existants : TV_Score(1..NB_SCORE_MAX);
        i : integer;
    begin
        i := analyse_fichier(joueur_defi,infos.defi,infos.nom,scores_existants);
        return scores_existants(1);
    end recup_score;

    -- Pour debug & co
    procedure afficher_scores is
        scores : TV_Score(1..NB_SCORE_MAX);
        j : integer := 0;
    begin
        ouvrir_fichier(lecture);
        while not end_of_file(f) loop
            j := j+1;
            read(f,scores(j));
        end loop;
        for i in 1..40 loop
            ecrire_ligne("indice n°"&image(i));
            ecrire_ligne("défi : " &image(scores(i).defi));
            ecrire_ligne("nom : " &scores(i).nom);
            ecrire_ligne("temps : ");
            -- ecrire_ligne(scores(i).temps);
            ecrire_ligne("moves : "&image(scores(i).nb_moves));
            a_la_ligne;
        end loop;
        close(f);
    end afficher_scores;

    -- Tri $scores selon les critères passés par $mode
    procedure tri_score(mode : in tri_type; scores : in out TV_Score) is
        score_tmp : TV_Score(1..NB_SCORE_MAX);
        i : integer := scores'first;
        onapermute : boolean := true;
    begin
        case mode is
            when nb_coups =>
                while onapermute loop
                    onapermute := false;
                    for j in reverse i+1..scores'last loop
                        if scores(j).nb_moves < scores(j-1).nb_moves then
                            permut(scores(j), scores(j-1));
                            onapermute := true;
                        end if;
                    end loop;i := i+1;
                end loop;
            when temps =>
                while onapermute loop
                    onapermute := false;
                    for j in reverse i+1..scores'last loop
                        if scores(j).temps < scores(j-1).temps then
                            permut(scores(j), scores(j-1));
                            onapermute := true;
                        end if;
                    end loop;i := i+1;
                end loop;
            when others =>
                null;
        end case;
    end tri_score;

end p_score;
