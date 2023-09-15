pageextension 60107 SalesQuoteListExt extends "Sales Quotes"
{
    layout
    {
        addafter("External Document No.")
        {
            field("Industry Shortcut Dimension"; Rec."Industry Shortcut Dimension")
            {
                Caption = 'Industry Code';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
