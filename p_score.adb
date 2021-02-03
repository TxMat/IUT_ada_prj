with sequential_io;

package body p_score is

    function analyse_fichier(mode,defi : in integer := 0; nom : in string := ""; tableau_score : in out TV_Score; f : in out p_score_io.file_type) return integer is
        --nom param => val
        tmp : TR_Score;
        i : integer := 0;
    begin
        reset(f);
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
        return i;
    end analyse_fichier;

    -- Écriture du score dans le fichier
    procedure ajout_score(score : in TR_Score; f : in out p_score_io.file_type) is
        scores_existants : TV_Score(1..NB_SCORE_MAX);
        i : integer := 0;
    begin

        -- Récupère tous les scores n'étant pas celui à ajouter -------
        -- while not end_of_file(f) loop
        --     read(f,tmp);
        --     if (tmp.nom /= score.nom) and (tmp.defi /= score.defi) then
        --         i := i + 1;
        --         scores_existants(i) := tmp;
        --     end if;
        -- end loop;
        i := analyse_fichier(1, 0, "", scores_existants, f);
        ---------------------------------------------------------------

        -- Ajoute le nouveau score ------------------------------------
        i := i + 1;
        scores_existants(i) := score;
        reset(f, out_file);

        for j in 1..i loop
            write(f, scores_existants(j));
        end loop;
        ---------------------------------------------------------------

    exception
        when CONSTRAINT_ERROR => null; --Histoire d'acknolwedge la possibilité, même si le fichier sera jamais plein, en théorie.
    end ajout_score;

    -- ouverture du fichier score, création sinon inexsitant
    procedure ouvrir_fichier(name : in string; f : in out p_score_io.file_type) is
    begin
        open(f, append_file, name);
    exception
        when NAME_ERROR => -- Si le fichier n'existe pas
            create(f, out_file, name);
    end ouvrir_fichier;

    -- Recupére les scores enregistrés pour ce défi
    function recup_score(defi : in integer; f : in out p_score_io.file_type) return TV_Score is
        scores_existants : TV_Score(1..NB_SCORE_MAX);
        i : integer := 0;
    begin
        i := analyse_fichier(2,defi,"",scores_existants,f);
        return scores_existants(1..i);
    end recup_score;

    -- Récupére les scores enregistrés pour ce joueur
    function recup_score(nom : in string; f : in out p_score_io.file_type) return TV_Score is
        scores_existants : TV_Score(1..NB_SCORE_MAX);
        i : integer := 0;
    begin
        i := analyse_fichier(3,0,nom,scores_existants,f);
        return scores_existants(1..i);
    end recup_score;

    -- Récupére le score du joueur pour ce défi
    function recup_score(infos : in TR_Score; f : in out p_score_io.file_type) return TR_Score is
        scores_existants : TV_Score(1..NB_SCORE_MAX);
        i : integer := 0;
    begin
        i := analyse_fichier(4,infos.defi,infos.nom,scores_existants,f);
        return scores_existants(1);
    end recup_score;

end p_score;
