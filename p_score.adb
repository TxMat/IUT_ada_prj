with sequential_io;
with p_esiut; use p_esiut;
package body p_score is

    -- ouverture du fichier score, création sinon inexsitant
    procedure ouvrir_fichier(io_type : in integer) is --Permet d'accéder au fichier même si l'utilisateur de supprime en pleine partie
    begin
        case io_type is
        when 1 => -- lecture
            open(f, in_file, NOM_FICHIER);
        when 2 => -- écriture
            open(f, out_file, NOM_FICHIER);
        when 3 => -- append
            open(f, append_file, NOM_FICHIER);
        when others => -- Impossible, en théorie
            null;
        end case;
        exception
            when NAME_ERROR => -- Si le fichier n'existe pas
                create(f, out_file, NOM_FICHIER);
                close(f);
                case io_type is
                when 1 => -- lecture
                    open(f, in_file, NOM_FICHIER);
                when 2 => -- écriture/écrasement
                    open(f, out_file, NOM_FICHIER);
                when 3 => -- écriture/append
                    open(f, append_file, NOM_FICHIER);
                when others => -- Impossible, en théorie
                    null;
                end case;
            end ouvrir_fichier;

    procedure fermer_fichier is
    begin
        close(f);
    end fermer_fichier;

    -- fonction privée (à rendre privée) Récupère les scores *relevant*
    function analyse_fichier(mode,defi : in integer := 0; nom : in string := ""; tableau_score : in out TV_Score) return integer is
        -- {f FERMÉ} => {}
        --nom param => val
        tmp : TR_Score;
        i : integer := 0;
    begin
        ouvrir_fichier(1);
        while not end_of_file(f) loop
            read(f,tmp);
            if  (mode = 1 and then ((tmp.nom /= nom) and (tmp.defi /= defi))) or -- ajout_score
            (mode = 2 and then (tmp.defi = defi)) or --Tous scores pour défi
            (mode = 3 and then (tmp.nom = nom)) or --Tous scores pour joueur
            (mode = 4 and then ((tmp.nom = nom) and (tmp.defi = defi))) then -- score du joueur pour ce défi
                i := i + 1;
                tableau_score(i) := tmp;
            end if;
        end loop;
        close(f);
        return i;
    end analyse_fichier;

    -- Écriture du score dans le fichier
    procedure ajout_score(score : in TR_Score) is
        scores_existants : TV_Score(1..NB_SCORE_MAX);
        i : integer := 0;
    begin
        i := analyse_fichier(1, 0, "", scores_existants);
        -- Ajoute le nouveau score ------------------------------------
        i := i + 1;
        scores_existants(i) := score;
        ouvrir_fichier(2); --Vide le fichier
        for j in 1..i loop
            write(f, scores_existants(j));
        end loop;
        ---------------------------------------------------------------
        close(f);
    exception
        when CONSTRAINT_ERROR => null; --Histoire d'acknolwedge la possibilité, même si le fichier sera jamais plein, en théorie.
    end ajout_score;

    -- Recupére les scores enregistrés pour ce défi
    function recup_score(defi : in integer) return TV_Score is
        scores_existants : TV_Score(1..NB_SCORE_MAX);
        i : integer := 0; -- vestige du temps où j'avais l'espoir de pouvoir return un tableau de la bonne taille.
    begin
        i := analyse_fichier(2,defi,"",scores_existants);
        return scores_existants(1..NB_SCORE_MAX);
    end recup_score;

    -- Récupére les scores enregistrés pour ce joueur
    function recup_score(nom : in string) return TV_Score is
        scores_existants : TV_Score(1..NB_SCORE_MAX);
        i : integer := 0;
    begin
        i := analyse_fichier(3,0,nom,scores_existants);
        return scores_existants;
    end recup_score;

    -- Récupére le score du joueur pour ce défi
    function recup_score(infos : in TR_Score) return TR_Score is
        scores_existants : TV_Score(1..NB_SCORE_MAX);
        i : integer := 0;
    begin
        i := analyse_fichier(4,infos.defi,infos.nom,scores_existants);
        return scores_existants(1);
    end recup_score;

    -- Pour debug & co
    procedure afficher_scores is
        scores : TV_Score(1..400);
        j : integer := 0;
    begin
        for i in 1..400 loop
            scores(i).defi := 2;
            scores(i).nom := "test                ";
            scores(i).temps := 1.0;
            scores(i).nb_moves := 3;
        end loop;
        ouvrir_fichier(1);
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

end p_score;
