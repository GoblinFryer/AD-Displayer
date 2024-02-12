 ###FENETRE###
 
    $folderForm = New-Object System.Windows.Forms.Form
    $folderform.text = "AD Displayer"
    $folderform.BackColor = '#EEB033'
    $folderform.MaximizeBox = $true
    $folderForm.MinimumSize = New-Object System.Drawing.Size(577,600)
    $folderForm.MaximumSize = New-Object System.Drawing.Size(577,600)

###BOUTONS###
 
    $infos = New-Object System.Windows.Forms.Button
    $infos.Text = 'Infos compte'
    $infos.Font = 'Arial, 8'
    $infos.width = 80
    $infos.height = 20
    $infos.BackColor = '#F3F3F3'
    $infos.ForeColor = '#000'
    $infos.Location = '208,60'
    $folderForm.Controls.Add($infos)

    $group = New-Object System.Windows.Forms.Button
    $group.Text = 'Groupes AD'
    $group.font = 'Arial,8'
    $group.width = 80
    $group.height = 20
    $group.BackColor = '#F3F3F3'
    $group.ForeColor = '#000'
    $group.Location = '296,60'
    $folderForm.Controls.Add($group)

    $compare = New-Object System.Windows.Forms.Button
    $compare.Text = 'Comparer'
    $compare.font = 'Arial,8'
    $compare.width = 80
    $compare.height = 20
    $compare.BackColor = '#F3F3F3'
    $compare.ForeColor = '#000'
    $compare.Location = '383,60'
    $folderForm.Controls.Add($compare)
###LABELS###
 
    $label1 = New-object System.Windows.Forms.Label
    $label1.font = New-Object Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)
    $label1.text = 'ID user:'
    $label1.autosize = $true
    $label1.location = '30,10'
    $folderForm.controls.Add($label1)

    $labelun = New-object System.Windows.Forms.Label
    $labelun.font = New-Object Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)
    $labelun.text = '1.'
    $labelun.autosize = $true
    $labelun.location = '15,35'
    $folderForm.controls.Add($labelun)

    $labeldeux = New-object System.Windows.Forms.Label
    $labeldeux.font = New-Object Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)
    $labeldeux.text = '2.'
    $labeldeux.autosize = $true
    $labeldeux.location = '15,65'
    $folderForm.controls.Add($labeldeux)

###TEXTBOX###

    #TEXTBOX1
    $textuser = New-Object System.Windows.Forms.TextBox
    $textuser.size = New-Object System.Drawing.Size(170,20)
    $textuser.location = '30,30'

    #création liste de suggestion
    $ou ='OU=,OU=,DC=,DC=,DC=,DC=' # <<< renseignez votre domaine et OU ici
    $ADusersName = Get-ADUser -Filter * -SearchBase $ou | Select-Object -ExpandProperty Name | Sort-Object
    $ADUsers = Get-ADUser -Filter * -SearchBase $ou | Select-Object givenname, surname | Sort-Object
    $GivennameSurname = foreach ($user in $ADUsers){"{0} {1}" -f $user.givenname, $user.surname}
    $suggestions = $ADusersName + $GivennameSurname
    $autocomplete = New-Object System.Windows.Forms.AutoCompleteStringCollection
    $autocomplete.AddRange($suggestions)
    $textuser.AutoCompleteCustomSource = $autocomplete
    $textuser.AutoCompleteMode = "SuggestAppend"
    $textuser.AutoCompleteSource = "CustomSource"
    $folderform.Controls.Add($textuser)

    #TEXTBOX2
    $textuser2 = New-Object System.Windows.Forms.TextBox
    $textuser2.size = New-Object System.Drawing.Size(170,20)
    $textuser2.location = '30,60'

    $ou ='OU=,OU=,DC=,DC=,DC=,DC=' # <<< renseignez votre domaine et OU ici
    $ADusersName = Get-ADUser -Filter * -SearchBase $ou | Select-Object -ExpandProperty Name | Sort-Object
    $ADUsers = Get-ADUser -Filter * -SearchBase $ou | Select-Object givenname, surname | Sort-Object
    $GivennameSurname = foreach ($user in $ADUsers){"{0} {1}" -f $user.givenname, $user.surname}
    $suggestions = $ADusersName + $GivennameSurname
    $autocomplete = New-Object System.Windows.Forms.AutoCompleteStringCollection
    $autocomplete.AddRange($suggestions)
    $textuser2.AutoCompleteCustomSource = $autocomplete
    $textuser2.AutoCompleteMode = "SuggestAppend"
    $textuser2.AutoCompleteSource = "CustomSource"
    $folderform.controls.Add($textuser2)


    $textboxresult = New-Object System.Windows.Forms.TextBox
    $textboxresult.size = New-Object System.Drawing.Size(500,400)
    $textboxresult.location = '30,100'
    $textboxresult.multiline = $true
    $textboxresult.scrollbars = "vertical"
    $textboxresult.Multiline = $true
    $folderform.controls.Add($textboxresult)

