(* C2PP
  ***************************************************************************

  Copyright D. LEBLANC 2025
  Ce programme peut être copié et utilisé librement.

  ***************************************************************************

  Ce projet est une démo des possibilités combinés des webstencils et de
  HTMX.

  ***************************************************************************
  File last update : 2025-07-05T15:24:36.000+02:00
  Signature : d8cd9d9ae03faa14e3d89c5e90ff70ba023516d9
  ***************************************************************************
*)

unit UConsts;

interface

const
  // Tags
  TAG_SESSION: string = '[%NoSession%]';

  TAG_CUST_ID: string = '[%CustId%]';
  TAG_NAME: string = '[%Name%]';
  TAG_CITY: string = '[%City%]';
  TAG_COUNTRY: string = '[%Country%]';
  TAG_TYPE: string = '[%Type%]';
  TAG_CB_TYPES_CUSTOMER = '[%CbCustomerTypes%]';

  TAG_QUOTE_ID: string = '[%QuoteId%]';
  TAG_QUOTE_DESCRIPTION: string = '[%QuoteDescription%]';
  TAG_QUOTE_AMOUNT: string = '[%QuoteAmount%]';

implementation

end.
