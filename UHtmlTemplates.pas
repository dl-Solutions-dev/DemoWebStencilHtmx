(* C2PP
  ***************************************************************************

  Copyright D. LEBLANC 2025
  Ce programme peut être copié et utilisé librement.

  ***************************************************************************

  Ce projet est une démo des possibilités combinés des webstencils et de
  HTMX.

  ***************************************************************************
  File last update : 2025-07-01T23:19:20.000+02:00
  Signature : 28d773d59df3c75f651e937f4f768767831c576e
  ***************************************************************************
*)

unit UHtmlTemplates;

interface

const
  LINE_USER: string = '''
    <tr id="Row[%IdUser%]">
      <td>

        <a href="#" hx-delete="/DeleteUser?Session=[%NoSession%]&id=[%IdUser%]" hx-confirm="Etes-vous certains de vouloir supprimer cet utilisateur ?" hx-target="closest tr" hx-swap="outerHTML swap:1s">
          <span class="material-icons">
          delete
          </span>
        </a>
      </td>
      <td>
      <button class="btn btn-warning"
          hx-get="/EditLineMode?Session=[%NoSession%]&id=[%IdUser%]&col=1"
          hx-trigger="edit"
          onClick="let editing = document.querySelector('.editing')
               if(editing) {
                 Swal.fire({title: 'Already Editing',
                      showCancelButton: true,
                      confirmButtonText: 'Oui, éditer cette ligne',
                      text:'Une ligne est déjà en cours d&#x2019;édition, voulez-vous continuer ?'})
                 .then((result) => {
                  if(result.isConfirmed) {
                     htmx.trigger(editing, 'Cancel')
                     htmx.trigger(this, 'edit')
                  }
                })
               } else {
                htmx.trigger(this, 'edit')
               }">
        Edit
      </button>
      </td>
      <td>[%IdUser%]</td>
      <td id="col1[%IdUser%]">
      [%Prenom%]
      </td>
      <td  id="col2[%IdUser%]">
      [%Nom%]
      </td>
    </tr>
  ''';

  EDIT_LINE_USER: string = '''
    <tr hx-trigger='cancel' class='editing' hx-get="/CancelEditUser?Session=[%NoSession%]&id=[%IdUser%]">
      <td></td>
      <td>
        <button class="btn btn-warning" hx-get="/CancelEditUser?Session=[%NoSession%]&id=[%IdUser%]&col=2">
          Cancel
        </button>
        <button class="btn btn-warning" hx-put="/ApplyUser?Session=[%NoSession%]&id=[%IdUser%]" hx-include="closest tr">
          Save
        </button>
      </td>
      <td>[%IdUser%]</td>
      <td><input autofocus id="edtPrenom" name='prenom' value='[%Prenom%]'></td>
      <td><input id="edtNom" name='nom' value='[%Nom%]'></td>
    </tr>
  ''';

  ADD_USER:string = '''
    <tr>
      <td></td>
      <td>
      <a href="#" hx-post="/ApplyInsertUser?Session=[%NoSession%]" hx-include="closest tr">
        <span class="material-icons">
          check
        </span>
      </a>
      <a href="#" hx-get="/CancelAddUser" hx-target="closest tr" hx-swap="outerHTML swap:1s">
        <span class="material-icons">
          cancel
        </span>
      </a>
      </td>
      <td></td>
      <td><input type="text" id="edtPrenom" name="prenom" value=""/></td>
      <td><input type="text" id="edtNom" name="Nom" value=""/></td>
    </tr>
  ''';

implementation

end.