###EVENTHANDLER###

#bloc qui récupère les valeurs indiquées dans $properties pour les afficher dans la textbox de la GUI
$infos.add_click({
    
    $user = $textuser.text
    $IDpc = $textuser2.text
    $properties = "displayname","title","lastlogondate","enabled","passwordlastset","LastBadPasswordAttempt","name"
    $PCProperties = "lastlogondate"

        if($user -match '^[^ ]+$'){

            $name = Get-ADUser -Identity "$user" -Properties $properties | Select-Object $properties
            $textboxresult.text = $name | out-string}

        elseif($user -match '^[^ ]+ [^ ]+$'){

            $user2 = $user -split " "
            $givenname = $user2[0]
            $surname = $user2[1]

            $adbyname = Get-ADUser -Filter {(givenname -eq $givenname -and surname -eq $surname)} -Properties $properties | Select-Object $properties
            $textboxresult.text = $adbyname | out-string 

        }

        elseif($user -match '^[^ ]+ [^ ]+ [^ ]+$'){

            $user2 = $user -split " "
            $givenname = $user2[0]
            $surname = $user2[1]+" "+$user2[2]

            $adbyname = Get-ADUser -Filter {(givenname -eq $givenname -and surname -eq $surname)} -Properties $properties | Select-Object $properties
            $textboxresult.text = $adbyname | out-string 

        }
    
        if($IDpc -Match '^RD'){

            $pc = get-adcomputer "$IDpc" -Properties $properties | Select-Object $PCProperties
            $textboxresult.text = $pc | out-string

        }

})

#Bloc qui liste les groupes AD de l'utilisateur renseigné dans le champ $textuser (textbox 1.)
$group.add_click({

    $user = $textuser.Text
    $IDpc = $textuser2.Text

    if($user -match '^[^ ]+$'){

        $groupes = Get-ADuser -Identity "$user" -Properties memberof | Select-Object -ExpandProperty "memberof" | sort-object
        $groupesAD = $groupes | ForEach-Object{

            if($_ -match 'CN=([^,]+)'){

                $Matches[1]

            }

        }
        
        $textboxresult.text = $groupesAD -join [System.Environment]::NewLine
       
    }

    elseif($user -match '^[^ ]+ [^ ]+$'){

        $prenomnom = $user -split " "
        $givenname = $prenomnom[0]
        $surname = $prenomnom[1]

        $groupes = Get-ADUser -Filter {GivenName -eq $givenname -and Surname -eq $surname} -Properties memberof | Select-Object -ExpandProperty memberof
        $groupesAD = $groupes | ForEach-Object{

            if($_ -match 'CN=([^,]+)'){

                $Matches[1]

            }

        }

        $textboxresult.text = $groupesAD -join [System.Environment]::NewLine
        
    }

    elseif($user -match '^[^ ]+ [^ ]+ [^ ]+$'){

        $prenomnom = $user -split " "
        $givenname = $prenomnom[0]
        $surname = $prenomnom[1]+" "+$prenomnom[2]

        $groupes = Get-ADUser -Filter {GivenName -eq $givenname -and Surname -eq $surname} -Properties memberof | Select-Object -ExpandProperty memberof
        $groupesAD = $groupes | ForEach-Object{

            if($_ -match 'CN=([^,]+)'){

                $Matches[1]

            }

        }

        $textboxresult.text = $groupesAD -join [System.Environment]::NewLine
        
    }

    if($IDpc -notlike $null){

        $groupes = get-adcomputer "$IDpc" -Properties memberof | Select-Object -ExpandProperty "memberof"

        $groupesAD = $groupes | foreach-object{ 
            
            if($_ -Match 'CN=([^,]+)'){

                $Matches[1]

            }

        }
        
        $textboxresult.text = $groupesAD -join [System.Environment]::NewLine

    }

})

