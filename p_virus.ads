with sequential_io;
with p_esiut; use p_esiut;

package p_virus is

	-- Types pour représenter la grille de jeu
	subtype T_Col is character range 'A'..'G';
	subtype T_Lig is integer range 1..7;
	type T_Coul is (rouge, turquoise, orange, rose, marron, bleu, violet, vert, jaune, blanc, vide);
	type TV_Grille is array (T_lig,T_col) of T_Coul;

	-- type pour les pièces du jeu
	subtype T_CoulP is T_Coul range rouge..blanc; -- couleurs des pièces
	package p_coul_io is new p_enum(T_CoulP); use p_coul_io; --

    -- type vecteur contraint pour mémoriser les pièces d'un défi donné
    type TV_Pieces is array(T_coulP) of boolean;

	-- éléments constitutif d'une pièce
	type TR_ElemP is record	-- 	un élément constituant une pièce
		colonne	:	T_Col;			-- 	la colonne qu'il occupe dans la grille
		ligne	:	T_Lig;			-- 	la ligne qu'il occupe dans la grille
		couleur	:	T_CoulP;		--	sa couleur
	end record;

    type TV_ElemP is array (1..3) of TR_ElemP;

	---- Instanciation de sequential_io pour un fichier de TR_ElemP
	package p_piece_io is new sequential_io (TR_ElemP); use p_piece_io;

	---- type pour les directions de déplacement des pièces
	type T_Direction is (bg, hg, bd, hd);

	package p_dir_io is new p_enum(T_Direction); use p_dir_io;

	--------------- Primitives d'initialisation d'une partie

	procedure InitPartie(Grille : in out TV_Grille; Pieces : in out TV_Pieces);
	-- {} => {Tous les éléments de Grille ont été initialisés avec la couleur VIDE, y compris les cases inutilisables
	--				Tous les élements de Pieces ont été initialisés à false}

	procedure Configurer(f : in out p_piece_io.file_type; num : in integer;
											 Grille : in out TV_Grille; Pieces : in out TV_Pieces);
	-- {f ouvert, non vide, num est un numéro de défi
	--	dans f, un défi est représenté par une suite d'éléments :
	--	* les éléments d'une même pièce (même couleur) sont stockés consécutivement
	--	* les deux éléments constituant le virus (couleur rouge) terminent le défi}
	-- 			=> {Grille a été mis à jour par lecture dans f de la configuration de numéro num
	--					Pieces a été mis à jour en fonction des pièces de cette configuration}

	-- pour tester une configuration initiale
	procedure PosPiece(Grille : in TV_Grille; coul : in T_coulP);
	-- {} => {la position de la pièce de couleur coul a été affichée, si coul appartient à Grille:
	--				exemple : ROUGE : F4 - G5}

	--------------- Contrôle du jeu

	function Possible(Grille : in TV_Grille; coul : in T_CoulP; Dir : in T_Direction) return boolean;
	-- {coul /= blanc}
	--	=> {resultat = vrai si la pièce de couleur coul peut être déplacée dans la direction Dir}

	procedure MajGrille(Grille : in out TV_Grille; coul : in T_CoulP; Dir : in T_Direction);
	-- {la pièce de couleur coul peut être déplacée dans la direction Dir}
	--	=> {Grille a été mis à jour suite au deplacement}

	function Guerison(Grille : in TV_Grille) return boolean;
	-- {} => {résultat = vrai si Grille(1,A) = Grille(2,B) = ROUGE}

    -- Oppose la direction de dir (bg <-> hd; bd <-> hg)
    procedure oppose (dir : in out T_Direction);

    -- Calcule la direction dans laquelle l'utilisateur veut déplacer sa pièce
    function calcul_dir(ligne_piece, ligne_cible : in integer; colonne_piece, colonne_cible : in character) return T_Direction;

    -- Vérifie si la pièce peut bouger dans au moins une direction
    function checkpossible (Grille : in TV_Grille; coul : in T_coulP) return boolean;

end p_virus;
