#!/bin/bash

#source_file=${1:?Fichier source manquant} # Fichier source

#echo $source_file





function error {

        echo $*
        exit 1

}







# Vérifier l'existence des dossiers requis
test -d input/ || error "Aucun dossier input pour extraire les fichiers."
test -d output/ || mkdir output
test -d layout/ || error "Aucun dossier layout pour extraire les fichiers."


# Idem pour les fichiers
test -f layout/before.html || error "layout/before.html: fichier inexistant"
test -f layout/after.html || error "layout/after.html: fichier inexistant"


# Actualiser la date de modification des fichiers  fichier

date_modif=$(date)



# Code source du fichier after.html
after_code=$(cat layout/after.html | sed "s/##DATEMODIF##/$date_modif/g")


for source_file in input/*.html; do
        echo "Chemin relatif du fichier source: $source_file"

        file_name="${source_file#input/}"

        echo "Construction du fichier $file_name"


        # Titre de la page
        title=$(head -1 $source_file)

        # Supprimer le titre en première ligne du code source du corps du fichier
        source_code=$(cat $source_file | sed "0,/$title/s/$title/\ /")

        echo "Titre du fichier source: $title"



        # Récupérer le lien vers la page pour y ajouter la classe 'current'
        original_page_link=$(grep $file_name layout/before.html)
        page_link_line=$(grep $file_name layout/before.html | sed "s/##CLASSCURRENT##/class='current'/g")

        # Supprimer les occurrences "CLASSCURRENT" des autres lignes
        original_link_lines=$(grep "##CLASSCURRENT##" layout/before.html | grep -v $file_name) 
        link_lines=$(grep "##CLASSCURRENT##" layout/before.html | grep -v $file_name | sed "s/##CLASSCURRENT##/\ /g")

        echo "Lignes de liens : $original_link_lines"
        echo "Nouvelles lignes de liens : $link_lines"

        #echo "Ligne originale du lien : ${original_page_link_line}"
        #echo "Ligne du lien : ${page_link_line}"

        #  Code source du fichier before.html

        before_code=$(cat layout/before.html)
        before_code=${before_code//"##TITRE##"/"$title"}

        before_code=${before_code//"$original_page_link"/"$page_link_line"}
        before_code=${before_code//"$original_link_lines"/"$link_lines"}
 

        #echo $date




        # Code final du fichier HTML
        final_code="$before_code$source_code$after_code"
        #echo $final_code





        # Ecrire le code source complet dans le fichier final
        echo $final_code > "public/$file_name"

        echo "Fini de construire public/$file_name"
done


for css_file in input/*.css; do

        echo "Copie de la feuille de style:  ${css_file}"

        file_name="${css_file/input}"

        cp $css_file "public/$file_name"

        echo "Copié la feuille de style dans public/$file_name"


done



echo "Terminé la copie des fichiers dans public/"