#Bloc qui compare les groupes AD de deux comptes utilisateurs pour afficher les groupes qui ne sont PAS en commun
$compare.add_click({

    $user = $textuser.text
    $user2 = $textuser2.Text
    $IDpc = $textuser.text
    $IDpc2 = $textuser2.text

    if($user -match '^[^ ]+$'){

        $groupe1 = Get-ADuser -Identity "$user" -Properties memberof | Select-Object -ExpandProperty "memberof" | sort-object
        $groupe1 = get-adcomputer "$IDpc" -Properties memberof | Select-Object -ExpandProperty "memberof"
        $groupcn1 = $groupe1 | ForEach-Object {

                if ($_ -match 'CN=([^,]+)'){

                    $Matches[1]

                }

        }

    }

    elseif($user -match '^[^ ]+ [^ ]+$'){

        $prenomnom = $user -split " "
        $givenname = $prenomnom[0]
        $surname = $prenomnom[1]

        $groupe1 = Get-ADUser -Filter {GivenName -eq $givenname -and Surname -eq $surname} -Properties memberof | Select-Object -ExpandProperty memberof
        $groupcn1 = $groupe1 | ForEach-Object{

            if($_ -match 'CN=([^,]+)'){

                $Matches[1]

            }

        }
        
    }

    elseif($user -match '^[^ ]+ [^ ]+ [^ ]+$'){

        $prenomnom = $user -split " "
        $givenname = $prenomnom[0]
        $surname = $prenomnom[1]+" "+$prenomnom[2]

        $groupe1 = Get-ADUser -Filter {GivenName -eq $givenname -and Surname -eq $surname} -Properties memberof | Select-Object -ExpandProperty memberof
        $groupcn1 = $groupe1 | ForEach-Object{

            if($_ -match 'CN=([^,]+)'){

                $Matches[1]

            }

        }
        
    }

    if($user2 -match '^[^ ]+$'){

        $groupe2 = Get-ADuser -Identity "$user2" -Properties memberof | Select-Object -ExpandProperty "memberof" | sort-object
        $groupe2 = get-adcomputer "$IDpc2" -Properties memberof | Select-Object -ExpandProperty "memberof"
        $groupcn2 = $groupe2 | ForEach-Object {

                if ($_ -match 'CN=([^,]+)'){

                    $Matches[1]

                }

        }

    }

    elseif($user2 -match '^[^ ]+ [^ ]+$'){

        $prenomnom2 = $user2 -split " "
        $givenname = $prenomnom2[0]
        $surname = $prenomnom2[1]

        $groupes = Get-ADUser -Filter {GivenName -eq $givenname2 -and Surname -eq $surname2} -Properties memberof | Select-Object -ExpandProperty memberof
        $groupcn2 = $groupes | ForEach-Object{

            if($_ -match 'CN=([^,]+)'){

                $Matches[1]

            }

        }

    }

    elseif($user2 -match '^[^ ]+ [^ ]+ [^ ]+$'){

        $prenomnom2 = $user2 -split " "
        $givenname2 = $prenomnom2[0]
        $surname2 = $prenomnom2[1]+" "+$prenomnom2[2]

        $groupes = Get-ADUser -Filter {GivenName -eq $givenname2 -and Surname -eq $surname2} -Properties memberof | Select-Object -ExpandProperty memberof
        $groupcn2 = $groupes | ForEach-Object{

            if($_ -match 'CN=([^,]+)'){

                $Matches[1]

            }

        }
        
    }


    $groupe2 = Get-ADuser -Identity "$user2" -Properties memberof | Select-Object -ExpandProperty "memberof" | sort-object
    $groupe2 = get-adcomputer "$IDpc2" -Properties memberof | Select-Object -ExpandProperty "memberof"
    $groupcn2 = $groupe2 | ForEach-Object {

        if ($_ -match 'CN=([^,]+)'){

            $Matches[1]

        }

    }

    #Variable qui compare les valeurs récupérées dans $groupcn1 et $groupcn2 et affiche les valeurs non-communes dans la textbox de la GUI
    #Le bloc compare les valeurs présentent pour le premier utilisateur et qui ne sont PAS présentes pour le second (l'ordre est donc IMPORTANT)
    $notismilar = $groupcn1 | where-object {$_ -notin $groupcn2} | sort-object
    $textboxresult.text = $notismilar -join [System.Environment]::NewLine

})

$pc.add_click({

    #récupére les groupes AD du PC dans 1. et les stock dans la variable $test2
    $IDpc = $textuser.text
    $pc = get-adcomputer "$IDpc" -Properties memberof | Select-Object -ExpandProperty "memberof"
    
    #Confition qui vérifie si 'EntNoScrSavGPO' est présente sur le poste indiqué dans la case 1. en récupérant les valeurs présente dans la condition précédente
    if($pc -match "EntNoScrSavGPO"){

        $textboxresult.text = "GPO presente"

    }

    else{

        $textboxresult.text = "GPO non-presente"

    }

})

#Nécessaire pour l'affichage de la fenêtre (GUI):
$folderform.ShowDialog()
