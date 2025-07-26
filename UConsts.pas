(* C2PP
  ***************************************************************************

  Copyright 2025 Dany Leblanc under AGPL 3.0 license.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
  OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
  OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS IN THE SOFTWARE.

  ***************************************************************************

  Ce projet est une démo des possibilités combinés des webstencils et de
  HTMX.

  ***************************************************************************
  File last update : 2025-07-06T10:01:48.000+02:00
  Signature : 391ff29354411dede7af97318a76df6e8bceaa0a
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
