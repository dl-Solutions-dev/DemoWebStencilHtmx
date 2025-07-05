(* C2PP
  ***************************************************************************

  Copyright D. LEBLANC 2025
  Ce programme peut être copié et utilisé librement.

  ***************************************************************************

  Ce projet est une démo des possibilités combinés des webstencils et de
  HTMX.

  ***************************************************************************
  File last update : 2025-07-05T15:29:38.000+02:00
  Signature : bf048b4f78a0237dd34c6a1fa4bdccd04b6d9456
  ***************************************************************************
*)

unit UHtmlTemplates;

interface

const
  LINE_CUSTOMER: string = '''
    <tr id="Row[%CustId%]">
      <td>

        <a href="#" hx-delete="/DeleteCustomer?Session=[%NoSession%]&id=[%CustId%]" hx-confirm="Etes-vous certains de vouloir supprimer ce client ?" hx-target="closest tr" hx-swap="outerHTML swap:1s">
          <span class="material-icons">
          delete
          </span>
        </a>
      </td>
      <td>
      <button class="btn btn-warning"
          hx-get="/EditLineMode?Session=[%NoSession%]&id=[%CustId%]&col=1"
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
      <td>[%CustId%]</td>
      <td id="col1[%CustId%]">
      [%Name%]
      </td>
      <td  id="col2[%CustId%]">
      [%City%]
      </td>
      <td  id="col2[%CustId%]">
      [%Country%]
      </td>
      <td  id="col2[%CustId%]">
      [%Type%]
      </td>
    </tr>
  ''';

  EDIT_LINE_CUSTOMER: string = '''
    <tr hx-trigger='cancel' class='editing' hx-get="/CancelEditLineCustomer?Session=[%NoSession%]&id=[%CustId%]">
      <td></td>
      <td>
        <button class="btn btn-warning" hx-get="/CancelEditLineCustomer?Session=[%NoSession%]&id=[%CustId%]&col=2">
          Cancel
        </button>
        <button class="btn btn-warning" hx-put="/ApplyCustomer?Session=[%NoSession%]&id=[%CustId%]" hx-include="closest tr">
          Save
        </button>
      </td>
      <td>[%CustId%]</td>
      <td><input autofocus id="edtName" name='name' value='[%Name%]'></td>
      <td><input id="edtCity" name='city' value='[%City%]'></td>
      <td><input id="edtCountry" name='country' value='[%Country%]'></td>
      <td>
        [%CbCustomerTypes%]
      </td>
    </tr>
  ''';

  ADD_CUSTOMER:string = '''
    <tr>
      <td></td>
      <td>
      <a href="#" hx-post="/ApplyInsertCustomer?Session=[%NoSession%]" hx-include="closest tr">
        <span class="material-icons">
          check
        </span>
      </a>
      <a href="#" hx-get="/CancelAddCusomer" hx-target="closest tr" hx-swap="outerHTML swap:1s">
        <span class="material-icons">
          cancel
        </span>
      </a>
      </td>
      <td></td>
      <td><input type="text" id="edtName" name="name" value=""/></td>
      <td><input type="text" id="edtCity" name="City" value=""/></td>
      <td><input type="text" id="edtCountry" name="Country" value=""/></td>
      <td>
        [%CbCustomerTypes%]
      </td>
    </tr>
  ''';

implementation

end.
